// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveAddressBook.sol';
import {V301UpgradeProposal} from '../src/contracts/V301UpgradeProposal.sol';

contract V301UpgradeProposalTest is TestWithExecutor {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 38552998);
    _selectPayloadExecutor(AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR);
    proposalPayload = new V301UpgradeProposal({
      poolAddressesProvider: AaveV3Polygon.POOL_ADDRESSES_PROVIDER,
      pool: AaveV3Polygon.POOL,
      poolConfigurator: AaveV3Polygon.POOL_CONFIGURATOR,
      collector: AaveV3Polygon.COLLECTOR,
      incentivesController: AaveV3Polygon.DEFAULT_INCENTIVES_CONTROLLER
    });
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
  }
}
