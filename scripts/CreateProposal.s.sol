// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';

contract CreateUpgradeProposal is Script {
  function run() external {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](4);
    payloads[0] = GovHelpers.buildMainnet(0x31A239f3e39c5D8BA6B201bA81ed584492Ae960F); // https://etherscan.io/address/0x31a239f3e39c5d8ba6b201ba81ed584492ae960f
    payloads[1] = GovHelpers.buildPolygon(0xa603Ad2b0258bDda94F3dfDb26859ef205AE9244); // https://polygonscan.com/address/0xa603ad2b0258bdda94f3dfdb26859ef205ae9244
    payloads[2] = GovHelpers.buildOptimism(0x7748d38A160EEeF9559e2b043eAec5CfFFCE3E4c); // https://optimistic.etherscan.io/address/0x7748d38a160eeef9559e2b043eaec5cfffce3e4c
    payloads[3] = GovHelpers.buildArbitrum(0x209Ad99bd808221293d03827B86cC544bcA0023b); // https://arbiscan.io/address/0x209ad99bd808221293d03827b86cc544bca0023b

    vm.startBroadcast();
    GovHelpers.createProposal(payloads, bytes32(''));
    vm.stopBroadcast();
  }
}
