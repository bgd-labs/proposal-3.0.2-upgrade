```diff
diff --git a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IACLManager.sol b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IACLManager.sol
index 4bb6e64..d5d97ce 100644
--- a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IACLManager.sol
+++ b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IACLManager.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {IPoolAddressesProvider} from './IPoolAddressesProvider.sol';
 
@@ -7,7 +7,7 @@ import {IPoolAddressesProvider} from './IPoolAddressesProvider.sol';
  * @title IACLManager
  * @author Aave
  * @notice Defines the basic interface for the ACL Manager
- **/
+ */
 interface IACLManager {
   /**
    * @notice Returns the contract address of the PoolAddressesProvider
@@ -123,7 +123,7 @@ interface IACLManager {
   function addFlashBorrower(address borrower) external;
 
   /**
-   * @notice Removes an admin as FlashBorrower
+   * @notice Removes an address as FlashBorrower
    * @param borrower The address of the FlashBorrower to remove
    */
   function removeFlashBorrower(address borrower) external;
diff --git a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IAaveOracle.sol b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IAaveOracle.sol
index 0ad9b47..0d4aa31 100644
--- a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IAaveOracle.sol
+++ b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IAaveOracle.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {IPriceOracleGetter} from './IPriceOracleGetter.sol';
 import {IPoolAddressesProvider} from './IPoolAddressesProvider.sol';
diff --git a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
index 01a126b..587a0d0 100644
--- a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
+++ b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
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
diff --git a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IPriceOracleGetter.sol b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IPriceOracleGetter.sol
index 92c1c46..0e0df3e 100644
--- a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IPriceOracleGetter.sol
+++ b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/interfaces/IPriceOracleGetter.sol
@@ -1,30 +1,30 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
  * @title IPriceOracleGetter
  * @author Aave
  * @notice Interface for the Aave price oracle.
- **/
+ */
 interface IPriceOracleGetter {
   /**
    * @notice Returns the base currency address
    * @dev Address 0x0 is reserved for USD as base currency.
    * @return Returns the base currency address.
-   **/
+   */
   function BASE_CURRENCY() external view returns (address);
 
   /**
    * @notice Returns the base currency unit
    * @dev 1 ether for ETH, 1e8 for USD.
    * @return Returns the base currency unit.
-   **/
+   */
   function BASE_CURRENCY_UNIT() external view returns (uint256);
 
   /**
    * @notice Returns the asset price in the base currency
    * @param asset The address of the asset
    * @return The price of the asset
-   **/
+   */
   function getAssetPrice(address asset) external view returns (uint256);
 }
diff --git a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/misc/AaveOracle.sol b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/misc/AaveOracle.sol
index 99afe28..4d728c9 100644
--- a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/misc/AaveOracle.sol
+++ b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/misc/AaveOracle.sol
@@ -28,7 +28,7 @@ contract AaveOracle is IAaveOracle {
 
   /**
    * @dev Only asset listing or pool admin can call functions marked by this modifier.
-   **/
+   */
   modifier onlyAssetListingOrPoolAdmins() {
     _onlyAssetListingOrPoolAdmins();
     _;
diff --git a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
index 640e463..1dacaf3 100644
--- a/downloads/polygon/ORACLE/AaveOracle/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+++ b/downloads/mainnet/ORACLE/AaveOracle/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
  * @title Errors library
@@ -54,13 +54,12 @@ library Errors {
   string public constant HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '45'; // 'Health factor is not below the threshold'
   string public constant COLLATERAL_CANNOT_BE_LIQUIDATED = '46'; // 'The collateral chosen cannot be liquidated'
   string public constant SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '47'; // 'User did not borrow the specified currency'
-  string public constant SAME_BLOCK_BORROW_REPAY = '48'; // 'Borrow and repay in same block is not allowed'
   string public constant INCONSISTENT_FLASHLOAN_PARAMS = '49'; // 'Inconsistent flashloan parameters'
   string public constant BORROW_CAP_EXCEEDED = '50'; // 'Borrow cap is exceeded'
   string public constant SUPPLY_CAP_EXCEEDED = '51'; // 'Supply cap is exceeded'
   string public constant UNBACKED_MINT_CAP_EXCEEDED = '52'; // 'Unbacked mint cap is exceeded'
   string public constant DEBT_CEILING_EXCEEDED = '53'; // 'Debt ceiling is exceeded'
-  string public constant ATOKEN_SUPPLY_NOT_ZERO = '54'; // 'AToken supply is not zero'
+  string public constant UNDERLYING_CLAIMABLE_RIGHTS_NOT_ZERO = '54'; // 'Claimable rights over underlying not zero (aToken supply or accruedToTreasury)'
   string public constant STABLE_DEBT_NOT_ZERO = '55'; // 'Stable debt supply is not zero'
   string public constant VARIABLE_DEBT_SUPPLY_NOT_ZERO = '56'; // 'Variable debt supply is not zero'
   string public constant LTV_VALIDATION_FAILED = '57'; // 'Ltv validation failed'
@@ -97,4 +96,5 @@ library Errors {
   string public constant STABLE_BORROWING_ENABLED = '88'; // 'Stable borrowing is enabled'
   string public constant SILOED_BORROWING_VIOLATION = '89'; // 'User is trying to borrow multiple assets including a siloed one'
   string public constant RESERVE_DEBT_NOT_ZERO = '90'; // the total debt of the reserve needs to be 0
+  string public constant FLASHLOAN_DISABLED = '91'; // FlashLoaning for this asset is disabled
 }
```
