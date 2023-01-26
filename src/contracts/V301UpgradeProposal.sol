// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IPoolAddressesProvider, IPool, IPoolConfigurator, DataTypes} from 'aave-address-book/AaveV3.sol';
import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {ConfiguratorInputTypes} from 'aave-v3-core/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol';
// TODO: use interface
import {AToken} from 'aave-v3-core/contracts/protocol/tokenization/AToken.sol';
import {VariableDebtToken} from 'aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol';

contract V301UpgradeProposal is IProposalGenericExecutor {
  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;
  IPool public immutable POOL;
  IPoolConfigurator public immutable POOL_CONFIGURATOR;
  address public immutable COLLECTOR;
  address public immutable INCENTIVES_CONTROLLER;

  address public immutable NEW_POOL_IMPL;
  address public immutable NEW_POOL_CONFIGURATOR_IMPL;
  address public immutable NEW_PROTOCOL_DATA_PROVIDER;
  address public immutable NEW_ATOKEN_IMPL;
  address public immutable NEW_VTOKEN_IMPL;

  constructor(
    IPoolAddressesProvider poolAddressesProvider,
    IPool pool,
    IPoolConfigurator poolConfigurator,
    address collector,
    address incentivesController,
    address newPoolImpl,
    address newPoolConfiguratorImpl,
    address newProtocolDataProvider,
    address newATokenImpl,
    address newVTokenImpl
  ) {
    POOL_ADDRESSES_PROVIDER = poolAddressesProvider;
    POOL = pool;
    POOL_CONFIGURATOR = poolConfigurator;
    COLLECTOR = collector;
    INCENTIVES_CONTROLLER = incentivesController;

    NEW_POOL_IMPL = newPoolImpl;
    NEW_POOL_CONFIGURATOR_IMPL = newPoolConfiguratorImpl;
    NEW_PROTOCOL_DATA_PROVIDER = newProtocolDataProvider;
    NEW_ATOKEN_IMPL = newATokenImpl;
    NEW_VTOKEN_IMPL = newVTokenImpl;
  }

  function execute() public {
    POOL_ADDRESSES_PROVIDER.setPoolImpl(NEW_POOL_IMPL);

    POOL_ADDRESSES_PROVIDER.setPoolConfiguratorImpl(NEW_POOL_CONFIGURATOR_IMPL);

    POOL_ADDRESSES_PROVIDER.setPoolDataProvider(NEW_PROTOCOL_DATA_PROVIDER);

    _updateTokens();
  }

  function _updateTokens() internal {
    address[] memory reserves = POOL.getReservesList();

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
          implementation: NEW_ATOKEN_IMPL,
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
          implementation: NEW_VTOKEN_IMPL,
          params: '0x10' // this parameter is not actually used anywhere
        });

      POOL_CONFIGURATOR.updateVariableDebtToken(inputVToken);
    }
  }
}
