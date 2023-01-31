// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Vm} from 'forge-std/Vm.sol';
import {Script} from 'forge-std/Script.sol';
import {IPoolAddressesProvider, IPool, IPoolConfigurator, DataTypes} from 'aave-address-book/AaveV3.sol';

import {Pool} from 'aave-v3-core/contracts/protocol/pool/Pool.sol';
import {L2Pool} from 'aave-v3-core/contracts/protocol/pool/L2Pool.sol';
import {PoolConfigurator} from 'aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol';
import {AaveProtocolDataProvider} from 'aave-v3-core/contracts/misc/AaveProtocolDataProvider.sol';
import {IAaveIncentivesController} from 'aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol';
import {AToken} from 'aave-v3-core/contracts/protocol/tokenization/AToken.sol';
import {VariableDebtToken} from 'aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol';
import {StableDebtToken} from 'aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol';

import {V301UpgradeProposal} from '../src/contracts/V301UpgradeProposal.sol';

// temp
import {AaveV3Polygon} from 'aave-address-book/AaveAddressBook.sol';

library DeployUpgrade {
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

  function _deployProposal(
    IPoolAddressesProvider poolAddressesProvider,
    IPool pool,
    IPoolConfigurator poolConfigurator,
    address collector,
    address incentivesController,
    address poolImpl
  ) internal returns (V301UpgradeProposal) {
    address poolPoolConfiguratorImpl = _deployPoolConfiguratorImpl(poolAddressesProvider);
    address protocolDataProvider = _deployProtocolDataProvider(poolAddressesProvider);
    address aTokenImpl = _deployAToken(pool);
    address vTokenImpl = _deployVToken(pool);
    address sTokenImpl = _deploySToken(pool);

    return
      new V301UpgradeProposal({
        poolAddressesProvider: poolAddressesProvider,
        pool: pool,
        poolConfigurator: poolConfigurator,
        collector: collector,
        incentivesController: incentivesController,
        newPoolImpl: poolImpl,
        newPoolConfiguratorImpl: poolPoolConfiguratorImpl,
        newProtocolDataProvider: protocolDataProvider,
        newATokenImpl: aTokenImpl,
        newVTokenImpl: vTokenImpl,
        newSTokenImpl: sTokenImpl
      });
  }

  function _deploy(
    IPoolAddressesProvider poolAddressesProvider,
    IPool pool,
    IPoolConfigurator poolConfigurator,
    address collector,
    address incentivesController
  ) public returns (V301UpgradeProposal) {
    address poolImpl = _deployPoolImpl(poolAddressesProvider);
    return
      _deployProposal({
        poolImpl: poolImpl,
        poolAddressesProvider: poolAddressesProvider,
        pool: pool,
        poolConfigurator: poolConfigurator,
        collector: collector,
        incentivesController: incentivesController
      });
  }

  function _deployL2(
    IPoolAddressesProvider poolAddressesProvider,
    IPool pool,
    IPoolConfigurator poolConfigurator,
    address collector,
    address incentivesController
  ) public returns (V301UpgradeProposal) {
    address poolImpl = _deployL2PoolImpl(poolAddressesProvider);
    return
      _deployProposal({
        poolImpl: poolImpl,
        poolAddressesProvider: poolAddressesProvider,
        pool: pool,
        poolConfigurator: poolConfigurator,
        collector: collector,
        incentivesController: incentivesController
      });
  }

  function deployPolygon() public returns (V301UpgradeProposal) {
    return
      _deploy({
        poolAddressesProvider: AaveV3Polygon.POOL_ADDRESSES_PROVIDER,
        pool: AaveV3Polygon.POOL,
        poolConfigurator: AaveV3Polygon.POOL_CONFIGURATOR,
        collector: AaveV3Polygon.COLLECTOR,
        incentivesController: AaveV3Polygon.DEFAULT_INCENTIVES_CONTROLLER
      });
  }
}

contract Deploy is Script {
  function run() external {
    vm.startBroadcast();
    vm.stopBroadcast();
  }
}
