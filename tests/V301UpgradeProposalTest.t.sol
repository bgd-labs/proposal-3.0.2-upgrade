// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon} from 'aave-address-book/AaveAddressBook.sol';
import {DeployUpgrade} from '../scripts/DeployProposal.s.sol';
import {V301UpgradeProposal} from '../src/contracts/V301UpgradeProposal.sol';
import {ProtocolV3TestBase, ProtocolV3_0_1TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';

contract V301UpgradeProposalPolygonSnapshot is ProtocolV3TestBase {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 38552998);
  }

  function testProposal() public {
    createConfigurationSnapshot('pre-upgrade-polygon', AaveV3Polygon.POOL);
  }
}

contract V301UpgradeProposalPolygonTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 38552998);
    _selectPayloadExecutor(AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR);

    proposalPayload = DeployUpgrade.deployPolygon();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-polygon', AaveV3Polygon.POOL);
  }
}
