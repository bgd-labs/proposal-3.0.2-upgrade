```diff
diff --git a/src/downloads/mainnet/POOL_IMPL.sol b/src/downloads/POOL_IMPL.sol
index a9d7f8d..274de8b 100644
--- a/src/downloads/mainnet/POOL_IMPL.sol
+++ b/src/downloads/POOL_IMPL.sol
@@ -7285,7 +7285,7 @@ contract PoolStorage {
 contract Pool is VersionedInitializable, PoolStorage, IPool {
   using ReserveLogic for DataTypes.ReserveData;
 
-  uint256 public constant POOL_REVISION = 0x1;
+  uint256 public constant POOL_REVISION = 0x2;
   IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
 
   /**
```
