```diff
diff --git a/src/downloads/mainnet/ACL_MANAGER.sol b/src/downloads/ACL_MANAGER.sol
index 762f518..834427d 100644
--- a/src/downloads/mainnet/ACL_MANAGER.sol
+++ b/src/downloads/ACL_MANAGER.sol
@@ -336,12 +336,10 @@ abstract contract AccessControl is Context, IAccessControl, ERC165 {
    *
    * - the caller must have ``role``'s admin role.
    */
-  function grantRole(bytes32 role, address account)
-    public
-    virtual
-    override
-    onlyRole(getRoleAdmin(role))
-  {
+  function grantRole(
+    bytes32 role,
+    address account
+  ) public virtual override onlyRole(getRoleAdmin(role)) {
     _grantRole(role, account);
   }
 
@@ -354,12 +352,10 @@ abstract contract AccessControl is Context, IAccessControl, ERC165 {
    *
    * - the caller must have ``role``'s admin role.
    */
-  function revokeRole(bytes32 role, address account)
-    public
-    virtual
-    override
-    onlyRole(getRoleAdmin(role))
-  {
+  function revokeRole(
+    bytes32 role,
+    address account
+  ) public virtual override onlyRole(getRoleAdmin(role)) {
     _revokeRole(role, account);
   }
 
@@ -891,7 +887,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -951,11 +947,10 @@ contract ACLManager is AccessControl, IACLManager {
   }
 
   /// @inheritdoc IACLManager
-  function setRoleAdmin(bytes32 role, bytes32 adminRole)
-    external
-    override
-    onlyRole(DEFAULT_ADMIN_ROLE)
-  {
+  function setRoleAdmin(
+    bytes32 role,
+    bytes32 adminRole
+  ) external override onlyRole(DEFAULT_ADMIN_ROLE) {
     _setRoleAdmin(role, adminRole);
   }
 
```
