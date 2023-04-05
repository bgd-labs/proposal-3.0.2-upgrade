// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibraryReportStorage} from './LibraryReportStorage.sol';
import 'forge-std/console.sol';
import {Create2Utils} from './Create2Utils.sol';
import {FlashLoanLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/FlashLoanLogic.sol';
import {LiquidationLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/LiquidationLogic.sol';
import {PoolLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/PoolLogic.sol';
import {SupplyLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/SupplyLogic.sol';

contract AaveV3LibrariesBatch2 is LibraryReportStorage, Create2Utils {
  constructor() {
    _librariesReport = _deployAaveV3Libraries();
  }

  function _deployAaveV3Libraries() internal returns (LibrariesReport memory libReport) {
    bytes32 salt = keccak256('AAVE_V3');

    libReport.flashLoanLogic = _create2Deploy(salt, type(FlashLoanLogic).creationCode);
    libReport.liquidationLogic = _create2Deploy(salt, type(LiquidationLogic).creationCode);
    libReport.poolLogic = _create2Deploy(salt, type(PoolLogic).creationCode);
    libReport.supplyLogic = _create2Deploy(salt, type(SupplyLogic).creationCode);
    return libReport;
  }
}
