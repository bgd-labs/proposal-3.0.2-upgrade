```diff
diff --git a/src/downloads/mainnet/POOL_ADDRESSES_PROVIDER.sol b/src/downloads/POOL_ADDRESSES_PROVIDER.sol
index 5a808d1..0f7ab98 100644
--- a/src/downloads/mainnet/POOL_ADDRESSES_PROVIDER.sol
+++ b/src/downloads/POOL_ADDRESSES_PROVIDER.sol
@@ -590,11 +590,10 @@ contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
    * It should include the signature and the parameters of the function to be called, as described in
    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
    */
-  function upgradeToAndCall(address newImplementation, bytes calldata data)
-    external
-    payable
-    ifAdmin
-  {
+  function upgradeToAndCall(
+    address newImplementation,
+    bytes calldata data
+  ) external payable ifAdmin {
     _upgradeTo(newImplementation);
     (bool success, ) = newImplementation.delegatecall(data);
     require(success);
@@ -688,11 +687,10 @@ contract PoolAddressesProvider is Ownable, IPoolAddressesProvider {
   }
 
   /// @inheritdoc IPoolAddressesProvider
-  function setAddressAsProxy(bytes32 id, address newImplementationAddress)
-    external
-    override
-    onlyOwner
-  {
+  function setAddressAsProxy(
+    bytes32 id,
+    address newImplementationAddress
+  ) external override onlyOwner {
     address proxyAddress = _addresses[id];
     address oldImplementationAddress = _getProxyImplementation(id);
     _updateImpl(id, newImplementationAddress);
```
