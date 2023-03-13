// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Vm} from 'forge-std/Vm.sol';
import {Script} from 'forge-std/Script.sol';
import {IPoolAddressesProvider, IPool, IPoolConfigurator, DataTypes, IACLManager} from 'aave-address-book/AaveV3.sol';

import {Pool} from 'aave-v3-core/contracts/protocol/pool/Pool.sol';
import {L2Pool} from 'aave-v3-core/contracts/protocol/pool/L2Pool.sol';
import {PoolConfigurator} from 'aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol';
import {AaveProtocolDataProvider} from 'aave-v3-core/contracts/misc/AaveProtocolDataProvider.sol';
import {IAaveIncentivesController} from 'aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol';
import {AToken} from 'aave-v3-core/contracts/protocol/tokenization/AToken.sol';
import {VariableDebtToken} from 'aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol';
import {StableDebtToken} from 'aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol';

import {V301EthereumUpgradePayload, V301L2UpgradePayload, SwapPermissionsPayload, SwapMigratorPermissionsPayload} from '../src/contracts/V301UpgradePayload.sol';

import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV3Ethereum} from 'aave-address-book/AaveV3Ethereum.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveV3Polygon.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';
import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';
import {AaveV3Fantom} from 'aave-address-book/AaveV3Fantom.sol';
import {AaveV3Harmony} from 'aave-address-book/AaveV3Harmony.sol';
import {AaveV3Optimism} from 'aave-address-book/AaveV3Optimism.sol';
import {AaveV3Arbitrum} from 'aave-address-book/AaveV3Arbitrum.sol';

// importing some unused files to make them available within the file graph
// funky workaround for https://github.com/gakonst/ethers-rs/pull/2256/files
import 'aave-v3-core/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol';
import 'aave-v3-periphery/contracts/rewards/EmissionManager.sol';
import 'aave-v3-periphery/contracts/rewards/RewardsController.sol';
import 'aave-v3-core/contracts/protocol/configuration/ACLManager.sol';
import 'aave-v3-core/contracts/misc/AaveOracle.sol';
import 'aave-v3-core/contracts/protocol/configuration/PoolAddressesProvider.sol';

