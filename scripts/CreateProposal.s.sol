// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';

contract CreateUpgradeProposal is Script {
  function run() external {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](3);
    payloads[0] = GovHelpers.buildPolygon(address(0)); //TODO:
    payloads[1] = GovHelpers.buildOptimism(address(0)); //TODO:
    payloads[2] = GovHelpers.buildArbitrum(address(0)); //TODO:

    vm.startBroadcast();
    GovHelpers.createProposal(payloads, bytes32(''));
    vm.stopBroadcast();
  }
}
