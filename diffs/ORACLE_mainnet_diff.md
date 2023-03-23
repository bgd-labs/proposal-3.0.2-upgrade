```diff
diff --git a/src/downloads/mainnet/ORACLE.sol b/src/downloads/ORACLE.sol
index 1a77e74..d6e1e69 100644
--- a/src/downloads/mainnet/ORACLE.sol
+++ b/src/downloads/ORACLE.sol
@@ -85,7 +85,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -660,20 +660,17 @@ contract AaveOracle is IAaveOracle {
   }
 
   /// @inheritdoc IAaveOracle
-  function setAssetSources(address[] calldata assets, address[] calldata sources)
-    external
-    override
-    onlyAssetListingOrPoolAdmins
-  {
+  function setAssetSources(
+    address[] calldata assets,
+    address[] calldata sources
+  ) external override onlyAssetListingOrPoolAdmins {
     _setAssetsSources(assets, sources);
   }
 
   /// @inheritdoc IAaveOracle
-  function setFallbackOracle(address fallbackOracle)
-    external
-    override
-    onlyAssetListingOrPoolAdmins
-  {
+  function setFallbackOracle(
+    address fallbackOracle
+  ) external override onlyAssetListingOrPoolAdmins {
     _setFallbackOracle(fallbackOracle);
   }
 
@@ -718,12 +715,9 @@ contract AaveOracle is IAaveOracle {
   }
 
   /// @inheritdoc IAaveOracle
-  function getAssetsPrices(address[] calldata assets)
-    external
-    view
-    override
-    returns (uint256[] memory)
-  {
+  function getAssetsPrices(
+    address[] calldata assets
+  ) external view override returns (uint256[] memory) {
     uint256[] memory prices = new uint256[](assets.length);
     for (uint256 i = 0; i < assets.length; i++) {
       prices[i] = getAssetPrice(assets[i]);
```