library DeployPayloads {
  function _deployPoolImpl(
    IPoolAddressesProvider poolAddressesProvider
  ) internal returns (address) {
    Pool newPoolImpl = new Pool(poolAddressesProvider);
    newPoolImpl.initialize(poolAddressesProvider);
    return address(newPoolImpl);
  }

  function _deployL2PoolImpl(
    IPoolAddressesProvider poolAddressesProvider
  ) internal returns (address) {
    L2Pool newPoolImpl = new L2Pool(poolAddressesProvider);
    newPoolImpl.initialize(poolAddressesProvider);
    return address(newPoolImpl);
  }

  function _deployPoolConfiguratorImpl(
    IPoolAddressesProvider poolAddressesProvider
  ) internal returns (address) {
    PoolConfigurator newPoolConfiguratorImpl = new PoolConfigurator();
    newPoolConfiguratorImpl.initialize(poolAddressesProvider);
    return address(newPoolConfiguratorImpl);
  }

  function _deployProtocolDataProvider(
    IPoolAddressesProvider poolAddressesProvider
  ) internal returns (address) {
    AaveProtocolDataProvider poolDataProvider = new AaveProtocolDataProvider(poolAddressesProvider);
    return address(poolDataProvider);
  }

  function _deployAToken(IPool pool) internal returns (address) {
    AToken aTokenImpl = new AToken(pool);
    // follow empty initialization pattern like in previous deployments
    // ref: https://etherscan.io/tx/0x5004f1475de545a39a891aa0f3ada15c2dfb6970bf1a080ebd5e10fee4c74dc5
    aTokenImpl.initialize(
      pool,
      address(0),
      address(0),
      IAaveIncentivesController(address(0)),
      0,
      'ATOKEN_IMPL',
      'ATOKEN_IMPL',
      '0x00'
    );
    return address(aTokenImpl);
  }

  function _deployVToken(IPool pool) internal returns (address) {
    VariableDebtToken variableDebtTokenImpl = new VariableDebtToken(pool);
    // follow empty initialization pattern like in previous deployments
    // ref: https://etherscan.io/tx/0xb31ebf63d6814ebbf0c7647d59010dabf75f094dd798f148f31941b872bc0c93
    variableDebtTokenImpl.initialize(
      pool,
      address(0),
      IAaveIncentivesController(address(0)),
      0,
      'VARIABLE_DEBT_TOKEN_IMPL',
      'VARIABLE_DEBT_TOKEN_IMPL',
      '0x00'
    );
    return address(variableDebtTokenImpl);
  }

  function _deploySToken(IPool pool) internal returns (address) {
    StableDebtToken stableDebtTokenImpl = new StableDebtToken(pool);
    // follow empty initialization pattern like in previous deployments
    // ref: https://etherscan.io/tx/0xb31ebf63d6814ebbf0c7647d59010dabf75f094dd798f148f31941b872bc0c93
    stableDebtTokenImpl.initialize(
      pool,
      address(0),
      IAaveIncentivesController(address(0)),
      0,
      'STABLE_DEBT_TOKEN_IMPL',
      'STABLE_DEBT_TOKEN_IMPL',
      '0x00'
    );
    return address(stableDebtTokenImpl);
  }

  function _deploy(
    IPoolAddressesProvider poolAddressesProvider,
    IPool pool
  ) internal returns (V301L2UpgradePayload.AddressArgs memory) {
    V301L2UpgradePayload.AddressArgs memory addresses;
    addresses.newPoolImpl = _deployPoolImpl(poolAddressesProvider);
    addresses.newPoolConfiguratorImpl = _deployPoolConfiguratorImpl(poolAddressesProvider);
    addresses.newProtocolDataProvider = _deployProtocolDataProvider(poolAddressesProvider);
    addresses.newATokenImpl = _deployAToken(pool);
    addresses.newVTokenImpl = _deployVToken(pool);
    addresses.newSTokenImpl = _deploySToken(pool);
    addresses.poolAddressesProvider = poolAddressesProvider;
    addresses.pool = pool;
    return addresses;
  }

  function _deployL2(
    IPoolAddressesProvider poolAddressesProvider,
    IPool pool
  ) internal returns (V301L2UpgradePayload.AddressArgs memory) {
    V301L2UpgradePayload.AddressArgs memory addresses;
    addresses.newPoolImpl = _deployL2PoolImpl(poolAddressesProvider);
    addresses.newPoolConfiguratorImpl = _deployPoolConfiguratorImpl(poolAddressesProvider);
    addresses.newProtocolDataProvider = _deployProtocolDataProvider(poolAddressesProvider);
    addresses.newATokenImpl = _deployAToken(pool);
    addresses.newVTokenImpl = _deployVToken(pool);
    addresses.newSTokenImpl = _deploySToken(pool);
    addresses.poolAddressesProvider = poolAddressesProvider;
    addresses.pool = pool;
    return addresses;
  }

  function deployMainnet() internal returns (V301EthereumUpgradePayload) {
    address poolImpl = _deployPoolImpl(AaveV3Ethereum.POOL_ADDRESSES_PROVIDER);
    return
      new V301EthereumUpgradePayload(
        AaveV3Ethereum.POOL_ADDRESSES_PROVIDER,
        poolImpl,
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3Ethereum.SWAP_COLLATERAL_ADAPTER,
        AaveV2Ethereum.MIGRATION_HELPER
      );
  }

  function deployPolygon() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = _deploy({
      poolAddressesProvider: AaveV3Polygon.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Polygon.POOL
    });
    addresses.poolConfigurator = AaveV3Polygon.POOL_CONFIGURATOR;
    addresses.collector = AaveV3Polygon.COLLECTOR;
    addresses.incentivesController = AaveV3Polygon.DEFAULT_INCENTIVES_CONTROLLER;

    return
      new SwapMigratorPermissionsPayload(
        addresses,
        AaveV3Polygon.ACL_MANAGER,
        AaveV3Polygon.SWAP_COLLATERAL_ADAPTER,
        AaveV2Polygon.MIGRATION_HELPER
      );
  }

  function deployAvalanche() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = _deploy({
      poolAddressesProvider: AaveV3Avalanche.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Avalanche.POOL
    });
    addresses.poolConfigurator = AaveV3Avalanche.POOL_CONFIGURATOR;
    addresses.collector = AaveV3Avalanche.COLLECTOR;
    addresses.incentivesController = AaveV3Avalanche.DEFAULT_INCENTIVES_CONTROLLER;

    return
      new SwapMigratorPermissionsPayload(
        addresses,
        AaveV3Avalanche.ACL_MANAGER,
        AaveV3Avalanche.SWAP_COLLATERAL_ADAPTER,
        AaveV2Avalanche.MIGRATION_HELPER
      );
  }

  function deployFantom() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = _deploy({
      poolAddressesProvider: AaveV3Fantom.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Fantom.POOL
    });
    addresses.poolConfigurator = AaveV3Fantom.POOL_CONFIGURATOR;
    addresses.collector = AaveV3Fantom.COLLECTOR;
    addresses.incentivesController = AaveV3Fantom.DEFAULT_INCENTIVES_CONTROLLER;

    return
      new SwapPermissionsPayload(
        addresses,
        AaveV3Fantom.ACL_MANAGER,
        AaveV3Fantom.SWAP_COLLATERAL_ADAPTER
      );
  }

  function deployOptimism() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = _deployL2({
      poolAddressesProvider: AaveV3Optimism.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Optimism.POOL
    });
    addresses.poolConfigurator = AaveV3Optimism.POOL_CONFIGURATOR;
    addresses.collector = AaveV3Optimism.COLLECTOR;
    addresses.incentivesController = AaveV3Optimism.DEFAULT_INCENTIVES_CONTROLLER;

    return
      new SwapPermissionsPayload(
        addresses,
        AaveV3Optimism.ACL_MANAGER,
        AaveV3Optimism.SWAP_COLLATERAL_ADAPTER
      );
  }

  function deployArbitrum() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = _deployL2({
      poolAddressesProvider: AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Arbitrum.POOL
    });
    addresses.poolConfigurator = AaveV3Arbitrum.POOL_CONFIGURATOR;
    addresses.collector = AaveV3Arbitrum.COLLECTOR;
    addresses.incentivesController = AaveV3Arbitrum.DEFAULT_INCENTIVES_CONTROLLER;

    return
      new SwapPermissionsPayload(
        addresses,
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3Arbitrum.SWAP_COLLATERAL_ADAPTER
      );
  }

  function deployHarmony() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = _deploy({
      poolAddressesProvider: AaveV3Harmony.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Harmony.POOL
    });
    addresses.poolConfigurator = AaveV3Harmony.POOL_CONFIGURATOR;
    addresses.collector = AaveV3Harmony.COLLECTOR;
    addresses.incentivesController = AaveV3Harmony.DEFAULT_INCENTIVES_CONTROLLER;

    return new V301L2UpgradePayload(addresses);
  }
}

