```diff
diff --git a/reports/EMISSION_MANAGER_polygon_storage.md b/reports/EMISSION_MANAGER_storage.md
index 657ed16..deda6a9 100644
--- a/reports/EMISSION_MANAGER_polygon_storage.md
+++ b/reports/EMISSION_MANAGER_storage.md
@@ -1,5 +1,5 @@
-| Name               | Type                        | Slot | Offset | Bytes | Contract                                                   |
-|--------------------|-----------------------------|------|--------|-------|------------------------------------------------------------|
-| _owner             | address                     | 0    | 0      | 20    | src/downloads/polygon/EMISSION_MANAGER.sol:EmissionManager |
-| _emissionAdmins    | mapping(address => address) | 1    | 0      | 32    | src/downloads/polygon/EMISSION_MANAGER.sol:EmissionManager |
-| _rewardsController | contract IRewardsController | 2    | 0      | 20    | src/downloads/polygon/EMISSION_MANAGER.sol:EmissionManager |
+| Name               | Type                        | Slot | Offset | Bytes | Contract                                                                    |
+|--------------------|-----------------------------|------|--------|-------|-----------------------------------------------------------------------------|
+| _owner             | address                     | 0    | 0      | 20    | lib/aave-v3-periphery/contracts/rewards/EmissionManager.sol:EmissionManager |
+| _emissionAdmins    | mapping(address => address) | 1    | 0      | 32    | lib/aave-v3-periphery/contracts/rewards/EmissionManager.sol:EmissionManager |
+| _rewardsController | contract IRewardsController | 2    | 0      | 20    | lib/aave-v3-periphery/contracts/rewards/EmissionManager.sol:EmissionManager |
```
