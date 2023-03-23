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
  if (!fs.existsSync(`src/downloads/${chain}/${name}`)) {
    runCmd(
      `cast etherscan-source --chain ${chain} -d src/downloads/${chain}/${name} ${address} --etherscan-api-key ${API_KEYS[chain]}`
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

function diffContract(networkName, settings, identifier) {
  if (settings.path) {
    // flatten
    const outPath = `src/downloads/${networkName}/${identifier}.sol`;
    runCmd(
      `forge flatten src/downloads/${networkName}/${identifier}/${settings.path} --output ${outPath}`
    );
    if (settings.reference) {
      try {
        // flatten reference
        runCmd(
          `forge flatten ${settings.reference} --output src/downloads/${identifier}.sol`
        );
        // diff
        runCmd(
          `make git-diff before=${outPath} after=src/downloads/${identifier}.sol out=${identifier}_${networkName}_diff`
        );
        // inspect upgrade
        runCmd(
          `forge inspect ${settings.reference}:${settings.name} storage-layout --pretty > reports/${identifier}_storage.md`
        );
        // inspect
        runCmd(
          `forge inspect ${outPath}:${settings.name} storage-layout --pretty > reports/${identifier}_${networkName}_storage.md`
        );
        // diff
        runCmd(
          `make git-diff before=reports/${identifier}_${networkName}_storage.md after=reports/${identifier}_storage.md out=${identifier}_${networkName}_storage_diff`
        );
      } catch (e) {
        console.log(`error: ${networkName}, ${JSON.stringify(settings)}`);
        console.log(e);
        throw new Error("lol");
      }
    }
  }
}

const CONTRACTS = {
  POOL_ADDRESSES_PROVIDER: {
    name: "PoolAddressesProvider",
    path: "PoolAddressesProvider/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProvider.sol",
    reference:
      "lib/aave-v3-core/contracts/protocol/configuration/PoolAddressesProvider.sol",
  },
  POOL: {
    name: "Pool",
    path: "Pool/@aave/core-v3/contracts/protocol/pool/Pool.sol",
    reference: "lib/aave-v3-core/contracts/protocol/pool/Pool.sol",
  },
  POOL_CONFIGURATOR: {
    name: "PoolConfigurator",
    path: "PoolConfigurator/@aave/core-v3/contracts/protocol/pool/PoolConfigurator.sol",
    reference: "lib/aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol",
  },
  ORACLE: {
    name: "AaveOracle",
    path: "AaveOracle/@aave/core-v3/contracts/misc/AaveOracle.sol",
    reference: "lib/aave-v3-core/contracts/misc/AaveOracle.sol",
  },
  AAVE_PROTOCOL_DATA_PROVIDER: {
    name: "AaveProtocolDataProvider",
    path: "AaveProtocolDataProvider/@aave/core-v3/contracts/misc/AaveProtocolDataProvider.sol",
    reference: "lib/aave-v3-core/contracts/misc/AaveProtocolDataProvider.sol",
  },
  ACL_MANAGER: {
    name: "ACLManager",
    path: "ACLManager/@aave/core-v3/contracts/protocol/configuration/ACLManager.sol",
    reference:
      "lib/aave-v3-core/contracts/protocol/configuration/ACLManager.sol",
  },
  DEFAULT_INCENTIVES_CONTROLLER: {
    name: "RewardsController",
    path: "RewardsController/@aave/periphery-v3/contracts/rewards/RewardsController.sol",
    reference: "lib/aave-v3-periphery/contracts/rewards/RewardsController.sol",
  },
  DEFAULT_A_TOKEN_IMPL_REV_1: {
    name: "AToken",
    path: "AToken/@aave/core-v3/contracts/protocol/tokenization/AToken.sol",
    reference: "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol",
  },
  DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1: {
    name: "VariableDebtToken",
    path: "VariableDebtToken/@aave/core-v3/contracts/protocol/tokenization/VariableDebtToken.sol",
    reference:
      "lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol",
  },
  DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1: {
    name: "StableDebtToken",
    path: "StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/StableDebtToken.sol",
    reference:
      "lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol",
  },
  EMISSION_MANAGER: {
    name: "EmissionManager",
    path: "EmissionManager/@aave/periphery-v3/contracts/rewards/EmissionManager.sol",
    reference: "lib/aave-v3-periphery/contracts/rewards/EmissionManager.sol",
  },
  POOL_ADDRESSES_PROVIDER_REGISTRY: {
    name: "PoolAddressesProviderRegistry",
    path: "PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol",
    reference:
      "lib/aave-v3-core/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol",
  },
};

const PROXIES = ["DEFAULT_INCENTIVES_CONTROLLER", "POOL", "POOL_CONFIGURATOR"];

function downloadContracts(networkName, config) {
  Object.keys(CONTRACTS).map((key) => {
    const isProxy = PROXIES.includes(key);
    const identifier = isProxy ? `${key}_IMPL` : key;
    download(
      networkName,
      identifier,
      isProxy ? getImpl(networkName, config[key]) : config[key]
    );
    diffContract(networkName, CONTRACTS[key], identifier);
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
  download(
    "optimism",
    "L2_POOL_IMPL",
    getImpl("optimism", AaveV3Optimism.POOL)
  );
  diffContract(
    "optimism",
    {
      name: "L2Pool",
      path: "L2Pool/@aave/core-v3/contracts/protocol/pool/L2Pool.sol",
      reference: "lib/aave-v3-core/contracts/protocol/pool/L2Pool.sol",
    },
    "L2_POOL_IMPL"
  );
}

main();