contract DeployPolygon is Script {
  function run() external {
    require(block.chainid == 1, 'MAINNET_ONLY');
    vm.startBroadcast();
    DeployPayloads.deployMainnet();
    vm.stopBroadcast();
  }
}

contract DeployPolygon is Script {
  function run() external {
    require(block.chainid == 137, 'POLYGON_ONLY');
    vm.startBroadcast();
    DeployPayloads.deployPolygon();
    vm.stopBroadcast();
  }
}

contract DeployOptimism is Script {
  function run() external {
    require(block.chainid == 10, 'OPTIMISM_ONLY');
    vm.startBroadcast();
    DeployPayloads.deployOptimism();
    vm.stopBroadcast();
  }
}

contract DeployArbitrum is Script {
  function run() external {
    require(block.chainid == 42161, 'ARBITRUM_ONLY');
    vm.startBroadcast();
    DeployPayloads.deployArbitrum();
    vm.stopBroadcast();
  }
}

contract DeployAvalanche is Script {
  function run() external {
    require(block.chainid == 43114, 'AVALANCHE_ONLY');
    vm.startBroadcast();
    DeployPayloads.deployAvalanche();
    vm.stopBroadcast();
  }
}

contract DeployFantom is Script {
  function run() external {
    require(block.chainid == 250, 'FANTOM_ONLY');
    vm.startBroadcast();
    DeployPayloads.deployFantom();
    vm.stopBroadcast();
  }
}

contract DeployHarmony is Script {
  function run() external {
    require(block.chainid == 1666600000, 'HARMONY_ONLY');
    vm.startBroadcast();
    DeployPayloads.deployHarmony();
    vm.stopBroadcast();
  }
}
