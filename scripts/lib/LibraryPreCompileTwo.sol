// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import 'forge-std/console.sol';
import {IMarketReportTypes} from './IMarketReportTypes.sol';
import {AaveV3LibrariesBatch1} from './AaveV3LibrariesBatch1.sol';
import {AaveV3LibrariesBatch2} from './AaveV3LibrariesBatch2.sol';

/**
 * @dev Deploy libraries in batch using CREATE2, this optional
 *      script allows to deploy the next 4 libraries of Aave V3 protocol
 *      and it appends the output to FOUNDRY_LIBRARIES env variable.
 *      The script will ask you to execute "LibraryPreCompileOne"
 *      if FOUNDRY_LIBRARIES is not set, due BorrowLogic is a needed
 *      dependency of FlashLoanLogic library.
 */
contract LibraryPreCompileTwo is IMarketReportTypes, Script {
  function run() external {
    _deployAndWriteLibrariesConfig();
  }

  function _deployAndWriteLibrariesConfig() internal {
    verifyEnvironment();

    LibrariesReport memory libraries;
    vm.startBroadcast();
    AaveV3LibrariesBatch2 batch2 = new AaveV3LibrariesBatch2();
    vm.stopBroadcast();
    LibrariesReport memory report = batch2.getLibrariesReport();

    string memory librariesSolcString = string(abi.encodePacked(getLibraryString2(report)));

    string memory sedCommand = string(
      abi.encodePacked(
        "sed --in-place='' -r 's (FOUNDRY_LIBRARIES=.*) \\1",
        librariesSolcString,
        " ' .env"
      )
    );
    string[] memory command = new string[](3);

    command[0] = 'bash';
    command[1] = '-c';
    command[2] = string(abi.encodePacked('response="$(', sedCommand, ')"; $response;'));
    vm.ffi(command);
  }

  function getLibraryString2(LibrariesReport memory report) internal returns (string memory) {
    return
      string(
        abi.encodePacked(
          ',',
          'lib/aave-v3-core/contracts/protocol/libraries/logic/FlashLoanLogic.sol:FlashLoanLogic:',
          vm.toString(report.flashLoanLogic),
          ',',
          'lib/aave-v3-core/contracts/protocol/libraries/logic/LiquidationLogic.sol:LiquidationLogic:',
          vm.toString(report.liquidationLogic),
          ',',
          'lib/aave-v3-core/contracts/protocol/libraries/logic/PoolLogic.sol:PoolLogic:',
          vm.toString(report.poolLogic),
          ',',
          'lib/aave-v3-core/contracts/protocol/libraries/logic/SupplyLogic.sol:SupplyLogic:',
          vm.toString(report.supplyLogic)
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

    if (found == false) {
      revert(
        'LibraryPreCompileTwo: FOUNDRY_LIBRARIES not found, please run LibraryPrecompileOne first.'
      );
    }
  }
}
