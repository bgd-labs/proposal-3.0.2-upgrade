```diff
diff --git a/reports/POOL_CONFIGURATOR_IMPL_mainnet_storage.md b/reports/POOL_CONFIGURATOR_IMPL_storage.md
index e1512ea..6c2b252 100644
--- a/reports/POOL_CONFIGURATOR_IMPL_mainnet_storage.md
+++ b/reports/POOL_CONFIGURATOR_IMPL_storage.md
@@ -1,7 +1,7 @@
-| Name                    | Type                            | Slot | Offset | Bytes | Contract                                                          |
-|-------------------------|---------------------------------|------|--------|-------|-------------------------------------------------------------------|
-| lastInitializedRevision | uint256                         | 0    | 0      | 32    | src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol:PoolConfigurator |
-| initializing            | bool                            | 1    | 0      | 1     | src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol:PoolConfigurator |
-| ______gap               | uint256[50]                     | 2    | 0      | 1600  | src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol:PoolConfigurator |
-| _addressesProvider      | contract IPoolAddressesProvider | 52   | 0      | 20    | src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol:PoolConfigurator |
-| _pool                   | contract IPool                  | 53   | 0      | 20    | src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol:PoolConfigurator |
+| Name                    | Type                            | Slot | Offset | Bytes | Contract                                                                       |
+|-------------------------|---------------------------------|------|--------|-------|--------------------------------------------------------------------------------|
+| lastInitializedRevision | uint256                         | 0    | 0      | 32    | lib/aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol:PoolConfigurator |
+| initializing            | bool                            | 1    | 0      | 1     | lib/aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol:PoolConfigurator |
+| ______gap               | uint256[50]                     | 2    | 0      | 1600  | lib/aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol:PoolConfigurator |
+| _addressesProvider      | contract IPoolAddressesProvider | 52   | 0      | 20    | lib/aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol:PoolConfigurator |
+| _pool                   | contract IPool                  | 53   | 0      | 20    | lib/aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol:PoolConfigurator |
```
