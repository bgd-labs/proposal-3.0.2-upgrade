```diff
diff --git a/reports/ORACLE_polygon_storage.md b/reports/ORACLE_storage.md
index 559ea58..8c3c78f 100644
--- a/reports/ORACLE_polygon_storage.md
+++ b/reports/ORACLE_storage.md
@@ -1,4 +1,4 @@
-| Name            | Type                                             | Slot | Offset | Bytes | Contract                                    |
-|-----------------|--------------------------------------------------|------|--------|-------|---------------------------------------------|
-| assetsSources   | mapping(address => contract AggregatorInterface) | 0    | 0      | 32    | src/downloads/polygon/ORACLE.sol:AaveOracle |
-| _fallbackOracle | contract IPriceOracleGetter                      | 1    | 0      | 20    | src/downloads/polygon/ORACLE.sol:AaveOracle |
+| Name            | Type                                             | Slot | Offset | Bytes | Contract                                                  |
+|-----------------|--------------------------------------------------|------|--------|-------|-----------------------------------------------------------|
+| assetsSources   | mapping(address => contract AggregatorInterface) | 0    | 0      | 32    | lib/aave-v3-core/contracts/misc/AaveOracle.sol:AaveOracle |
+| _fallbackOracle | contract IPriceOracleGetter                      | 1    | 0      | 20    | lib/aave-v3-core/contracts/misc/AaveOracle.sol:AaveOracle |
```
