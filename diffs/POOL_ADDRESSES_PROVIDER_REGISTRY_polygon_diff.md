```diff
diff --git a/src/downloads/polygon/POOL_ADDRESSES_PROVIDER_REGISTRY.sol b/src/downloads/POOL_ADDRESSES_PROVIDER_REGISTRY.sol
index 1d3ae2e..85973c7 100644
--- a/src/downloads/polygon/POOL_ADDRESSES_PROVIDER_REGISTRY.sol
+++ b/src/downloads/POOL_ADDRESSES_PROVIDER_REGISTRY.sol
@@ -139,13 +139,12 @@ library Errors {
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
@@ -153,7 +152,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -182,13 +181,14 @@ library Errors {
   string public constant STABLE_BORROWING_ENABLED = '88'; // 'Stable borrowing is enabled'
   string public constant SILOED_BORROWING_VIOLATION = '89'; // 'User is trying to borrow multiple assets including a siloed one'
   string public constant RESERVE_DEBT_NOT_ZERO = '90'; // the total debt of the reserve needs to be 0
+  string public constant FLASHLOAN_DISABLED = '91'; // FlashLoaning for this asset is disabled
 }
 
 /**
  * @title IPoolAddressesProviderRegistry
  * @author Aave
  * @notice Defines the basic interface for an Aave Pool Addresses Provider Registry.
- **/
+ */
 interface IPoolAddressesProviderRegistry {
   /**
    * @dev Emitted when a new AddressesProvider is registered.
@@ -207,7 +207,7 @@ interface IPoolAddressesProviderRegistry {
   /**
    * @notice Returns the list of registered addresses providers
    * @return The list of addresses providers
-   **/
+   */
   function getAddressesProvidersList() external view returns (address[] memory);
 
   /**
@@ -215,10 +215,9 @@ interface IPoolAddressesProviderRegistry {
    * @param addressesProvider The address of the PoolAddressesProvider
    * @return The id of the PoolAddressesProvider or 0 if is not registered
    */
-  function getAddressesProviderIdByAddress(address addressesProvider)
-    external
-    view
-    returns (uint256);
+  function getAddressesProviderIdByAddress(
+    address addressesProvider
+  ) external view returns (uint256);
 
   /**
    * @notice Returns the address of a registered PoolAddressesProvider
@@ -233,13 +232,13 @@ interface IPoolAddressesProviderRegistry {
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
 
@@ -249,7 +248,7 @@ interface IPoolAddressesProviderRegistry {
  * @notice Main registry of PoolAddressesProvider of Aave markets.
  * @dev Used for indexing purposes of Aave protocol's markets. The id assigned to a PoolAddressesProvider refers to the
  * market it is connected with, for example with `1` for the Aave main market and `2` for the next created.
- **/
+ */
 contract PoolAddressesProviderRegistry is Ownable, IPoolAddressesProviderRegistry {
   // Map of address provider ids (addressesProvider => id)
   mapping(address => uint256) private _addressesProviderToId;
@@ -299,12 +298,9 @@ contract PoolAddressesProviderRegistry is Ownable, IPoolAddressesProviderRegistr
   }
 
   /// @inheritdoc IPoolAddressesProviderRegistry
-  function getAddressesProviderIdByAddress(address addressesProvider)
-    external
-    view
-    override
-    returns (uint256)
-  {
+  function getAddressesProviderIdByAddress(
+    address addressesProvider
+  ) external view override returns (uint256) {
     return _addressesProviderToId[addressesProvider];
   }
 
```
