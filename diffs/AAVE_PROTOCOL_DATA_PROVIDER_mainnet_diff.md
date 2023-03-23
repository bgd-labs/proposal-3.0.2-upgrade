```diff
diff --git a/src/downloads/mainnet/AAVE_PROTOCOL_DATA_PROVIDER.sol b/src/downloads/AAVE_PROTOCOL_DATA_PROVIDER.sol
index fd141b2..39734b2 100644
--- a/src/downloads/mainnet/AAVE_PROTOCOL_DATA_PROVIDER.sol
+++ b/src/downloads/AAVE_PROTOCOL_DATA_PROVIDER.sol
@@ -58,11 +58,7 @@ interface IERC20 {
    *
    * Emits a {Transfer} event.
    */
-  function transferFrom(
-    address sender,
-    address recipient,
-    uint256 amount
-  ) external returns (bool);
+  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
 
   /**
    * @dev Emitted when `value` tokens are moved from one account (`from`) to
@@ -153,7 +149,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -262,11 +258,7 @@ library DataTypes {
     string label;
   }
 
-  enum InterestRateMode {
-    NONE,
-    STABLE,
-    VARIABLE
-  }
+  enum InterestRateMode {NONE, STABLE, VARIABLE}
 
   struct ReserveCache {
     uint256 currScaledVariableDebt;
@@ -537,10 +529,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param threshold The new liquidation threshold
    */
-  function setLiquidationThreshold(DataTypes.ReserveConfigurationMap memory self, uint256 threshold)
-    internal
-    pure
-  {
+  function setLiquidationThreshold(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 threshold
+  ) internal pure {
     require(threshold <= MAX_VALID_LIQUIDATION_THRESHOLD, Errors.INVALID_LIQ_THRESHOLD);
 
     self.data =
@@ -553,11 +545,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The liquidation threshold
    */
-  function getLiquidationThreshold(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getLiquidationThreshold(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
   }
 
@@ -566,10 +556,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param bonus The new liquidation bonus
    */
-  function setLiquidationBonus(DataTypes.ReserveConfigurationMap memory self, uint256 bonus)
-    internal
-    pure
-  {
+  function setLiquidationBonus(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 bonus
+  ) internal pure {
     require(bonus <= MAX_VALID_LIQUIDATION_BONUS, Errors.INVALID_LIQ_BONUS);
 
     self.data =
@@ -582,11 +572,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The liquidation bonus
    */
-  function getLiquidationBonus(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getLiquidationBonus(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
   }
 
@@ -595,10 +583,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param decimals The decimals
    */
-  function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals)
-    internal
-    pure
-  {
+  function setDecimals(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 decimals
+  ) internal pure {
     require(decimals <= MAX_VALID_DECIMALS, Errors.INVALID_DECIMALS);
 
     self.data = (self.data & DECIMALS_MASK) | (decimals << RESERVE_DECIMALS_START_BIT_POSITION);
@@ -609,11 +597,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The decimals of the asset
    */
-  function getDecimals(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getDecimals(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION;
   }
 
@@ -686,10 +672,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param borrowable True if the asset is borrowable
    */
-  function setBorrowableInIsolation(DataTypes.ReserveConfigurationMap memory self, bool borrowable)
-    internal
-    pure
-  {
+  function setBorrowableInIsolation(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool borrowable
+  ) internal pure {
     self.data =
       (self.data & BORROWABLE_IN_ISOLATION_MASK) |
       (uint256(borrowable ? 1 : 0) << BORROWABLE_IN_ISOLATION_START_BIT_POSITION);
@@ -704,11 +690,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The borrowable in isolation flag
    */
-  function getBorrowableInIsolation(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+  function getBorrowableInIsolation(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~BORROWABLE_IN_ISOLATION_MASK) != 0;
   }
 
@@ -718,10 +702,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param siloed True if the asset is siloed
    */
-  function setSiloedBorrowing(DataTypes.ReserveConfigurationMap memory self, bool siloed)
-    internal
-    pure
-  {
+  function setSiloedBorrowing(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool siloed
+  ) internal pure {
     self.data =
       (self.data & SILOED_BORROWING_MASK) |
       (uint256(siloed ? 1 : 0) << SILOED_BORROWING_START_BIT_POSITION);
@@ -733,11 +717,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The siloed borrowing flag
    */
-  function getSiloedBorrowing(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+  function getSiloedBorrowing(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~SILOED_BORROWING_MASK) != 0;
   }
 
@@ -746,10 +728,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param enabled True if the borrowing needs to be enabled, false otherwise
    */
-  function setBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled)
-    internal
-    pure
-  {
+  function setBorrowingEnabled(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool enabled
+  ) internal pure {
     self.data =
       (self.data & BORROWING_MASK) |
       (uint256(enabled ? 1 : 0) << BORROWING_ENABLED_START_BIT_POSITION);
@@ -760,11 +742,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The borrowing state
    */
-  function getBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+  function getBorrowingEnabled(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~BORROWING_MASK) != 0;
   }
 
@@ -787,11 +767,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The stable rate borrowing state
    */
-  function getStableRateBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+  function getStableRateBorrowingEnabled(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~STABLE_BORROWING_MASK) != 0;
   }
 
@@ -800,10 +778,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param reserveFactor The reserve factor
    */
-  function setReserveFactor(DataTypes.ReserveConfigurationMap memory self, uint256 reserveFactor)
-    internal
-    pure
-  {
+  function setReserveFactor(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 reserveFactor
+  ) internal pure {
     require(reserveFactor <= MAX_VALID_RESERVE_FACTOR, Errors.INVALID_RESERVE_FACTOR);
 
     self.data =
@@ -816,11 +794,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The reserve factor
    */
-  function getReserveFactor(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getReserveFactor(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
   }
 
@@ -829,10 +805,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param borrowCap The borrow cap
    */
-  function setBorrowCap(DataTypes.ReserveConfigurationMap memory self, uint256 borrowCap)
-    internal
-    pure
-  {
+  function setBorrowCap(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 borrowCap
+  ) internal pure {
     require(borrowCap <= MAX_VALID_BORROW_CAP, Errors.INVALID_BORROW_CAP);
 
     self.data = (self.data & BORROW_CAP_MASK) | (borrowCap << BORROW_CAP_START_BIT_POSITION);
@@ -843,11 +819,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The borrow cap
    */
-  function getBorrowCap(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getBorrowCap(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~BORROW_CAP_MASK) >> BORROW_CAP_START_BIT_POSITION;
   }
 
@@ -856,10 +830,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param supplyCap The supply cap
    */
-  function setSupplyCap(DataTypes.ReserveConfigurationMap memory self, uint256 supplyCap)
-    internal
-    pure
-  {
+  function setSupplyCap(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 supplyCap
+  ) internal pure {
     require(supplyCap <= MAX_VALID_SUPPLY_CAP, Errors.INVALID_SUPPLY_CAP);
 
     self.data = (self.data & SUPPLY_CAP_MASK) | (supplyCap << SUPPLY_CAP_START_BIT_POSITION);
@@ -870,11 +844,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The supply cap
    */
-  function getSupplyCap(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getSupplyCap(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~SUPPLY_CAP_MASK) >> SUPPLY_CAP_START_BIT_POSITION;
   }
 
@@ -883,10 +855,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param ceiling The maximum debt ceiling for the asset
    */
-  function setDebtCeiling(DataTypes.ReserveConfigurationMap memory self, uint256 ceiling)
-    internal
-    pure
-  {
+  function setDebtCeiling(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 ceiling
+  ) internal pure {
     require(ceiling <= MAX_VALID_DEBT_CEILING, Errors.INVALID_DEBT_CEILING);
 
     self.data = (self.data & DEBT_CEILING_MASK) | (ceiling << DEBT_CEILING_START_BIT_POSITION);
@@ -897,11 +869,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The debt ceiling (0 = isolation mode disabled)
    */
-  function getDebtCeiling(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getDebtCeiling(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~DEBT_CEILING_MASK) >> DEBT_CEILING_START_BIT_POSITION;
   }
 
@@ -929,11 +899,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The liquidation protocol fee
    */
-  function getLiquidationProtocolFee(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getLiquidationProtocolFee(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return
       (self.data & ~LIQUIDATION_PROTOCOL_FEE_MASK) >> LIQUIDATION_PROTOCOL_FEE_START_BIT_POSITION;
   }
@@ -959,11 +927,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The unbacked mint cap
    */
-  function getUnbackedMintCap(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getUnbackedMintCap(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~UNBACKED_MINT_CAP_MASK) >> UNBACKED_MINT_CAP_START_BIT_POSITION;
   }
 
@@ -972,10 +938,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param category The asset category when the user selects the eMode
    */
-  function setEModeCategory(DataTypes.ReserveConfigurationMap memory self, uint256 category)
-    internal
-    pure
-  {
+  function setEModeCategory(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 category
+  ) internal pure {
     require(category <= MAX_VALID_EMODE_CATEGORY, Errors.INVALID_EMODE_CATEGORY);
 
     self.data = (self.data & EMODE_CATEGORY_MASK) | (category << EMODE_CATEGORY_START_BIT_POSITION);
@@ -986,11 +952,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The eMode category for the asset
    */
-  function getEModeCategory(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+  function getEModeCategory(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~EMODE_CATEGORY_MASK) >> EMODE_CATEGORY_START_BIT_POSITION;
   }
 
@@ -999,10 +963,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @param flashLoanEnabled True if the asset is flashloanable, false otherwise
    */
-  function setFlashLoanEnabled(DataTypes.ReserveConfigurationMap memory self, bool flashLoanEnabled)
-    internal
-    pure
-  {
+  function setFlashLoanEnabled(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool flashLoanEnabled
+  ) internal pure {
     self.data =
       (self.data & FLASHLOAN_ENABLED_MASK) |
       (uint256(flashLoanEnabled ? 1 : 0) << FLASHLOAN_ENABLED_START_BIT_POSITION);
@@ -1013,11 +977,9 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The flashloanable flag
    */
-  function getFlashLoanEnabled(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+  function getFlashLoanEnabled(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~FLASHLOAN_ENABLED_MASK) != 0;
   }
 
@@ -1030,17 +992,9 @@ library ReserveConfiguration {
    * @return The state flag representing stableRateBorrowing enabled
    * @return The state flag representing paused
    */
-  function getFlags(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (
-      bool,
-      bool,
-      bool,
-      bool,
-      bool
-    )
-  {
+  function getFlags(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool, bool, bool, bool, bool) {
     uint256 dataLocal = self.data;
 
     return (
@@ -1062,18 +1016,9 @@ library ReserveConfiguration {
    * @return The state param representing reserve factor
    * @return The state param representing eMode category
    */
-  function getParams(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (
-      uint256,
-      uint256,
-      uint256,
-      uint256,
-      uint256,
-      uint256
-    )
-  {
+  function getParams(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256, uint256, uint256, uint256, uint256, uint256) {
     uint256 dataLocal = self.data;
 
     return (
@@ -1092,11 +1037,9 @@ library ReserveConfiguration {
    * @return The state param representing borrow cap
    * @return The state param representing supply cap.
    */
-  function getCaps(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256, uint256)
-  {
+  function getCaps(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256, uint256) {
     uint256 dataLocal = self.data;
 
     return (
@@ -1185,11 +1128,10 @@ library UserConfiguration {
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve for borrowing, false otherwise
    */
-  function isBorrowing(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
-    internal
-    pure
-    returns (bool)
-  {
+  function isBorrowing(
+    DataTypes.UserConfigurationMap memory self,
+    uint256 reserveIndex
+  ) internal pure returns (bool) {
     unchecked {
       require(reserveIndex < ReserveConfiguration.MAX_RESERVES_COUNT, Errors.INVALID_RESERVE_INDEX);
       return (self.data >> (reserveIndex << 1)) & 1 != 0;
@@ -1202,11 +1144,10 @@ library UserConfiguration {
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve as collateral, false otherwise
    */
-  function isUsingAsCollateral(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
-    internal
-    pure
-    returns (bool)
-  {
+  function isUsingAsCollateral(
+    DataTypes.UserConfigurationMap memory self,
+    uint256 reserveIndex
+  ) internal pure returns (bool) {
     unchecked {
       require(reserveIndex < ReserveConfiguration.MAX_RESERVES_COUNT, Errors.INVALID_RESERVE_INDEX);
       return (self.data >> ((reserveIndex << 1) + 1)) & 1 != 0;
@@ -1219,11 +1160,9 @@ library UserConfiguration {
    * @param self The configuration object
    * @return True if the user has been supplying as collateral one reserve, false otherwise
    */
-  function isUsingAsCollateralOne(DataTypes.UserConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+  function isUsingAsCollateralOne(
+    DataTypes.UserConfigurationMap memory self
+  ) internal pure returns (bool) {
     uint256 collateralData = self.data & COLLATERAL_MASK;
     return collateralData != 0 && (collateralData & (collateralData - 1) == 0);
   }
@@ -1233,11 +1172,9 @@ library UserConfiguration {
    * @param self The configuration object
    * @return True if the user has been supplying as collateral any reserve, false otherwise
    */
-  function isUsingAsCollateralAny(DataTypes.UserConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+  function isUsingAsCollateralAny(
+    DataTypes.UserConfigurationMap memory self
+  ) internal pure returns (bool) {
     return self.data & COLLATERAL_MASK != 0;
   }
 
@@ -1283,15 +1220,7 @@ library UserConfiguration {
     DataTypes.UserConfigurationMap memory self,
     mapping(address => DataTypes.ReserveData) storage reservesData,
     mapping(uint256 => address) storage reservesList
-  )
-    internal
-    view
-    returns (
-      bool,
-      address,
-      uint256
-    )
-  {
+  ) internal view returns (bool, address, uint256) {
     if (isUsingAsCollateralOne(self)) {
       uint256 assetId = _getFirstAssetIdByMask(self, COLLATERAL_MASK);
 
@@ -1333,11 +1262,10 @@ library UserConfiguration {
    * @param self The configuration object
    * @return The index of the first asset flagged in the bitmap once the corresponding mask is applied
    */
-  function _getFirstAssetIdByMask(DataTypes.UserConfigurationMap memory self, uint256 mask)
-    internal
-    pure
-    returns (uint256)
-  {
+  function _getFirstAssetIdByMask(
+    DataTypes.UserConfigurationMap memory self,
+    uint256 mask
+  ) internal pure returns (uint256) {
     unchecked {
       uint256 bitmapData = self.data & mask;
       uint256 firstAssetPosition = bitmapData & ~(bitmapData - 1);
@@ -1714,11 +1642,7 @@ interface IAaveIncentivesController {
    * @param totalSupply The total supply of the asset prior to user balance change
    * @param userBalance The previous user balance prior to balance change
    */
-  function handleAction(
-    address user,
-    uint256 totalSupply,
-    uint256 userBalance
-  ) external;
+  function handleAction(address user, uint256 totalSupply, uint256 userBalance) external;
 }
 
 /**
@@ -1949,11 +1873,7 @@ interface IPool {
    * @param fee The amount paid in fees
    * @return The backed amount
    */
-  function backUnbacked(
-    address asset,
-    uint256 amount,
-    uint256 fee
-  ) external returns (uint256);
+  function backUnbacked(address asset, uint256 amount, uint256 fee) external returns (uint256);
 
   /**
    * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
@@ -1966,12 +1886,7 @@ interface IPool {
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
    */
-  function supply(
-    address asset,
-    uint256 amount,
-    address onBehalfOf,
-    uint16 referralCode
-  ) external;
+  function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
 
   /**
    * @notice Supply with transfer approval of asset to be supplied done via permit function
@@ -2010,11 +1925,7 @@ interface IPool {
    *   different wallet
    * @return The final amount withdrawn
    */
-  function withdraw(
-    address asset,
-    uint256 amount,
-    address to
-  ) external returns (uint256);
+  function withdraw(address asset, uint256 amount, address to) external returns (uint256);
 
   /**
    * @notice Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
@@ -2151,7 +2062,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -2178,7 +2089,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -2204,7 +2115,9 @@ interface IPool {
    * @return ltv The loan to value of The user
    * @return healthFactor The current health factor of the user
    */
-  function getUserAccountData(address user)
+  function getUserAccountData(
+    address user
+  )
     external
     view
     returns (
@@ -2247,8 +2160,10 @@ interface IPool {
    * @param asset The address of the underlying asset of the reserve
    * @param rateStrategyAddress The address of the interest rate strategy contract
    */
-  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
-    external;
+  function setReserveInterestRateStrategyAddress(
+    address asset,
+    address rateStrategyAddress
+  ) external;
 
   /**
    * @notice Sets the configuration bitmap of the reserve as a whole
@@ -2256,28 +2171,28 @@ interface IPool {
    * @param asset The address of the underlying asset of the reserve
    * @param configuration The new configuration bitmap
    */
-  function setConfiguration(address asset, DataTypes.ReserveConfigurationMap calldata configuration)
-    external;
+  function setConfiguration(
+    address asset,
+    DataTypes.ReserveConfigurationMap calldata configuration
+  ) external;
 
   /**
    * @notice Returns the configuration of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The configuration of the reserve
    */
-  function getConfiguration(address asset)
-    external
-    view
-    returns (DataTypes.ReserveConfigurationMap memory);
+  function getConfiguration(
+    address asset
+  ) external view returns (DataTypes.ReserveConfigurationMap memory);
 
   /**
    * @notice Returns the configuration of the user across all the reserves
    * @param user The user address
    * @return The configuration of the user
    */
-  function getUserConfiguration(address user)
-    external
-    view
-    returns (DataTypes.UserConfigurationMap memory);
+  function getUserConfiguration(
+    address user
+  ) external view returns (DataTypes.UserConfigurationMap memory);
 
   /**
    * @notice Returns the normalized income of the reserve
@@ -2445,11 +2360,7 @@ interface IPool {
    * @param to The address of the recipient
    * @param amount The amount of token to transfer
    */
-  function rescueTokens(
-    address token,
-    address to,
-    uint256 amount
-  ) external;
+  function rescueTokens(address token, address to, uint256 amount) external;
 
   /**
    * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
@@ -2463,12 +2374,7 @@ interface IPool {
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
    */
-  function deposit(
-    address asset,
-    uint256 amount,
-    address onBehalfOf,
-    uint16 referralCode
-  ) external;
+  function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
 }
 
 /**
@@ -2583,13 +2489,7 @@ interface IStableDebtToken is IInitializableDebtToken {
     address onBehalfOf,
     uint256 amount,
     uint256 rate
-  )
-    external
-    returns (
-      bool,
-      uint256,
-      uint256
-    );
+  ) external returns (bool, uint256, uint256);
 
   /**
    * @notice Burns debt of `user`
@@ -2631,15 +2531,7 @@ interface IStableDebtToken is IInitializableDebtToken {
    * @return The average stable rate
    * @return The timestamp of the last update
    */
-  function getSupplyData()
-    external
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256,
-      uint40
-    );
+  function getSupplyData() external view returns (uint256, uint256, uint256, uint40);
 
   /**
    * @notice Returns the timestamp of the last update of the total supply
@@ -2769,11 +2661,7 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
    * @param index The variable debt index of the reserve
    * @return The scaled total debt of the reserve
    */
-  function burn(
-    address from,
-    uint256 amount,
-    uint256 index
-  ) external returns (uint256);
+  function burn(address from, uint256 amount, uint256 index) external returns (uint256);
 
   /**
    * @notice Returns the address of the underlying asset of this debtToken (E.g. WETH for variableDebtWETH)
@@ -2827,7 +2715,9 @@ interface IPoolDataProvider {
    * @return isActive True if it is active, false otherwise
    * @return isFrozen True if it is frozen, false otherwise
    */
-  function getReserveConfigurationData(address asset)
+  function getReserveConfigurationData(
+    address asset
+  )
     external
     view
     returns (
@@ -2856,10 +2746,9 @@ interface IPoolDataProvider {
    * @return borrowCap The borrow cap of the reserve
    * @return supplyCap The supply cap of the reserve
    */
-  function getReserveCaps(address asset)
-    external
-    view
-    returns (uint256 borrowCap, uint256 supplyCap);
+  function getReserveCaps(
+    address asset
+  ) external view returns (uint256 borrowCap, uint256 supplyCap);
 
   /**
    * @notice Returns if the pool is paused
@@ -2918,7 +2807,9 @@ interface IPoolDataProvider {
    * @return variableBorrowIndex The variable borrow index of the reserve
    * @return lastUpdateTimestamp The timestamp of the last update of the reserve
    */
-  function getReserveData(address asset)
+  function getReserveData(
+    address asset
+  )
     external
     view
     returns (
@@ -2965,7 +2856,10 @@ interface IPoolDataProvider {
    * @return usageAsCollateralEnabled True if the user is using the asset as collateral, false
    *         otherwise
    */
-  function getUserReserveData(address asset, address user)
+  function getUserReserveData(
+    address asset,
+    address user
+  )
     external
     view
     returns (
@@ -2987,7 +2881,9 @@ interface IPoolDataProvider {
    * @return stableDebtTokenAddress The StableDebtToken address of the reserve
    * @return variableDebtTokenAddress The VariableDebtToken address of the reserve
    */
-  function getReserveTokensAddresses(address asset)
+  function getReserveTokensAddresses(
+    address asset
+  )
     external
     view
     returns (
@@ -3001,10 +2897,9 @@ interface IPoolDataProvider {
    * @param asset The address of the underlying asset of the reserve
    * @return irStrategyAddress The address of the Interest Rate strategy
    */
-  function getInterestRateStrategyAddress(address asset)
-    external
-    view
-    returns (address irStrategyAddress);
+  function getInterestRateStrategyAddress(
+    address asset
+  ) external view returns (address irStrategyAddress);
 
   /**
    * @notice Returns whether the reserve has FlashLoans enabled or disabled
@@ -3076,7 +2971,9 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   }
 
   /// @inheritdoc IPoolDataProvider
-  function getReserveConfigurationData(address asset)
+  function getReserveConfigurationData(
+    address asset
+  )
     external
     view
     override
@@ -3112,12 +3009,9 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   }
 
   /// @inheritdoc IPoolDataProvider
-  function getReserveCaps(address asset)
-    external
-    view
-    override
-    returns (uint256 borrowCap, uint256 supplyCap)
-  {
+  function getReserveCaps(
+    address asset
+  ) external view override returns (uint256 borrowCap, uint256 supplyCap) {
     (borrowCap, supplyCap) = IPool(ADDRESSES_PROVIDER.getPool()).getConfiguration(asset).getCaps();
   }
 
@@ -3152,7 +3046,9 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   }
 
   /// @inheritdoc IPoolDataProvider
-  function getReserveData(address asset)
+  function getReserveData(
+    address asset
+  )
     external
     view
     override
@@ -3210,7 +3106,10 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   }
 
   /// @inheritdoc IPoolDataProvider
-  function getUserReserveData(address asset, address user)
+  function getUserReserveData(
+    address asset,
+    address user
+  )
     external
     view
     override
@@ -3247,7 +3146,9 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   }
 
   /// @inheritdoc IPoolDataProvider
-  function getReserveTokensAddresses(address asset)
+  function getReserveTokensAddresses(
+    address asset
+  )
     external
     view
     override
@@ -3269,12 +3170,9 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   }
 
   /// @inheritdoc IPoolDataProvider
-  function getInterestRateStrategyAddress(address asset)
-    external
-    view
-    override
-    returns (address irStrategyAddress)
-  {
+  function getInterestRateStrategyAddress(
+    address asset
+  ) external view override returns (address irStrategyAddress) {
     DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
```
