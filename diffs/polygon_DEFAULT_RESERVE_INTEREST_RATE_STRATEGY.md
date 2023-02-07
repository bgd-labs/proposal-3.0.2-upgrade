```diff
diff --git a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
index 7dc5593..326d738 100644
--- a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IDefaultInterestRateStrategy.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IDefaultInterestRateStrategy.sol
new file mode 100644
index 0000000..2277022
--- /dev/null
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IDefaultInterestRateStrategy.sol
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.0;
+
+import {IReserveInterestRateStrategy} from './IReserveInterestRateStrategy.sol';
+import {IPoolAddressesProvider} from './IPoolAddressesProvider.sol';
+
+/**
+ * @title IDefaultInterestRateStrategy
+ * @author Aave
+ * @notice Defines the basic interface of the DefaultReserveInterestRateStrategy
+ */
+interface IDefaultInterestRateStrategy is IReserveInterestRateStrategy {
+  /**
+   * @notice Returns the usage ratio at which the pool aims to obtain most competitive borrow rates.
+   * @return The optimal usage ratio, expressed in ray.
+   */
+  function OPTIMAL_USAGE_RATIO() external view returns (uint256);
+
+  /**
+   * @notice Returns the optimal stable to total debt ratio of the reserve.
+   * @return The optimal stable to total debt ratio, expressed in ray.
+   */
+  function OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO() external view returns (uint256);
+
+  /**
+   * @notice Returns the excess usage ratio above the optimal.
+   * @dev It's always equal to 1-optimal usage ratio (added as constant for gas optimizations)
+   * @return The max excess usage ratio, expressed in ray.
+   */
+  function MAX_EXCESS_USAGE_RATIO() external view returns (uint256);
+
+  /**
+   * @notice Returns the excess stable debt ratio above the optimal.
+   * @dev It's always equal to 1-optimal stable to total debt ratio (added as constant for gas optimizations)
+   * @return The max excess stable to total debt ratio, expressed in ray.
+   */
+  function MAX_EXCESS_STABLE_TO_TOTAL_DEBT_RATIO() external view returns (uint256);
+
+  /**
+   * @notice Returns the address of the PoolAddressesProvider
+   * @return The address of the PoolAddressesProvider contract
+   */
+  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
+
+  /**
+   * @notice Returns the variable rate slope below optimal usage ratio
+   * @dev It's the variable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
+   * @return The variable rate slope, expressed in ray
+   */
+  function getVariableRateSlope1() external view returns (uint256);
+
+  /**
+   * @notice Returns the variable rate slope above optimal usage ratio
+   * @dev It's the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
+   * @return The variable rate slope, expressed in ray
+   */
+  function getVariableRateSlope2() external view returns (uint256);
+
+  /**
+   * @notice Returns the stable rate slope below optimal usage ratio
+   * @dev It's the stable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
+   * @return The stable rate slope, expressed in ray
+   */
+  function getStableRateSlope1() external view returns (uint256);
+
+  /**
+   * @notice Returns the stable rate slope above optimal usage ratio
+   * @dev It's the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
+   * @return The stable rate slope, expressed in ray
+   */
+  function getStableRateSlope2() external view returns (uint256);
+
+  /**
+   * @notice Returns the stable rate excess offset
+   * @dev It's an additional premium applied to the stable when stable debt > OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO
+   * @return The stable rate excess offset, expressed in ray
+   */
+  function getStableRateExcessOffset() external view returns (uint256);
+
+  /**
+   * @notice Returns the base stable borrow rate
+   * @return The base stable borrow rate, expressed in ray
+   */
+  function getBaseStableBorrowRate() external view returns (uint256);
+
+  /**
+   * @notice Returns the base variable borrow rate
+   * @return The base variable borrow rate, expressed in ray
+   */
+  function getBaseVariableBorrowRate() external view returns (uint256);
+
+  /**
+   * @notice Returns the maximum variable borrow rate
+   * @return The maximum variable borrow rate, expressed in ray
+   */
+  function getMaxVariableBorrowRate() external view returns (uint256);
+}
diff --git a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
index 01a126b..587a0d0 100644
--- a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
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
diff --git a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IReserveInterestRateStrategy.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IReserveInterestRateStrategy.sol
index 5c9cbdc..65eefa5 100644
--- a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IReserveInterestRateStrategy.sol
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/interfaces/IReserveInterestRateStrategy.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {DataTypes} from '../protocol/libraries/types/DataTypes.sol';
 
@@ -9,25 +9,13 @@ import {DataTypes} from '../protocol/libraries/types/DataTypes.sol';
  * @notice Interface for the calculation of the interest rates
  */
 interface IReserveInterestRateStrategy {
-  /**
-   * @notice Returns the base variable borrow rate
-   * @return The base variable borrow rate, expressed in ray
-   **/
-  function getBaseVariableBorrowRate() external view returns (uint256);
-
-  /**
-   * @notice Returns the maximum variable borrow rate
-   * @return The maximum variable borrow rate, expressed in ray
-   **/
-  function getMaxVariableBorrowRate() external view returns (uint256);
-
   /**
    * @notice Calculates the interest rates depending on the reserve's state and configurations
    * @param params The parameters needed to calculate interest rates
    * @return liquidityRate The liquidity rate expressed in rays
    * @return stableBorrowRate The stable borrow rate expressed in rays
    * @return variableBorrowRate The variable borrow rate expressed in rays
-   **/
+   */
   function calculateInterestRates(DataTypes.CalculateInterestRatesParams memory params)
     external
     view
diff --git a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
index 640e463..1dacaf3 100644
--- a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
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
diff --git a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol
index 5306105..c000be3 100644
--- a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
  * @title PercentageMath library
@@ -7,7 +7,7 @@ pragma solidity 0.8.10;
  * @notice Provides functions to perform percentage calculations
  * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
  * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
- **/
+ */
 library PercentageMath {
   // Maximum percentage factor (100.00%)
   uint256 internal constant PERCENTAGE_FACTOR = 1e4;
@@ -21,7 +21,7 @@ library PercentageMath {
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return result value percentmul percentage
-   **/
+   */
   function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
     // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
     assembly {
@@ -44,7 +44,7 @@ library PercentageMath {
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return result value percentdiv percentage
-   **/
+   */
   function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
     // to avoid overflow, value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR
     assembly {
diff --git a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol
index dbe1a40..f61fe87 100644
--- a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
  * @title WadRayMath library
@@ -8,7 +8,7 @@ pragma solidity 0.8.10;
  * @dev Provides mul and div function for wads (decimal numbers with 18 digits of precision) and rays (decimal numbers
  * with 27 digits of precision)
  * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
- **/
+ */
 library WadRayMath {
   // HALF_WAD and HALF_RAY expressed with extended notation as constant with operations are not supported in Yul assembly
   uint256 internal constant WAD = 1e18;
@@ -25,7 +25,7 @@ library WadRayMath {
    * @param a Wad
    * @param b Wad
    * @return c = a*b, in wad
-   **/
+   */
   function wadMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - HALF_WAD) / b
     assembly {
@@ -43,7 +43,7 @@ library WadRayMath {
    * @param a Wad
    * @param b Wad
    * @return c = a/b, in wad
-   **/
+   */
   function wadDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - halfB) / WAD
     assembly {
@@ -61,7 +61,7 @@ library WadRayMath {
    * @param a Ray
    * @param b Ray
    * @return c = a raymul b
-   **/
+   */
   function rayMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - HALF_RAY) / b
     assembly {
@@ -79,7 +79,7 @@ library WadRayMath {
    * @param a Ray
    * @param b Ray
    * @return c = a raydiv b
-   **/
+   */
   function rayDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - halfB) / RAY
     assembly {
@@ -96,7 +96,7 @@ library WadRayMath {
    * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
    * @param a Ray
    * @return b = a converted to wad, rounded half up to the nearest wad
-   **/
+   */
   function rayToWad(uint256 a) internal pure returns (uint256 b) {
     assembly {
       b := div(a, WAD_RAY_RATIO)
@@ -112,7 +112,7 @@ library WadRayMath {
    * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
    * @param a Wad
    * @return b = a converted in ray
-   **/
+   */
   function wadToRay(uint256 a) internal pure returns (uint256 b) {
     // to avoid overflow, b/WAD_RAY_RATIO == a
     assembly {
diff --git a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
index 7113a0a..c40d732 100644
--- a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 library DataTypes {
   struct ReserveData {
diff --git a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol
index 7d082a9..e8430f6 100644
--- a/downloads/polygon/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol
+++ b/downloads/mainnet/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY/DefaultReserveInterestRateStrategy/@aave/core-v3/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol
@@ -1,13 +1,14 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20.sol';
 import {WadRayMath} from '../libraries/math/WadRayMath.sol';
 import {PercentageMath} from '../libraries/math/PercentageMath.sol';
 import {DataTypes} from '../libraries/types/DataTypes.sol';
+import {Errors} from '../libraries/helpers/Errors.sol';
+import {IDefaultInterestRateStrategy} from '../../interfaces/IDefaultInterestRateStrategy.sol';
 import {IReserveInterestRateStrategy} from '../../interfaces/IReserveInterestRateStrategy.sol';
 import {IPoolAddressesProvider} from '../../interfaces/IPoolAddressesProvider.sol';
-import {Errors} from '../libraries/helpers/Errors.sol';
 
 /**
  * @title DefaultReserveInterestRateStrategy contract
@@ -17,35 +18,21 @@ import {Errors} from '../libraries/helpers/Errors.sol';
  * point of usage and another from that one to 100%.
  * - An instance of this same contract, can't be used across different Aave markets, due to the caching
  *   of the PoolAddressesProvider
- **/
-contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
+ */
+contract DefaultReserveInterestRateStrategy is IDefaultInterestRateStrategy {
   using WadRayMath for uint256;
   using PercentageMath for uint256;
 
-  /**
-   * @dev This constant represents the usage ratio at which the pool aims to obtain most competitive borrow rates.
-   * Expressed in ray
-   **/
+  /// @inheritdoc IDefaultInterestRateStrategy
   uint256 public immutable OPTIMAL_USAGE_RATIO;
 
-  /**
-   * @dev This constant represents the optimal stable debt to total debt ratio of the reserve.
-   * Expressed in ray
-   */
+  /// @inheritdoc IDefaultInterestRateStrategy
   uint256 public immutable OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO;
 
-  /**
-   * @dev This constant represents the excess usage ratio above the optimal. It's always equal to
-   * 1-optimal usage ratio. Added as a constant here for gas optimizations.
-   * Expressed in ray
-   **/
+  /// @inheritdoc IDefaultInterestRateStrategy
   uint256 public immutable MAX_EXCESS_USAGE_RATIO;
 
-  /**
-   * @dev This constant represents the excess stable debt ratio above the optimal. It's always equal to
-   * 1-optimal stable to total debt ratio. Added as a constant here for gas optimizations.
-   * Expressed in ray
-   **/
+  /// @inheritdoc IDefaultInterestRateStrategy
   uint256 public immutable MAX_EXCESS_STABLE_TO_TOTAL_DEBT_RATIO;
 
   IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
@@ -115,65 +102,42 @@ contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
     _stableRateExcessOffset = stableRateExcessOffset;
   }
 
-  /**
-   * @notice Returns the variable rate slope below optimal usage ratio
-   * @dev Its the variable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
-   * @return The variable rate slope
-   **/
+  /// @inheritdoc IDefaultInterestRateStrategy
   function getVariableRateSlope1() external view returns (uint256) {
     return _variableRateSlope1;
   }
 
-  /**
-   * @notice Returns the variable rate slope above optimal usage ratio
-   * @dev Its the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
-   * @return The variable rate slope
-   **/
+  /// @inheritdoc IDefaultInterestRateStrategy
   function getVariableRateSlope2() external view returns (uint256) {
     return _variableRateSlope2;
   }
 
-  /**
-   * @notice Returns the stable rate slope below optimal usage ratio
-   * @dev Its the stable rate when usage ratio > 0 and <= OPTIMAL_USAGE_RATIO
-   * @return The stable rate slope
-   **/
+  /// @inheritdoc IDefaultInterestRateStrategy
   function getStableRateSlope1() external view returns (uint256) {
     return _stableRateSlope1;
   }
 
-  /**
-   * @notice Returns the stable rate slope above optimal usage ratio
-   * @dev Its the variable rate when usage ratio > OPTIMAL_USAGE_RATIO
-   * @return The stable rate slope
-   **/
+  /// @inheritdoc IDefaultInterestRateStrategy
   function getStableRateSlope2() external view returns (uint256) {
     return _stableRateSlope2;
   }
 
-  /**
-   * @notice Returns the stable rate excess offset
-   * @dev An additional premium applied to the stable when stable debt > OPTIMAL_STABLE_TO_TOTAL_DEBT_RATIO
-   * @return The stable rate excess offset
-   */
+  /// @inheritdoc IDefaultInterestRateStrategy
   function getStableRateExcessOffset() external view returns (uint256) {
     return _stableRateExcessOffset;
   }
 
-  /**
-   * @notice Returns the base stable borrow rate
-   * @return The base stable borrow rate
-   **/
+  /// @inheritdoc IDefaultInterestRateStrategy
   function getBaseStableBorrowRate() public view returns (uint256) {
     return _variableRateSlope1 + _baseStableRateOffset;
   }
 
-  /// @inheritdoc IReserveInterestRateStrategy
+  /// @inheritdoc IDefaultInterestRateStrategy
   function getBaseVariableBorrowRate() external view override returns (uint256) {
     return _baseVariableBorrowRate;
   }
 
-  /// @inheritdoc IReserveInterestRateStrategy
+  /// @inheritdoc IDefaultInterestRateStrategy
   function getMaxVariableBorrowRate() external view override returns (uint256) {
     return _baseVariableBorrowRate + _variableRateSlope1 + _variableRateSlope2;
   }
@@ -191,8 +155,8 @@ contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
   }
 
   /// @inheritdoc IReserveInterestRateStrategy
-  function calculateInterestRates(DataTypes.CalculateInterestRatesParams calldata params)
-    external
+  function calculateInterestRates(DataTypes.CalculateInterestRatesParams memory params)
+    public
     view
     override
     returns (
@@ -275,7 +239,7 @@ contract DefaultReserveInterestRateStrategy is IReserveInterestRateStrategy {
    * @param currentVariableBorrowRate The current variable borrow rate of the reserve
    * @param currentAverageStableBorrowRate The current weighted average of all the stable rate loans
    * @return The weighted averaged borrow rate
-   **/
+   */
   function _getOverallBorrowRate(
     uint256 totalStableDebt,
     uint256 totalVariableDebt,
```
