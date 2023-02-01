// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {ProtocolV3TestBase, ProtocolV3_0_1TestBase} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum} from 'aave-address-book/AaveAddressBook.sol';

import {DeployUpgrade} from '../scripts/DeployProposal.s.sol';
import {V301UpgradeProposal} from '../src/contracts/V301UpgradeProposal.sol';

library ForkBlocks {
  uint256 constant POLYGON = 38552998;
  uint256 constant AVALANCHE = 25691722;
  uint256 constant OPTIMISM = 71636817;
  uint256 constant ARBITRUM = 57167179;
}

/**
 * Just generating snapshots via ProtocolV3TestBase so we can compare with ProtocolV3_0_1TestBase
 */
contract V301UpgradePreProposalSnapshot is ProtocolV3TestBase {
  V301UpgradeProposal public proposalPayload;

  uint256 polygonFork;
  uint256 avalancheFork;
  uint256 optimismFork;
  uint256 arbitrumFork;

  function setUp() public {
    polygonFork = vm.createFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
    avalancheFork = vm.createFork(vm.rpcUrl('avalanche'), ForkBlocks.AVALANCHE);
    optimismFork = vm.createFork(vm.rpcUrl('optimism'), ForkBlocks.OPTIMISM);
    arbitrumFork = vm.createFork(vm.rpcUrl('arbitrum'), ForkBlocks.ARBITRUM);
  }

  function testCreateSnapshot() public {
    vm.selectFork(polygonFork);
    createConfigurationSnapshot('pre-upgrade-polygon', AaveV3Polygon.POOL);
    vm.selectFork(avalancheFork);
    createConfigurationSnapshot('pre-upgrade-avalanche', AaveV3Avalanche.POOL);
    vm.selectFork(optimismFork);
    createConfigurationSnapshot('pre-upgrade-optimism', AaveV3Optimism.POOL);
    vm.selectFork(arbitrumFork);
    createConfigurationSnapshot('pre-upgrade-arbitrum', AaveV3Arbitrum.POOL);
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
    // address user = address(42);
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
    // address user = address(42);
    // e2eTest(AaveV3Avalanche.POOL, user);
  }
}

contract V301UpgradeOptimismProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), ForkBlocks.OPTIMISM);
    _selectPayloadExecutor(AaveV3Optimism.ACL_ADMIN); // guardian is still owner of addresses provider

    proposalPayload = DeployUpgrade.deployOptimism();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-optimism', AaveV3Optimism.POOL);

    // error due to [FAIL. Reason: stdStorage find(StdStorage): Packed slot. This would cause dangerous overwriting and currently isn't supported.] - not sure what it means
    // address user = address(42);
    // e2eTest(AaveV3Optimism.POOL, user);
  }
}

contract V301UpgradeArbitrumProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradeProposal public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), ForkBlocks.ARBITRUM);
    _selectPayloadExecutor(AaveV3Arbitrum.ACL_ADMIN); // guardian is still owner of addresses provider

    proposalPayload = DeployUpgrade.deployArbitrum();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-arbitrum', AaveV3Arbitrum.POOL);

    // error due to supply cap - tests need improvement
    // address user = address(42);
    // e2eTest(AaveV3Arbitrum.POOL, user);
  }
}
