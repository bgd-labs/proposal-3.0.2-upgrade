```diff
diff --git a/reports/ACL_MANAGER_mainnet_storage.md b/reports/ACL_MANAGER_storage.md
index 9f81481..582c480 100644
--- a/reports/ACL_MANAGER_mainnet_storage.md
+++ b/reports/ACL_MANAGER_storage.md
@@ -1,3 +1,3 @@
-| Name   | Type                                              | Slot | Offset | Bytes | Contract                                         |
-|--------|---------------------------------------------------|------|--------|-------|--------------------------------------------------|
-| _roles | mapping(bytes32 => struct AccessControl.RoleData) | 0    | 0      | 32    | src/downloads/mainnet/ACL_MANAGER.sol:ACLManager |
+| Name   | Type                                              | Slot | Offset | Bytes | Contract                                                                    |
+|--------|---------------------------------------------------|------|--------|-------|-----------------------------------------------------------------------------|
+| _roles | mapping(bytes32 => struct AccessControl.RoleData) | 0    | 0      | 32    | lib/aave-v3-core/contracts/protocol/configuration/ACLManager.sol:ACLManager |
```
