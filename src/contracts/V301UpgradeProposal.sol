// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IPoolAddressesProvider} from 'aave-address-book/AaveV3.sol';

contract V301UpgradeProposal {
  IPoolAddressesProvider public immutable POOL_ADDRESSES_PROVIDER;

  constructor(IPoolAddressesProvider poolAddressesProvider) {
    POOL_ADDRESSES_PROVIDER = poolAddressesProvider;
  }

  function execute() public {
    // poolDataProvider upgrade (added getFlashLoanEnabled)
    poolAddressesProvider
  }
}
