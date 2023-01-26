// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveAddressBook.sol';
import {DeployUpgrade} from '../scripts/DeployProposal.s.sol';
import {V301UpgradeProposal} from '../src/contracts/V301UpgradeProposal.sol';

contract V301UpgradeProposalTest is TestWithExecutor {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 38552998);
    _selectPayloadExecutor(AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR);

    address poolImpl = DeployUpgrade._deployPoolImpl(AaveV3Polygon.POOL_ADDRESSES_PROVIDER);
    address poolPoolConfiguratorImpl = DeployUpgrade._deployPoolConfiguratorImpl(
      AaveV3Polygon.POOL_ADDRESSES_PROVIDER
    );
    address protocolDataProvider = DeployUpgrade._deployProtocolDataProvider(
      AaveV3Polygon.POOL_ADDRESSES_PROVIDER
    );
    address aTokenImpl = DeployUpgrade._deployAToken(AaveV3Polygon.POOL);
    address vTokenImpl = DeployUpgrade._deployVToken(AaveV3Polygon.POOL);

    proposalPayload = new V301UpgradeProposal({
      poolAddressesProvider: AaveV3Polygon.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Polygon.POOL,
      poolConfigurator: AaveV3Polygon.POOL_CONFIGURATOR,
      collector: AaveV3Polygon.COLLECTOR,
      incentivesController: AaveV3Polygon.DEFAULT_INCENTIVES_CONTROLLER,
      newPoolImpl: poolImpl,
      newPoolConfiguratorImpl: poolPoolConfiguratorImpl,
      newProtocolDataProvider: protocolDataProvider,
      newATokenImpl: aTokenImpl,
      newVTokenImpl: vTokenImpl
    });
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
  }
}
