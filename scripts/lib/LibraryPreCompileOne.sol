// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import 'forge-std/console.sol';
import {IMarketReportTypes} from './IMarketReportTypes.sol';
import {AaveV3LibrariesBatch1} from './AaveV3LibrariesBatch1.sol';
import {AaveV3LibrariesBatch2} from './AaveV3LibrariesBatch2.sol';

/**
 * @dev Deploy libraries in batch using CREATE2, this optional
 *      script allows to deploy the first 4 libraries of Aave V3 protocol
 *      and it saves the output to FOUNDRY_LIBRARIES env variable.
 *      The script will ask you to re-execute if FOUNDRY_LIBRARIES
 *      is set, due that setting mutates the bytecode and could result
 *      in different library addresses.
 */
contract LibraryPreCompileOne is IMarketReportTypes, Script {
  function run() external {
    _deployAndWriteLibrariesConfig();
  }

  function _deployAndWriteLibrariesConfig() internal {
    verifyEnvironment();

    LibrariesReport memory libraries;
    vm.startBroadcast();
    AaveV3LibrariesBatch1 batch1 = new AaveV3LibrariesBatch1(libraries);
    vm.stopBroadcast();
    LibrariesReport memory report = batch1.getLibrariesReport();

    string memory librariesSolcString = string(abi.encodePacked(getLibraryString1(report)));

    string memory sedCommand = string(
      abi.encodePacked('echo FOUNDRY_LIBRARIES=', librariesSolcString, ' >> .env')
    );
    string[] memory command = new string[](3);

    command[0] = 'bash';
    command[1] = '-c';
    command[2] = string(abi.encodePacked('response="$(', sedCommand, ')"; $response;'));
    vm.ffi(command);
  }

  function getLibraryString1(LibrariesReport memory report) internal returns (string memory) {
    return
      string(
        abi.encodePacked(
          'lib/aave-v3-core/contracts/protocol/libraries/logic/BorrowLogic.sol:BorrowLogic:',
          vm.toString(report.borrowLogic),
          ',',
          'lib/aave-v3-core/contracts/protocol/libraries/logic/BridgeLogic.sol:BridgeLogic:',
          vm.toString(report.bridgeLogic),
          ',',
          'lib/aave-v3-core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol:ConfiguratorLogic:',
          vm.toString(report.configuratorLogic),
          ',',
          'lib/aave-v3-core/contracts/protocol/libraries/logic/EModeLogic.sol:EModeLogic:',
          vm.toString(report.eModeLogic)
        )
      );
  }

  function verifyEnvironment() internal {
    string memory checkCommand = 'grep -q "FOUNDRY_LIBRARIES" .env && echo true || echo false';
    string[] memory command = new string[](3);

    command[0] = 'bash';
    command[1] = '-c';
    command[2] = string(
      abi.encodePacked(
        'response="$(',
        checkCommand,
        ')"; cast abi-encode "response(bool)" $response;'
      )
    );
    bytes memory res = vm.ffi(command);

    bool found = abi.decode(res, (bool));

    if (found == true) {
      string memory deleteCommand = "sed --in-place='' -r '/FOUNDRY_LIBRARIES/d' .env";
      string[] memory delCommand = new string[](3);

      delCommand[0] = 'bash';
      delCommand[1] = '-c';
      delCommand[2] = string(abi.encodePacked('response="$(', deleteCommand, ')"; $response;'));
      vm.ffi(delCommand);
      revert(
        'LibraryPreCompileOne: FOUNDRY_LIBRARIES was detected and removed. Please run again to deploy libraries with a fresh compilation.'
      );
    }
  }
}
