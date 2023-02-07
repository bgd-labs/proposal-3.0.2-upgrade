```diff
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/interfaces/IPoolAddressesProviderRegistry.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/interfaces/IPoolAddressesProviderRegistry.sol
index a48ff20..e81df67 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/interfaces/IPoolAddressesProviderRegistry.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/interfaces/IPoolAddressesProviderRegistry.sol
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
  * @title IPoolAddressesProviderRegistry
  * @author Aave
  * @notice Defines the basic interface for an Aave Pool Addresses Provider Registry.
- **/
+ */
 interface IPoolAddressesProviderRegistry {
   /**
    * @dev Emitted when a new AddressesProvider is registered.
@@ -24,7 +24,7 @@ interface IPoolAddressesProviderRegistry {
   /**
    * @notice Returns the list of registered addresses providers
    * @return The list of addresses providers
-   **/
+   */
   function getAddressesProvidersList() external view returns (address[] memory);
 
   /**
@@ -50,12 +50,12 @@ interface IPoolAddressesProviderRegistry {
    * @dev The id must not be used by an already registered PoolAddressesProvider
    * @param provider The address of the new PoolAddressesProvider
    * @param id The id for the new PoolAddressesProvider, referring to the market it belongs to
-   **/
+   */
   function registerAddressesProvider(address provider, uint256 id) external;
 
   /**
    * @notice Removes an addresses provider from the list of registered addresses providers
    * @param provider The PoolAddressesProvider address
-   **/
+   */
   function unregisterAddressesProvider(address provider) external;
 }
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol
index f5cb3d3..5f724eb 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol
@@ -11,7 +11,7 @@ import {IPoolAddressesProviderRegistry} from '../../interfaces/IPoolAddressesPro
  * @notice Main registry of PoolAddressesProvider of Aave markets.
  * @dev Used for indexing purposes of Aave protocol's markets. The id assigned to a PoolAddressesProvider refers to the
  * market it is connected with, for example with `1` for the Aave main market and `2` for the next created.
- **/
+ */
 contract PoolAddressesProviderRegistry is Ownable, IPoolAddressesProviderRegistry {
   // Map of address provider ids (addressesProvider => id)
   mapping(address => uint256) private _addressesProviderToId;
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
index 640e463..1dacaf3 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER_REGISTRY/PoolAddressesProviderRegistry/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
  * @title Errors library
@@ -54,13 +54,12 @@ library Errors {
   string public constant HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '45'; // 'Health factor is not below the threshold'
   string public constant COLLATERAL_CANNOT_BE_LIQUIDATED = '46'; // 'The collateral chosen cannot be liquidated'
   string public constant SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '47'; // 'User did not borrow the specified currency'
-  string public constant SAME_BLOCK_BORROW_REPAY = '48'; // 'Borrow and repay in same block is not allowed'
   string public constant INCONSISTENT_FLASHLOAN_PARAMS = '49'; // 'Inconsistent flashloan parameters'
   string public constant BORROW_CAP_EXCEEDED = '50'; // 'Borrow cap is exceeded'
   string public constant SUPPLY_CAP_EXCEEDED = '51'; // 'Supply cap is exceeded'
   string public constant UNBACKED_MINT_CAP_EXCEEDED = '52'; // 'Unbacked mint cap is exceeded'
   string public constant DEBT_CEILING_EXCEEDED = '53'; // 'Debt ceiling is exceeded'
-  string public constant ATOKEN_SUPPLY_NOT_ZERO = '54'; // 'AToken supply is not zero'
+  string public constant UNDERLYING_CLAIMABLE_RIGHTS_NOT_ZERO = '54'; // 'Claimable rights over underlying not zero (aToken supply or accruedToTreasury)'
   string public constant STABLE_DEBT_NOT_ZERO = '55'; // 'Stable debt supply is not zero'
   string public constant VARIABLE_DEBT_SUPPLY_NOT_ZERO = '56'; // 'Variable debt supply is not zero'
   string public constant LTV_VALIDATION_FAILED = '57'; // 'Ltv validation failed'
@@ -97,4 +96,5 @@ library Errors {
   string public constant STABLE_BORROWING_ENABLED = '88'; // 'Stable borrowing is enabled'
   string public constant SILOED_BORROWING_VIOLATION = '89'; // 'User is trying to borrow multiple assets including a siloed one'
   string public constant RESERVE_DEBT_NOT_ZERO = '90'; // the total debt of the reserve needs to be 0
+  string public constant FLASHLOAN_DISABLED = '91'; // FlashLoaning for this asset is disabled
 }
```
