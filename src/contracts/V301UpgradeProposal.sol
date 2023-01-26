// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IPoolAddressesProvider, IPool, IPoolConfigurator, DataTypes} from 'aave-address-book/AaveV3.sol';
import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveProtocolDataProvider} from 'aave-v3-core/contracts/misc/AaveProtocolDataProvider.sol';
import {Pool} from 'aave-v3-core/contracts/protocol/pool/Pool.sol';
import {AToken} from 'aave-v3-core/contracts/protocol/tokenization/AToken.sol';
import {VariableDebtToken} from 'aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol';
import {PoolConfigurator} from 'aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol';
import {ConfiguratorInputTypes} from 'aave-v3-core/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol';

contract V301UpgradeProposal is IProposalGenericExecutor {
  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  IPool public immutable POOL;
  IPoolConfigurator public immutable POOL_CONFIGURATOR;
  address public immutable COLLECTOR;
  address public immutable INCENTIVES_CONTROLLER;

  constructor(
    IPoolAddressesProvider poolAddressesProvider,
    IPool pool,
    IPoolConfigurator poolConfigurator,
    address collector,
    address incentivesController
  ) {
    POOL_ADDRESSES_PROVIDER = poolAddressesProvider;
    POOL = pool;
    POOL_CONFIGURATOR = poolConfigurator;
    COLLECTOR = collector;
    INCENTIVES_CONTROLLER = incentivesController;
  }

  function execute() public {
    // Pool newPoolImpl = new Pool(POOL_ADDRESSES_PROVIDER);
    // POOL_ADDRESSES_PROVIDER.setPoolImpl(address(newPoolImpl));

    // PoolConfigurator newConfiguratorImpl = new PoolConfigurator();
    // POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(address(newConfiguratorImpl));

    AaveProtocolDataProvider poolDataProvider = new AaveProtocolDataProvider(
      POOL_ADDRESSES_PROVIDER
    );
    POOL_ADDRESSES_PROVIDER.setPoolDataProvider(address(poolDataProvider));

    _updateTokens();
  }

  function _updateTokens() internal {
    address[] memory reserves = POOL.getReservesList();
    AToken aTokenImpl = new AToken(POOL); // TODO: initialize
    VariableDebtToken variableDebtTokenImpl = new VariableDebtToken(POOL); // TODO: initialize

    for (uint256 i = 0; i < reserves.length; i++) {
      DataTypes.ReserveData memory reserveData = POOL.getReserveData(reserves[i]);

      AToken aToken = AToken(reserveData.aTokenAddress);
      ConfiguratorInputTypes.UpdateATokenInput memory inputAToken = ConfiguratorInputTypes
        .UpdateATokenInput({
          asset: reserves[i],
          treasury: COLLECTOR,
          incentivesController: INCENTIVES_CONTROLLER,
          name: aToken.name(),
          symbol: aToken.symbol(),
          implementation: address(aTokenImpl),
          params: '0x10' // this parameter is not actually used anywhere
        });

      POOL_CONFIGURATOR.updateAToken(inputAToken);

      VariableDebtToken vToken = VariableDebtToken(reserveData.variableDebtTokenAddress);
      ConfiguratorInputTypes.UpdateDebtTokenInput memory inputVToken = ConfiguratorInputTypes
        .UpdateDebtTokenInput({
          asset: reserves[i],
          incentivesController: INCENTIVES_CONTROLLER,
          name: vToken.name(),
          symbol: vToken.symbol(),
          implementation: address(variableDebtTokenImpl),
          params: '0x10' // this parameter is not actually used anywhere
        });

      POOL_CONFIGURATOR.updateVariableDebtToken(inputVToken);
    }
  }
}
