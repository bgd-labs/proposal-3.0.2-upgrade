// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';

contract CreateUpgradeProposal is Script {
  function run() external {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](4);
    payloads[0] = GovHelpers.buildMainnet(0x6F6caee8348c10dC9441Fbe28cb588566F1251D5); // https://etherscan.io/address/0x6f6caee8348c10dc9441fbe28cb588566f1251d5
    payloads[1] = GovHelpers.buildPolygon(0xb56c0688316c333bFAA20cD7d836e05d48939b58); // https://polygonscan.com/address/0xb56c0688316c333bfaa20cd7d836e05d48939b58
    payloads[2] = GovHelpers.buildOptimism(0x45CE944c29A25AEE0e135f8f89aB55Dc9c5438E5); // https://optimistic.etherscan.io/address/0x45ce944c29a25aee0e135f8f89ab55dc9c5438e5
    payloads[3] = GovHelpers.buildArbitrum(0xF876Fa9A96EcD51c0BBa8554Ff2e397fE7F73BAB); // https://arbiscan.io/address/0xf876fa9a96ecd51c0bba8554ff2e397fe7f73bab 

    vm.startBroadcast();
    GovHelpers.createProposal(
      payloads,
      0x4d341d5b023269b873d952389bd067055c3ae43d978bdc13d27ad7e389e6562b
    );
    vm.stopBroadcast();
  }
}
