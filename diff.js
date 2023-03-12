#!/usr/bin/env node
require("dotenv").config();
const child_process = require("child_process");
const fs = require("fs");
const { utils } = require("ethers");
const {
  AaveV3Ethereum,
  AaveV3Polygon,
  AaveV3Optimism,
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

const CONTRACTS = {
  POOL_ADDRESSES_PROVIDER: {},
  POOL: {},
  POOL_CONFIGURATOR: {},
  ORACLE: {},
  AAVE_PROTOCOL_DATA_PROVIDER: {},
  ACL_MANAGER: {},
  COLLECTOR: {},
  DEFAULT_INCENTIVES_CONTROLLER: {},
  DEFAULT_A_TOKEN_IMPL_REV_1: {},
  DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1: {},
  DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1: {},
  EMISSION_MANAGER: {},
  POOL_ADDRESSES_PROVIDER_REGISTRY: {},
};

const PROXIES = [
  "COLLECTOR",
  "DEFAULT_INCENTIVES_CONTROLLER",
  "POOL",
  "POOL_CONFIGURATOR",
];

function downloadContracts(networkName, config) {
  Object.keys(CONTRACTS).map((key) => {
    const isProxy = PROXIES.includes(key);
    download(
      networkName,
      isProxy ? `${key}_IMPL` : key,
      isProxy ? getImpl(networkName, config[key]) : config[key]
    );
  });
}

function diffContracts(chain, config) {
  Object.keys(CONTRACTS).map((key) => {
    const identifier = PROXIES.includes(key) ? `${key}_IMPL` : key;
    runCmd(
      `make git-diff before=src/downloads/${chain}/${identifier} after=src/downloads/mainnet/${identifier} out=${identifier}_diff`
    );
  });
}

async function main() {
  // manually add an IR for diffing
  AaveV3Ethereum.DEFAULT_RESERVE_INTEREST_RATE_STRATEGY =
    "0x694d4cFdaeE639239df949b6E24Ff8576A00d1f2";
  AaveV3Polygon.DEFAULT_RESERVE_INTEREST_RATE_STRATEGY =
    "0xA9F3C3caE095527061e6d270DBE163693e6fda9D";
  downloadContracts("mainnet", AaveV3Ethereum);
  downloadContracts("polygon", AaveV3Polygon);
  diffContracts("polygon", AaveV3Polygon);
  download(
    "optimism",
    "L2_POOL_IMPL",
    getImpl("optimism", AaveV3Optimism.POOL)
  );
}

main();
