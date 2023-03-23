```diff
diff --git a/src/downloads/polygon/AAVE_PROTOCOL_DATA_PROVIDER.sol b/src/downloads/AAVE_PROTOCOL_DATA_PROVIDER.sol
index d57659b..39734b2 100644
--- a/src/downloads/polygon/AAVE_PROTOCOL_DATA_PROVIDER.sol
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
@@ -140,13 +136,12 @@ library Errors {
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
@@ -154,7 +149,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -183,6 +178,7 @@ library Errors {
   string public constant STABLE_BORROWING_ENABLED = '88'; // 'Stable borrowing is enabled'
   string public constant SILOED_BORROWING_VIOLATION = '89'; // 'User is trying to borrow multiple assets including a siloed one'
   string public constant RESERVE_DEBT_NOT_ZERO = '90'; // the total debt of the reserve needs to be 0
+  string public constant FLASHLOAN_DISABLED = '91'; // FlashLoaning for this asset is disabled
 }
 
 library DataTypes {
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
@@ -468,6 +460,7 @@ library ReserveConfiguration {
   uint256 internal constant PAUSED_MASK =                    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant BORROWABLE_IN_ISOLATION_MASK =   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant SILOED_BORROWING_MASK =          0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant FLASHLOAN_ENABLED_MASK =         0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant RESERVE_FACTOR_MASK =            0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant BORROW_CAP_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant SUPPLY_CAP_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
@@ -487,8 +480,7 @@ library ReserveConfiguration {
   uint256 internal constant IS_PAUSED_START_BIT_POSITION = 60;
   uint256 internal constant BORROWABLE_IN_ISOLATION_START_BIT_POSITION = 61;
   uint256 internal constant SILOED_BORROWING_START_BIT_POSITION = 62;
-  /// @dev bit 63 reserved
-
+  uint256 internal constant FLASHLOAN_ENABLED_START_BIT_POSITION = 63;
   uint256 internal constant RESERVE_FACTOR_START_BIT_POSITION = 64;
   uint256 internal constant BORROW_CAP_START_BIT_POSITION = 80;
   uint256 internal constant SUPPLY_CAP_START_BIT_POSITION = 116;
@@ -516,7 +508,7 @@ library ReserveConfiguration {
    * @notice Sets the Loan to Value of the reserve
    * @param self The reserve configuration
    * @param ltv The new ltv
-   **/
+   */
   function setLtv(DataTypes.ReserveConfigurationMap memory self, uint256 ltv) internal pure {
     require(ltv <= MAX_VALID_LTV, Errors.INVALID_LTV);
 
@@ -527,7 +519,7 @@ library ReserveConfiguration {
    * @notice Gets the Loan to Value of the reserve
    * @param self The reserve configuration
    * @return The loan to value
-   **/
+   */
   function getLtv(DataTypes.ReserveConfigurationMap memory self) internal pure returns (uint256) {
     return self.data & ~LTV_MASK;
   }
@@ -536,11 +528,11 @@ library ReserveConfiguration {
    * @notice Sets the liquidation threshold of the reserve
    * @param self The reserve configuration
    * @param threshold The new liquidation threshold
-   **/
-  function setLiquidationThreshold(DataTypes.ReserveConfigurationMap memory self, uint256 threshold)
-    internal
-    pure
-  {
+   */
+  function setLiquidationThreshold(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 threshold
+  ) internal pure {
     require(threshold <= MAX_VALID_LIQUIDATION_THRESHOLD, Errors.INVALID_LIQ_THRESHOLD);
 
     self.data =
@@ -552,12 +544,10 @@ library ReserveConfiguration {
    * @notice Gets the liquidation threshold of the reserve
    * @param self The reserve configuration
    * @return The liquidation threshold
-   **/
-  function getLiquidationThreshold(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getLiquidationThreshold(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
   }
 
@@ -565,11 +555,11 @@ library ReserveConfiguration {
    * @notice Sets the liquidation bonus of the reserve
    * @param self The reserve configuration
    * @param bonus The new liquidation bonus
-   **/
-  function setLiquidationBonus(DataTypes.ReserveConfigurationMap memory self, uint256 bonus)
-    internal
-    pure
-  {
+   */
+  function setLiquidationBonus(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 bonus
+  ) internal pure {
     require(bonus <= MAX_VALID_LIQUIDATION_BONUS, Errors.INVALID_LIQ_BONUS);
 
     self.data =
@@ -581,12 +571,10 @@ library ReserveConfiguration {
    * @notice Gets the liquidation bonus of the reserve
    * @param self The reserve configuration
    * @return The liquidation bonus
-   **/
-  function getLiquidationBonus(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getLiquidationBonus(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
   }
 
@@ -594,11 +582,11 @@ library ReserveConfiguration {
    * @notice Sets the decimals of the underlying asset of the reserve
    * @param self The reserve configuration
    * @param decimals The decimals
-   **/
-  function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals)
-    internal
-    pure
-  {
+   */
+  function setDecimals(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 decimals
+  ) internal pure {
     require(decimals <= MAX_VALID_DECIMALS, Errors.INVALID_DECIMALS);
 
     self.data = (self.data & DECIMALS_MASK) | (decimals << RESERVE_DECIMALS_START_BIT_POSITION);
@@ -608,12 +596,10 @@ library ReserveConfiguration {
    * @notice Gets the decimals of the underlying asset of the reserve
    * @param self The reserve configuration
    * @return The decimals of the asset
-   **/
-  function getDecimals(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getDecimals(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~DECIMALS_MASK) >> RESERVE_DECIMALS_START_BIT_POSITION;
   }
 
@@ -621,7 +607,7 @@ library ReserveConfiguration {
    * @notice Sets the active state of the reserve
    * @param self The reserve configuration
    * @param active The active state
-   **/
+   */
   function setActive(DataTypes.ReserveConfigurationMap memory self, bool active) internal pure {
     self.data =
       (self.data & ACTIVE_MASK) |
@@ -632,7 +618,7 @@ library ReserveConfiguration {
    * @notice Gets the active state of the reserve
    * @param self The reserve configuration
    * @return The active state
-   **/
+   */
   function getActive(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~ACTIVE_MASK) != 0;
   }
@@ -641,7 +627,7 @@ library ReserveConfiguration {
    * @notice Sets the frozen state of the reserve
    * @param self The reserve configuration
    * @param frozen The frozen state
-   **/
+   */
   function setFrozen(DataTypes.ReserveConfigurationMap memory self, bool frozen) internal pure {
     self.data =
       (self.data & FROZEN_MASK) |
@@ -652,7 +638,7 @@ library ReserveConfiguration {
    * @notice Gets the frozen state of the reserve
    * @param self The reserve configuration
    * @return The frozen state
-   **/
+   */
   function getFrozen(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~FROZEN_MASK) != 0;
   }
@@ -661,7 +647,7 @@ library ReserveConfiguration {
    * @notice Sets the paused state of the reserve
    * @param self The reserve configuration
    * @param paused The paused state
-   **/
+   */
   function setPaused(DataTypes.ReserveConfigurationMap memory self, bool paused) internal pure {
     self.data =
       (self.data & PAUSED_MASK) |
@@ -672,7 +658,7 @@ library ReserveConfiguration {
    * @notice Gets the paused state of the reserve
    * @param self The reserve configuration
    * @return The paused state
-   **/
+   */
   function getPaused(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~PAUSED_MASK) != 0;
   }
@@ -685,11 +671,11 @@ library ReserveConfiguration {
    * consistency in the debt ceiling calculations.
    * @param self The reserve configuration
    * @param borrowable True if the asset is borrowable
-   **/
-  function setBorrowableInIsolation(DataTypes.ReserveConfigurationMap memory self, bool borrowable)
-    internal
-    pure
-  {
+   */
+  function setBorrowableInIsolation(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool borrowable
+  ) internal pure {
     self.data =
       (self.data & BORROWABLE_IN_ISOLATION_MASK) |
       (uint256(borrowable ? 1 : 0) << BORROWABLE_IN_ISOLATION_START_BIT_POSITION);
@@ -703,12 +689,10 @@ library ReserveConfiguration {
    * consistency in the debt ceiling calculations.
    * @param self The reserve configuration
    * @return The borrowable in isolation flag
-   **/
-  function getBorrowableInIsolation(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function getBorrowableInIsolation(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~BORROWABLE_IN_ISOLATION_MASK) != 0;
   }
 
@@ -717,11 +701,11 @@ library ReserveConfiguration {
    * @dev When this flag is set to true, users borrowing this asset will not be allowed to borrow any other asset.
    * @param self The reserve configuration
    * @param siloed True if the asset is siloed
-   **/
-  function setSiloedBorrowing(DataTypes.ReserveConfigurationMap memory self, bool siloed)
-    internal
-    pure
-  {
+   */
+  function setSiloedBorrowing(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool siloed
+  ) internal pure {
     self.data =
       (self.data & SILOED_BORROWING_MASK) |
       (uint256(siloed ? 1 : 0) << SILOED_BORROWING_START_BIT_POSITION);
@@ -732,12 +716,10 @@ library ReserveConfiguration {
    * @dev When this flag is set to true, users borrowing this asset will not be allowed to borrow any other asset.
    * @param self The reserve configuration
    * @return The siloed borrowing flag
-   **/
-  function getSiloedBorrowing(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function getSiloedBorrowing(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~SILOED_BORROWING_MASK) != 0;
   }
 
@@ -745,11 +727,11 @@ library ReserveConfiguration {
    * @notice Enables or disables borrowing on the reserve
    * @param self The reserve configuration
    * @param enabled True if the borrowing needs to be enabled, false otherwise
-   **/
-  function setBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled)
-    internal
-    pure
-  {
+   */
+  function setBorrowingEnabled(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool enabled
+  ) internal pure {
     self.data =
       (self.data & BORROWING_MASK) |
       (uint256(enabled ? 1 : 0) << BORROWING_ENABLED_START_BIT_POSITION);
@@ -759,12 +741,10 @@ library ReserveConfiguration {
    * @notice Gets the borrowing state of the reserve
    * @param self The reserve configuration
    * @return The borrowing state
-   **/
-  function getBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function getBorrowingEnabled(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~BORROWING_MASK) != 0;
   }
 
@@ -772,7 +752,7 @@ library ReserveConfiguration {
    * @notice Enables or disables stable rate borrowing on the reserve
    * @param self The reserve configuration
    * @param enabled True if the stable rate borrowing needs to be enabled, false otherwise
-   **/
+   */
   function setStableRateBorrowingEnabled(
     DataTypes.ReserveConfigurationMap memory self,
     bool enabled
@@ -786,12 +766,10 @@ library ReserveConfiguration {
    * @notice Gets the stable rate borrowing state of the reserve
    * @param self The reserve configuration
    * @return The stable rate borrowing state
-   **/
-  function getStableRateBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function getStableRateBorrowingEnabled(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
     return (self.data & ~STABLE_BORROWING_MASK) != 0;
   }
 
@@ -799,11 +777,11 @@ library ReserveConfiguration {
    * @notice Sets the reserve factor of the reserve
    * @param self The reserve configuration
    * @param reserveFactor The reserve factor
-   **/
-  function setReserveFactor(DataTypes.ReserveConfigurationMap memory self, uint256 reserveFactor)
-    internal
-    pure
-  {
+   */
+  function setReserveFactor(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 reserveFactor
+  ) internal pure {
     require(reserveFactor <= MAX_VALID_RESERVE_FACTOR, Errors.INVALID_RESERVE_FACTOR);
 
     self.data =
@@ -815,12 +793,10 @@ library ReserveConfiguration {
    * @notice Gets the reserve factor of the reserve
    * @param self The reserve configuration
    * @return The reserve factor
-   **/
-  function getReserveFactor(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getReserveFactor(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
   }
 
@@ -828,11 +804,11 @@ library ReserveConfiguration {
    * @notice Sets the borrow cap of the reserve
    * @param self The reserve configuration
    * @param borrowCap The borrow cap
-   **/
-  function setBorrowCap(DataTypes.ReserveConfigurationMap memory self, uint256 borrowCap)
-    internal
-    pure
-  {
+   */
+  function setBorrowCap(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 borrowCap
+  ) internal pure {
     require(borrowCap <= MAX_VALID_BORROW_CAP, Errors.INVALID_BORROW_CAP);
 
     self.data = (self.data & BORROW_CAP_MASK) | (borrowCap << BORROW_CAP_START_BIT_POSITION);
@@ -842,12 +818,10 @@ library ReserveConfiguration {
    * @notice Gets the borrow cap of the reserve
    * @param self The reserve configuration
    * @return The borrow cap
-   **/
-  function getBorrowCap(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getBorrowCap(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~BORROW_CAP_MASK) >> BORROW_CAP_START_BIT_POSITION;
   }
 
@@ -855,11 +829,11 @@ library ReserveConfiguration {
    * @notice Sets the supply cap of the reserve
    * @param self The reserve configuration
    * @param supplyCap The supply cap
-   **/
-  function setSupplyCap(DataTypes.ReserveConfigurationMap memory self, uint256 supplyCap)
-    internal
-    pure
-  {
+   */
+  function setSupplyCap(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 supplyCap
+  ) internal pure {
     require(supplyCap <= MAX_VALID_SUPPLY_CAP, Errors.INVALID_SUPPLY_CAP);
 
     self.data = (self.data & SUPPLY_CAP_MASK) | (supplyCap << SUPPLY_CAP_START_BIT_POSITION);
@@ -869,12 +843,10 @@ library ReserveConfiguration {
    * @notice Gets the supply cap of the reserve
    * @param self The reserve configuration
    * @return The supply cap
-   **/
-  function getSupplyCap(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getSupplyCap(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~SUPPLY_CAP_MASK) >> SUPPLY_CAP_START_BIT_POSITION;
   }
 
@@ -882,11 +854,11 @@ library ReserveConfiguration {
    * @notice Sets the debt ceiling in isolation mode for the asset
    * @param self The reserve configuration
    * @param ceiling The maximum debt ceiling for the asset
-   **/
-  function setDebtCeiling(DataTypes.ReserveConfigurationMap memory self, uint256 ceiling)
-    internal
-    pure
-  {
+   */
+  function setDebtCeiling(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 ceiling
+  ) internal pure {
     require(ceiling <= MAX_VALID_DEBT_CEILING, Errors.INVALID_DEBT_CEILING);
 
     self.data = (self.data & DEBT_CEILING_MASK) | (ceiling << DEBT_CEILING_START_BIT_POSITION);
@@ -896,12 +868,10 @@ library ReserveConfiguration {
    * @notice Gets the debt ceiling for the asset if the asset is in isolation mode
    * @param self The reserve configuration
    * @return The debt ceiling (0 = isolation mode disabled)
-   **/
-  function getDebtCeiling(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getDebtCeiling(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~DEBT_CEILING_MASK) >> DEBT_CEILING_START_BIT_POSITION;
   }
 
@@ -909,7 +879,7 @@ library ReserveConfiguration {
    * @notice Sets the liquidation protocol fee of the reserve
    * @param self The reserve configuration
    * @param liquidationProtocolFee The liquidation protocol fee
-   **/
+   */
   function setLiquidationProtocolFee(
     DataTypes.ReserveConfigurationMap memory self,
     uint256 liquidationProtocolFee
@@ -928,12 +898,10 @@ library ReserveConfiguration {
    * @dev Gets the liquidation protocol fee
    * @param self The reserve configuration
    * @return The liquidation protocol fee
-   **/
-  function getLiquidationProtocolFee(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getLiquidationProtocolFee(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return
       (self.data & ~LIQUIDATION_PROTOCOL_FEE_MASK) >> LIQUIDATION_PROTOCOL_FEE_START_BIT_POSITION;
   }
@@ -942,7 +910,7 @@ library ReserveConfiguration {
    * @notice Sets the unbacked mint cap of the reserve
    * @param self The reserve configuration
    * @param unbackedMintCap The unbacked mint cap
-   **/
+   */
   function setUnbackedMintCap(
     DataTypes.ReserveConfigurationMap memory self,
     uint256 unbackedMintCap
@@ -958,12 +926,10 @@ library ReserveConfiguration {
    * @dev Gets the unbacked mint cap of the reserve
    * @param self The reserve configuration
    * @return The unbacked mint cap
-   **/
-  function getUnbackedMintCap(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getUnbackedMintCap(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~UNBACKED_MINT_CAP_MASK) >> UNBACKED_MINT_CAP_START_BIT_POSITION;
   }
 
@@ -971,11 +937,11 @@ library ReserveConfiguration {
    * @notice Sets the eMode asset category
    * @param self The reserve configuration
    * @param category The asset category when the user selects the eMode
-   **/
-  function setEModeCategory(DataTypes.ReserveConfigurationMap memory self, uint256 category)
-    internal
-    pure
-  {
+   */
+  function setEModeCategory(
+    DataTypes.ReserveConfigurationMap memory self,
+    uint256 category
+  ) internal pure {
     require(category <= MAX_VALID_EMODE_CATEGORY, Errors.INVALID_EMODE_CATEGORY);
 
     self.data = (self.data & EMODE_CATEGORY_MASK) | (category << EMODE_CATEGORY_START_BIT_POSITION);
@@ -985,15 +951,38 @@ library ReserveConfiguration {
    * @dev Gets the eMode asset category
    * @param self The reserve configuration
    * @return The eMode category for the asset
-   **/
-  function getEModeCategory(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256)
-  {
+   */
+  function getEModeCategory(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256) {
     return (self.data & ~EMODE_CATEGORY_MASK) >> EMODE_CATEGORY_START_BIT_POSITION;
   }
 
+  /**
+   * @notice Sets the flashloanable flag for the reserve
+   * @param self The reserve configuration
+   * @param flashLoanEnabled True if the asset is flashloanable, false otherwise
+   */
+  function setFlashLoanEnabled(
+    DataTypes.ReserveConfigurationMap memory self,
+    bool flashLoanEnabled
+  ) internal pure {
+    self.data =
+      (self.data & FLASHLOAN_ENABLED_MASK) |
+      (uint256(flashLoanEnabled ? 1 : 0) << FLASHLOAN_ENABLED_START_BIT_POSITION);
+  }
+
+  /**
+   * @notice Gets the flashloanable flag for the reserve
+   * @param self The reserve configuration
+   * @return The flashloanable flag
+   */
+  function getFlashLoanEnabled(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool) {
+    return (self.data & ~FLASHLOAN_ENABLED_MASK) != 0;
+  }
+
   /**
    * @notice Gets the configuration flags of the reserve
    * @param self The reserve configuration
@@ -1002,18 +991,10 @@ library ReserveConfiguration {
    * @return The state flag representing borrowing enabled
    * @return The state flag representing stableRateBorrowing enabled
    * @return The state flag representing paused
-   **/
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
+   */
+  function getFlags(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (bool, bool, bool, bool, bool) {
     uint256 dataLocal = self.data;
 
     return (
@@ -1034,19 +1015,10 @@ library ReserveConfiguration {
    * @return The state param representing reserve decimals
    * @return The state param representing reserve factor
    * @return The state param representing eMode category
-   **/
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
+   */
+  function getParams(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256, uint256, uint256, uint256, uint256, uint256) {
     uint256 dataLocal = self.data;
 
     return (
@@ -1064,12 +1036,10 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The state param representing borrow cap
    * @return The state param representing supply cap.
-   **/
-  function getCaps(DataTypes.ReserveConfigurationMap memory self)
-    internal
-    pure
-    returns (uint256, uint256)
-  {
+   */
+  function getCaps(
+    DataTypes.ReserveConfigurationMap memory self
+  ) internal pure returns (uint256, uint256) {
     uint256 dataLocal = self.data;
 
     return (
@@ -1097,7 +1067,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @param borrowing True if the user is borrowing the reserve, false otherwise
-   **/
+   */
   function setBorrowing(
     DataTypes.UserConfigurationMap storage self,
     uint256 reserveIndex,
@@ -1119,7 +1089,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @param usingAsCollateral True if the user is using the reserve as collateral, false otherwise
-   **/
+   */
   function setUsingAsCollateral(
     DataTypes.UserConfigurationMap storage self,
     uint256 reserveIndex,
@@ -1141,7 +1111,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve for borrowing or as collateral, false otherwise
-   **/
+   */
   function isUsingAsCollateralOrBorrowing(
     DataTypes.UserConfigurationMap memory self,
     uint256 reserveIndex
@@ -1157,12 +1127,11 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve for borrowing, false otherwise
-   **/
-  function isBorrowing(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function isBorrowing(
+    DataTypes.UserConfigurationMap memory self,
+    uint256 reserveIndex
+  ) internal pure returns (bool) {
     unchecked {
       require(reserveIndex < ReserveConfiguration.MAX_RESERVES_COUNT, Errors.INVALID_RESERVE_INDEX);
       return (self.data >> (reserveIndex << 1)) & 1 != 0;
@@ -1174,12 +1143,11 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve as collateral, false otherwise
-   **/
-  function isUsingAsCollateral(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function isUsingAsCollateral(
+    DataTypes.UserConfigurationMap memory self,
+    uint256 reserveIndex
+  ) internal pure returns (bool) {
     unchecked {
       require(reserveIndex < ReserveConfiguration.MAX_RESERVES_COUNT, Errors.INVALID_RESERVE_INDEX);
       return (self.data >> ((reserveIndex << 1) + 1)) & 1 != 0;
@@ -1191,12 +1159,10 @@ library UserConfiguration {
    * @dev this uses a simple trick - if a number is a power of two (only one bit set) then n & (n - 1) == 0
    * @param self The configuration object
    * @return True if the user has been supplying as collateral one reserve, false otherwise
-   **/
-  function isUsingAsCollateralOne(DataTypes.UserConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function isUsingAsCollateralOne(
+    DataTypes.UserConfigurationMap memory self
+  ) internal pure returns (bool) {
     uint256 collateralData = self.data & COLLATERAL_MASK;
     return collateralData != 0 && (collateralData & (collateralData - 1) == 0);
   }
@@ -1205,12 +1171,10 @@ library UserConfiguration {
    * @notice Checks if a user has been supplying any reserve as collateral
    * @param self The configuration object
    * @return True if the user has been supplying as collateral any reserve, false otherwise
-   **/
-  function isUsingAsCollateralAny(DataTypes.UserConfigurationMap memory self)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function isUsingAsCollateralAny(
+    DataTypes.UserConfigurationMap memory self
+  ) internal pure returns (bool) {
     return self.data & COLLATERAL_MASK != 0;
   }
 
@@ -1219,7 +1183,7 @@ library UserConfiguration {
    * @dev this uses a simple trick - if a number is a power of two (only one bit set) then n & (n - 1) == 0
    * @param self The configuration object
    * @return True if the user has been supplying as collateral one reserve, false otherwise
-   **/
+   */
   function isBorrowingOne(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     uint256 borrowingData = self.data & BORROWING_MASK;
     return borrowingData != 0 && (borrowingData & (borrowingData - 1) == 0);
@@ -1229,7 +1193,7 @@ library UserConfiguration {
    * @notice Checks if a user has been borrowing from any reserve
    * @param self The configuration object
    * @return True if the user has been borrowing any reserve, false otherwise
-   **/
+   */
   function isBorrowingAny(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     return self.data & BORROWING_MASK != 0;
   }
@@ -1238,7 +1202,7 @@ library UserConfiguration {
    * @notice Checks if a user has not been using any reserve for borrowing or supply
    * @param self The configuration object
    * @return True if the user has not been borrowing or supplying any reserve, false otherwise
-   **/
+   */
   function isEmpty(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     return self.data == 0;
   }
@@ -1256,15 +1220,7 @@ library UserConfiguration {
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
 
@@ -1306,11 +1262,10 @@ library UserConfiguration {
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
@@ -1331,7 +1286,7 @@ library UserConfiguration {
  * @dev Provides mul and div function for wads (decimal numbers with 18 digits of precision) and rays (decimal numbers
  * with 27 digits of precision)
  * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
- **/
+ */
 library WadRayMath {
   // HALF_WAD and HALF_RAY expressed with extended notation as constant with operations are not supported in Yul assembly
   uint256 internal constant WAD = 1e18;
@@ -1348,7 +1303,7 @@ library WadRayMath {
    * @param a Wad
    * @param b Wad
    * @return c = a*b, in wad
-   **/
+   */
   function wadMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - HALF_WAD) / b
     assembly {
@@ -1366,7 +1321,7 @@ library WadRayMath {
    * @param a Wad
    * @param b Wad
    * @return c = a/b, in wad
-   **/
+   */
   function wadDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - halfB) / WAD
     assembly {
@@ -1384,7 +1339,7 @@ library WadRayMath {
    * @param a Ray
    * @param b Ray
    * @return c = a raymul b
-   **/
+   */
   function rayMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - HALF_RAY) / b
     assembly {
@@ -1402,7 +1357,7 @@ library WadRayMath {
    * @param a Ray
    * @param b Ray
    * @return c = a raydiv b
-   **/
+   */
   function rayDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - halfB) / RAY
     assembly {
@@ -1419,7 +1374,7 @@ library WadRayMath {
    * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
    * @param a Ray
    * @return b = a converted to wad, rounded half up to the nearest wad
-   **/
+   */
   function rayToWad(uint256 a) internal pure returns (uint256 b) {
     assembly {
       b := div(a, WAD_RAY_RATIO)
@@ -1435,7 +1390,7 @@ library WadRayMath {
    * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
    * @param a Wad
    * @return b = a converted in ray
-   **/
+   */
   function wadToRay(uint256 a) internal pure returns (uint256 b) {
     // to avoid overflow, b/WAD_RAY_RATIO == a
     assembly {
@@ -1452,7 +1407,7 @@ library WadRayMath {
  * @title IPoolAddressesProvider
  * @author Aave
  * @notice Defines the basic interface for a Pool Addresses Provider.
- **/
+ */
 interface IPoolAddressesProvider {
   /**
    * @dev Emitted when the market identifier is updated.
@@ -1547,7 +1502,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Returns the id of the Aave market to which this contract points to.
    * @return The market id
-   **/
+   */
   function getMarketId() external view returns (string memory);
 
   /**
@@ -1589,27 +1544,27 @@ interface IPoolAddressesProvider {
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
@@ -1633,7 +1588,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the ACL manager.
    * @param newAclManager The address of the new ACLManager
-   **/
+   */
   function setACLManager(address newAclManager) external;
 
   /**
@@ -1657,7 +1612,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the price oracle sentinel.
    * @param newPriceOracleSentinel The address of the new PriceOracleSentinel
-   **/
+   */
   function setPriceOracleSentinel(address newPriceOracleSentinel) external;
 
   /**
@@ -1669,7 +1624,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the data provider.
    * @param newDataProvider The address of the new DataProvider
-   **/
+   */
   function setPoolDataProvider(address newDataProvider) external;
 }
 
@@ -1677,181 +1632,24 @@ interface IPoolAddressesProvider {
  * @title IAaveIncentivesController
  * @author Aave
  * @notice Defines the basic interface for an Aave Incentives Controller.
- **/
+ * @dev It only contains one single function, needed as a hook on aToken and debtToken transfers.
+ */
 interface IAaveIncentivesController {
   /**
-   * @dev Emitted during `handleAction`, `claimRewards` and `claimRewardsOnBehalf`
-   * @param user The user that accrued rewards
-   * @param amount The amount of accrued rewards
+   * @dev Called by the corresponding asset on transfer hook in order to update the rewards distribution.
+   * @dev The units of `totalSupply` and `userBalance` should be the same.
+   * @param user The address of the user whose asset balance has changed
+   * @param totalSupply The total supply of the asset prior to user balance change
+   * @param userBalance The previous user balance prior to balance change
    */
-  event RewardsAccrued(address indexed user, uint256 amount);
-
-  event RewardsClaimed(address indexed user, address indexed to, uint256 amount);
-
-  /**
-   * @dev Emitted during `claimRewards` and `claimRewardsOnBehalf`
-   * @param user The address that accrued rewards
-   * @param to The address that will be receiving the rewards
-   * @param claimer The address that performed the claim
-   * @param amount The amount of rewards
-   */
-  event RewardsClaimed(
-    address indexed user,
-    address indexed to,
-    address indexed claimer,
-    uint256 amount
-  );
-
-  /**
-   * @dev Emitted during `setClaimer`
-   * @param user The address of the user
-   * @param claimer The address of the claimer
-   */
-  event ClaimerSet(address indexed user, address indexed claimer);
-
-  /**
-   * @notice Returns the configuration of the distribution for a certain asset
-   * @param asset The address of the reference asset of the distribution
-   * @return The asset index
-   * @return The emission per second
-   * @return The last updated timestamp
-   **/
-  function getAssetData(address asset)
-    external
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256
-    );
-
-  /**
-   * LEGACY **************************
-   * @dev Returns the configuration of the distribution for a certain asset
-   * @param asset The address of the reference asset of the distribution
-   * @return The asset index, the emission per second and the last updated timestamp
-   **/
-  function assets(address asset)
-    external
-    view
-    returns (
-      uint128,
-      uint128,
-      uint256
-    );
-
-  /**
-   * @notice Whitelists an address to claim the rewards on behalf of another address
-   * @param user The address of the user
-   * @param claimer The address of the claimer
-   */
-  function setClaimer(address user, address claimer) external;
-
-  /**
-   * @notice Returns the whitelisted claimer for a certain address (0x0 if not set)
-   * @param user The address of the user
-   * @return The claimer address
-   */
-  function getClaimer(address user) external view returns (address);
-
-  /**
-   * @notice Configure assets for a certain rewards emission
-   * @param assets The assets to incentivize
-   * @param emissionsPerSecond The emission for each asset
-   */
-  function configureAssets(address[] calldata assets, uint256[] calldata emissionsPerSecond)
-    external;
-
-  /**
-   * @notice Called by the corresponding asset on any update that affects the rewards distribution
-   * @param asset The address of the user
-   * @param userBalance The balance of the user of the asset in the pool
-   * @param totalSupply The total supply of the asset in the pool
-   **/
-  function handleAction(
-    address asset,
-    uint256 userBalance,
-    uint256 totalSupply
-  ) external;
-
-  /**
-   * @notice Returns the total of rewards of a user, already accrued + not yet accrued
-   * @param assets The assets to accumulate rewards for
-   * @param user The address of the user
-   * @return The rewards
-   **/
-  function getRewardsBalance(address[] calldata assets, address user)
-    external
-    view
-    returns (uint256);
-
-  /**
-   * @notice Claims reward for a user, on the assets of the pool, accumulating the pending rewards
-   * @param assets The assets to accumulate rewards for
-   * @param amount Amount of rewards to claim
-   * @param to Address that will be receiving the rewards
-   * @return Rewards claimed
-   **/
-  function claimRewards(
-    address[] calldata assets,
-    uint256 amount,
-    address to
-  ) external returns (uint256);
-
-  /**
-   * @notice Claims reward for a user on its behalf, on the assets of the pool, accumulating the pending rewards.
-   * @dev The caller must be whitelisted via "allowClaimOnBehalf" function by the RewardsAdmin role manager
-   * @param assets The assets to accumulate rewards for
-   * @param amount The amount of rewards to claim
-   * @param user The address to check and claim rewards
-   * @param to The address that will be receiving the rewards
-   * @return The amount of rewards claimed
-   **/
-  function claimRewardsOnBehalf(
-    address[] calldata assets,
-    uint256 amount,
-    address user,
-    address to
-  ) external returns (uint256);
-
-  /**
-   * @notice Returns the unclaimed rewards of the user
-   * @param user The address of the user
-   * @return The unclaimed user rewards
-   */
-  function getUserUnclaimedRewards(address user) external view returns (uint256);
-
-  /**
-   * @notice Returns the user index for a specific asset
-   * @param user The address of the user
-   * @param asset The asset to incentivize
-   * @return The user index for the asset
-   */
-  function getUserAssetData(address user, address asset) external view returns (uint256);
-
-  /**
-   * @notice for backward compatibility with previous implementation of the Incentives controller
-   * @return The address of the reward token
-   */
-  function REWARD_TOKEN() external view returns (address);
-
-  /**
-   * @notice for backward compatibility with previous implementation of the Incentives controller
-   * @return The precision used in the incentives controller
-   */
-  function PRECISION() external view returns (uint8);
-
-  /**
-   * @dev Gets the distribution end timestamp of the emissions
-   */
-  function DISTRIBUTION_END() external view returns (uint256);
+  function handleAction(address user, uint256 totalSupply, uint256 userBalance) external;
 }
 
 /**
  * @title IPool
  * @author Aave
  * @notice Defines the basic interface for an Aave Pool.
- **/
+ */
 interface IPool {
   /**
    * @dev Emitted on mintUnbacked()
@@ -1860,7 +1658,7 @@ interface IPool {
    * @param onBehalfOf The beneficiary of the supplied assets, receiving the aTokens
    * @param amount The amount of supplied assets
    * @param referralCode The referral code used
-   **/
+   */
   event MintUnbacked(
     address indexed reserve,
     address user,
@@ -1875,7 +1673,7 @@ interface IPool {
    * @param backer The address paying for the backing
    * @param amount The amount added as backing
    * @param fee The amount paid in fees
-   **/
+   */
   event BackUnbacked(address indexed reserve, address indexed backer, uint256 amount, uint256 fee);
 
   /**
@@ -1885,7 +1683,7 @@ interface IPool {
    * @param onBehalfOf The beneficiary of the supply, receiving the aTokens
    * @param amount The amount supplied
    * @param referralCode The referral code used
-   **/
+   */
   event Supply(
     address indexed reserve,
     address user,
@@ -1900,7 +1698,7 @@ interface IPool {
    * @param user The address initiating the withdrawal, owner of aTokens
    * @param to The address that will receive the underlying
    * @param amount The amount to be withdrawn
-   **/
+   */
   event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);
 
   /**
@@ -1913,7 +1711,7 @@ interface IPool {
    * @param interestRateMode The rate mode: 1 for Stable, 2 for Variable
    * @param borrowRate The numeric rate at which the user has borrowed, expressed in ray
    * @param referralCode The referral code used
-   **/
+   */
   event Borrow(
     address indexed reserve,
     address user,
@@ -1931,7 +1729,7 @@ interface IPool {
    * @param repayer The address of the user initiating the repay(), providing the funds
    * @param amount The amount repaid
    * @param useATokens True if the repayment is done using aTokens, `false` if done with underlying asset directly
-   **/
+   */
   event Repay(
     address indexed reserve,
     address indexed user,
@@ -1945,7 +1743,7 @@ interface IPool {
    * @param reserve The address of the underlying asset of the reserve
    * @param user The address of the user swapping his rate mode
    * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
-   **/
+   */
   event SwapBorrowRateMode(
     address indexed reserve,
     address indexed user,
@@ -1963,28 +1761,28 @@ interface IPool {
    * @dev Emitted when the user selects a certain asset category for eMode
    * @param user The address of the user
    * @param categoryId The category id
-   **/
+   */
   event UserEModeSet(address indexed user, uint8 categoryId);
 
   /**
    * @dev Emitted on setUserUseReserveAsCollateral()
    * @param reserve The address of the underlying asset of the reserve
    * @param user The address of the user enabling the usage as collateral
-   **/
+   */
   event ReserveUsedAsCollateralEnabled(address indexed reserve, address indexed user);
 
   /**
    * @dev Emitted on setUserUseReserveAsCollateral()
    * @param reserve The address of the underlying asset of the reserve
    * @param user The address of the user enabling the usage as collateral
-   **/
+   */
   event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);
 
   /**
    * @dev Emitted on rebalanceStableBorrowRate()
    * @param reserve The address of the underlying asset of the reserve
    * @param user The address of the user for which the rebalance has been executed
-   **/
+   */
   event RebalanceStableBorrowRate(address indexed reserve, address indexed user);
 
   /**
@@ -1996,7 +1794,7 @@ interface IPool {
    * @param interestRateMode The flashloan mode: 0 for regular flashloan, 1 for Stable debt, 2 for Variable debt
    * @param premium The fee flash borrowed
    * @param referralCode The referral code used
-   **/
+   */
   event FlashLoan(
     address indexed target,
     address initiator,
@@ -2017,7 +1815,7 @@ interface IPool {
    * @param liquidator The address of the liquidator
    * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
    * to receive the underlying collateral asset directly
-   **/
+   */
   event LiquidationCall(
     address indexed collateralAsset,
     address indexed debtAsset,
@@ -2036,7 +1834,7 @@ interface IPool {
    * @param variableBorrowRate The next variable borrow rate
    * @param liquidityIndex The next liquidity index
    * @param variableBorrowIndex The next variable borrow index
-   **/
+   */
   event ReserveDataUpdated(
     address indexed reserve,
     uint256 liquidityRate,
@@ -2050,17 +1848,17 @@ interface IPool {
    * @dev Emitted when the protocol treasury receives minted aTokens from the accrued interest.
    * @param reserve The address of the reserve
    * @param amountMinted The amount minted to the treasury
-   **/
+   */
   event MintedToTreasury(address indexed reserve, uint256 amountMinted);
 
   /**
-   * @dev Mints an `amount` of aTokens to the `onBehalfOf`
+   * @notice Mints an `amount` of aTokens to the `onBehalfOf`
    * @param asset The address of the underlying asset to mint
    * @param amount The amount to mint
    * @param onBehalfOf The address that will receive the aTokens
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function mintUnbacked(
     address asset,
     uint256 amount,
@@ -2069,16 +1867,13 @@ interface IPool {
   ) external;
 
   /**
-   * @dev Back the current unbacked underlying with `amount` and pay `fee`.
+   * @notice Back the current unbacked underlying with `amount` and pay `fee`.
    * @param asset The address of the underlying asset to back
    * @param amount The amount to back
    * @param fee The amount paid in fees
-   **/
-  function backUnbacked(
-    address asset,
-    uint256 amount,
-    uint256 fee
-  ) external;
+   * @return The backed amount
+   */
+  function backUnbacked(address asset, uint256 amount, uint256 fee) external returns (uint256);
 
   /**
    * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
@@ -2090,13 +1885,8 @@ interface IPool {
    *   is a different wallet
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
-  function supply(
-    address asset,
-    uint256 amount,
-    address onBehalfOf,
-    uint16 referralCode
-  ) external;
+   */
+  function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
 
   /**
    * @notice Supply with transfer approval of asset to be supplied done via permit function
@@ -2112,7 +1902,7 @@ interface IPool {
    * @param permitV The V parameter of ERC712 permit sig
    * @param permitR The R parameter of ERC712 permit sig
    * @param permitS The S parameter of ERC712 permit sig
-   **/
+   */
   function supplyWithPermit(
     address asset,
     uint256 amount,
@@ -2134,12 +1924,8 @@ interface IPool {
    *   wants to receive it on his own wallet, or a different address if the beneficiary is a
    *   different wallet
    * @return The final amount withdrawn
-   **/
-  function withdraw(
-    address asset,
-    uint256 amount,
-    address to
-  ) external returns (uint256);
+   */
+  function withdraw(address asset, uint256 amount, address to) external returns (uint256);
 
   /**
    * @notice Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
@@ -2155,7 +1941,7 @@ interface IPool {
    * @param onBehalfOf The address of the user who will receive the debt. Should be the address of the borrower itself
    * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
    * if he has been given credit delegation allowance
-   **/
+   */
   function borrow(
     address asset,
     uint256 amount,
@@ -2175,7 +1961,7 @@ interface IPool {
    * user calling the function if he wants to reduce/remove his own debt, or the address of any other
    * other borrower whose debt should be removed
    * @return The final amount repaid
-   **/
+   */
   function repay(
     address asset,
     uint256 amount,
@@ -2198,7 +1984,7 @@ interface IPool {
    * @param permitR The R parameter of ERC712 permit sig
    * @param permitS The S parameter of ERC712 permit sig
    * @return The final amount repaid
-   **/
+   */
   function repayWithPermit(
     address asset,
     uint256 amount,
@@ -2221,7 +2007,7 @@ interface IPool {
    * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
    * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
    * @return The final amount repaid
-   **/
+   */
   function repayWithATokens(
     address asset,
     uint256 amount,
@@ -2232,7 +2018,7 @@ interface IPool {
    * @notice Allows a borrower to swap his debt between stable and variable mode, or vice versa
    * @param asset The address of the underlying asset borrowed
    * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
-   **/
+   */
   function swapBorrowRateMode(address asset, uint256 interestRateMode) external;
 
   /**
@@ -2243,14 +2029,14 @@ interface IPool {
    *        much has been borrowed at a stable rate and suppliers are not earning enough
    * @param asset The address of the underlying asset borrowed
    * @param user The address of the user to be rebalanced
-   **/
+   */
   function rebalanceStableBorrowRate(address asset, address user) external;
 
   /**
    * @notice Allows suppliers to enable/disable a specific supplied asset as collateral
    * @param asset The address of the underlying asset supplied
    * @param useAsCollateral True if the user wants to use the supply as collateral, false otherwise
-   **/
+   */
   function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;
 
   /**
@@ -2263,7 +2049,7 @@ interface IPool {
    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
    * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
    * to receive the underlying collateral asset directly
-   **/
+   */
   function liquidationCall(
     address collateralAsset,
     address debtAsset,
@@ -2276,7 +2062,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -2288,7 +2074,7 @@ interface IPool {
    * @param params Variadic packed params to pass to the receiver as extra information
    * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function flashLoan(
     address receiverAddress,
     address[] calldata assets,
@@ -2303,14 +2089,14 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
    * @param params Variadic packed params to pass to the receiver as extra information
    * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function flashLoanSimple(
     address receiverAddress,
     address asset,
@@ -2328,8 +2114,10 @@ interface IPool {
    * @return currentLiquidationThreshold The liquidation threshold of the user
    * @return ltv The loan to value of The user
    * @return healthFactor The current health factor of the user
-   **/
-  function getUserAccountData(address user)
+   */
+  function getUserAccountData(
+    address user
+  )
     external
     view
     returns (
@@ -2350,7 +2138,7 @@ interface IPool {
    * @param stableDebtAddress The address of the StableDebtToken that will be assigned to the reserve
    * @param variableDebtAddress The address of the VariableDebtToken that will be assigned to the reserve
    * @param interestRateStrategyAddress The address of the interest rate strategy contract
-   **/
+   */
   function initReserve(
     address asset,
     address aTokenAddress,
@@ -2363,7 +2151,7 @@ interface IPool {
    * @notice Drop a reserve
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
-   **/
+   */
   function dropReserve(address asset) external;
 
   /**
@@ -2371,41 +2159,43 @@ interface IPool {
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
    * @param rateStrategyAddress The address of the interest rate strategy contract
-   **/
-  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
-    external;
+   */
+  function setReserveInterestRateStrategyAddress(
+    address asset,
+    address rateStrategyAddress
+  ) external;
 
   /**
    * @notice Sets the configuration bitmap of the reserve as a whole
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
    * @param configuration The new configuration bitmap
-   **/
-  function setConfiguration(address asset, DataTypes.ReserveConfigurationMap calldata configuration)
-    external;
+   */
+  function setConfiguration(
+    address asset,
+    DataTypes.ReserveConfigurationMap calldata configuration
+  ) external;
 
   /**
    * @notice Returns the configuration of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The configuration of the reserve
-   **/
-  function getConfiguration(address asset)
-    external
-    view
-    returns (DataTypes.ReserveConfigurationMap memory);
+   */
+  function getConfiguration(
+    address asset
+  ) external view returns (DataTypes.ReserveConfigurationMap memory);
 
   /**
    * @notice Returns the configuration of the user across all the reserves
    * @param user The user address
    * @return The configuration of the user
-   **/
-  function getUserConfiguration(address user)
-    external
-    view
-    returns (DataTypes.UserConfigurationMap memory);
+   */
+  function getUserConfiguration(
+    address user
+  ) external view returns (DataTypes.UserConfigurationMap memory);
 
   /**
-   * @notice Returns the normalized income normalized income of the reserve
+   * @notice Returns the normalized income of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The reserve's normalized income
    */
@@ -2413,6 +2203,13 @@ interface IPool {
 
   /**
    * @notice Returns the normalized variable debt per unit of asset
+   * @dev WARNING: This function is intended to be used primarily by the protocol itself to get a
+   * "dynamic" variable index based on time, current stored index and virtual rate at the current
+   * moment (approx. a borrower would get if opening a position). This means that is always used in
+   * combination with variable debt supply/balances.
+   * If using this function externally, consider that is possible to have an increasing normalized
+   * variable debt that is not equivalent to how the variable debt index would be updated in storage
+   * (e.g. only updates with non-zero variable debt supply)
    * @param asset The address of the underlying asset of the reserve
    * @return The reserve normalized variable debt
    */
@@ -2422,7 +2219,7 @@ interface IPool {
    * @notice Returns the state and configuration of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The state and configuration data of the reserve
-   **/
+   */
   function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
 
   /**
@@ -2448,20 +2245,20 @@ interface IPool {
    * @notice Returns the list of the underlying assets of all the initialized reserves
    * @dev It does not include dropped reserves
    * @return The addresses of the underlying assets of the initialized reserves
-   **/
+   */
   function getReservesList() external view returns (address[] memory);
 
   /**
    * @notice Returns the address of the underlying asset of a reserve by the reserve id as stored in the DataTypes.ReserveData struct
    * @param id The id of the reserve as stored in the DataTypes.ReserveData struct
    * @return The address of the reserve associated with id
-   **/
+   */
   function getReserveAddressById(uint16 id) external view returns (address);
 
   /**
    * @notice Returns the PoolAddressesProvider connected to this contract
    * @return The address of the PoolAddressesProvider
-   **/
+   */
   function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
 
   /**
@@ -2554,7 +2351,7 @@ interface IPool {
   /**
    * @notice Mints the assets accrued through the reserve factor to the treasury in the form of aTokens
    * @param assets The list of reserves for which the minting needs to be executed
-   **/
+   */
   function mintToTreasury(address[] calldata assets) external;
 
   /**
@@ -2563,11 +2360,7 @@ interface IPool {
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
@@ -2580,20 +2373,15 @@ interface IPool {
    *   is a different wallet
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
-  function deposit(
-    address asset,
-    uint256 amount,
-    address onBehalfOf,
-    uint16 referralCode
-  ) external;
+   */
+  function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
 }
 
 /**
  * @title IInitializableDebtToken
  * @author Aave
  * @notice Interface for the initialize function common between debt tokens
- **/
+ */
 interface IInitializableDebtToken {
   /**
    * @dev Emitted when a debt token is initialized
@@ -2604,7 +2392,7 @@ interface IInitializableDebtToken {
    * @param debtTokenName The name of the debt token
    * @param debtTokenSymbol The symbol of the debt token
    * @param params A set of encoded parameters for additional initialization
-   **/
+   */
   event Initialized(
     address indexed underlyingAsset,
     address indexed pool,
@@ -2641,19 +2429,19 @@ interface IInitializableDebtToken {
  * @author Aave
  * @notice Defines the interface for the stable debt token
  * @dev It does not inherit from IERC20 to save in code size
- **/
+ */
 interface IStableDebtToken is IInitializableDebtToken {
   /**
    * @dev Emitted when new stable debt is minted
    * @param user The address of the user who triggered the minting
    * @param onBehalfOf The recipient of stable debt tokens
    * @param amount The amount minted (user entered amount + balance increase from interest)
-   * @param currentBalance The current balance of the user
-   * @param balanceIncrease The increase in balance since the last action of the user
+   * @param currentBalance The balance of the user based on the previous balance and balance increase from interest
+   * @param balanceIncrease The increase in balance since the last action of the user 'onBehalfOf'
    * @param newRate The rate of the debt after the minting
    * @param avgStableRate The next average stable rate after the minting
    * @param newTotalSupply The next total supply of the stable debt token after the action
-   **/
+   */
   event Mint(
     address indexed user,
     address indexed onBehalfOf,
@@ -2669,11 +2457,11 @@ interface IStableDebtToken is IInitializableDebtToken {
    * @dev Emitted when new stable debt is burned
    * @param from The address from which the debt will be burned
    * @param amount The amount being burned (user entered amount - balance increase from interest)
-   * @param currentBalance The current balance of the user
-   * @param balanceIncrease The the increase in balance since the last action of the user
+   * @param currentBalance The balance of the user based on the previous balance and balance increase from interest
+   * @param balanceIncrease The increase in balance since the last action of 'from'
    * @param avgStableRate The next average stable rate after the burning
    * @param newTotalSupply The next total supply of the stable debt token after the action
-   **/
+   */
   event Burn(
     address indexed from,
     uint256 amount,
@@ -2695,19 +2483,13 @@ interface IStableDebtToken is IInitializableDebtToken {
    * @return True if it is the first borrow, false otherwise
    * @return The total stable debt
    * @return The average stable borrow rate
-   **/
+   */
   function mint(
     address user,
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
@@ -2719,27 +2501,27 @@ interface IStableDebtToken is IInitializableDebtToken {
    * @param amount The amount of debt tokens getting burned
    * @return The total stable debt
    * @return The average stable borrow rate
-   **/
+   */
   function burn(address from, uint256 amount) external returns (uint256, uint256);
 
   /**
    * @notice Returns the average rate of all the stable rate loans.
    * @return The average stable rate
-   **/
+   */
   function getAverageStableRate() external view returns (uint256);
 
   /**
    * @notice Returns the stable rate of the user debt
    * @param user The address of the user
    * @return The stable rate of the user
-   **/
+   */
   function getUserStableRate(address user) external view returns (uint256);
 
   /**
    * @notice Returns the timestamp of the last update of the user
    * @param user The address of the user
    * @return The timestamp
-   **/
+   */
   function getUserLastUpdated(address user) external view returns (uint40);
 
   /**
@@ -2748,57 +2530,49 @@ interface IStableDebtToken is IInitializableDebtToken {
    * @return The total supply
    * @return The average stable rate
    * @return The timestamp of the last update
-   **/
-  function getSupplyData()
-    external
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256,
-      uint40
-    );
+   */
+  function getSupplyData() external view returns (uint256, uint256, uint256, uint40);
 
   /**
    * @notice Returns the timestamp of the last update of the total supply
    * @return The timestamp
-   **/
+   */
   function getTotalSupplyLastUpdated() external view returns (uint40);
 
   /**
    * @notice Returns the total supply and the average stable rate
    * @return The total supply
    * @return The average rate
-   **/
+   */
   function getTotalSupplyAndAvgRate() external view returns (uint256, uint256);
 
   /**
    * @notice Returns the principal debt balance of the user
    * @return The debt balance of the user since the last burn/mint action
-   **/
+   */
   function principalBalanceOf(address user) external view returns (uint256);
 
   /**
    * @notice Returns the address of the underlying asset of this stableDebtToken (E.g. WETH for stableDebtWETH)
    * @return The address of the underlying asset
-   **/
+   */
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
 
 /**
  * @title IScaledBalanceToken
  * @author Aave
- * @notice Defines the basic interface for a scaledbalance token.
- **/
+ * @notice Defines the basic interface for a scaled-balance token.
+ */
 interface IScaledBalanceToken {
   /**
    * @dev Emitted after the mint action
    * @param caller The address performing the mint
-   * @param onBehalfOf The address of the user that will receive the minted scaled balance tokens
-   * @param value The amount being minted (user entered amount + balance increase from interest)
-   * @param balanceIncrease The increase in balance since the last action of the user
+   * @param onBehalfOf The address of the user that will receive the minted tokens
+   * @param value The scaled-up amount being minted (based on user entered amount and balance increase from interest)
+   * @param balanceIncrease The increase in scaled-up balance since the last action of 'onBehalfOf'
    * @param index The next liquidity index of the reserve
-   **/
+   */
   event Mint(
     address indexed caller,
     address indexed onBehalfOf,
@@ -2808,13 +2582,14 @@ interface IScaledBalanceToken {
   );
 
   /**
-   * @dev Emitted after scaled balance tokens are burned
-   * @param from The address from which the scaled tokens will be burned
+   * @dev Emitted after the burn action
+   * @dev If the burn function does not involve a transfer of the underlying asset, the target defaults to zero address
+   * @param from The address from which the tokens will be burned
    * @param target The address that will receive the underlying, if any
-   * @param value The amount being burned (user entered amount - balance increase from interest)
-   * @param balanceIncrease The increase in balance since the last action of the user
+   * @param value The scaled-up amount being burned (user entered amount - balance increase from interest)
+   * @param balanceIncrease The increase in scaled-up balance since the last action of 'from'
    * @param index The next liquidity index of the reserve
-   **/
+   */
   event Burn(
     address indexed from,
     address indexed target,
@@ -2829,7 +2604,7 @@ interface IScaledBalanceToken {
    * at the moment of the update
    * @param user The user whose balance is calculated
    * @return The scaled balance of the user
-   **/
+   */
   function scaledBalanceOf(address user) external view returns (uint256);
 
   /**
@@ -2837,20 +2612,20 @@ interface IScaledBalanceToken {
    * @param user The address of the user
    * @return The scaled balance of the user
    * @return The scaled total supply
-   **/
+   */
   function getScaledUserBalanceAndSupply(address user) external view returns (uint256, uint256);
 
   /**
    * @notice Returns the scaled total supply of the scaled balance token. Represents sum(debt/index)
    * @return The scaled total supply
-   **/
+   */
   function scaledTotalSupply() external view returns (uint256);
 
   /**
    * @notice Returns last index interest was accrued to the user's balance
    * @param user The address of the user
    * @return The last index interest was accrued to the user's balance, expressed in ray
-   **/
+   */
   function getPreviousIndex(address user) external view returns (uint256);
 }
 
@@ -2858,7 +2633,7 @@ interface IScaledBalanceToken {
  * @title IVariableDebtToken
  * @author Aave
  * @notice Defines the basic interface for a variable debt token.
- **/
+ */
 interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
   /**
    * @notice Mints debt token to the `onBehalfOf` address
@@ -2869,7 +2644,7 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
    * @param index The variable debt index of the reserve
    * @return True if the previous balance of the user is 0, false otherwise
    * @return The scaled total debt of the reserve
-   **/
+   */
   function mint(
     address user,
     address onBehalfOf,
@@ -2885,21 +2660,137 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
    * @param amount The amount getting burned
    * @param index The variable debt index of the reserve
    * @return The scaled total debt of the reserve
-   **/
-  function burn(
-    address from,
-    uint256 amount,
-    uint256 index
-  ) external returns (uint256);
+   */
+  function burn(address from, uint256 amount, uint256 index) external returns (uint256);
 
   /**
    * @notice Returns the address of the underlying asset of this debtToken (E.g. WETH for variableDebtWETH)
    * @return The address of the underlying asset
-   **/
+   */
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 }
 
+/**
+ * @title IPoolDataProvider
+ * @author Aave
+ * @notice Defines the basic interface of a PoolDataProvider
+ */
 interface IPoolDataProvider {
+  struct TokenData {
+    string symbol;
+    address tokenAddress;
+  }
+
+  /**
+   * @notice Returns the address for the PoolAddressesProvider contract.
+   * @return The address for the PoolAddressesProvider contract
+   */
+  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);
+
+  /**
+   * @notice Returns the list of the existing reserves in the pool.
+   * @dev Handling MKR and ETH in a different way since they do not have standard `symbol` functions.
+   * @return The list of reserves, pairs of symbols and addresses
+   */
+  function getAllReservesTokens() external view returns (TokenData[] memory);
+
+  /**
+   * @notice Returns the list of the existing ATokens in the pool.
+   * @return The list of ATokens, pairs of symbols and addresses
+   */
+  function getAllATokens() external view returns (TokenData[] memory);
+
+  /**
+   * @notice Returns the configuration data of the reserve
+   * @dev Not returning borrow and supply caps for compatibility, nor pause flag
+   * @param asset The address of the underlying asset of the reserve
+   * @return decimals The number of decimals of the reserve
+   * @return ltv The ltv of the reserve
+   * @return liquidationThreshold The liquidationThreshold of the reserve
+   * @return liquidationBonus The liquidationBonus of the reserve
+   * @return reserveFactor The reserveFactor of the reserve
+   * @return usageAsCollateralEnabled True if the usage as collateral is enabled, false otherwise
+   * @return borrowingEnabled True if borrowing is enabled, false otherwise
+   * @return stableBorrowRateEnabled True if stable rate borrowing is enabled, false otherwise
+   * @return isActive True if it is active, false otherwise
+   * @return isFrozen True if it is frozen, false otherwise
+   */
+  function getReserveConfigurationData(
+    address asset
+  )
+    external
+    view
+    returns (
+      uint256 decimals,
+      uint256 ltv,
+      uint256 liquidationThreshold,
+      uint256 liquidationBonus,
+      uint256 reserveFactor,
+      bool usageAsCollateralEnabled,
+      bool borrowingEnabled,
+      bool stableBorrowRateEnabled,
+      bool isActive,
+      bool isFrozen
+    );
+
+  /**
+   * @notice Returns the efficiency mode category of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return The eMode id of the reserve
+   */
+  function getReserveEModeCategory(address asset) external view returns (uint256);
+
+  /**
+   * @notice Returns the caps parameters of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return borrowCap The borrow cap of the reserve
+   * @return supplyCap The supply cap of the reserve
+   */
+  function getReserveCaps(
+    address asset
+  ) external view returns (uint256 borrowCap, uint256 supplyCap);
+
+  /**
+   * @notice Returns if the pool is paused
+   * @param asset The address of the underlying asset of the reserve
+   * @return isPaused True if the pool is paused, false otherwise
+   */
+  function getPaused(address asset) external view returns (bool isPaused);
+
+  /**
+   * @notice Returns the siloed borrowing flag
+   * @param asset The address of the underlying asset of the reserve
+   * @return True if the asset is siloed for borrowing
+   */
+  function getSiloedBorrowing(address asset) external view returns (bool);
+
+  /**
+   * @notice Returns the protocol fee on the liquidation bonus
+   * @param asset The address of the underlying asset of the reserve
+   * @return The protocol fee on liquidation
+   */
+  function getLiquidationProtocolFee(address asset) external view returns (uint256);
+
+  /**
+   * @notice Returns the unbacked mint cap of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return The unbacked mint cap of the reserve
+   */
+  function getUnbackedMintCap(address asset) external view returns (uint256);
+
+  /**
+   * @notice Returns the debt ceiling of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return The debt ceiling of the reserve
+   */
+  function getDebtCeiling(address asset) external view returns (uint256);
+
+  /**
+   * @notice Returns the debt ceiling decimals
+   * @return The debt ceiling decimals
+   */
+  function getDebtCeilingDecimals() external pure returns (uint256);
+
   /**
    * @notice Returns the reserve data
    * @param asset The address of the underlying asset of the reserve
@@ -2915,8 +2806,10 @@ interface IPoolDataProvider {
    * @return liquidityIndex The liquidity index of the reserve
    * @return variableBorrowIndex The variable borrow index of the reserve
    * @return lastUpdateTimestamp The timestamp of the last update of the reserve
-   **/
-  function getReserveData(address asset)
+   */
+  function getReserveData(
+    address asset
+  )
     external
     view
     returns (
@@ -2938,15 +2831,82 @@ interface IPoolDataProvider {
    * @notice Returns the total supply of aTokens for a given asset
    * @param asset The address of the underlying asset of the reserve
    * @return The total supply of the aToken
-   **/
+   */
   function getATokenTotalSupply(address asset) external view returns (uint256);
 
   /**
    * @notice Returns the total debt for a given asset
    * @param asset The address of the underlying asset of the reserve
    * @return The total debt for asset
-   **/
+   */
   function getTotalDebt(address asset) external view returns (uint256);
+
+  /**
+   * @notice Returns the user data in a reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @param user The address of the user
+   * @return currentATokenBalance The current AToken balance of the user
+   * @return currentStableDebt The current stable debt of the user
+   * @return currentVariableDebt The current variable debt of the user
+   * @return principalStableDebt The principal stable debt of the user
+   * @return scaledVariableDebt The scaled variable debt of the user
+   * @return stableBorrowRate The stable borrow rate of the user
+   * @return liquidityRate The liquidity rate of the reserve
+   * @return stableRateLastUpdated The timestamp of the last update of the user stable rate
+   * @return usageAsCollateralEnabled True if the user is using the asset as collateral, false
+   *         otherwise
+   */
+  function getUserReserveData(
+    address asset,
+    address user
+  )
+    external
+    view
+    returns (
+      uint256 currentATokenBalance,
+      uint256 currentStableDebt,
+      uint256 currentVariableDebt,
+      uint256 principalStableDebt,
+      uint256 scaledVariableDebt,
+      uint256 stableBorrowRate,
+      uint256 liquidityRate,
+      uint40 stableRateLastUpdated,
+      bool usageAsCollateralEnabled
+    );
+
+  /**
+   * @notice Returns the token addresses of the reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @return aTokenAddress The AToken address of the reserve
+   * @return stableDebtTokenAddress The StableDebtToken address of the reserve
+   * @return variableDebtTokenAddress The VariableDebtToken address of the reserve
+   */
+  function getReserveTokensAddresses(
+    address asset
+  )
+    external
+    view
+    returns (
+      address aTokenAddress,
+      address stableDebtTokenAddress,
+      address variableDebtTokenAddress
+    );
+
+  /**
+   * @notice Returns the address of the Interest Rate strategy
+   * @param asset The address of the underlying asset of the reserve
+   * @return irStrategyAddress The address of the Interest Rate strategy
+   */
+  function getInterestRateStrategyAddress(
+    address asset
+  ) external view returns (address irStrategyAddress);
+
+  /**
+   * @notice Returns whether the reserve has FlashLoans enabled or disabled
+   * @param asset The address of the underlying asset of the reserve
+   * @return True if FlashLoans are enabled, false otherwise
+   */
+  function getFlashLoanEnabled(address asset) external view returns (bool);
 }
 
 /**
@@ -2962,23 +2922,19 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
   address constant MKR = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
   address constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
 
-  struct TokenData {
-    string symbol;
-    address tokenAddress;
-  }
-
+  /// @inheritdoc IPoolDataProvider
   IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
 
+  /**
+   * @notice Constructor
+   * @param addressesProvider The address of the PoolAddressesProvider contract
+   */
   constructor(IPoolAddressesProvider addressesProvider) {
     ADDRESSES_PROVIDER = addressesProvider;
   }
 
-  /**
-   * @notice Returns the list of the existing reserves in the pool.
-   * @dev Handling MKR and ETH in a different way since they do not have standard `symbol` functions.
-   * @return The list of reserves, pairs of symbols and addresses
-   */
-  function getAllReservesTokens() external view returns (TokenData[] memory) {
+  /// @inheritdoc IPoolDataProvider
+  function getAllReservesTokens() external view override returns (TokenData[] memory) {
     IPool pool = IPool(ADDRESSES_PROVIDER.getPool());
     address[] memory reserves = pool.getReservesList();
     TokenData[] memory reservesTokens = new TokenData[](reserves.length);
@@ -2999,11 +2955,8 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     return reservesTokens;
   }
 
-  /**
-   * @notice Returns the list of the existing ATokens in the pool.
-   * @return The list of ATokens, pairs of symbols and addresses
-   */
-  function getAllATokens() external view returns (TokenData[] memory) {
+  /// @inheritdoc IPoolDataProvider
+  function getAllATokens() external view override returns (TokenData[] memory) {
     IPool pool = IPool(ADDRESSES_PROVIDER.getPool());
     address[] memory reserves = pool.getReservesList();
     TokenData[] memory aTokens = new TokenData[](reserves.length);
@@ -3017,24 +2970,13 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     return aTokens;
   }
 
-  /**
-   * @notice Returns the configuration data of the reserve
-   * @dev Not returning borrow and supply caps for compatibility, nor pause flag
-   * @param asset The address of the underlying asset of the reserve
-   * @return decimals The number of decimals of the reserve
-   * @return ltv The ltv of the reserve
-   * @return liquidationThreshold The liquidationThreshold of the reserve
-   * @return liquidationBonus The liquidationBonus of the reserve
-   * @return reserveFactor The reserveFactor of the reserve
-   * @return usageAsCollateralEnabled True if the usage as collateral is enabled, false otherwise
-   * @return borrowingEnabled True if borrowing is enabled, false otherwise
-   * @return stableBorrowRateEnabled True if stable rate borrowing is enabled, false otherwise
-   * @return isActive True if it is active, false otherwise
-   * @return isFrozen True if it is frozen, false otherwise
-   **/
-  function getReserveConfigurationData(address asset)
+  /// @inheritdoc IPoolDataProvider
+  function getReserveConfigurationData(
+    address asset
+  )
     external
     view
+    override
     returns (
       uint256 decimals,
       uint256 ltv,
@@ -3059,101 +3001,54 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     usageAsCollateralEnabled = liquidationThreshold != 0;
   }
 
-  /**
-   * Returns the efficiency mode category of the reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @return The eMode id of the reserve
-   */
-  function getReserveEModeCategory(address asset) external view returns (uint256) {
+  /// @inheritdoc IPoolDataProvider
+  function getReserveEModeCategory(address asset) external view override returns (uint256) {
     DataTypes.ReserveConfigurationMap memory configuration = IPool(ADDRESSES_PROVIDER.getPool())
       .getConfiguration(asset);
     return configuration.getEModeCategory();
   }
 
-  /**
-   * @notice Returns the caps parameters of the reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @return borrowCap The borrow cap of the reserve
-   * @return supplyCap The supply cap of the reserve
-   **/
-  function getReserveCaps(address asset)
-    external
-    view
-    returns (uint256 borrowCap, uint256 supplyCap)
-  {
+  /// @inheritdoc IPoolDataProvider
+  function getReserveCaps(
+    address asset
+  ) external view override returns (uint256 borrowCap, uint256 supplyCap) {
     (borrowCap, supplyCap) = IPool(ADDRESSES_PROVIDER.getPool()).getConfiguration(asset).getCaps();
   }
 
-  /**
-   * @notice Returns if the pool is paused
-   * @param asset The address of the underlying asset of the reserve
-   * @return isPaused True if the pool is paused, false otherwise
-   **/
-  function getPaused(address asset) external view returns (bool isPaused) {
+  /// @inheritdoc IPoolDataProvider
+  function getPaused(address asset) external view override returns (bool isPaused) {
     (, , , , isPaused) = IPool(ADDRESSES_PROVIDER.getPool()).getConfiguration(asset).getFlags();
   }
 
-  /**
-   * @notice Returns the siloed borrowing flag
-   * @param asset The address of the underlying asset of the reserve
-   * @return True if the asset is siloed for borrowing
-   **/
-  function getSiloedBorrowing(address asset) external view returns (bool) {
+  /// @inheritdoc IPoolDataProvider
+  function getSiloedBorrowing(address asset) external view override returns (bool) {
     return IPool(ADDRESSES_PROVIDER.getPool()).getConfiguration(asset).getSiloedBorrowing();
   }
 
-  /**
-   * @notice Returns the protocol fee on the liquidation bonus
-   * @param asset The address of the underlying asset of the reserve
-   * @return The protocol fee on liquidation
-   **/
-  function getLiquidationProtocolFee(address asset) external view returns (uint256) {
+  /// @inheritdoc IPoolDataProvider
+  function getLiquidationProtocolFee(address asset) external view override returns (uint256) {
     return IPool(ADDRESSES_PROVIDER.getPool()).getConfiguration(asset).getLiquidationProtocolFee();
   }
 
-  /**
-   * @notice Returns the unbacked mint cap of the reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @return The unbacked mint cap of the reserve
-   **/
-  function getUnbackedMintCap(address asset) external view returns (uint256) {
+  /// @inheritdoc IPoolDataProvider
+  function getUnbackedMintCap(address asset) external view override returns (uint256) {
     return IPool(ADDRESSES_PROVIDER.getPool()).getConfiguration(asset).getUnbackedMintCap();
   }
 
-  /**
-   * @notice Returns the debt ceiling of the reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @return The debt ceiling of the reserve
-   **/
-  function getDebtCeiling(address asset) external view returns (uint256) {
+  /// @inheritdoc IPoolDataProvider
+  function getDebtCeiling(address asset) external view override returns (uint256) {
     return IPool(ADDRESSES_PROVIDER.getPool()).getConfiguration(asset).getDebtCeiling();
   }
 
-  /**
-   * @notice Returns the debt ceiling decimals
-   * @return The debt ceiling decimals
-   **/
-  function getDebtCeilingDecimals() external pure returns (uint256) {
+  /// @inheritdoc IPoolDataProvider
+  function getDebtCeilingDecimals() external pure override returns (uint256) {
     return ReserveConfiguration.DEBT_CEILING_DECIMALS;
   }
 
-  /**
-   * @notice Returns the reserve data
-   * @param asset The address of the underlying asset of the reserve
-   * @return unbacked The amount of unbacked tokens
-   * @return accruedToTreasuryScaled The scaled amount of tokens accrued to treasury that is to be minted
-   * @return totalAToken The total supply of the aToken
-   * @return totalStableDebt The total stable debt of the reserve
-   * @return totalVariableDebt The total variable debt of the reserve
-   * @return liquidityRate The liquidity rate of the reserve
-   * @return variableBorrowRate The variable borrow rate of the reserve
-   * @return stableBorrowRate The stable borrow rate of the reserve
-   * @return averageStableBorrowRate The average stable borrow rate of the reserve
-   * @return liquidityIndex The liquidity index of the reserve
-   * @return variableBorrowIndex The variable borrow index of the reserve
-   * @return lastUpdateTimestamp The timestamp of the last update of the reserve
-   **/
-  function getReserveData(address asset)
+  /// @inheritdoc IPoolDataProvider
+  function getReserveData(
+    address asset
+  )
     external
     view
     override
@@ -3192,11 +3087,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     );
   }
 
-  /**
-   * @notice Returns the total supply of aTokens for a given asset
-   * @param asset The address of the underlying asset of the reserve
-   * @return The total supply of the aToken
-   **/
+  /// @inheritdoc IPoolDataProvider
   function getATokenTotalSupply(address asset) external view override returns (uint256) {
     DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
@@ -3204,11 +3095,7 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     return IERC20Detailed(reserve.aTokenAddress).totalSupply();
   }
 
-  /**
-   * @notice Returns the total debt for a given asset
-   * @param asset The address of the underlying asset of the reserve
-   * @return The total debt for asset
-   **/
+  /// @inheritdoc IPoolDataProvider
   function getTotalDebt(address asset) external view override returns (uint256) {
     DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
@@ -3218,24 +3105,14 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
       IERC20Detailed(reserve.variableDebtTokenAddress).totalSupply();
   }
 
-  /**
-   * @notice Returns the user data in a reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @param user The address of the user
-   * @return currentATokenBalance The current AToken balance of the user
-   * @return currentStableDebt The current stable debt of the user
-   * @return currentVariableDebt The current variable debt of the user
-   * @return principalStableDebt The principal stable debt of the user
-   * @return scaledVariableDebt The scaled variable debt of the user
-   * @return stableBorrowRate The stable borrow rate of the user
-   * @return liquidityRate The liquidity rate of the reserve
-   * @return stableRateLastUpdated The timestamp of the last update of the user stable rate
-   * @return usageAsCollateralEnabled True if the user is using the asset as collateral, false
-   *         otherwise
-   **/
-  function getUserReserveData(address asset, address user)
+  /// @inheritdoc IPoolDataProvider
+  function getUserReserveData(
+    address asset,
+    address user
+  )
     external
     view
+    override
     returns (
       uint256 currentATokenBalance,
       uint256 currentStableDebt,
@@ -3268,16 +3145,13 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     usageAsCollateralEnabled = userConfig.isUsingAsCollateral(reserve.id);
   }
 
-  /**
-   * @notice Returns the token addresses of the reserve
-   * @param asset The address of the underlying asset of the reserve
-   * @return aTokenAddress The AToken address of the reserve
-   * @return stableDebtTokenAddress The StableDebtToken address of the reserve
-   * @return variableDebtTokenAddress The VariableDebtToken address of the reserve
-   */
-  function getReserveTokensAddresses(address asset)
+  /// @inheritdoc IPoolDataProvider
+  function getReserveTokensAddresses(
+    address asset
+  )
     external
     view
+    override
     returns (
       address aTokenAddress,
       address stableDebtTokenAddress,
@@ -3295,20 +3169,22 @@ contract AaveProtocolDataProvider is IPoolDataProvider {
     );
   }
 
-  /**
-   * @notice Returns the address of the Interest Rate strategy
-   * @param asset The address of the underlying asset of the reserve
-   * @return irStrategyAddress The address of the Interest Rate strategy
-   */
-  function getInterestRateStrategyAddress(address asset)
-    external
-    view
-    returns (address irStrategyAddress)
-  {
+  /// @inheritdoc IPoolDataProvider
+  function getInterestRateStrategyAddress(
+    address asset
+  ) external view override returns (address irStrategyAddress) {
     DataTypes.ReserveData memory reserve = IPool(ADDRESSES_PROVIDER.getPool()).getReserveData(
       asset
     );
 
     return (reserve.interestRateStrategyAddress);
   }
+
+  /// @inheritdoc IPoolDataProvider
+  function getFlashLoanEnabled(address asset) external view override returns (bool) {
+    DataTypes.ReserveConfigurationMap memory configuration = IPool(ADDRESSES_PROVIDER.getPool())
+      .getConfiguration(asset);
+
+    return configuration.getFlashLoanEnabled();
+  }
 }
```
