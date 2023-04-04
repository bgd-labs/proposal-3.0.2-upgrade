// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
import {StdUtils} from 'forge-std/StdUtils.sol';

import {BorrowLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/BorrowLogic.sol';
import {BridgeLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/BridgeLogic.sol';
// can be reused as neither logic nor used logic changed
import {ConfiguratorLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol';
// can potentially be reused as no used methods changed
import {EModeLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/EModeLogic.sol';
import {PoolLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/PoolLogic.sol';
import {SupplyLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/SupplyLogic.sol';

// relies on BorrowLogic
import {FlashLoanLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/FlashLoanLogic.sol';
// relies on EModeLogic
import {LiquidationLogic} from 'aave-v3-core/contracts/protocol/libraries/logic/LiquidationLogic.sol';

/**
 * These scrips are needed to workaround: https://github.com/foundry-rs/foundry/issues/4443#issuecomment-1457171444
 * The addresses need to be inlined into `foundry.toml` to ensure proper verification.
 */

contract Create2Utils is StdUtils {
  address private constant CREATE2_FACTORY = 0x4e59b44847b379578588920cA78FbF26c0B4956C;

  bytes32 constant BORROW_LOGIC_SALT = keccak256(bytes('aave.borrowlogic.v3.0.2'));
  bytes32 constant BRIDGE_LOGIC_SALT = keccak256(bytes('aave.bridgelogic.v3.0.2'));
  bytes32 constant CONFIGURATOR_LOGIC_SALT = keccak256(bytes('aave.configuratorlogic.v3.0.2'));
  bytes32 constant EMODE_LOGIC_SALT = keccak256(bytes('aave.emodelogic.v3.0.2'));
  bytes32 constant POOL_LOGIC_SALT = keccak256(bytes('aave.poollogic.v3.0.2'));
  bytes32 constant SUPPLY_LOGIC_SALT = keccak256(bytes('aave.supplylogic.v3.0.2'));
  bytes32 constant FLASHLOAN_LOGIC_SALT = keccak256(bytes('aave.flashloanlogic.v3.0.2'));
  bytes32 constant LIQUIDATION_LOGIC_SALT = keccak256(bytes('aave.liquidationlogic.v3.0.2'));

  function _create2Deploy(bytes32 salt, bytes memory bytecode) internal returns (address) {
    if (isContractDeployed(CREATE2_FACTORY) == false) {
      revert('MISSING CREATE2_FACTORY');
    }
    address computed = computeCreate2Address(salt, hashInitCode(bytecode));

    if (isContractDeployed(computed)) {
      return computed;
    } else {
      bytes memory creationBytecode = abi.encodePacked(salt, bytecode);
      bytes memory returnData;
      (, returnData) = CREATE2_FACTORY.call(creationBytecode);
      address deployedAt = address(uint160(bytes20(returnData)));
      require(deployedAt == computed, 'failure at create2 address derivation');
      return deployedAt;
    }
  }

  function isContractDeployed(address _addr) internal view returns (bool isContract) {
    return (_addr.code.length > 0);
  }
}

contract DeployLibrariesChunk1 is Create2Utils, Script {
  function run() external {
    vm.startBroadcast();
    _create2Deploy(Create2Utils.BORROW_LOGIC_SALT, type(BorrowLogic).creationCode);
    vm.stopBroadcast();
  }
}

contract DeployLibrariesChunk2 is Create2Utils, Script {
  function run() external {
    vm.startBroadcast();
    // needs to be commited out as long as borrowlogic is not deployed as otherwise the compiler errors due to missing linking when deploying chunk1
    _create2Deploy(Create2Utils.FLASHLOAN_LOGIC_SALT, type(FlashLoanLogic).creationCode);
    _create2Deploy(Create2Utils.BRIDGE_LOGIC_SALT, type(BridgeLogic).creationCode);
    _create2Deploy(Create2Utils.CONFIGURATOR_LOGIC_SALT, type(ConfiguratorLogic).creationCode);
    _create2Deploy(Create2Utils.EMODE_LOGIC_SALT, type(EModeLogic).creationCode);
    _create2Deploy(Create2Utils.POOL_LOGIC_SALT, type(PoolLogic).creationCode);
    _create2Deploy(Create2Utils.SUPPLY_LOGIC_SALT, type(SupplyLogic).creationCode);
    _create2Deploy(Create2Utils.LIQUIDATION_LOGIC_SALT, type(LiquidationLogic).creationCode);
    vm.stopBroadcast();
  }
}
