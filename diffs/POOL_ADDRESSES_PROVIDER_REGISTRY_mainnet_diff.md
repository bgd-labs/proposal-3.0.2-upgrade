```diff
diff --git a/src/downloads/mainnet/POOL_ADDRESSES_PROVIDER_REGISTRY.sol b/src/downloads/POOL_ADDRESSES_PROVIDER_REGISTRY.sol
index bfa8faf..85973c7 100644
--- a/src/downloads/mainnet/POOL_ADDRESSES_PROVIDER_REGISTRY.sol
+++ b/src/downloads/POOL_ADDRESSES_PROVIDER_REGISTRY.sol
@@ -152,7 +152,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
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
