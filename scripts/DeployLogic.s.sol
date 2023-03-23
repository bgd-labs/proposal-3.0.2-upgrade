// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from 'forge-std/Script.sol';
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
