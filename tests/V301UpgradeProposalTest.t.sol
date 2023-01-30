// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {ProtocolV3TestBase, ProtocolV3_0_1TestBase} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon, AaveV3Ethereum} from 'aave-address-book/AaveAddressBook.sol';

import {DeployUpgrade} from '../scripts/DeployProposal.s.sol';
import {V301UpgradeProposal} from '../src/contracts/V301UpgradeProposal.sol';

library ForkBlocks {
  uint256 constant POLYGON = 38552998;
}

/**
 * Just generating snapshots via ProtocolV3TestBase so we can compare with ProtocolV3_0_1TestBase
 */
contract V301UpgradePreProposalSnapshot is ProtocolV3TestBase {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
  }

  function testProposal() public {
    createConfigurationSnapshot('pre-upgrade-polygon', AaveV3Polygon.POOL);
  }
}

contract V301UpgradeProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
    _selectPayloadExecutor(AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR);

    proposalPayload = DeployUpgrade.deployPolygon();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-polygon', AaveV3Polygon.POOL);
  }
}
