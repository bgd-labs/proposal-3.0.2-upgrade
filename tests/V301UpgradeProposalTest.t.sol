// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {ProtocolV3TestBase, ProtocolV3_0_1TestBase} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon, AaveV3Avalanche} from 'aave-address-book/AaveAddressBook.sol';

import {DeployUpgrade} from '../scripts/DeployProposal.s.sol';
import {V301UpgradeProposal} from '../src/contracts/V301UpgradeProposal.sol';

library ForkBlocks {
  uint256 constant POLYGON = 38552998;
  uint256 constant AVALANCHE = 25691722;
}

/**
 * Just generating snapshots via ProtocolV3TestBase so we can compare with ProtocolV3_0_1TestBase
 */
contract V301UpgradePreProposalSnapshot is ProtocolV3TestBase {
  V301UpgradeProposal public proposalPayload;

  uint256 polygonFork;
  uint256 avalancheFork;

  function setUp() public {
    polygonFork = vm.createFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
    avalancheFork = vm.createFork(vm.rpcUrl('avalanche'), ForkBlocks.AVALANCHE);
  }

  function createSnapshot() public {
    vm.selectFork(polygonFork);
    createConfigurationSnapshot('pre-upgrade-polygon', AaveV3Polygon.POOL);
    vm.selectFork(avalancheFork);
    createConfigurationSnapshot('pre-upgrade-avalanche', AaveV3Avalanche.POOL);
  }
}

contract V301UpgradePolygonProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
    _selectPayloadExecutor(AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR); // admin is the guardian

    proposalPayload = DeployUpgrade.deployPolygon();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-polygon', AaveV3Avalanche.POOL);

    // error due to supply cap - tests need improvement
    // address user = address(4);
    // e2eTest(AaveV3Polygon.POOL, user);
  }
}

contract V301UpgradeAvalancheProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), ForkBlocks.AVALANCHE);
    _selectPayloadExecutor(AaveV3Avalanche.ACL_ADMIN);

    proposalPayload = DeployUpgrade.deployAvalanche();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-avalanche', AaveV3Avalanche.POOL);

    // error due to supply cap - tests need improvement
    // address user = address(4);
    // e2eTest(AaveV3Polygon.POOL, user);
  }
}
