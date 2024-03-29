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
    return
      new V301EthereumUpgradePayload(
        AaveV3Ethereum.POOL_ADDRESSES_PROVIDER,
        AaveV3Ethereum.POOL_CONFIGURATOR,
        0xF1Cd4193bbc1aD4a23E833170f49d60f3D35a621, // https://etherscan.io/address/0xF1Cd4193bbc1aD4a23E833170f49d60f3D35a621#code
        AaveV3Ethereum.ACL_MANAGER,
        AaveV3Ethereum.SWAP_COLLATERAL_ADAPTER,
        AaveV2Ethereum.MIGRATION_HELPER
      );
  }

  function deployPolygon() internal returns (V301L2UpgradePayload) {
    // addresses from https://polygonscan.com/address/0xa603ad2b0258bdda94f3dfdb26859ef205ae9244#readContract
    V301L2UpgradePayload.AddressArgs memory addresses = V301L2UpgradePayload.AddressArgs({
      poolAddressesProvider: AaveV3Polygon.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Polygon.POOL,
      poolConfigurator: AaveV3Polygon.POOL_CONFIGURATOR,
      collector: AaveV3Polygon.COLLECTOR,
      incentivesController: AaveV3Polygon.DEFAULT_INCENTIVES_CONTROLLER,
      newPoolImpl: 0xb77fc84a549ecc0b410d6fa15159C2df207545a3,
      newPoolConfiguratorImpl: 0xADf86b537eF08591c2777E144322E8b0Ca7E82a7,
      newProtocolDataProvider: 0x9441B65EE553F70df9C77d45d3283B6BC24F222d,
      newATokenImpl: 0xCf85FF1c37c594a10195F7A9Ab85CBb0a03f69dE,
      newVTokenImpl: 0x79b5e91037AE441dE0d9e6fd3Fd85b96B83d4E93,
      newSTokenImpl: 0x50ddd0Cd4266299527d25De9CBb55fE0EB8dAc30
    });

    return
      new SwapMigratorPermissionsPayload(
        addresses,
        AaveV3Polygon.ACL_MANAGER,
        AaveV3Polygon.SWAP_COLLATERAL_ADAPTER,
        AaveV2Polygon.MIGRATION_HELPER
      );
  }

  function deployAvalanche() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = V301L2UpgradePayload.AddressArgs({
      poolAddressesProvider: AaveV3Avalanche.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Avalanche.POOL,
      poolConfigurator: AaveV3Avalanche.POOL_CONFIGURATOR,
      collector: AaveV3Avalanche.COLLECTOR,
      incentivesController: AaveV3Avalanche.DEFAULT_INCENTIVES_CONTROLLER,
      newPoolImpl: 0xCf85FF1c37c594a10195F7A9Ab85CBb0a03f69dE,
      newPoolConfiguratorImpl: 0x79b5e91037AE441dE0d9e6fd3Fd85b96B83d4E93,
      newProtocolDataProvider: 0x50ddd0Cd4266299527d25De9CBb55fE0EB8dAc30,
      newATokenImpl: 0x1E81af09001aD208BDa68FF022544dB2102A752d,
      newVTokenImpl: 0xa0d9C1E9E48Ca30c8d8C3B5D69FF5dc1f6DFfC24,
      newSTokenImpl: 0x893411580e590D62dDBca8a703d61Cc4A8c7b2b9
    });

    return
      new SwapMigratorPermissionsPayload(
        addresses,
        AaveV3Avalanche.ACL_MANAGER,
        AaveV3Avalanche.SWAP_COLLATERAL_ADAPTER,
        AaveV2Avalanche.MIGRATION_HELPER
      );
  }

  function deployFantom() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = V301L2UpgradePayload.AddressArgs({
      poolAddressesProvider: AaveV3Fantom.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Fantom.POOL,
      poolConfigurator: AaveV3Fantom.POOL_CONFIGURATOR,
      collector: AaveV3Fantom.COLLECTOR,
      incentivesController: AaveV3Fantom.DEFAULT_INCENTIVES_CONTROLLER,
      newPoolImpl: 0x84B08568906ee891de1c23175E5B92d7Df7DDCc4,
      newPoolConfiguratorImpl: 0x7CB7fdeEB5E71f322F8E39Be67959C32a6A3aAA3,
      newProtocolDataProvider: 0x764594F8e9757edE877B75716f8077162B251460,
      newATokenImpl: 0x8f30ADaA6950b31f675bF8a709Bc23F55aa24735,
      newVTokenImpl: 0x61637B1EF7e9A102e50B661D3d7dbe19ef93347e,
      newSTokenImpl: 0xbCb167bDCF14a8F791d6f4A6EDd964aed2F8813B
    });

    return
      new SwapPermissionsPayload(
        addresses,
        AaveV3Fantom.ACL_MANAGER,
        AaveV3Fantom.SWAP_COLLATERAL_ADAPTER
      );
  }

  function deployOptimism() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = V301L2UpgradePayload.AddressArgs({
      poolAddressesProvider: AaveV3Optimism.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Optimism.POOL,
      poolConfigurator: AaveV3Optimism.POOL_CONFIGURATOR,
      collector: AaveV3Optimism.COLLECTOR,
      incentivesController: AaveV3Optimism.DEFAULT_INCENTIVES_CONTROLLER,
      newPoolImpl: 0x764594F8e9757edE877B75716f8077162B251460,
      newPoolConfiguratorImpl: 0x29081f7aB5a644716EfcDC10D5c926c5fEe9F72B,
      newProtocolDataProvider: 0xd9Ca4878dd38B021583c1B669905592EAe76E044,
      newATokenImpl: 0xbCb167bDCF14a8F791d6f4A6EDd964aed2F8813B,
      newVTokenImpl: 0x04a8D477eE202aDCE1682F5902e1160455205b12,
      newSTokenImpl: 0x6b4E260b765B3cA1514e618C0215A6B7839fF93e
    });

    return
      new SwapPermissionsPayload(
        addresses,
        AaveV3Optimism.ACL_MANAGER,
        AaveV3Optimism.SWAP_COLLATERAL_ADAPTER
      );
  }

  function deployArbitrum() internal returns (V301L2UpgradePayload) {
    V301L2UpgradePayload.AddressArgs memory addresses = V301L2UpgradePayload.AddressArgs({
      poolAddressesProvider: AaveV3Arbitrum.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Arbitrum.POOL,
      poolConfigurator: AaveV3Arbitrum.POOL_CONFIGURATOR,
      collector: AaveV3Arbitrum.COLLECTOR,
      incentivesController: AaveV3Arbitrum.DEFAULT_INCENTIVES_CONTROLLER,
      newPoolImpl: 0xbCb167bDCF14a8F791d6f4A6EDd964aed2F8813B,
      newPoolConfiguratorImpl: 0x04a8D477eE202aDCE1682F5902e1160455205b12,
      newProtocolDataProvider: 0x6b4E260b765B3cA1514e618C0215A6B7839fF93e,
      newATokenImpl: 0x1Be1798b70aEe431c2986f7ff48d9D1fa350786a,
      newVTokenImpl: 0x5E76E98E0963EcDC6A065d1435F84065b7523f39,
      newSTokenImpl: 0x0c2C95b24529664fE55D4437D7A31175CFE6c4f7
    });

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

contract DeployMainnet is Script {
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
