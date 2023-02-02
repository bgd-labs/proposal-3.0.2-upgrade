// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {ProtocolV3TestBase, ProtocolV3_0_1TestBase} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Harmony, AaveV3Fantom} from 'aave-address-book/AaveAddressBook.sol';

import {DeployPayloads} from '../scripts/DeployPayloads.s.sol';
import {V301UpgradePayload} from '../src/contracts/V301UpgradePayload.sol';

library ForkBlocks {
  uint256 constant POLYGON = 38552998;
  uint256 constant AVALANCHE = 25691722;
  uint256 constant OPTIMISM = 71636817;
  uint256 constant ARBITRUM = 57167179;
  uint256 constant FANTOM = 54855719;
  uint256 constant HARMONY = 37364700;
}

/**
 * Just generating snapshots via ProtocolV3TestBase so we can compare with ProtocolV3_0_1TestBase
 */
contract V301UpgradePreProposalSnapshot is ProtocolV3TestBase {
  uint256 polygonFork;
  uint256 avalancheFork;
  uint256 optimismFork;
  uint256 arbitrumFork;
  uint256 harmonyFork;
  uint256 fantomFork;

  function setUp() public {
    polygonFork = vm.createFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
    avalancheFork = vm.createFork(vm.rpcUrl('avalanche'), ForkBlocks.AVALANCHE);
    optimismFork = vm.createFork(vm.rpcUrl('optimism'), ForkBlocks.OPTIMISM);
    arbitrumFork = vm.createFork(vm.rpcUrl('arbitrum'), ForkBlocks.ARBITRUM);
    harmonyFork = vm.createFork(vm.rpcUrl('harmony'), ForkBlocks.HARMONY);
    fantomFork = vm.createFork(vm.rpcUrl('fantom'), ForkBlocks.FANTOM);
  }

  function testCreateSnapshot() public {
    vm.selectFork(polygonFork);
    createConfigurationSnapshot('pre-upgrade-polygon', AaveV3Polygon.POOL);
    vm.selectFork(avalancheFork);
    createConfigurationSnapshot('pre-upgrade-avalanche', AaveV3Avalanche.POOL);
    vm.selectFork(optimismFork);
    createConfigurationSnapshot('pre-upgrade-optimism', AaveV3Optimism.POOL);
    vm.selectFork(harmonyFork);
    createConfigurationSnapshot('pre-upgrade-harmony', AaveV3Harmony.POOL);
    vm.selectFork(fantomFork);
    createConfigurationSnapshot('pre-upgrade-fantom', AaveV3Fantom.POOL);
  }
}

contract V301UpgradePolygonProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradePayload public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
    _selectPayloadExecutor(AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR); // admin is the guardian

    proposalPayload = DeployPayloads.deployPolygon();
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
  V301UpgradePayload public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), ForkBlocks.AVALANCHE);
    _selectPayloadExecutor(AaveV3Avalanche.ACL_ADMIN);

    proposalPayload = DeployPayloads.deployAvalanche();
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
  V301UpgradePayload public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), ForkBlocks.OPTIMISM);
    _selectPayloadExecutor(AaveV3Optimism.ACL_ADMIN); // guardian is still owner of addresses provider

    proposalPayload = DeployPayloads.deployOptimism();
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
  V301UpgradePayload public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), ForkBlocks.ARBITRUM);
    _selectPayloadExecutor(AaveV3Arbitrum.ACL_ADMIN); // guardian is still owner of addresses provider

    proposalPayload = DeployPayloads.deployArbitrum();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-arbitrum', AaveV3Arbitrum.POOL);

    // error due to supply cap - tests need improvement
    // address user = address(42);
    // e2eTest(AaveV3Arbitrum.POOL, user);
  }
}

contract V301UpgradeHarmonyProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradePayload public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('harmony'), ForkBlocks.HARMONY);
    _selectPayloadExecutor(AaveV3Harmony.ACL_ADMIN); // guardian is still owner of addresses provider

    proposalPayload = DeployPayloads.deployHarmony();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-harmony', AaveV3Harmony.POOL);

    // error due to supply cap - tests need improvement
    // address user = address(42);
    // e2eTest(AaveV3Arbitrum.POOL, user);
  }
}

contract V301UpgradeFantomProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301UpgradePayload public proposalPayload;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('fantom'), ForkBlocks.FANTOM);
    _selectPayloadExecutor(AaveV3Fantom.ACL_ADMIN); // guardian is still owner of addresses provider

    proposalPayload = DeployPayloads.deployFantom();
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-fantom', AaveV3Fantom.POOL);

    // error due to supply cap - tests need improvement
    // address user = address(42);
    // e2eTest(AaveV3Arbitrum.POOL, user);
  }

  // function testFfi() public {
  //   string[] memory inputs = new string[](4);
  //   inputs[0] = 'make';
  //   inputs[1] = 'git-diff';
  //   inputs[2] = abi.encodePacked('before=');
  //   inputs[3] = 'after=';
  //   inputs[4] = 'out=';

  //   vm.ffi(inputs);
  // }
}
