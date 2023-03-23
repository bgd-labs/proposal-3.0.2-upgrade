```diff
diff --git a/src/downloads/polygon/POOL_ADDRESSES_PROVIDER.sol b/src/downloads/POOL_ADDRESSES_PROVIDER.sol
index ebd62af..0f7ab98 100644
--- a/src/downloads/polygon/POOL_ADDRESSES_PROVIDER.sol
+++ b/src/downloads/POOL_ADDRESSES_PROVIDER.sol
@@ -90,7 +90,7 @@ contract Ownable is Context {
  * @title IPoolAddressesProvider
  * @author Aave
  * @notice Defines the basic interface for a Pool Addresses Provider.
- **/
+ */
 interface IPoolAddressesProvider {
   /**
    * @dev Emitted when the market identifier is updated.
@@ -185,7 +185,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Returns the id of the Aave market to which this contract points to.
    * @return The market id
-   **/
+   */
   function getMarketId() external view returns (string memory);
 
   /**
@@ -227,27 +227,27 @@ interface IPoolAddressesProvider {
   /**
    * @notice Returns the address of the Pool proxy.
    * @return The Pool proxy address
-   **/
+   */
   function getPool() external view returns (address);
 
   /**
    * @notice Updates the implementation of the Pool, or creates a proxy
    * setting the new `pool` implementation when the function is called for the first time.
    * @param newPoolImpl The new Pool implementation
-   **/
+   */
   function setPoolImpl(address newPoolImpl) external;
 
   /**
    * @notice Returns the address of the PoolConfigurator proxy.
    * @return The PoolConfigurator proxy address
-   **/
+   */
   function getPoolConfigurator() external view returns (address);
 
   /**
    * @notice Updates the implementation of the PoolConfigurator, or creates a proxy
    * setting the new `PoolConfigurator` implementation when the function is called for the first time.
    * @param newPoolConfiguratorImpl The new PoolConfigurator implementation
-   **/
+   */
   function setPoolConfiguratorImpl(address newPoolConfiguratorImpl) external;
 
   /**
@@ -271,7 +271,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the ACL manager.
    * @param newAclManager The address of the new ACLManager
-   **/
+   */
   function setACLManager(address newAclManager) external;
 
   /**
@@ -295,7 +295,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the price oracle sentinel.
    * @param newPriceOracleSentinel The address of the new PriceOracleSentinel
-   **/
+   */
   function setPriceOracleSentinel(address newPriceOracleSentinel) external;
 
   /**
@@ -307,7 +307,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the data provider.
    * @param newDataProvider The address of the new DataProvider
-   **/
+   */
   function setPoolDataProvider(address newDataProvider) external;
 }
 
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
@@ -638,7 +637,7 @@ contract InitializableImmutableAdminUpgradeabilityProxy is
  * @notice Main registry of addresses part of or connected to the protocol, including permissioned roles
  * @dev Acts as factory of proxies and admin of those, so with right to change its implementations
  * @dev Owned by the Aave Governance
- **/
+ */
 contract PoolAddressesProvider is Ownable, IPoolAddressesProvider {
   // Identifier of the Aave Market
   string private _marketId;
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
@@ -791,7 +789,7 @@ contract PoolAddressesProvider is Ownable, IPoolAddressesProvider {
    *   calls the initialize() function via upgradeToAndCall() in the proxy
    * @param id The id of the proxy to be updated
    * @param newAddress The address of the new implementation
-   **/
+   */
   function _updateImpl(bytes32 id, address newAddress) internal {
     address proxyAddress = _addresses[id];
     InitializableImmutableAdminUpgradeabilityProxy proxy;
@@ -811,7 +809,7 @@ contract PoolAddressesProvider is Ownable, IPoolAddressesProvider {
   /**
    * @notice Updates the identifier of the Aave market.
    * @param newMarketId The new id of the market
-   **/
+   */
   function _setMarketId(string memory newMarketId) internal {
     string memory oldMarketId = _marketId;
     _marketId = newMarketId;
```
