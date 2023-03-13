```diff
diff --git a/src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol b/src/downloads/POOL_CONFIGURATOR_IMPL.sol
index 24c3413..a0fa221 100644
--- a/src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol
+++ b/src/downloads/POOL_CONFIGURATOR_IMPL.sol
@@ -3798,10 +3798,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     _;
   }
 
-  uint256 public constant CONFIGURATOR_REVISION = 0x1;
+  uint256 public constant CONFIGURATOR_REVISION = 0x2;
 
   /// @inheritdoc VersionedInitializable
-  function getRevision() internal pure virtual override returns (uint256) {
+  function getRevision() internal virtual override pure returns (uint256) {
     return CONFIGURATOR_REVISION;
   }
 
@@ -4227,7 +4227,8 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   function _checkNoSuppliers(address asset) internal view {
     (, uint256 accruedToTreasury, uint256 totalATokens, , , , , , , , , ) = IPoolDataProvider(
       _addressesProvider.getPoolDataProvider()
-    ).getReserveData(asset);
+    )
+      .getReserveData(asset);
 
     require(totalATokens == 0 && accruedToTreasury == 0, Errors.RESERVE_LIQUIDITY_NOT_ZERO);
   }
```
