#!/usr/bin/env node
require("dotenv").config();
const child_process = require("child_process");
const fs = require("fs");
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

const INVALID_KEYS = [
  "CHAIN_ID",
  "REPAY_WITH_COLLATERAL_ADAPTER",
  "SWAP_COLLATERAL_ADAPTER",
];

function downloadContracts(networkName, config) {
  Object.keys(config)
    .filter((key) => !INVALID_KEYS.includes(key))
    .map((key) => download(networkName, key, config[key]));
}

function diffContracts(chain, config) {
  Object.keys(config)
    .filter((key) => !INVALID_KEYS.includes(key))
    .map((key) =>
      runCmd(
        `make git-diff before=downloads/${chain}/${key} after=downloads/mainnet/${key} out=${chain}_${key}`
      )
    );
}

async function main() {
  downloadContracts("mainnet", AaveV3Ethereum);
  downloadContracts("polygon", AaveV3Polygon);
  diffContracts("polygon", AaveV3Polygon);
}

main();
