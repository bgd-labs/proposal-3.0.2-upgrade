```diff
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
index c6dcfda..66cf8b8 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
index bf52cd5..805fb57 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 import './Proxy.sol';
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
index 5ecec08..d76a024 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 import './BaseUpgradeabilityProxy.sol';
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
index 44b790d..6f68021 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
index 01a126b..587a0d0 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
  * @title IPoolAddressesProvider
  * @author Aave
  * @notice Defines the basic interface for a Pool Addresses Provider.
- **/
+ */
 interface IPoolAddressesProvider {
   /**
    * @dev Emitted when the market identifier is updated.
@@ -100,7 +100,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Returns the id of the Aave market to which this contract points to.
    * @return The market id
-   **/
+   */
   function getMarketId() external view returns (string memory);
 
   /**
@@ -142,27 +142,27 @@ interface IPoolAddressesProvider {
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
@@ -186,7 +186,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the ACL manager.
    * @param newAclManager The address of the new ACLManager
-   **/
+   */
   function setACLManager(address newAclManager) external;
 
   /**
@@ -210,7 +210,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the price oracle sentinel.
    * @param newPriceOracleSentinel The address of the new PriceOracleSentinel
-   **/
+   */
   function setPriceOracleSentinel(address newPriceOracleSentinel) external;
 
   /**
@@ -222,6 +222,6 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the data provider.
    * @param newDataProvider The address of the new DataProvider
-   **/
+   */
   function setPoolDataProvider(address newDataProvider) external;
 }
diff --git a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProvider.sol b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProvider.sol
index 073e92f..b4255fa 100644
--- a/downloads/polygon/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProvider.sol
+++ b/downloads/mainnet/POOL_ADDRESSES_PROVIDER/PoolAddressesProvider/@aave/core-v3/contracts/protocol/configuration/PoolAddressesProvider.sol
@@ -11,7 +11,7 @@ import {InitializableImmutableAdminUpgradeabilityProxy} from '../libraries/aave-
  * @notice Main registry of addresses part of or connected to the protocol, including permissioned roles
  * @dev Acts as factory of proxies and admin of those, so with right to change its implementations
  * @dev Owned by the Aave Governance
- **/
+ */
 contract PoolAddressesProvider is Ownable, IPoolAddressesProvider {
   // Identifier of the Aave Market
   string private _marketId;
@@ -164,7 +164,7 @@ contract PoolAddressesProvider is Ownable, IPoolAddressesProvider {
    *   calls the initialize() function via upgradeToAndCall() in the proxy
    * @param id The id of the proxy to be updated
    * @param newAddress The address of the new implementation
-   **/
+   */
   function _updateImpl(bytes32 id, address newAddress) internal {
     address proxyAddress = _addresses[id];
     InitializableImmutableAdminUpgradeabilityProxy proxy;
@@ -184,7 +184,7 @@ contract PoolAddressesProvider is Ownable, IPoolAddressesProvider {
   /**
    * @notice Updates the identifier of the Aave market.
    * @param newMarketId The new id of the market
-   **/
+   */
   function _setMarketId(string memory newMarketId) internal {
     string memory oldMarketId = _marketId;
     _marketId = newMarketId;
```
