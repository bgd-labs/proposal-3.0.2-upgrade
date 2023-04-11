// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {ProtocolV3TestBase, ProtocolV3_0_1TestBase, ReserveConfig} from 'aave-helpers/ProtocolV3TestBase.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Ethereum, AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Harmony, AaveV3Fantom} from 'aave-address-book/AaveAddressBook.sol';

import {DeployPayloads} from '../scripts/DeployPayloads.s.sol';
import {V301L2UpgradePayload, V301EthereumUpgradePayload} from '../src/contracts/V301UpgradePayload.sol';

library ForkBlocks {
  uint256 constant MAINNET = 17023945;
  uint256 constant POLYGON = 41401211;
  uint256 constant AVALANCHE = 28600883;
  uint256 constant OPTIMISM = 88969517;
  uint256 constant ARBITRUM = 79295611;
  uint256 constant FANTOM = 59620062;
  // uint256 constant HARMONY = 37364700;
}

/**
 * @dev commented out as only used to create initial snapshot to compare against.
 * Just generating snapshots via ProtocolV3TestBase so we can compare with ProtocolV3_0_1TestBase
 */
// contract V301UpgradePreProposalSnapshot is ProtocolV3TestBase {
//   uint256 mainnetFork;
//   uint256 polygonFork;
//   uint256 avalancheFork;
//   uint256 optimismFork;
//   uint256 arbitrumFork;
//   uint256 harmonyFork;
//   uint256 fantomFork;

//   function setUp() public {
//     mainnetFork = vm.createFork(vm.rpcUrl('mainnet'), ForkBlocks.MAINNET);
//     polygonFork = vm.createFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
//     avalancheFork = vm.createFork(vm.rpcUrl('avalanche'), ForkBlocks.AVALANCHE);
//     optimismFork = vm.createFork(vm.rpcUrl('optimism'), ForkBlocks.OPTIMISM);
//     arbitrumFork = vm.createFork(vm.rpcUrl('arbitrum'), ForkBlocks.ARBITRUM);
//     // harmonyFork = vm.createFork(vm.rpcUrl('harmony'), ForkBlocks.HARMONY);
//     fantomFork = vm.createFork(vm.rpcUrl('fantom'), ForkBlocks.FANTOM);
//   }

//   function testMainnet() public {
//     vm.selectFork(mainnetFork);
//     createConfigurationSnapshot('pre-upgrade-mainnet', AaveV3Ethereum.POOL);
//   }

//   // function testHarmony() public {
//   //   vm.selectFork(harmonyFork);
//   //   createConfigurationSnapshot('pre-upgrade-harmony', AaveV3Harmony.POOL);
//   // }

//   function testAvalanche() public {
//     vm.selectFork(avalancheFork);
//     createConfigurationSnapshot('pre-upgrade-avalanche', AaveV3Avalanche.POOL);
//   }

//   function testFantom() public {
//     vm.selectFork(fantomFork);
//     createConfigurationSnapshot('pre-upgrade-fantom', AaveV3Fantom.POOL);
//   }

//   function testPolygon() public {
//     vm.selectFork(polygonFork);
//     createConfigurationSnapshot('pre-upgrade-polygon', AaveV3Polygon.POOL);
//   }

//   function testOptimism() public {
//     vm.selectFork(optimismFork);
//     createConfigurationSnapshot('pre-upgrade-optimism', AaveV3Optimism.POOL);
//   }

//   function testArbitrum() public {
//     vm.selectFork(arbitrumFork);
//     createConfigurationSnapshot('pre-upgrade-arbitrum', AaveV3Arbitrum.POOL);
//   }
// }

contract V301UpgradeMainnetProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301EthereumUpgradePayload public proposalPayload =
    V301EthereumUpgradePayload(0x31A239f3e39c5D8BA6B201bA81ed584492Ae960F);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), ForkBlocks.MAINNET);
    _selectPayloadExecutor(AaveGovernanceV2.SHORT_EXECUTOR); // admin is the guardian
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-mainnet', AaveV3Ethereum.POOL);
    diffReports('pre-upgrade-mainnet', 'post-upgrade-mainnet');
  }
}

contract V301UpgradePolygonProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301L2UpgradePayload public proposalPayload =
    V301L2UpgradePayload(0xa603Ad2b0258bDda94F3dfDb26859ef205AE9244);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), ForkBlocks.POLYGON);
    _selectPayloadExecutor(AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR);
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-polygon', AaveV3Polygon.POOL);
    diffReports('pre-upgrade-polygon', 'post-upgrade-polygon');
  }
}

contract V301UpgradeAvalancheProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301L2UpgradePayload public proposalPayload =
    V301L2UpgradePayload(0xD792a3779D3C80bAEe8CF3304D6aEAc74bC432BE);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), ForkBlocks.AVALANCHE);
    _selectPayloadExecutor(AaveV3Avalanche.ACL_ADMIN);
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-avalanche', AaveV3Avalanche.POOL);
    diffReports('pre-upgrade-avalanche', 'post-upgrade-avalanche');
  }
}

contract V301UpgradeOptimismProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301L2UpgradePayload public proposalPayload =
    V301L2UpgradePayload(0x7748d38A160EEeF9559e2b043eAec5CfFFCE3E4c);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), ForkBlocks.OPTIMISM);
    _selectPayloadExecutor(AaveGovernanceV2.OPTIMISM_BRIDGE_EXECUTOR);
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-optimism', AaveV3Optimism.POOL);
    diffReports('pre-upgrade-optimism', 'post-upgrade-optimism');
  }
}

contract V301UpgradeArbitrumProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301L2UpgradePayload public proposalPayload =
    V301L2UpgradePayload(0x209Ad99bd808221293d03827B86cC544bcA0023b);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), ForkBlocks.ARBITRUM);
    _selectPayloadExecutor(AaveGovernanceV2.ARBITRUM_BRIDGE_EXECUTOR);
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-arbitrum', AaveV3Arbitrum.POOL);
    diffReports('pre-upgrade-arbitrum', 'post-upgrade-arbitrum');
  }
}

contract V301UpgradeFantomProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
  V301L2UpgradePayload public proposalPayload =
    V301L2UpgradePayload(0x04a8D477eE202aDCE1682F5902e1160455205b12);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('fantom'), ForkBlocks.FANTOM);
    _selectPayloadExecutor(AaveV3Fantom.ACL_ADMIN);
  }

  function testProposal() public {
    _executePayload(address(proposalPayload));
    createConfigurationSnapshot('post-upgrade-fantom', AaveV3Fantom.POOL);
    diffReports('pre-upgrade-fantom', 'post-upgrade-fantom');
  }
}

// contract V301UpgradeHarmonyProposalTest is TestWithExecutor, ProtocolV3_0_1TestBase {
//   V301UpgradePayload public proposalPayload;

//   function setUp() public {
//     vm.createSelectFork(vm.rpcUrl('harmony'), ForkBlocks.HARMONY);
//     _selectPayloadExecutor(AaveV3Harmony.ACL_ADMIN); // guardian is still owner of addresses provider

//     proposalPayload = DeployPayloads.deployHarmony();
//   }

//   function testProposal() public {
//     _executePayload(address(proposalPayload));
//     // createConfigurationSnapshot('post-upgrade-harmony', AaveV3Harmony.POOL);
//     diffReports('pre-upgrade-harmony', 'post-upgrade-harmony');

//     // error: all reserves are frozen, nothing to test
//     // address user = address(42);
//     // e2eTest(AaveV3Arbitrum.POOL, user);
//   }
// }
