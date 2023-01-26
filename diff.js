#!/usr/bin/env node
require("dotenv").config();
const child_process = require("child_process");
const fs = require("fs");
const { utils } = require("ethers");
const {
  AaveV3Ethereum,
  AaveV3Polygon,
} = require("@bgd-labs/aave-address-book");

function runCmd(cmd) {
  var resp = child_process.execSync(cmd);
  var result = resp.toString("UTF8");
  return result;
}

const API_KEYS = {
  mainnet: process.env.ETHERSCAN_API_KEY_MAINNET,
  polygon: process.env.ETHERSCAN_API_KEY_POLYGON,
  // process.env.ETHERSCAN_API_KEY_AVALANCHE,
  // process.env.ETHERSCAN_API_KEY_FANTOM,
  // process.env.ETHERSCAN_API_KEY_OPTIMISM,
  // process.env.ETHERSCAN_API_KEY_ARBITRUM
};

function download(chain, name, address) {
  if (!fs.existsSync(`downloads/${chain}/${name}`)) {
    runCmd(
      `cast etherscan-source --chain ${chain} -d downloads/${chain}/${name} ${address} --etherscan-api-key ${API_KEYS[chain]}`
    );
  }
}

function getImpl(chain, address) {
  return utils.hexStripZeros(
    runCmd(
      `cast storage --rpc-url ${chain} ${address} 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
    ).replace("\n", ""),
    32
  );
}

const INVALID_KEYS = [
  "CHAIN_ID", // random artifact
  "REPAY_WITH_COLLATERAL_ADAPTER", // utility
  "SWAP_COLLATERAL_ADAPTER", // utility
  "LISTING_ENGINE", // utility
  "ACL_ADMIN", // chain specific
];

const PROXIES = [
  "COLLECTOR",
  "DEFAULT_INCENTIVES_CONTROLLER",
  "POOL",
  "POOL_CONFIGURATOR",
];

function downloadContracts(networkName, config) {
  Object.keys(config)
    .filter((key) => !INVALID_KEYS.includes(key))
    .map((key) => {
      const isProxy = PROXIES.includes(key);
      download(
        networkName,
        isProxy ? `${key}_IMPL` : key,
        isProxy ? getImpl(networkName, config[key]) : config[key]
      );
    });
}

function diffContracts(chain, config) {
  Object.keys(config)
    .filter((key) => !INVALID_KEYS.includes(key))
    .map((key) => {
      const identifier = PROXIES.includes(key) ? `${key}_IMPL` : key;
      runCmd(
        `make git-diff before=downloads/${chain}/${identifier} after=downloads/mainnet/${identifier} out=${chain}_${identifier}`
      );
    });
}

async function main() {
  downloadContracts("mainnet", AaveV3Ethereum);
  downloadContracts("polygon", AaveV3Polygon);
  diffContracts("polygon", AaveV3Polygon);
}

main();
