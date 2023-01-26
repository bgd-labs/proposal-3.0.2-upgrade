// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {IPoolAddressesProvider, IPool, IPoolConfigurator, DataTypes} from 'aave-address-book/AaveV3.sol';

import {Pool} from 'aave-v3-core/contracts/protocol/pool/Pool.sol';
import {L2Pool} from 'aave-v3-core/contracts/protocol/pool/L2Pool.sol';
import {PoolConfigurator} from 'aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol';
import {AaveProtocolDataProvider} from 'aave-v3-core/contracts/misc/AaveProtocolDataProvider.sol';
import {AToken} from 'aave-v3-core/contracts/protocol/tokenization/AToken.sol';
import {VariableDebtToken} from 'aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol';

library DeployUpgrade {
  function _deployPoolImpl(IPoolAddressesProvider poolAddressesProvider) public returns (address) {
    Pool newPoolImpl = new Pool(poolAddressesProvider);
    newPoolImpl.initialize(poolAddressesProvider);
    return address(newPoolImpl);
  }

  function _deployL2PoolImpl(
    IPoolAddressesProvider poolAddressesProvider
  ) public returns (address) {
    L2Pool newPoolImpl = new L2Pool(poolAddressesProvider);
    newPoolImpl.initialize(poolAddressesProvider);
    return address(newPoolImpl);
  }

  function _deployPoolConfiguratorImpl(
    IPoolAddressesProvider poolAddressesProvider
  ) public returns (address) {
    PoolConfigurator newPoolConfiguratorImpl = new PoolConfigurator();
    newPoolConfiguratorImpl.initialize(poolAddressesProvider);
    return address(newPoolConfiguratorImpl);
  }

  function _deployProtocolDataProvider(
    IPoolAddressesProvider poolAddressesProvider
  ) public returns (address) {
    AaveProtocolDataProvider poolDataProvider = new AaveProtocolDataProvider(poolAddressesProvider);
    return address(poolDataProvider);
  }

  function _deployAToken(IPool pool) public returns (address) {
    AToken aTokenImpl = new AToken(pool); // TODO: initialize
    return address(aTokenImpl);
  }

  function _deployVToken(IPool pool) public returns (address) {
    VariableDebtToken variableDebtTokenImpl = new VariableDebtToken(pool); // TODO: initialize
    return address(variableDebtTokenImpl);
  }
}

contract Deploy is Script {
  function run() external {
    vm.startBroadcast();
    vm.stopBroadcast();
  }
}
