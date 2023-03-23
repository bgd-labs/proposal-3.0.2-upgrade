```diff
diff --git a/src/downloads/mainnet/POOL_IMPL.sol b/src/downloads/POOL_IMPL.sol
index a9d7f8d..8fa7602 100644
--- a/src/downloads/mainnet/POOL_IMPL.sol
+++ b/src/downloads/POOL_IMPL.sol
@@ -142,7 +142,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -251,11 +251,7 @@ library DataTypes {
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
@@ -526,10 +522,10 @@ library ReserveConfiguration {
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
@@ -542,11 +538,9 @@ library ReserveConfiguration {
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
 
@@ -555,10 +549,10 @@ library ReserveConfiguration {
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
@@ -571,11 +565,9 @@ library ReserveConfiguration {
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
 
@@ -584,10 +576,10 @@ library ReserveConfiguration {
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
@@ -598,11 +590,9 @@ library ReserveConfiguration {
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
 
@@ -675,10 +665,10 @@ library ReserveConfiguration {
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
@@ -693,11 +683,9 @@ library ReserveConfiguration {
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
 
@@ -707,10 +695,10 @@ library ReserveConfiguration {
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
@@ -722,11 +710,9 @@ library ReserveConfiguration {
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
 
@@ -735,10 +721,10 @@ library ReserveConfiguration {
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
@@ -749,11 +735,9 @@ library ReserveConfiguration {
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
 
@@ -776,11 +760,9 @@ library ReserveConfiguration {
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
 
@@ -789,10 +771,10 @@ library ReserveConfiguration {
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
@@ -805,11 +787,9 @@ library ReserveConfiguration {
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
 
@@ -818,10 +798,10 @@ library ReserveConfiguration {
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
@@ -832,11 +812,9 @@ library ReserveConfiguration {
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
 
@@ -845,10 +823,10 @@ library ReserveConfiguration {
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
@@ -859,11 +837,9 @@ library ReserveConfiguration {
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
 
@@ -872,10 +848,10 @@ library ReserveConfiguration {
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
@@ -886,11 +862,9 @@ library ReserveConfiguration {
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
 
@@ -918,11 +892,9 @@ library ReserveConfiguration {
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
@@ -948,11 +920,9 @@ library ReserveConfiguration {
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
 
@@ -961,10 +931,10 @@ library ReserveConfiguration {
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
@@ -975,11 +945,9 @@ library ReserveConfiguration {
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
 
@@ -988,10 +956,10 @@ library ReserveConfiguration {
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
@@ -1002,11 +970,9 @@ library ReserveConfiguration {
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
 
@@ -1019,17 +985,9 @@ library ReserveConfiguration {
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
@@ -1051,18 +1009,9 @@ library ReserveConfiguration {
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
@@ -1081,11 +1030,9 @@ library ReserveConfiguration {
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
@@ -1152,11 +1099,7 @@ interface IERC20 {
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
@@ -1179,11 +1122,7 @@ interface IERC20 {
 library GPv2SafeERC20 {
   /// @dev Wrapper around a call to the ERC20 function `transfer` that reverts
   /// also when the token returns `false`.
-  function safeTransfer(
-    IERC20 token,
-    address to,
-    uint256 value
-  ) internal {
+  function safeTransfer(IERC20 token, address to, uint256 value) internal {
     bytes4 selector_ = token.transfer.selector;
 
     // solhint-disable-next-line no-inline-assembly
@@ -1204,12 +1143,7 @@ library GPv2SafeERC20 {
 
   /// @dev Wrapper around a call to the ERC20 function `transferFrom` that
   /// reverts also when the token returns `false`.
-  function safeTransferFrom(
-    IERC20 token,
-    address from,
-    address to,
-    uint256 value
-  ) internal {
+  function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
     bytes4 selector_ = token.transferFrom.selector;
 
     // solhint-disable-next-line no-inline-assembly
@@ -1436,11 +1370,7 @@ interface IAaveIncentivesController {
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
@@ -1896,11 +1826,7 @@ interface IPool {
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
@@ -1913,12 +1839,7 @@ interface IPool {
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
@@ -1957,11 +1878,7 @@ interface IPool {
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
@@ -2098,7 +2015,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -2125,7 +2042,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -2151,7 +2068,9 @@ interface IPool {
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
@@ -2194,8 +2113,10 @@ interface IPool {
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
@@ -2203,28 +2124,28 @@ interface IPool {
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
@@ -2392,11 +2313,7 @@ interface IPool {
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
@@ -2410,12 +2327,7 @@ interface IPool {
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
@@ -2508,12 +2420,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param amount The amount being burned
    * @param index The next liquidity index of the reserve
    */
-  function burn(
-    address from,
-    address receiverOfUnderlying,
-    uint256 amount,
-    uint256 index
-  ) external;
+  function burn(address from, address receiverOfUnderlying, uint256 amount, uint256 index) external;
 
   /**
    * @notice Mints aTokens to the reserve treasury
@@ -2528,11 +2435,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param to The recipient
    * @param value The amount of tokens getting transferred
    */
-  function transferOnLiquidation(
-    address from,
-    address to,
-    uint256 value
-  ) external;
+  function transferOnLiquidation(address from, address to, uint256 value) external;
 
   /**
    * @notice Transfers the underlying asset to `target`.
@@ -2551,11 +2454,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param onBehalfOf The address of the user who will get his debt reduced/removed
    * @param amount The amount getting repaid
    */
-  function handleRepayment(
-    address user,
-    address onBehalfOf,
-    uint256 amount
-  ) external;
+  function handleRepayment(address user, address onBehalfOf, uint256 amount) external;
 
   /**
    * @notice Allow passing a signed message to approve spending
@@ -2611,11 +2510,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param to The address of the recipient
    * @param amount The amount of token to transfer
    */
-  function rescueTokens(
-    address token,
-    address to,
-    uint256 amount
-  ) external;
+  function rescueTokens(address token, address to, uint256 amount) external;
 }
 
 /**
@@ -2854,13 +2749,7 @@ interface IStableDebtToken is IInitializableDebtToken {
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
@@ -2902,15 +2791,7 @@ interface IStableDebtToken is IInitializableDebtToken {
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
@@ -2970,11 +2851,7 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
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
@@ -2996,14 +2873,9 @@ interface IReserveInterestRateStrategy {
    * @return stableBorrowRate The stable borrow rate expressed in rays
    * @return variableBorrowRate The variable borrow rate expressed in rays
    */
-  function calculateInterestRates(DataTypes.CalculateInterestRatesParams memory params)
-    external
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256
-    );
+  function calculateInterestRates(
+    DataTypes.CalculateInterestRatesParams memory params
+  ) external view returns (uint256, uint256, uint256);
 }
 
 /**
@@ -3023,11 +2895,10 @@ library MathUtils {
    * @param lastUpdateTimestamp The timestamp of the last update of the interest
    * @return The interest rate linearly accumulated during the timeDelta, in ray
    */
-  function calculateLinearInterest(uint256 rate, uint40 lastUpdateTimestamp)
-    internal
-    view
-    returns (uint256)
-  {
+  function calculateLinearInterest(
+    uint256 rate,
+    uint40 lastUpdateTimestamp
+  ) internal view returns (uint256) {
     //solium-disable-next-line
     uint256 result = rate * (block.timestamp - uint256(lastUpdateTimestamp));
     unchecked {
@@ -3094,11 +2965,10 @@ library MathUtils {
    * @param lastUpdateTimestamp The timestamp from which the interest accumulation needs to be calculated
    * @return The interest rate compounded between lastUpdateTimestamp and current block timestamp, in ray
    */
-  function calculateCompoundedInterest(uint256 rate, uint40 lastUpdateTimestamp)
-    internal
-    view
-    returns (uint256)
-  {
+  function calculateCompoundedInterest(
+    uint256 rate,
+    uint40 lastUpdateTimestamp
+  ) internal view returns (uint256) {
     return calculateCompoundedInterest(rate, lastUpdateTimestamp, block.timestamp);
   }
 }
@@ -3446,11 +3316,9 @@ library ReserveLogic {
    * @param reserve The reserve object
    * @return The normalized income, expressed in ray
    */
-  function getNormalizedIncome(DataTypes.ReserveData storage reserve)
-    internal
-    view
-    returns (uint256)
-  {
+  function getNormalizedIncome(
+    DataTypes.ReserveData storage reserve
+  ) internal view returns (uint256) {
     uint40 timestamp = reserve.lastUpdateTimestamp;
 
     //solium-disable-next-line
@@ -3472,11 +3340,9 @@ library ReserveLogic {
    * @param reserve The reserve object
    * @return The normalized variable debt, expressed in ray
    */
-  function getNormalizedDebt(DataTypes.ReserveData storage reserve)
-    internal
-    view
-    returns (uint256)
-  {
+  function getNormalizedDebt(
+    DataTypes.ReserveData storage reserve
+  ) internal view returns (uint256) {
     uint40 timestamp = reserve.lastUpdateTimestamp;
 
     //solium-disable-next-line
@@ -3728,11 +3594,9 @@ library ReserveLogic {
    * @param reserve The reserve object for which the cache will be filled
    * @return The cache object
    */
-  function cache(DataTypes.ReserveData storage reserve)
-    internal
-    view
-    returns (DataTypes.ReserveCache memory)
-  {
+  function cache(
+    DataTypes.ReserveData storage reserve
+  ) internal view returns (DataTypes.ReserveCache memory) {
     DataTypes.ReserveCache memory reserveCache;
 
     reserveCache.reserveConfiguration = reserve.configuration;
@@ -3860,6 +3724,94 @@ interface IPriceOracleSentinel {
   function getGracePeriod() external view returns (uint256);
 }
 
+/**
+ * @dev External interface of AccessControl declared to support ERC165 detection.
+ */
+interface IAccessControl {
+  /**
+   * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
+   *
+   * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
+   * {RoleAdminChanged} not being emitted signaling this.
+   *
+   * _Available since v3.1._
+   */
+  event RoleAdminChanged(
+    bytes32 indexed role,
+    bytes32 indexed previousAdminRole,
+    bytes32 indexed newAdminRole
+  );
+
+  /**
+   * @dev Emitted when `account` is granted `role`.
+   *
+   * `sender` is the account that originated the contract call, an admin role
+   * bearer except when using {AccessControl-_setupRole}.
+   */
+  event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
+
+  /**
+   * @dev Emitted when `account` is revoked `role`.
+   *
+   * `sender` is the account that originated the contract call:
+   *   - if using `revokeRole`, it is the admin role bearer
+   *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
+   */
+  event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
+
+  /**
+   * @dev Returns `true` if `account` has been granted `role`.
+   */
+  function hasRole(bytes32 role, address account) external view returns (bool);
+
+  /**
+   * @dev Returns the admin role that controls `role`. See {grantRole} and
+   * {revokeRole}.
+   *
+   * To change a role's admin, use {AccessControl-_setRoleAdmin}.
+   */
+  function getRoleAdmin(bytes32 role) external view returns (bytes32);
+
+  /**
+   * @dev Grants `role` to `account`.
+   *
+   * If `account` had not been already granted `role`, emits a {RoleGranted}
+   * event.
+   *
+   * Requirements:
+   *
+   * - the caller must have ``role``'s admin role.
+   */
+  function grantRole(bytes32 role, address account) external;
+
+  /**
+   * @dev Revokes `role` from `account`.
+   *
+   * If `account` had been granted `role`, emits a {RoleRevoked} event.
+   *
+   * Requirements:
+   *
+   * - the caller must have ``role``'s admin role.
+   */
+  function revokeRole(bytes32 role, address account) external;
+
+  /**
+   * @dev Revokes `role` from the calling account.
+   *
+   * Roles are often managed via {grantRole} and {revokeRole}: this function's
+   * purpose is to provide a mechanism for accounts to lose their privileges
+   * if they are compromised (such as when a trusted device is misplaced).
+   *
+   * If the calling account had been granted `role`, emits a {RoleRevoked}
+   * event.
+   *
+   * Requirements:
+   *
+   * - the caller must be `account`.
+   */
+  function renounceRole(bytes32 role, address account) external;
+}
+
 /**
  * @title UserConfiguration library
  * @author Aave
@@ -3939,11 +3891,10 @@ library UserConfiguration {
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
@@ -3956,11 +3907,10 @@ library UserConfiguration {
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
@@ -3973,11 +3923,9 @@ library UserConfiguration {
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
@@ -3987,11 +3935,9 @@ library UserConfiguration {
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
 
@@ -4037,15 +3983,7 @@ library UserConfiguration {
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
 
@@ -4087,11 +4025,10 @@ library UserConfiguration {
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
@@ -4179,15 +4116,7 @@ library EModeLogic {
   function getEModeConfiguration(
     DataTypes.EModeCategory storage category,
     IPriceOracleGetter oracle
-  )
-    internal
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256
-    )
-  {
+  ) internal view returns (uint256, uint256, uint256) {
     uint256 eModeAssetPrice = 0;
     address eModePriceSource = category.priceSource;
 
@@ -4204,11 +4133,10 @@ library EModeLogic {
    * @param eModeAssetCategory The asset eMode category
    * @return True if eMode is active and the asset belongs to the eMode category chosen by the user, false otherwise
    */
-  function isInEModeCategory(uint256 eModeUserCategory, uint256 eModeAssetCategory)
-    internal
-    pure
-    returns (bool)
-  {
+  function isInEModeCategory(
+    uint256 eModeUserCategory,
+    uint256 eModeAssetCategory
+  ) internal pure returns (bool) {
     return (eModeUserCategory != 0 && eModeAssetCategory == eModeUserCategory);
   }
 }
@@ -4267,18 +4195,7 @@ library GenericLogic {
     mapping(uint256 => address) storage reservesList,
     mapping(uint8 => DataTypes.EModeCategory) storage eModeCategories,
     DataTypes.CalculateUserAccountDataParams memory params
-  )
-    internal
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256,
-      uint256,
-      uint256,
-      bool
-    )
-  {
+  ) internal view returns (uint256, uint256, uint256, uint256, uint256, bool) {
     if (params.userConfig.isEmpty()) {
       return (0, 0, 0, 0, type(uint256).max, false);
     }
@@ -4322,7 +4239,7 @@ library GenericLogic {
       ) = currentReserve.configuration.getParams();
 
       unchecked {
-        vars.assetUnit = 10**vars.decimals;
+        vars.assetUnit = 10 ** vars.decimals;
       }
 
       vars.assetPrice = vars.eModeAssetPrice != 0 &&
@@ -4480,6 +4397,428 @@ library GenericLogic {
   }
 }
 
+/*
+ * @dev Provides information about the current execution context, including the
+ * sender of the transaction and its data. While these are generally available
+ * via msg.sender and msg.data, they should not be accessed in such a direct
+ * manner, since when dealing with GSN meta-transactions the account sending and
+ * paying for execution may not be the actual sender (as far as an application
+ * is concerned).
+ *
+ * This contract is only required for intermediate, library-like contracts.
+ */
+abstract contract Context {
+  function _msgSender() internal view virtual returns (address payable) {
+    return payable(msg.sender);
+  }
+
+  function _msgData() internal view virtual returns (bytes memory) {
+    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
+    return msg.data;
+  }
+}
+
+interface IERC20Detailed is IERC20 {
+  function name() external view returns (string memory);
+
+  function symbol() external view returns (string memory);
+
+  function decimals() external view returns (uint8);
+}
+
+/**
+ * @title IACLManager
+ * @author Aave
+ * @notice Defines the basic interface for the ACL Manager
+ */
+interface IACLManager {
+  /**
+   * @notice Returns the contract address of the PoolAddressesProvider
+   * @return The address of the PoolAddressesProvider
+   */
+  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
+
+  /**
+   * @notice Returns the identifier of the PoolAdmin role
+   * @return The id of the PoolAdmin role
+   */
+  function POOL_ADMIN_ROLE() external view returns (bytes32);
+
+  /**
+   * @notice Returns the identifier of the EmergencyAdmin role
+   * @return The id of the EmergencyAdmin role
+   */
+  function EMERGENCY_ADMIN_ROLE() external view returns (bytes32);
+
+  /**
+   * @notice Returns the identifier of the RiskAdmin role
+   * @return The id of the RiskAdmin role
+   */
+  function RISK_ADMIN_ROLE() external view returns (bytes32);
+
+  /**
+   * @notice Returns the identifier of the FlashBorrower role
+   * @return The id of the FlashBorrower role
+   */
+  function FLASH_BORROWER_ROLE() external view returns (bytes32);
+
+  /**
+   * @notice Returns the identifier of the Bridge role
+   * @return The id of the Bridge role
+   */
+  function BRIDGE_ROLE() external view returns (bytes32);
+
+  /**
+   * @notice Returns the identifier of the AssetListingAdmin role
+   * @return The id of the AssetListingAdmin role
+   */
+  function ASSET_LISTING_ADMIN_ROLE() external view returns (bytes32);
+
+  /**
+   * @notice Set the role as admin of a specific role.
+   * @dev By default the admin role for all roles is `DEFAULT_ADMIN_ROLE`.
+   * @param role The role to be managed by the admin role
+   * @param adminRole The admin role
+   */
+  function setRoleAdmin(bytes32 role, bytes32 adminRole) external;
+
+  /**
+   * @notice Adds a new admin as PoolAdmin
+   * @param admin The address of the new admin
+   */
+  function addPoolAdmin(address admin) external;
+
+  /**
+   * @notice Removes an admin as PoolAdmin
+   * @param admin The address of the admin to remove
+   */
+  function removePoolAdmin(address admin) external;
+
+  /**
+   * @notice Returns true if the address is PoolAdmin, false otherwise
+   * @param admin The address to check
+   * @return True if the given address is PoolAdmin, false otherwise
+   */
+  function isPoolAdmin(address admin) external view returns (bool);
+
+  /**
+   * @notice Adds a new admin as EmergencyAdmin
+   * @param admin The address of the new admin
+   */
+  function addEmergencyAdmin(address admin) external;
+
+  /**
+   * @notice Removes an admin as EmergencyAdmin
+   * @param admin The address of the admin to remove
+   */
+  function removeEmergencyAdmin(address admin) external;
+
+  /**
+   * @notice Returns true if the address is EmergencyAdmin, false otherwise
+   * @param admin The address to check
+   * @return True if the given address is EmergencyAdmin, false otherwise
+   */
+  function isEmergencyAdmin(address admin) external view returns (bool);
+
+  /**
+   * @notice Adds a new admin as RiskAdmin
+   * @param admin The address of the new admin
+   */
+  function addRiskAdmin(address admin) external;
+
+  /**
+   * @notice Removes an admin as RiskAdmin
+   * @param admin The address of the admin to remove
+   */
+  function removeRiskAdmin(address admin) external;
+
+  /**
+   * @notice Returns true if the address is RiskAdmin, false otherwise
+   * @param admin The address to check
+   * @return True if the given address is RiskAdmin, false otherwise
+   */
+  function isRiskAdmin(address admin) external view returns (bool);
+
+  /**
+   * @notice Adds a new address as FlashBorrower
+   * @param borrower The address of the new FlashBorrower
+   */
+  function addFlashBorrower(address borrower) external;
+
+  /**
+   * @notice Removes an address as FlashBorrower
+   * @param borrower The address of the FlashBorrower to remove
+   */
+  function removeFlashBorrower(address borrower) external;
+
+  /**
+   * @notice Returns true if the address is FlashBorrower, false otherwise
+   * @param borrower The address to check
+   * @return True if the given address is FlashBorrower, false otherwise
+   */
+  function isFlashBorrower(address borrower) external view returns (bool);
+
+  /**
+   * @notice Adds a new address as Bridge
+   * @param bridge The address of the new Bridge
+   */
+  function addBridge(address bridge) external;
+
+  /**
+   * @notice Removes an address as Bridge
+   * @param bridge The address of the bridge to remove
+   */
+  function removeBridge(address bridge) external;
+
+  /**
+   * @notice Returns true if the address is Bridge, false otherwise
+   * @param bridge The address to check
+   * @return True if the given address is Bridge, false otherwise
+   */
+  function isBridge(address bridge) external view returns (bool);
+
+  /**
+   * @notice Adds a new admin as AssetListingAdmin
+   * @param admin The address of the new admin
+   */
+  function addAssetListingAdmin(address admin) external;
+
+  /**
+   * @notice Removes an admin as AssetListingAdmin
+   * @param admin The address of the admin to remove
+   */
+  function removeAssetListingAdmin(address admin) external;
+
+  /**
+   * @notice Returns true if the address is AssetListingAdmin, false otherwise
+   * @param admin The address to check
+   * @return True if the given address is AssetListingAdmin, false otherwise
+   */
+  function isAssetListingAdmin(address admin) external view returns (bool);
+}
+
+/**
+ * @title IncentivizedERC20
+ * @author Aave, inspired by the Openzeppelin ERC20 implementation
+ * @notice Basic ERC20 implementation
+ */
+abstract contract IncentivizedERC20 is Context, IERC20Detailed {
+  using WadRayMath for uint256;
+  using SafeCast for uint256;
+
+  /**
+   * @dev Only pool admin can call functions marked by this modifier.
+   */
+  modifier onlyPoolAdmin() {
+    IACLManager aclManager = IACLManager(_addressesProvider.getACLManager());
+    require(aclManager.isPoolAdmin(msg.sender), Errors.CALLER_NOT_POOL_ADMIN);
+    _;
+  }
+
+  /**
+   * @dev Only pool can call functions marked by this modifier.
+   */
+  modifier onlyPool() {
+    require(_msgSender() == address(POOL), Errors.CALLER_MUST_BE_POOL);
+    _;
+  }
+
+  /**
+   * @dev UserState - additionalData is a flexible field.
+   * ATokens and VariableDebtTokens use this field store the index of the
+   * user's last supply/withdrawal/borrow/repayment. StableDebtTokens use
+   * this field to store the user's stable rate.
+   */
+  struct UserState {
+    uint128 balance;
+    uint128 additionalData;
+  }
+  // Map of users address and their state data (userAddress => userStateData)
+  mapping(address => UserState) internal _userState;
+
+  // Map of allowances (delegator => delegatee => allowanceAmount)
+  mapping(address => mapping(address => uint256)) private _allowances;
+
+  uint256 internal _totalSupply;
+  string private _name;
+  string private _symbol;
+  uint8 private _decimals;
+  IAaveIncentivesController internal _incentivesController;
+  IPoolAddressesProvider internal immutable _addressesProvider;
+  IPool public immutable POOL;
+
+  /**
+   * @dev Constructor.
+   * @param pool The reference to the main Pool contract
+   * @param name The name of the token
+   * @param symbol The symbol of the token
+   * @param decimals The number of decimals of the token
+   */
+  constructor(IPool pool, string memory name, string memory symbol, uint8 decimals) {
+    _addressesProvider = pool.ADDRESSES_PROVIDER();
+    _name = name;
+    _symbol = symbol;
+    _decimals = decimals;
+    POOL = pool;
+  }
+
+  /// @inheritdoc IERC20Detailed
+  function name() public view override returns (string memory) {
+    return _name;
+  }
+
+  /// @inheritdoc IERC20Detailed
+  function symbol() external view override returns (string memory) {
+    return _symbol;
+  }
+
+  /// @inheritdoc IERC20Detailed
+  function decimals() external view override returns (uint8) {
+    return _decimals;
+  }
+
+  /// @inheritdoc IERC20
+  function totalSupply() public view virtual override returns (uint256) {
+    return _totalSupply;
+  }
+
+  /// @inheritdoc IERC20
+  function balanceOf(address account) public view virtual override returns (uint256) {
+    return _userState[account].balance;
+  }
+
+  /**
+   * @notice Returns the address of the Incentives Controller contract
+   * @return The address of the Incentives Controller
+   */
+  function getIncentivesController() external view virtual returns (IAaveIncentivesController) {
+    return _incentivesController;
+  }
+
+  /**
+   * @notice Sets a new Incentives Controller
+   * @param controller the new Incentives controller
+   */
+  function setIncentivesController(IAaveIncentivesController controller) external onlyPoolAdmin {
+    _incentivesController = controller;
+  }
+
+  /// @inheritdoc IERC20
+  function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
+    uint128 castAmount = amount.toUint128();
+    _transfer(_msgSender(), recipient, castAmount);
+    return true;
+  }
+
+  /// @inheritdoc IERC20
+  function allowance(
+    address owner,
+    address spender
+  ) external view virtual override returns (uint256) {
+    return _allowances[owner][spender];
+  }
+
+  /// @inheritdoc IERC20
+  function approve(address spender, uint256 amount) external virtual override returns (bool) {
+    _approve(_msgSender(), spender, amount);
+    return true;
+  }
+
+  /// @inheritdoc IERC20
+  function transferFrom(
+    address sender,
+    address recipient,
+    uint256 amount
+  ) external virtual override returns (bool) {
+    uint128 castAmount = amount.toUint128();
+    _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - castAmount);
+    _transfer(sender, recipient, castAmount);
+    return true;
+  }
+
+  /**
+   * @notice Increases the allowance of spender to spend _msgSender() tokens
+   * @param spender The user allowed to spend on behalf of _msgSender()
+   * @param addedValue The amount being added to the allowance
+   * @return `true`
+   */
+  function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
+    _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
+    return true;
+  }
+
+  /**
+   * @notice Decreases the allowance of spender to spend _msgSender() tokens
+   * @param spender The user allowed to spend on behalf of _msgSender()
+   * @param subtractedValue The amount being subtracted to the allowance
+   * @return `true`
+   */
+  function decreaseAllowance(
+    address spender,
+    uint256 subtractedValue
+  ) external virtual returns (bool) {
+    _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
+    return true;
+  }
+
+  /**
+   * @notice Transfers tokens between two users and apply incentives if defined.
+   * @param sender The source address
+   * @param recipient The destination address
+   * @param amount The amount getting transferred
+   */
+  function _transfer(address sender, address recipient, uint128 amount) internal virtual {
+    uint128 oldSenderBalance = _userState[sender].balance;
+    _userState[sender].balance = oldSenderBalance - amount;
+    uint128 oldRecipientBalance = _userState[recipient].balance;
+    _userState[recipient].balance = oldRecipientBalance + amount;
+
+    IAaveIncentivesController incentivesControllerLocal = _incentivesController;
+    if (address(incentivesControllerLocal) != address(0)) {
+      uint256 currentTotalSupply = _totalSupply;
+      incentivesControllerLocal.handleAction(sender, currentTotalSupply, oldSenderBalance);
+      if (sender != recipient) {
+        incentivesControllerLocal.handleAction(recipient, currentTotalSupply, oldRecipientBalance);
+      }
+    }
+  }
+
+  /**
+   * @notice Approve `spender` to use `amount` of `owner`s balance
+   * @param owner The address owning the tokens
+   * @param spender The address approved for spending
+   * @param amount The amount of tokens to approve spending of
+   */
+  function _approve(address owner, address spender, uint256 amount) internal virtual {
+    _allowances[owner][spender] = amount;
+    emit Approval(owner, spender, amount);
+  }
+
+  /**
+   * @notice Update the name of the token
+   * @param newName The new name for the token
+   */
+  function _setName(string memory newName) internal {
+    _name = newName;
+  }
+
+  /**
+   * @notice Update the symbol for the token
+   * @param newSymbol The new symbol for the token
+   */
+  function _setSymbol(string memory newSymbol) internal {
+    _symbol = newSymbol;
+  }
+
+  /**
+   * @notice Update the number of decimals for the token
+   * @param newDecimals The new number of decimals for the token
+   */
+  function _setDecimals(uint8 newDecimals) internal {
+    _decimals = newDecimals;
+  }
+}
+
 /**
  * @title ReserveLogic library
  * @author Aave
@@ -4509,6 +4848,12 @@ library ValidationLogic {
    */
   uint256 public constant HEALTH_FACTOR_LIQUIDATION_THRESHOLD = 1e18;
 
+  /**
+   * @dev Role identifier for the role allowed to supply isolated reserves as collateral
+   */
+  bytes32 public constant ISOLATED_COLLATERAL_SUPPLIER_ROLE =
+    keccak256('ISOLATED_COLLATERAL_SUPPLIER');
+
   /**
    * @notice Validates a supply action.
    * @param reserveCache The cached data of the reserve
@@ -4533,7 +4878,7 @@ library ValidationLogic {
       supplyCap == 0 ||
         ((IAToken(reserveCache.aTokenAddress).scaledTotalSupply() +
           uint256(reserve.accruedToTreasury)).rayMul(reserveCache.nextLiquidityIndex) + amount) <=
-        supplyCap * (10**reserveCache.reserveConfiguration.getDecimals()),
+        supplyCap * (10 ** reserveCache.reserveConfiguration.getDecimals()),
       Errors.SUPPLY_CAP_EXCEEDED
     );
   }
@@ -4626,7 +4971,7 @@ library ValidationLogic {
     vars.reserveDecimals = params.reserveCache.reserveConfiguration.getDecimals();
     vars.borrowCap = params.reserveCache.reserveConfiguration.getBorrowCap();
     unchecked {
-      vars.assetUnit = 10**vars.reserveDecimals;
+      vars.assetUnit = 10 ** vars.reserveDecimals;
     }
 
     if (vars.borrowCap != 0) {
@@ -4654,7 +4999,8 @@ library ValidationLogic {
 
       require(
         reservesData[params.isolationModeCollateralAddress].isolationModeTotalDebt +
-          (params.amount / 10**(vars.reserveDecimals - ReserveConfiguration.DEBT_CEILING_DECIMALS))
+          (params.amount /
+            10 ** (vars.reserveDecimals - ReserveConfiguration.DEBT_CEILING_DECIMALS))
             .toUint128() <=
           params.isolationModeDebtCeiling,
         Errors.DEBT_CEILING_EXCEEDED
@@ -5123,7 +5469,7 @@ library ValidationLogic {
       Errors.INCONSISTENT_EMODE_CATEGORY
     );
 
-    //eMode can always be enabled if the user hasn't supplied anything
+    // eMode can always be enabled if the user hasn't supplied anything
     if (userConfig.isEmpty()) {
       return;
     }
@@ -5147,10 +5493,8 @@ library ValidationLogic {
   }
 
   /**
-   * @notice Validates if an asset can be activated as collateral in the following actions: supply, transfer,
-   * set as collateral, mint unbacked, and liquidate
-   * @dev This is used to ensure that the constraints for isolated assets are respected by all the actions that
-   * generate transfers of aTokens
+   * @notice Validates the action of activating the asset as collateral.
+   * @dev Only possible if the asset has non-zero LTV and the user is not in isolation mode
    * @param reservesData The state of all the reserves
    * @param reservesList The addresses of all the active reserves
    * @param userConfig the user configuration
@@ -5163,6 +5507,9 @@ library ValidationLogic {
     DataTypes.UserConfigurationMap storage userConfig,
     DataTypes.ReserveConfigurationMap memory reserveConfig
   ) internal view returns (bool) {
+    if (reserveConfig.getLtv() == 0) {
+      return false;
+    }
     if (!userConfig.isUsingAsCollateralAny()) {
       return true;
     }
@@ -5170,6 +5517,38 @@ library ValidationLogic {
 
     return (!isolationModeActive && reserveConfig.getDebtCeiling() == 0);
   }
+
+  /**
+   * @notice Validates if an asset should be automatically activated as collateral in the following actions: supply,
+   * transfer, mint unbacked, and liquidate
+   * @dev This is used to ensure that isolated assets are not enabled as collateral automatically
+   * @param reservesData The state of all the reserves
+   * @param reservesList The addresses of all the active reserves
+   * @param userConfig the user configuration
+   * @param reserveConfig The reserve configuration
+   * @return True if the asset can be activated as collateral, false otherwise
+   */
+  function validateAutomaticUseAsCollateral(
+    mapping(address => DataTypes.ReserveData) storage reservesData,
+    mapping(uint256 => address) storage reservesList,
+    DataTypes.UserConfigurationMap storage userConfig,
+    DataTypes.ReserveConfigurationMap memory reserveConfig,
+    address aTokenAddress
+  ) internal view returns (bool) {
+    if (reserveConfig.getDebtCeiling() != 0) {
+      // ensures only the ISOLATED_COLLATERAL_SUPPLIER_ROLE can enable collateral as side-effect of an action
+      IPoolAddressesProvider addressesProvider = IncentivizedERC20(aTokenAddress)
+        .POOL()
+        .ADDRESSES_PROVIDER();
+      if (
+        !IAccessControl(addressesProvider.getACLManager()).hasRole(
+          ISOLATED_COLLATERAL_SUPPLIER_ROLE,
+          msg.sender
+        )
+      ) return false;
+    }
+    return validateUseAsCollateral(reservesData, reservesList, userConfig, reserveConfig);
+  }
 }
 
 /**
@@ -5231,11 +5610,7 @@ library PoolLogic {
    * @param to The address of the recipient
    * @param amount The amount of token to transfer
    */
-  function executeRescueTokens(
-    address token,
-    address to,
-    uint256 amount
-  ) external {
+  function executeRescueTokens(address token, address to, uint256 amount) external {
     IERC20(token).safeTransfer(to, amount);
   }
 
@@ -5412,11 +5787,12 @@ library SupplyLogic {
 
     if (isFirstSupply) {
       if (
-        ValidationLogic.validateUseAsCollateral(
+        ValidationLogic.validateAutomaticUseAsCollateral(
           reservesData,
           reservesList,
           userConfig,
-          reserveCache.reserveConfiguration
+          reserveCache.reserveConfiguration,
+          reserveCache.aTokenAddress
         )
       ) {
         userConfig.setUsingAsCollateral(reserve.id, true);
@@ -5549,11 +5925,12 @@ library SupplyLogic {
       if (params.balanceToBefore == 0) {
         DataTypes.UserConfigurationMap storage toConfig = usersConfig[params.to];
         if (
-          ValidationLogic.validateUseAsCollateral(
+          ValidationLogic.validateAutomaticUseAsCollateral(
             reservesData,
             reservesList,
             toConfig,
-            reserve.configuration
+            reserve.configuration,
+            reserve.aTokenAddress
           )
         ) {
           toConfig.setUsingAsCollateral(reserveId, true);
@@ -5607,7 +5984,7 @@ library SupplyLogic {
           userConfig,
           reserveCache.reserveConfiguration
         ),
-        Errors.USER_IN_ISOLATION_MODE
+        Errors.USER_IN_ISOLATION_MODE_OR_LTV_ZERO
       );
 
       userConfig.setUsingAsCollateral(reserve.id, true);
@@ -5705,11 +6082,10 @@ library Helpers {
    * @return The stable debt balance
    * @return The variable debt balance
    */
-  function getUserCurrentDebt(address user, DataTypes.ReserveCache memory reserveCache)
-    internal
-    view
-    returns (uint256, uint256)
-  {
+  function getUserCurrentDebt(
+    address user,
+    DataTypes.ReserveCache memory reserveCache
+  ) internal view returns (uint256, uint256) {
     return (
       IERC20(reserveCache.stableDebtTokenAddress).balanceOf(user),
       IERC20(reserveCache.variableDebtTokenAddress).balanceOf(user)
@@ -6184,7 +6560,10 @@ library FlashLoanLogic {
 
     for (vars.i = 0; vars.i < params.assets.length; vars.i++) {
       vars.currentAmount = params.amounts[vars.i];
-      vars.totalPremiums[vars.i] = vars.currentAmount.percentMul(vars.flashloanPremiumTotal);
+      vars.totalPremiums[vars.i] = DataTypes.InterestRateMode(params.interestRateModes[vars.i]) ==
+        DataTypes.InterestRateMode.NONE
+        ? vars.currentAmount.percentMul(vars.flashloanPremiumTotal)
+        : 0;
       IAToken(reservesData[params.assets[vars.i]].aTokenAddress).transferUnderlyingTo(
         params.receiverAddress,
         vars.currentAmount
@@ -6640,11 +7019,12 @@ library LiquidationLogic {
     if (liquidatorPreviousATokenBalance == 0) {
       DataTypes.UserConfigurationMap storage liquidatorConfig = usersConfig[msg.sender];
       if (
-        ValidationLogic.validateUseAsCollateral(
+        ValidationLogic.validateAutomaticUseAsCollateral(
           reservesData,
           reservesList,
           liquidatorConfig,
-          collateralReserve.configuration
+          collateralReserve.configuration,
+          collateralReserve.aTokenAddress
         )
       ) {
         liquidatorConfig.setUsingAsCollateral(collateralReserve.id, true);
@@ -6703,15 +7083,7 @@ library LiquidationLogic {
     DataTypes.ReserveCache memory debtReserveCache,
     DataTypes.ExecuteLiquidationCallParams memory params,
     uint256 healthFactor
-  )
-    internal
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256
-    )
-  {
+  ) internal view returns (uint256, uint256, uint256) {
     (uint256 userStableDebt, uint256 userVariableDebt) = Helpers.getUserCurrentDebt(
       params.user,
       debtReserveCache
@@ -6746,16 +7118,7 @@ library LiquidationLogic {
     mapping(uint8 => DataTypes.EModeCategory) storage eModeCategories,
     DataTypes.ReserveData storage collateralReserve,
     DataTypes.ExecuteLiquidationCallParams memory params
-  )
-    internal
-    view
-    returns (
-      IAToken,
-      address,
-      address,
-      uint256
-    )
-  {
+  ) internal view returns (IAToken, address, address, uint256) {
     IAToken collateralAToken = IAToken(collateralReserve.aTokenAddress);
     uint256 liquidationBonus = collateralReserve.configuration.getLiquidationBonus();
 
@@ -6828,15 +7191,7 @@ library LiquidationLogic {
     uint256 userCollateralBalance,
     uint256 liquidationBonus,
     IPriceOracleGetter oracle
-  )
-    internal
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256
-    )
-  {
+  ) internal view returns (uint256, uint256, uint256) {
     AvailableCollateralToLiquidateLocalVars memory vars;
 
     vars.collateralPrice = oracle.getAssetPrice(collateralAsset);
@@ -6846,8 +7201,8 @@ library LiquidationLogic {
     vars.debtAssetDecimals = debtReserveCache.reserveConfiguration.getDecimals();
 
     unchecked {
-      vars.collateralAssetUnit = 10**vars.collateralDecimals;
-      vars.debtAssetUnit = 10**vars.debtAssetDecimals;
+      vars.collateralAssetUnit = 10 ** vars.collateralDecimals;
+      vars.debtAssetUnit = 10 ** vars.debtAssetDecimals;
     }
 
     vars.liquidationProtocolFeePercentage = collateralReserve
@@ -6946,7 +7301,10 @@ library BridgeLogic {
 
     uint256 unbacked = reserve.unbacked += amount.toUint128();
 
-    require(unbacked <= unbackedMintCap * (10**reserveDecimals), Errors.UNBACKED_MINT_CAP_EXCEEDED);
+    require(
+      unbacked <= unbackedMintCap * (10 ** reserveDecimals),
+      Errors.UNBACKED_MINT_CAP_EXCEEDED
+    );
 
     reserve.updateInterestRates(reserveCache, asset, 0, 0);
 
@@ -6959,11 +7317,12 @@ library BridgeLogic {
 
     if (isFirstSupply) {
       if (
-        ValidationLogic.validateUseAsCollateral(
+        ValidationLogic.validateAutomaticUseAsCollateral(
           reservesData,
           reservesList,
           userConfig,
-          reserveCache.reserveConfiguration
+          reserveCache.reserveConfiguration,
+          reserveCache.aTokenAddress
         )
       ) {
         userConfig.setUsingAsCollateral(reserve.id, true);
@@ -7050,177 +7409,6 @@ interface IERC20WithPermit is IERC20 {
   ) external;
 }
 
-/**
- * @title IACLManager
- * @author Aave
- * @notice Defines the basic interface for the ACL Manager
- */
-interface IACLManager {
-  /**
-   * @notice Returns the contract address of the PoolAddressesProvider
-   * @return The address of the PoolAddressesProvider
-   */
-  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
-
-  /**
-   * @notice Returns the identifier of the PoolAdmin role
-   * @return The id of the PoolAdmin role
-   */
-  function POOL_ADMIN_ROLE() external view returns (bytes32);
-
-  /**
-   * @notice Returns the identifier of the EmergencyAdmin role
-   * @return The id of the EmergencyAdmin role
-   */
-  function EMERGENCY_ADMIN_ROLE() external view returns (bytes32);
-
-  /**
-   * @notice Returns the identifier of the RiskAdmin role
-   * @return The id of the RiskAdmin role
-   */
-  function RISK_ADMIN_ROLE() external view returns (bytes32);
-
-  /**
-   * @notice Returns the identifier of the FlashBorrower role
-   * @return The id of the FlashBorrower role
-   */
-  function FLASH_BORROWER_ROLE() external view returns (bytes32);
-
-  /**
-   * @notice Returns the identifier of the Bridge role
-   * @return The id of the Bridge role
-   */
-  function BRIDGE_ROLE() external view returns (bytes32);
-
-  /**
-   * @notice Returns the identifier of the AssetListingAdmin role
-   * @return The id of the AssetListingAdmin role
-   */
-  function ASSET_LISTING_ADMIN_ROLE() external view returns (bytes32);
-
-  /**
-   * @notice Set the role as admin of a specific role.
-   * @dev By default the admin role for all roles is `DEFAULT_ADMIN_ROLE`.
-   * @param role The role to be managed by the admin role
-   * @param adminRole The admin role
-   */
-  function setRoleAdmin(bytes32 role, bytes32 adminRole) external;
-
-  /**
-   * @notice Adds a new admin as PoolAdmin
-   * @param admin The address of the new admin
-   */
-  function addPoolAdmin(address admin) external;
-
-  /**
-   * @notice Removes an admin as PoolAdmin
-   * @param admin The address of the admin to remove
-   */
-  function removePoolAdmin(address admin) external;
-
-  /**
-   * @notice Returns true if the address is PoolAdmin, false otherwise
-   * @param admin The address to check
-   * @return True if the given address is PoolAdmin, false otherwise
-   */
-  function isPoolAdmin(address admin) external view returns (bool);
-
-  /**
-   * @notice Adds a new admin as EmergencyAdmin
-   * @param admin The address of the new admin
-   */
-  function addEmergencyAdmin(address admin) external;
-
-  /**
-   * @notice Removes an admin as EmergencyAdmin
-   * @param admin The address of the admin to remove
-   */
-  function removeEmergencyAdmin(address admin) external;
-
-  /**
-   * @notice Returns true if the address is EmergencyAdmin, false otherwise
-   * @param admin The address to check
-   * @return True if the given address is EmergencyAdmin, false otherwise
-   */
-  function isEmergencyAdmin(address admin) external view returns (bool);
-
-  /**
-   * @notice Adds a new admin as RiskAdmin
-   * @param admin The address of the new admin
-   */
-  function addRiskAdmin(address admin) external;
-
-  /**
-   * @notice Removes an admin as RiskAdmin
-   * @param admin The address of the admin to remove
-   */
-  function removeRiskAdmin(address admin) external;
-
-  /**
-   * @notice Returns true if the address is RiskAdmin, false otherwise
-   * @param admin The address to check
-   * @return True if the given address is RiskAdmin, false otherwise
-   */
-  function isRiskAdmin(address admin) external view returns (bool);
-
-  /**
-   * @notice Adds a new address as FlashBorrower
-   * @param borrower The address of the new FlashBorrower
-   */
-  function addFlashBorrower(address borrower) external;
-
-  /**
-   * @notice Removes an address as FlashBorrower
-   * @param borrower The address of the FlashBorrower to remove
-   */
-  function removeFlashBorrower(address borrower) external;
-
-  /**
-   * @notice Returns true if the address is FlashBorrower, false otherwise
-   * @param borrower The address to check
-   * @return True if the given address is FlashBorrower, false otherwise
-   */
-  function isFlashBorrower(address borrower) external view returns (bool);
-
-  /**
-   * @notice Adds a new address as Bridge
-   * @param bridge The address of the new Bridge
-   */
-  function addBridge(address bridge) external;
-
-  /**
-   * @notice Removes an address as Bridge
-   * @param bridge The address of the bridge to remove
-   */
-  function removeBridge(address bridge) external;
-
-  /**
-   * @notice Returns true if the address is Bridge, false otherwise
-   * @param bridge The address to check
-   * @return True if the given address is Bridge, false otherwise
-   */
-  function isBridge(address bridge) external view returns (bool);
-
-  /**
-   * @notice Adds a new admin as AssetListingAdmin
-   * @param admin The address of the new admin
-   */
-  function addAssetListingAdmin(address admin) external;
-
-  /**
-   * @notice Removes an admin as AssetListingAdmin
-   * @param admin The address of the admin to remove
-   */
-  function removeAssetListingAdmin(address admin) external;
-
-  /**
-   * @notice Returns true if the address is AssetListingAdmin, false otherwise
-   * @param admin The address to check
-   * @return True if the given address is AssetListingAdmin, false otherwise
-   */
-  function isAssetListingAdmin(address admin) external view returns (bool);
-}
-
 /**
  * @title PoolStorage
  * @author Aave
@@ -7285,7 +7473,7 @@ contract PoolStorage {
 contract Pool is VersionedInitializable, PoolStorage, IPool {
   using ReserveLogic for DataTypes.ReserveData;
 
-  uint256 public constant POOL_REVISION = 0x1;
+  uint256 public constant POOL_REVISION = 0x2;
   IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
 
   /**
@@ -7586,11 +7774,10 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
   }
 
   /// @inheritdoc IPool
-  function setUserUseReserveAsCollateral(address asset, bool useAsCollateral)
-    public
-    virtual
-    override
-  {
+  function setUserUseReserveAsCollateral(
+    address asset,
+    bool useAsCollateral
+  ) public virtual override {
     SupplyLogic.executeUseReserveAsCollateral(
       _reserves,
       _reservesList,
@@ -7695,18 +7882,16 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
   }
 
   /// @inheritdoc IPool
-  function getReserveData(address asset)
-    external
-    view
-    virtual
-    override
-    returns (DataTypes.ReserveData memory)
-  {
+  function getReserveData(
+    address asset
+  ) external view virtual override returns (DataTypes.ReserveData memory) {
     return _reserves[asset];
   }
 
   /// @inheritdoc IPool
-  function getUserAccountData(address user)
+  function getUserAccountData(
+    address user
+  )
     external
     view
     virtual
@@ -7736,46 +7921,30 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
   }
 
   /// @inheritdoc IPool
-  function getConfiguration(address asset)
-    external
-    view
-    virtual
-    override
-    returns (DataTypes.ReserveConfigurationMap memory)
-  {
+  function getConfiguration(
+    address asset
+  ) external view virtual override returns (DataTypes.ReserveConfigurationMap memory) {
     return _reserves[asset].configuration;
   }
 
   /// @inheritdoc IPool
-  function getUserConfiguration(address user)
-    external
-    view
-    virtual
-    override
-    returns (DataTypes.UserConfigurationMap memory)
-  {
+  function getUserConfiguration(
+    address user
+  ) external view virtual override returns (DataTypes.UserConfigurationMap memory) {
     return _usersConfig[user];
   }
 
   /// @inheritdoc IPool
-  function getReserveNormalizedIncome(address asset)
-    external
-    view
-    virtual
-    override
-    returns (uint256)
-  {
+  function getReserveNormalizedIncome(
+    address asset
+  ) external view virtual override returns (uint256) {
     return _reserves[asset].getNormalizedIncome();
   }
 
   /// @inheritdoc IPool
-  function getReserveNormalizedVariableDebt(address asset)
-    external
-    view
-    virtual
-    override
-    returns (uint256)
-  {
+  function getReserveNormalizedVariableDebt(
+    address asset
+  ) external view virtual override returns (uint256) {
     return _reserves[asset].getNormalizedDebt();
   }
 
@@ -7892,36 +8061,29 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
   }
 
   /// @inheritdoc IPool
-  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
-    external
-    virtual
-    override
-    onlyPoolConfigurator
-  {
+  function setReserveInterestRateStrategyAddress(
+    address asset,
+    address rateStrategyAddress
+  ) external virtual override onlyPoolConfigurator {
     require(asset != address(0), Errors.ZERO_ADDRESS_NOT_VALID);
     require(_reserves[asset].id != 0 || _reservesList[0] == asset, Errors.ASSET_NOT_LISTED);
     _reserves[asset].interestRateStrategyAddress = rateStrategyAddress;
   }
 
   /// @inheritdoc IPool
-  function setConfiguration(address asset, DataTypes.ReserveConfigurationMap calldata configuration)
-    external
-    virtual
-    override
-    onlyPoolConfigurator
-  {
+  function setConfiguration(
+    address asset,
+    DataTypes.ReserveConfigurationMap calldata configuration
+  ) external virtual override onlyPoolConfigurator {
     require(asset != address(0), Errors.ZERO_ADDRESS_NOT_VALID);
     require(_reserves[asset].id != 0 || _reservesList[0] == asset, Errors.ASSET_NOT_LISTED);
     _reserves[asset].configuration = configuration;
   }
 
   /// @inheritdoc IPool
-  function updateBridgeProtocolFee(uint256 protocolFee)
-    external
-    virtual
-    override
-    onlyPoolConfigurator
-  {
+  function updateBridgeProtocolFee(
+    uint256 protocolFee
+  ) external virtual override onlyPoolConfigurator {
     _bridgeProtocolFee = protocolFee;
   }
 
@@ -7935,25 +8097,19 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
   }
 
   /// @inheritdoc IPool
-  function configureEModeCategory(uint8 id, DataTypes.EModeCategory memory category)
-    external
-    virtual
-    override
-    onlyPoolConfigurator
-  {
+  function configureEModeCategory(
+    uint8 id,
+    DataTypes.EModeCategory memory category
+  ) external virtual override onlyPoolConfigurator {
     // category 0 is reserved for volatile heterogeneous assets and it's always disabled
     require(id != 0, Errors.EMODE_CATEGORY_RESERVED);
     _eModeCategories[id] = category;
   }
 
   /// @inheritdoc IPool
-  function getEModeCategoryData(uint8 id)
-    external
-    view
-    virtual
-    override
-    returns (DataTypes.EModeCategory memory)
-  {
+  function getEModeCategoryData(
+    uint8 id
+  ) external view virtual override returns (DataTypes.EModeCategory memory) {
     return _eModeCategories[id];
   }
 
@@ -7979,12 +8135,9 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
   }
 
   /// @inheritdoc IPool
-  function resetIsolationModeTotalDebt(address asset)
-    external
-    virtual
-    override
-    onlyPoolConfigurator
-  {
+  function resetIsolationModeTotalDebt(
+    address asset
+  ) external virtual override onlyPoolConfigurator {
     PoolLogic.executeResetIsolationModeTotalDebt(_reserves, asset);
   }
 
```
