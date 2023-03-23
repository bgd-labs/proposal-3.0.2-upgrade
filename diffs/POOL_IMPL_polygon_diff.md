```diff
diff --git a/src/downloads/polygon/POOL_IMPL.sol b/src/downloads/POOL_IMPL.sol
index 77a2ce7..8fa7602 100644
--- a/src/downloads/polygon/POOL_IMPL.sol
+++ b/src/downloads/POOL_IMPL.sol
@@ -51,13 +51,13 @@ abstract contract VersionedInitializable {
    * @notice Returns the revision number of the contract
    * @dev Needs to be defined in the inherited class as a constant.
    * @return The revision number
-   **/
+   */
   function getRevision() internal pure virtual returns (uint256);
 
   /**
    * @notice Returns true if and only if the function is running in the constructor
    * @return True if the function is running in the constructor
-   **/
+   */
   function isConstructor() private view returns (bool) {
     // extcodesize checks the size of the code stored in an address, and
     // address returns the current address. Since the code is still not
@@ -129,13 +129,12 @@ library Errors {
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
@@ -143,7 +142,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -172,6 +171,7 @@ library Errors {
   string public constant STABLE_BORROWING_ENABLED = '88'; // 'Stable borrowing is enabled'
   string public constant SILOED_BORROWING_VIOLATION = '89'; // 'User is trying to borrow multiple assets including a siloed one'
   string public constant RESERVE_DEBT_NOT_ZERO = '90'; // the total debt of the reserve needs to be 0
+  string public constant FLASHLOAN_DISABLED = '91'; // FlashLoaning for this asset is disabled
 }
 
 library DataTypes {
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
@@ -457,6 +453,7 @@ library ReserveConfiguration {
   uint256 internal constant PAUSED_MASK =                    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant BORROWABLE_IN_ISOLATION_MASK =   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant SILOED_BORROWING_MASK =          0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant FLASHLOAN_ENABLED_MASK =         0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant RESERVE_FACTOR_MASK =            0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant BORROW_CAP_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant SUPPLY_CAP_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
@@ -476,8 +473,7 @@ library ReserveConfiguration {
   uint256 internal constant IS_PAUSED_START_BIT_POSITION = 60;
   uint256 internal constant BORROWABLE_IN_ISOLATION_START_BIT_POSITION = 61;
   uint256 internal constant SILOED_BORROWING_START_BIT_POSITION = 62;
-  /// @dev bit 63 reserved
-
+  uint256 internal constant FLASHLOAN_ENABLED_START_BIT_POSITION = 63;
   uint256 internal constant RESERVE_FACTOR_START_BIT_POSITION = 64;
   uint256 internal constant BORROW_CAP_START_BIT_POSITION = 80;
   uint256 internal constant SUPPLY_CAP_START_BIT_POSITION = 116;
@@ -505,7 +501,7 @@ library ReserveConfiguration {
    * @notice Sets the Loan to Value of the reserve
    * @param self The reserve configuration
    * @param ltv The new ltv
-   **/
+   */
   function setLtv(DataTypes.ReserveConfigurationMap memory self, uint256 ltv) internal pure {
     require(ltv <= MAX_VALID_LTV, Errors.INVALID_LTV);
 
@@ -516,7 +512,7 @@ library ReserveConfiguration {
    * @notice Gets the Loan to Value of the reserve
    * @param self The reserve configuration
    * @return The loan to value
-   **/
+   */
   function getLtv(DataTypes.ReserveConfigurationMap memory self) internal pure returns (uint256) {
     return self.data & ~LTV_MASK;
   }
@@ -525,11 +521,11 @@ library ReserveConfiguration {
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
@@ -541,12 +537,10 @@ library ReserveConfiguration {
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
 
@@ -554,11 +548,11 @@ library ReserveConfiguration {
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
@@ -570,12 +564,10 @@ library ReserveConfiguration {
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
 
@@ -583,11 +575,11 @@ library ReserveConfiguration {
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
@@ -597,12 +589,10 @@ library ReserveConfiguration {
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
 
@@ -610,7 +600,7 @@ library ReserveConfiguration {
    * @notice Sets the active state of the reserve
    * @param self The reserve configuration
    * @param active The active state
-   **/
+   */
   function setActive(DataTypes.ReserveConfigurationMap memory self, bool active) internal pure {
     self.data =
       (self.data & ACTIVE_MASK) |
@@ -621,7 +611,7 @@ library ReserveConfiguration {
    * @notice Gets the active state of the reserve
    * @param self The reserve configuration
    * @return The active state
-   **/
+   */
   function getActive(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~ACTIVE_MASK) != 0;
   }
@@ -630,7 +620,7 @@ library ReserveConfiguration {
    * @notice Sets the frozen state of the reserve
    * @param self The reserve configuration
    * @param frozen The frozen state
-   **/
+   */
   function setFrozen(DataTypes.ReserveConfigurationMap memory self, bool frozen) internal pure {
     self.data =
       (self.data & FROZEN_MASK) |
@@ -641,7 +631,7 @@ library ReserveConfiguration {
    * @notice Gets the frozen state of the reserve
    * @param self The reserve configuration
    * @return The frozen state
-   **/
+   */
   function getFrozen(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~FROZEN_MASK) != 0;
   }
@@ -650,7 +640,7 @@ library ReserveConfiguration {
    * @notice Sets the paused state of the reserve
    * @param self The reserve configuration
    * @param paused The paused state
-   **/
+   */
   function setPaused(DataTypes.ReserveConfigurationMap memory self, bool paused) internal pure {
     self.data =
       (self.data & PAUSED_MASK) |
@@ -661,7 +651,7 @@ library ReserveConfiguration {
    * @notice Gets the paused state of the reserve
    * @param self The reserve configuration
    * @return The paused state
-   **/
+   */
   function getPaused(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~PAUSED_MASK) != 0;
   }
@@ -674,11 +664,11 @@ library ReserveConfiguration {
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
@@ -692,12 +682,10 @@ library ReserveConfiguration {
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
 
@@ -706,11 +694,11 @@ library ReserveConfiguration {
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
@@ -721,12 +709,10 @@ library ReserveConfiguration {
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
 
@@ -734,11 +720,11 @@ library ReserveConfiguration {
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
@@ -748,12 +734,10 @@ library ReserveConfiguration {
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
 
@@ -761,7 +745,7 @@ library ReserveConfiguration {
    * @notice Enables or disables stable rate borrowing on the reserve
    * @param self The reserve configuration
    * @param enabled True if the stable rate borrowing needs to be enabled, false otherwise
-   **/
+   */
   function setStableRateBorrowingEnabled(
     DataTypes.ReserveConfigurationMap memory self,
     bool enabled
@@ -775,12 +759,10 @@ library ReserveConfiguration {
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
 
@@ -788,11 +770,11 @@ library ReserveConfiguration {
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
@@ -804,12 +786,10 @@ library ReserveConfiguration {
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
 
@@ -817,11 +797,11 @@ library ReserveConfiguration {
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
@@ -831,12 +811,10 @@ library ReserveConfiguration {
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
 
@@ -844,11 +822,11 @@ library ReserveConfiguration {
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
@@ -858,12 +836,10 @@ library ReserveConfiguration {
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
 
@@ -871,11 +847,11 @@ library ReserveConfiguration {
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
@@ -885,12 +861,10 @@ library ReserveConfiguration {
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
 
@@ -898,7 +872,7 @@ library ReserveConfiguration {
    * @notice Sets the liquidation protocol fee of the reserve
    * @param self The reserve configuration
    * @param liquidationProtocolFee The liquidation protocol fee
-   **/
+   */
   function setLiquidationProtocolFee(
     DataTypes.ReserveConfigurationMap memory self,
     uint256 liquidationProtocolFee
@@ -917,12 +891,10 @@ library ReserveConfiguration {
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
@@ -931,7 +903,7 @@ library ReserveConfiguration {
    * @notice Sets the unbacked mint cap of the reserve
    * @param self The reserve configuration
    * @param unbackedMintCap The unbacked mint cap
-   **/
+   */
   function setUnbackedMintCap(
     DataTypes.ReserveConfigurationMap memory self,
     uint256 unbackedMintCap
@@ -947,12 +919,10 @@ library ReserveConfiguration {
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
 
@@ -960,11 +930,11 @@ library ReserveConfiguration {
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
@@ -974,15 +944,38 @@ library ReserveConfiguration {
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
@@ -991,18 +984,10 @@ library ReserveConfiguration {
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
@@ -1023,19 +1008,10 @@ library ReserveConfiguration {
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
@@ -1053,12 +1029,10 @@ library ReserveConfiguration {
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
@@ -1125,11 +1099,7 @@ interface IERC20 {
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
@@ -1152,11 +1122,7 @@ interface IERC20 {
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
@@ -1177,12 +1143,7 @@ library GPv2SafeERC20 {
 
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
@@ -1328,17 +1289,17 @@ library Address {
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
@@ -1348,13 +1309,14 @@ interface IScaledBalanceToken {
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
@@ -1369,7 +1331,7 @@ interface IScaledBalanceToken {
    * at the moment of the update
    * @param user The user whose balance is calculated
    * @return The scaled balance of the user
-   **/
+   */
   function scaledBalanceOf(address user) external view returns (uint256);
 
   /**
@@ -1377,20 +1339,20 @@ interface IScaledBalanceToken {
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
 
@@ -1398,181 +1360,24 @@ interface IScaledBalanceToken {
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
  * @title IPoolAddressesProvider
  * @author Aave
  * @notice Defines the basic interface for a Pool Addresses Provider.
- **/
+ */
 interface IPoolAddressesProvider {
   /**
    * @dev Emitted when the market identifier is updated.
@@ -1667,7 +1472,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Returns the id of the Aave market to which this contract points to.
    * @return The market id
-   **/
+   */
   function getMarketId() external view returns (string memory);
 
   /**
@@ -1709,27 +1514,27 @@ interface IPoolAddressesProvider {
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
@@ -1753,7 +1558,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the ACL manager.
    * @param newAclManager The address of the new ACLManager
-   **/
+   */
   function setACLManager(address newAclManager) external;
 
   /**
@@ -1777,7 +1582,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the price oracle sentinel.
    * @param newPriceOracleSentinel The address of the new PriceOracleSentinel
-   **/
+   */
   function setPriceOracleSentinel(address newPriceOracleSentinel) external;
 
   /**
@@ -1789,7 +1594,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the data provider.
    * @param newDataProvider The address of the new DataProvider
-   **/
+   */
   function setPoolDataProvider(address newDataProvider) external;
 }
 
@@ -1797,7 +1602,7 @@ interface IPoolAddressesProvider {
  * @title IPool
  * @author Aave
  * @notice Defines the basic interface for an Aave Pool.
- **/
+ */
 interface IPool {
   /**
    * @dev Emitted on mintUnbacked()
@@ -1806,7 +1611,7 @@ interface IPool {
    * @param onBehalfOf The beneficiary of the supplied assets, receiving the aTokens
    * @param amount The amount of supplied assets
    * @param referralCode The referral code used
-   **/
+   */
   event MintUnbacked(
     address indexed reserve,
     address user,
@@ -1821,7 +1626,7 @@ interface IPool {
    * @param backer The address paying for the backing
    * @param amount The amount added as backing
    * @param fee The amount paid in fees
-   **/
+   */
   event BackUnbacked(address indexed reserve, address indexed backer, uint256 amount, uint256 fee);
 
   /**
@@ -1831,7 +1636,7 @@ interface IPool {
    * @param onBehalfOf The beneficiary of the supply, receiving the aTokens
    * @param amount The amount supplied
    * @param referralCode The referral code used
-   **/
+   */
   event Supply(
     address indexed reserve,
     address user,
@@ -1846,7 +1651,7 @@ interface IPool {
    * @param user The address initiating the withdrawal, owner of aTokens
    * @param to The address that will receive the underlying
    * @param amount The amount to be withdrawn
-   **/
+   */
   event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);
 
   /**
@@ -1859,7 +1664,7 @@ interface IPool {
    * @param interestRateMode The rate mode: 1 for Stable, 2 for Variable
    * @param borrowRate The numeric rate at which the user has borrowed, expressed in ray
    * @param referralCode The referral code used
-   **/
+   */
   event Borrow(
     address indexed reserve,
     address user,
@@ -1877,7 +1682,7 @@ interface IPool {
    * @param repayer The address of the user initiating the repay(), providing the funds
    * @param amount The amount repaid
    * @param useATokens True if the repayment is done using aTokens, `false` if done with underlying asset directly
-   **/
+   */
   event Repay(
     address indexed reserve,
     address indexed user,
@@ -1891,7 +1696,7 @@ interface IPool {
    * @param reserve The address of the underlying asset of the reserve
    * @param user The address of the user swapping his rate mode
    * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
-   **/
+   */
   event SwapBorrowRateMode(
     address indexed reserve,
     address indexed user,
@@ -1909,28 +1714,28 @@ interface IPool {
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
@@ -1942,7 +1747,7 @@ interface IPool {
    * @param interestRateMode The flashloan mode: 0 for regular flashloan, 1 for Stable debt, 2 for Variable debt
    * @param premium The fee flash borrowed
    * @param referralCode The referral code used
-   **/
+   */
   event FlashLoan(
     address indexed target,
     address initiator,
@@ -1963,7 +1768,7 @@ interface IPool {
    * @param liquidator The address of the liquidator
    * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
    * to receive the underlying collateral asset directly
-   **/
+   */
   event LiquidationCall(
     address indexed collateralAsset,
     address indexed debtAsset,
@@ -1982,7 +1787,7 @@ interface IPool {
    * @param variableBorrowRate The next variable borrow rate
    * @param liquidityIndex The next liquidity index
    * @param variableBorrowIndex The next variable borrow index
-   **/
+   */
   event ReserveDataUpdated(
     address indexed reserve,
     uint256 liquidityRate,
@@ -1996,17 +1801,17 @@ interface IPool {
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
@@ -2015,16 +1820,13 @@ interface IPool {
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
@@ -2036,13 +1838,8 @@ interface IPool {
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
@@ -2058,7 +1855,7 @@ interface IPool {
    * @param permitV The V parameter of ERC712 permit sig
    * @param permitR The R parameter of ERC712 permit sig
    * @param permitS The S parameter of ERC712 permit sig
-   **/
+   */
   function supplyWithPermit(
     address asset,
     uint256 amount,
@@ -2080,12 +1877,8 @@ interface IPool {
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
@@ -2101,7 +1894,7 @@ interface IPool {
    * @param onBehalfOf The address of the user who will receive the debt. Should be the address of the borrower itself
    * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
    * if he has been given credit delegation allowance
-   **/
+   */
   function borrow(
     address asset,
     uint256 amount,
@@ -2121,7 +1914,7 @@ interface IPool {
    * user calling the function if he wants to reduce/remove his own debt, or the address of any other
    * other borrower whose debt should be removed
    * @return The final amount repaid
-   **/
+   */
   function repay(
     address asset,
     uint256 amount,
@@ -2144,7 +1937,7 @@ interface IPool {
    * @param permitR The R parameter of ERC712 permit sig
    * @param permitS The S parameter of ERC712 permit sig
    * @return The final amount repaid
-   **/
+   */
   function repayWithPermit(
     address asset,
     uint256 amount,
@@ -2167,7 +1960,7 @@ interface IPool {
    * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
    * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
    * @return The final amount repaid
-   **/
+   */
   function repayWithATokens(
     address asset,
     uint256 amount,
@@ -2178,7 +1971,7 @@ interface IPool {
    * @notice Allows a borrower to swap his debt between stable and variable mode, or vice versa
    * @param asset The address of the underlying asset borrowed
    * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
-   **/
+   */
   function swapBorrowRateMode(address asset, uint256 interestRateMode) external;
 
   /**
@@ -2189,14 +1982,14 @@ interface IPool {
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
@@ -2209,7 +2002,7 @@ interface IPool {
    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
    * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
    * to receive the underlying collateral asset directly
-   **/
+   */
   function liquidationCall(
     address collateralAsset,
     address debtAsset,
@@ -2222,7 +2015,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -2234,7 +2027,7 @@ interface IPool {
    * @param params Variadic packed params to pass to the receiver as extra information
    * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function flashLoan(
     address receiverAddress,
     address[] calldata assets,
@@ -2249,14 +2042,14 @@ interface IPool {
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
@@ -2274,8 +2067,10 @@ interface IPool {
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
@@ -2296,7 +2091,7 @@ interface IPool {
    * @param stableDebtAddress The address of the StableDebtToken that will be assigned to the reserve
    * @param variableDebtAddress The address of the VariableDebtToken that will be assigned to the reserve
    * @param interestRateStrategyAddress The address of the interest rate strategy contract
-   **/
+   */
   function initReserve(
     address asset,
     address aTokenAddress,
@@ -2309,7 +2104,7 @@ interface IPool {
    * @notice Drop a reserve
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
-   **/
+   */
   function dropReserve(address asset) external;
 
   /**
@@ -2317,41 +2112,43 @@ interface IPool {
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
@@ -2359,6 +2156,13 @@ interface IPool {
 
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
@@ -2368,7 +2172,7 @@ interface IPool {
    * @notice Returns the state and configuration of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The state and configuration data of the reserve
-   **/
+   */
   function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
 
   /**
@@ -2394,20 +2198,20 @@ interface IPool {
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
@@ -2500,7 +2304,7 @@ interface IPool {
   /**
    * @notice Mints the assets accrued through the reserve factor to the treasury in the form of aTokens
    * @param assets The list of reserves for which the minting needs to be executed
-   **/
+   */
   function mintToTreasury(address[] calldata assets) external;
 
   /**
@@ -2509,11 +2313,7 @@ interface IPool {
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
@@ -2526,20 +2326,15 @@ interface IPool {
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
  * @title IInitializableAToken
  * @author Aave
  * @notice Interface for the initialize function on AToken
- **/
+ */
 interface IInitializableAToken {
   /**
    * @dev Emitted when an aToken is initialized
@@ -2551,7 +2346,7 @@ interface IInitializableAToken {
    * @param aTokenName The name of the aToken
    * @param aTokenSymbol The symbol of the aToken
    * @param params A set of encoded parameters for additional initialization
-   **/
+   */
   event Initialized(
     address indexed underlyingAsset,
     address indexed pool,
@@ -2590,15 +2385,15 @@ interface IInitializableAToken {
  * @title IAToken
  * @author Aave
  * @notice Defines the basic interface for an AToken.
- **/
+ */
 interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
   /**
    * @dev Emitted during the transfer action
    * @param from The user whose tokens are being transferred
    * @param to The recipient
-   * @param value The amount being transferred
+   * @param value The scaled amount being transferred
    * @param index The next liquidity index of the reserve
-   **/
+   */
   event BalanceTransfer(address indexed from, address indexed to, uint256 value, uint256 index);
 
   /**
@@ -2624,13 +2419,8 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param receiverOfUnderlying The address that will receive the underlying
    * @param amount The amount being burned
    * @param index The next liquidity index of the reserve
-   **/
-  function burn(
-    address from,
-    address receiverOfUnderlying,
-    uint256 amount,
-    uint256 index
-  ) external;
+   */
+  function burn(address from, address receiverOfUnderlying, uint256 amount, uint256 index) external;
 
   /**
    * @notice Mints aTokens to the reserve treasury
@@ -2644,20 +2434,16 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param from The address getting liquidated, current owner of the aTokens
    * @param to The recipient
    * @param value The amount of tokens getting transferred
-   **/
-  function transferOnLiquidation(
-    address from,
-    address to,
-    uint256 value
-  ) external;
+   */
+  function transferOnLiquidation(address from, address to, uint256 value) external;
 
   /**
    * @notice Transfers the underlying asset to `target`.
    * @dev Used by the Pool to transfer assets in borrow(), withdraw() and flashLoan()
-   * @param user The recipient of the underlying
+   * @param target The recipient of the underlying
    * @param amount The amount getting transferred
-   **/
-  function transferUnderlyingTo(address user, uint256 amount) external;
+   */
+  function transferUnderlyingTo(address target, uint256 amount) external;
 
   /**
    * @notice Handles the underlying received by the aToken after the transfer has been completed.
@@ -2665,9 +2451,10 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * transfer is concluded. However in the future there may be aTokens that allow for example to stake the underlying
    * to receive LM rewards. In that case, `handleRepayment()` would perform the staking of the underlying asset.
    * @param user The user executing the repayment
+   * @param onBehalfOf The address of the user who will get his debt reduced/removed
    * @param amount The amount getting repaid
-   **/
-  function handleRepayment(address user, uint256 amount) external;
+   */
+  function handleRepayment(address user, address onBehalfOf, uint256 amount) external;
 
   /**
    * @notice Allow passing a signed message to approve spending
@@ -2694,13 +2481,13 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
   /**
    * @notice Returns the address of the underlying asset of this aToken (E.g. WETH for aWETH)
    * @return The address of the underlying asset
-   **/
+   */
   function UNDERLYING_ASSET_ADDRESS() external view returns (address);
 
   /**
    * @notice Returns the address of the Aave treasury, receiving the fees on this aToken.
    * @return Address of the Aave treasury
-   **/
+   */
   function RESERVE_TREASURY_ADDRESS() external view returns (address);
 
   /**
@@ -2714,7 +2501,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @notice Returns the nonce for owner.
    * @param owner The address of the owner
    * @return The nonce of the owner
-   **/
+   */
   function nonces(address owner) external view returns (uint256);
 
   /**
@@ -2723,11 +2510,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -2737,7 +2520,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
  * @dev Provides mul and div function for wads (decimal numbers with 18 digits of precision) and rays (decimal numbers
  * with 27 digits of precision)
  * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
- **/
+ */
 library WadRayMath {
   // HALF_WAD and HALF_RAY expressed with extended notation as constant with operations are not supported in Yul assembly
   uint256 internal constant WAD = 1e18;
@@ -2754,7 +2537,7 @@ library WadRayMath {
    * @param a Wad
    * @param b Wad
    * @return c = a*b, in wad
-   **/
+   */
   function wadMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - HALF_WAD) / b
     assembly {
@@ -2772,7 +2555,7 @@ library WadRayMath {
    * @param a Wad
    * @param b Wad
    * @return c = a/b, in wad
-   **/
+   */
   function wadDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - halfB) / WAD
     assembly {
@@ -2790,7 +2573,7 @@ library WadRayMath {
    * @param a Ray
    * @param b Ray
    * @return c = a raymul b
-   **/
+   */
   function rayMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - HALF_RAY) / b
     assembly {
@@ -2808,7 +2591,7 @@ library WadRayMath {
    * @param a Ray
    * @param b Ray
    * @return c = a raydiv b
-   **/
+   */
   function rayDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - halfB) / RAY
     assembly {
@@ -2825,7 +2608,7 @@ library WadRayMath {
    * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
    * @param a Ray
    * @return b = a converted to wad, rounded half up to the nearest wad
-   **/
+   */
   function rayToWad(uint256 a) internal pure returns (uint256 b) {
     assembly {
       b := div(a, WAD_RAY_RATIO)
@@ -2841,7 +2624,7 @@ library WadRayMath {
    * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
    * @param a Wad
    * @return b = a converted in ray
-   **/
+   */
   function wadToRay(uint256 a) internal pure returns (uint256 b) {
     // to avoid overflow, b/WAD_RAY_RATIO == a
     assembly {
@@ -2858,7 +2641,7 @@ library WadRayMath {
  * @title IInitializableDebtToken
  * @author Aave
  * @notice Interface for the initialize function common between debt tokens
- **/
+ */
 interface IInitializableDebtToken {
   /**
    * @dev Emitted when a debt token is initialized
@@ -2869,7 +2652,7 @@ interface IInitializableDebtToken {
    * @param debtTokenName The name of the debt token
    * @param debtTokenSymbol The symbol of the debt token
    * @param params A set of encoded parameters for additional initialization
-   **/
+   */
   event Initialized(
     address indexed underlyingAsset,
     address indexed pool,
@@ -2906,19 +2689,19 @@ interface IInitializableDebtToken {
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
@@ -2934,11 +2717,11 @@ interface IStableDebtToken is IInitializableDebtToken {
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
@@ -2960,19 +2743,13 @@ interface IStableDebtToken is IInitializableDebtToken {
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
@@ -2984,27 +2761,27 @@ interface IStableDebtToken is IInitializableDebtToken {
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
@@ -3013,40 +2790,32 @@ interface IStableDebtToken is IInitializableDebtToken {
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
 
@@ -3054,7 +2823,7 @@ interface IStableDebtToken is IInitializableDebtToken {
  * @title IVariableDebtToken
  * @author Aave
  * @notice Defines the basic interface for a variable debt token.
- **/
+ */
 interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
   /**
    * @notice Mints debt token to the `onBehalfOf` address
@@ -3065,7 +2834,7 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
    * @param index The variable debt index of the reserve
    * @return True if the previous balance of the user is 0, false otherwise
    * @return The scaled total debt of the reserve
-   **/
+   */
   function mint(
     address user,
     address onBehalfOf,
@@ -3081,17 +2850,13 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
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
 
@@ -3101,33 +2866,16 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
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
-  function calculateInterestRates(DataTypes.CalculateInterestRatesParams memory params)
-    external
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256
-    );
+   */
+  function calculateInterestRates(
+    DataTypes.CalculateInterestRatesParams memory params
+  ) external view returns (uint256, uint256, uint256);
 }
 
 /**
@@ -3146,12 +2894,11 @@ library MathUtils {
    * @param rate The interest rate, in ray
    * @param lastUpdateTimestamp The timestamp of the last update of the interest
    * @return The interest rate linearly accumulated during the timeDelta, in ray
-   **/
-  function calculateLinearInterest(uint256 rate, uint40 lastUpdateTimestamp)
-    internal
-    view
-    returns (uint256)
-  {
+   */
+  function calculateLinearInterest(
+    uint256 rate,
+    uint40 lastUpdateTimestamp
+  ) internal view returns (uint256) {
     //solium-disable-next-line
     uint256 result = rate * (block.timestamp - uint256(lastUpdateTimestamp));
     unchecked {
@@ -3174,7 +2921,7 @@ library MathUtils {
    * @param rate The interest rate, in ray
    * @param lastUpdateTimestamp The timestamp of the last update of the interest
    * @return The interest rate compounded during the timeDelta, in ray
-   **/
+   */
   function calculateCompoundedInterest(
     uint256 rate,
     uint40 lastUpdateTimestamp,
@@ -3217,12 +2964,11 @@ library MathUtils {
    * @param rate The interest rate (in ray)
    * @param lastUpdateTimestamp The timestamp from which the interest accumulation needs to be calculated
    * @return The interest rate compounded between lastUpdateTimestamp and current block timestamp, in ray
-   **/
-  function calculateCompoundedInterest(uint256 rate, uint40 lastUpdateTimestamp)
-    internal
-    view
-    returns (uint256)
-  {
+   */
+  function calculateCompoundedInterest(
+    uint256 rate,
+    uint40 lastUpdateTimestamp
+  ) internal view returns (uint256) {
     return calculateCompoundedInterest(rate, lastUpdateTimestamp, block.timestamp);
   }
 }
@@ -3233,7 +2979,7 @@ library MathUtils {
  * @notice Provides functions to perform percentage calculations
  * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
  * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
- **/
+ */
 library PercentageMath {
   // Maximum percentage factor (100.00%)
   uint256 internal constant PERCENTAGE_FACTOR = 1e4;
@@ -3247,7 +2993,7 @@ library PercentageMath {
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return result value percentmul percentage
-   **/
+   */
   function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
     // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
     assembly {
@@ -3270,7 +3016,7 @@ library PercentageMath {
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return result value percentdiv percentage
-   **/
+   */
   function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
     // to avoid overflow, value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR
     assembly {
@@ -3569,12 +3315,10 @@ library ReserveLogic {
    * @dev A value of 2*1e27 means for each unit of asset one unit of income has been accrued
    * @param reserve The reserve object
    * @return The normalized income, expressed in ray
-   **/
-  function getNormalizedIncome(DataTypes.ReserveData storage reserve)
-    internal
-    view
-    returns (uint256)
-  {
+   */
+  function getNormalizedIncome(
+    DataTypes.ReserveData storage reserve
+  ) internal view returns (uint256) {
     uint40 timestamp = reserve.lastUpdateTimestamp;
 
     //solium-disable-next-line
@@ -3595,12 +3339,10 @@ library ReserveLogic {
    * @dev A value of 2*1e27 means that for each unit of debt, one unit worth of interest has been accumulated
    * @param reserve The reserve object
    * @return The normalized variable debt, expressed in ray
-   **/
-  function getNormalizedDebt(DataTypes.ReserveData storage reserve)
-    internal
-    view
-    returns (uint256)
-  {
+   */
+  function getNormalizedDebt(
+    DataTypes.ReserveData storage reserve
+  ) internal view returns (uint256) {
     uint40 timestamp = reserve.lastUpdateTimestamp;
 
     //solium-disable-next-line
@@ -3619,13 +3361,22 @@ library ReserveLogic {
    * @notice Updates the liquidity cumulative index and the variable borrow index.
    * @param reserve The reserve object
    * @param reserveCache The caching layer for the reserve data
-   **/
+   */
   function updateState(
     DataTypes.ReserveData storage reserve,
     DataTypes.ReserveCache memory reserveCache
   ) internal {
+    // If time didn't pass since last stored timestamp, skip state update
+    //solium-disable-next-line
+    if (reserve.lastUpdateTimestamp == uint40(block.timestamp)) {
+      return;
+    }
+
     _updateIndexes(reserve, reserveCache);
     _accrueToTreasury(reserve, reserveCache);
+
+    //solium-disable-next-line
+    reserve.lastUpdateTimestamp = uint40(block.timestamp);
   }
 
   /**
@@ -3635,7 +3386,7 @@ library ReserveLogic {
    * @param totalLiquidity The total liquidity available in the reserve
    * @param amount The amount to accumulate
    * @return The next liquidity index of the reserve
-   **/
+   */
   function cumulateToLiquidityIndex(
     DataTypes.ReserveData storage reserve,
     uint256 totalLiquidity,
@@ -3657,7 +3408,7 @@ library ReserveLogic {
    * @param stableDebtTokenAddress The address of the overlying stable debt token contract
    * @param variableDebtTokenAddress The address of the overlying variable debt token contract
    * @param interestRateStrategyAddress The address of the interest rate strategy contract
-   **/
+   */
   function init(
     DataTypes.ReserveData storage reserve,
     address aTokenAddress,
@@ -3689,7 +3440,7 @@ library ReserveLogic {
    * @param reserveAddress The address of the reserve to be updated
    * @param liquidityAdded The amount of liquidity added to the protocol (supply or repay) in the previous action
    * @param liquidityTaken The amount of liquidity taken from the protocol (redeem or borrow)
-   **/
+   */
   function updateInterestRates(
     DataTypes.ReserveData storage reserve,
     DataTypes.ReserveCache memory reserveCache,
@@ -3709,9 +3460,7 @@ library ReserveLogic {
       vars.nextVariableRate
     ) = IReserveInterestRateStrategy(reserve.interestRateStrategyAddress).calculateInterestRates(
       DataTypes.CalculateInterestRatesParams({
-        unbacked: reserveCache.reserveConfiguration.getUnbackedMintCap() != 0
-          ? reserve.unbacked
-          : 0,
+        unbacked: reserve.unbacked,
         liquidityAdded: liquidityAdded,
         liquidityTaken: liquidityTaken,
         totalStableDebt: reserveCache.nextTotalStableDebt,
@@ -3751,7 +3500,7 @@ library ReserveLogic {
    * specific asset.
    * @param reserve The reserve to be updated
    * @param reserveCache The caching layer for the reserve data
-   **/
+   */
   function _accrueToTreasury(
     DataTypes.ReserveData storage reserve,
     DataTypes.ReserveCache memory reserveCache
@@ -3804,15 +3553,14 @@ library ReserveLogic {
    * @notice Updates the reserve indexes and the timestamp of the update.
    * @param reserve The reserve reserve to be updated
    * @param reserveCache The cache layer holding the cached protocol data
-   **/
+   */
   function _updateIndexes(
     DataTypes.ReserveData storage reserve,
     DataTypes.ReserveCache memory reserveCache
   ) internal {
-    reserveCache.nextLiquidityIndex = reserveCache.currLiquidityIndex;
-    reserveCache.nextVariableBorrowIndex = reserveCache.currVariableBorrowIndex;
-
-    //only cumulating if there is any income being produced
+    // Only cumulating on the supply side if there is any income being produced
+    // The case of Reserve Factor 100% is not a problem (currentLiquidityRate == 0),
+    // as liquidity index should not be updated
     if (reserveCache.currLiquidityRate != 0) {
       uint256 cumulatedLiquidityInterest = MathUtils.calculateLinearInterest(
         reserveCache.currLiquidityRate,
@@ -3822,23 +3570,22 @@ library ReserveLogic {
         reserveCache.currLiquidityIndex
       );
       reserve.liquidityIndex = reserveCache.nextLiquidityIndex.toUint128();
-
-      //as the liquidity rate might come only from stable rate loans, we need to ensure
-      //that there is actual variable debt before accumulating
-      if (reserveCache.currScaledVariableDebt != 0) {
-        uint256 cumulatedVariableBorrowInterest = MathUtils.calculateCompoundedInterest(
-          reserveCache.currVariableBorrowRate,
-          reserveCache.reserveLastUpdateTimestamp
-        );
-        reserveCache.nextVariableBorrowIndex = cumulatedVariableBorrowInterest.rayMul(
-          reserveCache.currVariableBorrowIndex
-        );
-        reserve.variableBorrowIndex = reserveCache.nextVariableBorrowIndex.toUint128();
-      }
     }
 
-    //solium-disable-next-line
-    reserve.lastUpdateTimestamp = uint40(block.timestamp);
+    // Variable borrow index only gets updated if there is any variable debt.
+    // reserveCache.currVariableBorrowRate != 0 is not a correct validation,
+    // because a positive base variable rate can be stored on
+    // reserveCache.currVariableBorrowRate, but the index should not increase
+    if (reserveCache.currScaledVariableDebt != 0) {
+      uint256 cumulatedVariableBorrowInterest = MathUtils.calculateCompoundedInterest(
+        reserveCache.currVariableBorrowRate,
+        reserveCache.reserveLastUpdateTimestamp
+      );
+      reserveCache.nextVariableBorrowIndex = cumulatedVariableBorrowInterest.rayMul(
+        reserveCache.currVariableBorrowIndex
+      );
+      reserve.variableBorrowIndex = reserveCache.nextVariableBorrowIndex.toUint128();
+    }
   }
 
   /**
@@ -3847,17 +3594,16 @@ library ReserveLogic {
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
     reserveCache.reserveFactor = reserveCache.reserveConfiguration.getReserveFactor();
-    reserveCache.currLiquidityIndex = reserve.liquidityIndex;
-    reserveCache.currVariableBorrowIndex = reserve.variableBorrowIndex;
+    reserveCache.currLiquidityIndex = reserveCache.nextLiquidityIndex = reserve.liquidityIndex;
+    reserveCache.currVariableBorrowIndex = reserveCache.nextVariableBorrowIndex = reserve
+      .variableBorrowIndex;
     reserveCache.currLiquidityRate = reserve.currentLiquidityRate;
     reserveCache.currVariableBorrowRate = reserve.currentVariableBorrowRate;
 
@@ -3891,27 +3637,27 @@ library ReserveLogic {
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
 
@@ -3978,6 +3724,94 @@ interface IPriceOracleSentinel {
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
@@ -3996,7 +3830,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @param borrowing True if the user is borrowing the reserve, false otherwise
-   **/
+   */
   function setBorrowing(
     DataTypes.UserConfigurationMap storage self,
     uint256 reserveIndex,
@@ -4018,7 +3852,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @param usingAsCollateral True if the user is using the reserve as collateral, false otherwise
-   **/
+   */
   function setUsingAsCollateral(
     DataTypes.UserConfigurationMap storage self,
     uint256 reserveIndex,
@@ -4040,7 +3874,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve for borrowing or as collateral, false otherwise
-   **/
+   */
   function isUsingAsCollateralOrBorrowing(
     DataTypes.UserConfigurationMap memory self,
     uint256 reserveIndex
@@ -4056,12 +3890,11 @@ library UserConfiguration {
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
@@ -4073,12 +3906,11 @@ library UserConfiguration {
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
@@ -4090,12 +3922,10 @@ library UserConfiguration {
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
@@ -4104,12 +3934,10 @@ library UserConfiguration {
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
 
@@ -4118,7 +3946,7 @@ library UserConfiguration {
    * @dev this uses a simple trick - if a number is a power of two (only one bit set) then n & (n - 1) == 0
    * @param self The configuration object
    * @return True if the user has been supplying as collateral one reserve, false otherwise
-   **/
+   */
   function isBorrowingOne(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     uint256 borrowingData = self.data & BORROWING_MASK;
     return borrowingData != 0 && (borrowingData & (borrowingData - 1) == 0);
@@ -4128,7 +3956,7 @@ library UserConfiguration {
    * @notice Checks if a user has been borrowing from any reserve
    * @param self The configuration object
    * @return True if the user has been borrowing any reserve, false otherwise
-   **/
+   */
   function isBorrowingAny(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     return self.data & BORROWING_MASK != 0;
   }
@@ -4137,7 +3965,7 @@ library UserConfiguration {
    * @notice Checks if a user has not been using any reserve for borrowing or supply
    * @param self The configuration object
    * @return True if the user has not been borrowing or supplying any reserve, false otherwise
-   **/
+   */
   function isEmpty(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     return self.data == 0;
   }
@@ -4155,15 +3983,7 @@ library UserConfiguration {
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
 
@@ -4205,11 +4025,10 @@ library UserConfiguration {
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
@@ -4293,19 +4112,11 @@ library EModeLogic {
    * @return The eMode ltv
    * @return The eMode liquidation threshold
    * @return The eMode asset price
-   **/
+   */
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
 
@@ -4321,12 +4132,11 @@ library EModeLogic {
    * @param eModeUserCategory The user eMode category
    * @param eModeAssetCategory The asset eMode category
    * @return True if eMode is active and the asset belongs to the eMode category chosen by the user, false otherwise
-   **/
-  function isInEModeCategory(uint256 eModeUserCategory, uint256 eModeAssetCategory)
-    internal
-    pure
-    returns (bool)
-  {
+   */
+  function isInEModeCategory(
+    uint256 eModeUserCategory,
+    uint256 eModeAssetCategory
+  ) internal pure returns (bool) {
     return (eModeUserCategory != 0 && eModeAssetCategory == eModeUserCategory);
   }
 }
@@ -4379,24 +4189,13 @@ library GenericLogic {
    * @return The average liquidation threshold of the user
    * @return The health factor of the user
    * @return True if the ltv is zero, false otherwise
-   **/
+   */
   function calculateUserAccountData(
     mapping(address => DataTypes.ReserveData) storage reservesData,
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
@@ -4440,7 +4239,7 @@ library GenericLogic {
       ) = currentReserve.configuration.getParams();
 
       unchecked {
-        vars.assetUnit = 10**vars.decimals;
+        vars.assetUnit = 10 ** vars.decimals;
       }
 
       vars.assetPrice = vars.eModeAssetPrice != 0 &&
@@ -4521,7 +4320,7 @@ library GenericLogic {
    * @param totalDebtInBaseCurrency The total borrow balance in the base currency used by the price feed
    * @param ltv The average loan to value
    * @return The amount available to borrow in the base currency of the used by the price feed
-   **/
+   */
   function calculateAvailableBorrows(
     uint256 totalCollateralInBaseCurrency,
     uint256 totalDebtInBaseCurrency,
@@ -4547,7 +4346,7 @@ library GenericLogic {
    * @param assetPrice The price of the asset for which the total debt of the user is being calculated
    * @param assetUnit The value representing one full unit of the asset (10^decimals)
    * @return The total debt of the user normalized to the base currency
-   **/
+   */
   function _getUserDebtInBaseCurrency(
     address user,
     DataTypes.ReserveData storage reserve,
@@ -4580,7 +4379,7 @@ library GenericLogic {
    * @param assetPrice The price of the asset for which the total aToken balance of the user is being calculated
    * @param assetUnit The value representing one full unit of the asset (10^decimals)
    * @return The total aToken balance of the user normalized to the base currency of the price oracle
-   **/
+   */
   function _getUserBalanceInBaseCurrency(
     address user,
     DataTypes.ReserveData storage reserve,
@@ -4598,6 +4397,428 @@ library GenericLogic {
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
@@ -4627,15 +4848,22 @@ library ValidationLogic {
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
    * @param amount The amount to be supplied
    */
-  function validateSupply(DataTypes.ReserveCache memory reserveCache, uint256 amount)
-    internal
-    view
-  {
+  function validateSupply(
+    DataTypes.ReserveCache memory reserveCache,
+    DataTypes.ReserveData storage reserve,
+    uint256 amount
+  ) internal view {
     require(amount != 0, Errors.INVALID_AMOUNT);
 
     (bool isActive, bool isFrozen, , , bool isPaused) = reserveCache
@@ -4648,10 +4876,9 @@ library ValidationLogic {
     uint256 supplyCap = reserveCache.reserveConfiguration.getSupplyCap();
     require(
       supplyCap == 0 ||
-        (IAToken(reserveCache.aTokenAddress).scaledTotalSupply().rayMul(
-          reserveCache.nextLiquidityIndex
-        ) + amount) <=
-        supplyCap * (10**reserveCache.reserveConfiguration.getDecimals()),
+        ((IAToken(reserveCache.aTokenAddress).scaledTotalSupply() +
+          uint256(reserve.accruedToTreasury)).rayMul(reserveCache.nextLiquidityIndex) + amount) <=
+        supplyCap * (10 ** reserveCache.reserveConfiguration.getDecimals()),
       Errors.SUPPLY_CAP_EXCEEDED
     );
   }
@@ -4744,7 +4971,7 @@ library ValidationLogic {
     vars.reserveDecimals = params.reserveCache.reserveConfiguration.getDecimals();
     vars.borrowCap = params.reserveCache.reserveConfiguration.getBorrowCap();
     unchecked {
-      vars.assetUnit = 10**vars.reserveDecimals;
+      vars.assetUnit = 10 ** vars.reserveDecimals;
     }
 
     if (vars.borrowCap != 0) {
@@ -4772,7 +4999,8 @@ library ValidationLogic {
 
       require(
         reservesData[params.isolationModeCollateralAddress].isolationModeTotalDebt +
-          (params.amount / 10**(vars.reserveDecimals - ReserveConfiguration.DEBT_CEILING_DECIMALS))
+          (params.amount /
+            10 ** (vars.reserveDecimals - ReserveConfiguration.DEBT_CEILING_DECIMALS))
             .toUint128() <=
           params.isolationModeDebtCeiling,
         Errors.DEBT_CEILING_EXCEEDED
@@ -4839,7 +5067,7 @@ library ValidationLogic {
      * 2. Users cannot borrow from the reserve if their collateral is (mostly) the same currency
      *    they are borrowing, to prevent abuses.
      * 3. Users will be able to borrow only a portion of the total available liquidity
-     **/
+     */
 
     if (params.interestRateMode == DataTypes.InterestRateMode.STABLE) {
       //check if the borrow mode is stable and if stable rate borrowing is enabled on this reserve
@@ -4905,20 +5133,6 @@ library ValidationLogic {
     require(isActive, Errors.RESERVE_INACTIVE);
     require(!isPaused, Errors.RESERVE_PAUSED);
 
-    uint256 variableDebtPreviousIndex = IScaledBalanceToken(reserveCache.variableDebtTokenAddress)
-      .getPreviousIndex(onBehalfOf);
-
-    uint40 stableRatePreviousTimestamp = IStableDebtToken(reserveCache.stableDebtTokenAddress)
-      .getUserLastUpdated(onBehalfOf);
-
-    require(
-      (stableRatePreviousTimestamp < uint40(block.timestamp) &&
-        interestRateMode == DataTypes.InterestRateMode.STABLE) ||
-        (variableDebtPreviousIndex < reserveCache.nextVariableBorrowIndex &&
-          interestRateMode == DataTypes.InterestRateMode.VARIABLE),
-      Errors.SAME_BLOCK_BORROW_REPAY
-    );
-
     require(
       (stableDebt != 0 && interestRateMode == DataTypes.InterestRateMode.STABLE) ||
         (variableDebt != 0 && interestRateMode == DataTypes.InterestRateMode.VARIABLE),
@@ -4960,7 +5174,7 @@ library ValidationLogic {
        * 2. user is not trying to abuse the reserve by supplying
        * more collateral than he is borrowing, artificially lowering
        * the interest rate, borrowing at variable, and switching to stable
-       **/
+       */
       require(stableRateEnabled, Errors.STABLE_BORROWING_NOT_ENABLED);
 
       require(
@@ -5046,10 +5260,7 @@ library ValidationLogic {
   ) internal view {
     require(assets.length == amounts.length, Errors.INCONSISTENT_FLASHLOAN_PARAMS);
     for (uint256 i = 0; i < assets.length; i++) {
-      DataTypes.ReserveConfigurationMap memory configuration = reservesData[assets[i]]
-        .configuration;
-      require(!configuration.getPaused(), Errors.RESERVE_PAUSED);
-      require(configuration.getActive(), Errors.RESERVE_INACTIVE);
+      validateFlashloanSimple(reservesData[assets[i]]);
     }
   }
 
@@ -5061,6 +5272,7 @@ library ValidationLogic {
     DataTypes.ReserveConfigurationMap memory configuration = reserve.configuration;
     require(!configuration.getPaused(), Errors.RESERVE_PAUSED);
     require(configuration.getActive(), Errors.RESERVE_INACTIVE);
+    require(configuration.getFlashLoanEnabled(), Errors.FLASHLOAN_DISABLED);
   }
 
   struct ValidateLiquidationCallLocalVars {
@@ -5215,7 +5427,7 @@ library ValidationLogic {
    * @param reservesList The addresses of all the active reserves
    * @param reserve The reserve object
    * @param asset The address of the reserve's underlying asset
-   **/
+   */
   function validateDropReserve(
     mapping(uint256 => address) storage reservesList,
     DataTypes.ReserveData storage reserve,
@@ -5228,7 +5440,10 @@ library ValidationLogic {
       IERC20(reserve.variableDebtTokenAddress).totalSupply() == 0,
       Errors.VARIABLE_DEBT_SUPPLY_NOT_ZERO
     );
-    require(IERC20(reserve.aTokenAddress).totalSupply() == 0, Errors.ATOKEN_SUPPLY_NOT_ZERO);
+    require(
+      IERC20(reserve.aTokenAddress).totalSupply() == 0 && reserve.accruedToTreasury == 0,
+      Errors.UNDERLYING_CLAIMABLE_RIGHTS_NOT_ZERO
+    );
   }
 
   /**
@@ -5239,7 +5454,7 @@ library ValidationLogic {
    * @param userConfig the user configuration
    * @param reservesCount The total number of valid reserves
    * @param categoryId The id of the category
-   **/
+   */
   function validateSetUserEMode(
     mapping(address => DataTypes.ReserveData) storage reservesData,
     mapping(uint256 => address) storage reservesList,
@@ -5254,7 +5469,7 @@ library ValidationLogic {
       Errors.INCONSISTENT_EMODE_CATEGORY
     );
 
-    //eMode can always be enabled if the user hasn't supplied anything
+    // eMode can always be enabled if the user hasn't supplied anything
     if (userConfig.isEmpty()) {
       return;
     }
@@ -5278,22 +5493,23 @@ library ValidationLogic {
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
    * @param reserveConfig The reserve configuration
    * @return True if the asset can be activated as collateral, false otherwise
-   **/
+   */
   function validateUseAsCollateral(
     mapping(address => DataTypes.ReserveData) storage reservesData,
     mapping(uint256 => address) storage reservesList,
     DataTypes.UserConfigurationMap storage userConfig,
     DataTypes.ReserveConfigurationMap memory reserveConfig
   ) internal view returns (bool) {
+    if (reserveConfig.getLtv() == 0) {
+      return false;
+    }
     if (!userConfig.isUsingAsCollateralAny()) {
       return true;
     }
@@ -5301,6 +5517,38 @@ library ValidationLogic {
 
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
@@ -5324,7 +5572,7 @@ library PoolLogic {
    * @param reservesList The addresses of all the active reserves
    * @param params Additional parameters needed for initiation
    * @return true if appended, false if inserted at existing empty spot
-   **/
+   */
   function executeInitReserve(
     mapping(address => DataTypes.ReserveData) storage reservesData,
     mapping(uint256 => address) storage reservesList,
@@ -5362,11 +5610,7 @@ library PoolLogic {
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
 
@@ -5374,7 +5618,7 @@ library PoolLogic {
    * @notice Mints the assets accrued through the reserve factor to the treasury in the form of aTokens
    * @param reservesData The state of all the reserves
    * @param assets The list of reserves for which the minting needs to be executed
-   **/
+   */
   function executeMintToTreasury(
     mapping(address => DataTypes.ReserveData) storage reservesData,
     address[] calldata assets
@@ -5422,7 +5666,7 @@ library PoolLogic {
    * @param reservesData The state of all the reserves
    * @param reservesList The addresses of all the active reserves
    * @param asset The address of the underlying asset of the reserve
-   **/
+   */
   function executeDropReserve(
     mapping(address => DataTypes.ReserveData) storage reservesData,
     mapping(uint256 => address) storage reservesList,
@@ -5446,7 +5690,7 @@ library PoolLogic {
    * @return currentLiquidationThreshold The liquidation threshold of the user
    * @return ltv The loan to value of The user
    * @return healthFactor The current health factor of the user
-   **/
+   */
   function executeGetUserAccountData(
     mapping(address => DataTypes.ReserveData) storage reservesData,
     mapping(uint256 => address) storage reservesList,
@@ -5528,7 +5772,7 @@ library SupplyLogic {
 
     reserve.updateState(reserveCache);
 
-    ValidationLogic.validateSupply(reserveCache, params.amount);
+    ValidationLogic.validateSupply(reserveCache, reserve, params.amount);
 
     reserve.updateInterestRates(reserveCache, params.asset, params.amount, 0);
 
@@ -5543,11 +5787,12 @@ library SupplyLogic {
 
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
@@ -5596,6 +5841,13 @@ library SupplyLogic {
 
     reserve.updateInterestRates(reserveCache, params.asset, 0, amountToWithdraw);
 
+    bool isCollateral = userConfig.isUsingAsCollateral(reserve.id);
+
+    if (isCollateral && amountToWithdraw == userBalance) {
+      userConfig.setUsingAsCollateral(reserve.id, false);
+      emit ReserveUsedAsCollateralDisabled(params.asset, msg.sender);
+    }
+
     IAToken(reserveCache.aTokenAddress).burn(
       msg.sender,
       params.to,
@@ -5603,25 +5855,18 @@ library SupplyLogic {
       reserveCache.nextLiquidityIndex
     );
 
-    if (userConfig.isUsingAsCollateral(reserve.id)) {
-      if (userConfig.isBorrowingAny()) {
-        ValidationLogic.validateHFAndLtv(
-          reservesData,
-          reservesList,
-          eModeCategories,
-          userConfig,
-          params.asset,
-          msg.sender,
-          params.reservesCount,
-          params.oracle,
-          params.userEModeCategory
-        );
-      }
-
-      if (amountToWithdraw == userBalance) {
-        userConfig.setUsingAsCollateral(reserve.id, false);
-        emit ReserveUsedAsCollateralDisabled(params.asset, msg.sender);
-      }
+    if (isCollateral && userConfig.isBorrowingAny()) {
+      ValidationLogic.validateHFAndLtv(
+        reservesData,
+        reservesList,
+        eModeCategories,
+        userConfig,
+        params.asset,
+        msg.sender,
+        params.reservesCount,
+        params.oracle,
+        params.userEModeCategory
+      );
     }
 
     emit Withdraw(params.asset, msg.sender, params.to, amountToWithdraw);
@@ -5680,11 +5925,12 @@ library SupplyLogic {
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
@@ -5732,8 +5978,13 @@ library SupplyLogic {
 
     if (useAsCollateral) {
       require(
-        ValidationLogic.validateUseAsCollateral(reservesData, reservesList, userConfig, reserveCache.reserveConfiguration),
-        Errors.USER_IN_ISOLATION_MODE
+        ValidationLogic.validateUseAsCollateral(
+          reservesData,
+          reservesList,
+          userConfig,
+          reserveCache.reserveConfiguration
+        ),
+        Errors.USER_IN_ISOLATION_MODE_OR_LTV_ZERO
       );
 
       userConfig.setUsingAsCollateral(reserve.id, true);
@@ -5762,7 +6013,7 @@ library SupplyLogic {
  * @author Aave
  * @notice Defines the basic interface of a flashloan-receiver contract.
  * @dev Implement this interface to develop a flashloan-compatible flashLoanReceiver contract
- **/
+ */
 interface IFlashLoanReceiver {
   /**
    * @notice Executes an operation after receiving the flash-borrowed assets
@@ -5793,7 +6044,7 @@ interface IFlashLoanReceiver {
  * @author Aave
  * @notice Defines the basic interface of a flashloan-receiver contract.
  * @dev Implement this interface to develop a flashloan-compatible flashLoanReceiver contract
- **/
+ */
 interface IFlashLoanSimpleReceiver {
   /**
    * @notice Executes an operation after receiving the flash-borrowed asset
@@ -5830,12 +6081,11 @@ library Helpers {
    * @param reserveCache The reserve cache data object
    * @return The stable debt balance
    * @return The variable debt balance
-   **/
-  function getUserCurrentDebt(address user, DataTypes.ReserveCache memory reserveCache)
-    internal
-    view
-    returns (uint256, uint256)
-  {
+   */
+  function getUserCurrentDebt(
+    address user,
+    DataTypes.ReserveCache memory reserveCache
+  ) internal view returns (uint256, uint256) {
     return (
       IERC20(reserveCache.stableDebtTokenAddress).balanceOf(user),
       IERC20(reserveCache.variableDebtTokenAddress).balanceOf(user)
@@ -6137,7 +6387,11 @@ library BorrowLogic {
       );
     } else {
       IERC20(params.asset).safeTransferFrom(msg.sender, reserveCache.aTokenAddress, paybackAmount);
-      IAToken(reserveCache.aTokenAddress).handleRepayment(msg.sender, paybackAmount);
+      IAToken(reserveCache.aTokenAddress).handleRepayment(
+        msg.sender,
+        params.onBehalfOf,
+        paybackAmount
+      );
     }
 
     emit Repay(params.asset, params.onBehalfOf, msg.sender, paybackAmount, params.useATokens);
@@ -6306,7 +6560,10 @@ library FlashLoanLogic {
 
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
@@ -6446,7 +6703,8 @@ library FlashLoanLogic {
     DataTypes.ReserveCache memory reserveCache = reserve.cache();
     reserve.updateState(reserveCache);
     reserveCache.nextLiquidityIndex = reserve.cumulateToLiquidityIndex(
-      IERC20(reserveCache.aTokenAddress).totalSupply(),
+      IERC20(reserveCache.aTokenAddress).totalSupply() +
+        uint256(reserve.accruedToTreasury).rayMul(reserveCache.nextLiquidityIndex),
       premiumToLP
     );
 
@@ -6462,7 +6720,11 @@ library FlashLoanLogic {
       amountPlusPremium
     );
 
-    IAToken(reserveCache.aTokenAddress).handleRepayment(params.receiverAddress, amountPlusPremium);
+    IAToken(reserveCache.aTokenAddress).handleRepayment(
+      params.receiverAddress,
+      params.receiverAddress,
+      amountPlusPremium
+    );
 
     emit FlashLoan(
       params.receiverAddress,
@@ -6480,7 +6742,7 @@ library FlashLoanLogic {
  * @title LiquidationLogic library
  * @author Aave
  * @notice Implements actions involving management of collateral in the protocol, the main one being the liquidations
- **/
+ */
 library LiquidationLogic {
   using WadRayMath for uint256;
   using PercentageMath for uint256;
@@ -6549,7 +6811,7 @@ library LiquidationLogic {
    * @param usersConfig The users configuration mapping that track the supplied/borrowed assets
    * @param eModeCategories The configuration of all the efficiency mode categories
    * @param params The additional parameters needed to execute the liquidation function
-   **/
+   */
   function executeLiquidationCall(
     mapping(address => DataTypes.ReserveData) storage reservesData,
     mapping(uint256 => address) storage reservesList,
@@ -6623,6 +6885,16 @@ library LiquidationLogic {
       userConfig.setBorrowing(debtReserve.id, false);
     }
 
+    // If the collateral being liquidated is equal to the user balance,
+    // we set the currency as not being used as collateral anymore
+    if (
+      vars.actualCollateralToLiquidate + vars.liquidationProtocolFeeAmount ==
+      vars.userCollateralBalance
+    ) {
+      userConfig.setUsingAsCollateral(collateralReserve.id, false);
+      emit ReserveUsedAsCollateralDisabled(params.collateralAsset, params.user);
+    }
+
     _burnDebtTokens(params, vars);
 
     debtReserve.updateInterestRates(
@@ -6648,6 +6920,15 @@ library LiquidationLogic {
 
     // Transfer fee to treasury if it is non-zero
     if (vars.liquidationProtocolFeeAmount != 0) {
+      uint256 liquidityIndex = collateralReserve.getNormalizedIncome();
+      uint256 scaledDownLiquidationProtocolFee = vars.liquidationProtocolFeeAmount.rayDiv(
+        liquidityIndex
+      );
+      uint256 scaledDownUserBalance = vars.collateralAToken.scaledBalanceOf(params.user);
+      // To avoid trying to send more aTokens than available on balance, due to 1 wei imprecision
+      if (scaledDownLiquidationProtocolFee > scaledDownUserBalance) {
+        vars.liquidationProtocolFeeAmount = scaledDownUserBalance.rayMul(liquidityIndex);
+      }
       vars.collateralAToken.transferOnLiquidation(
         params.user,
         vars.collateralAToken.RESERVE_TREASURY_ADDRESS(),
@@ -6655,13 +6936,6 @@ library LiquidationLogic {
       );
     }
 
-    // If the collateral being liquidated is equal to the user balance,
-    // we set the currency as not being used as collateral anymore
-    if (vars.actualCollateralToLiquidate == vars.userCollateralBalance) {
-      userConfig.setUsingAsCollateral(collateralReserve.id, false);
-      emit ReserveUsedAsCollateralDisabled(params.collateralAsset, params.user);
-    }
-
     // Transfers the debt asset being repaid to the aToken, where the liquidity is kept
     IERC20(params.debtAsset).safeTransferFrom(
       msg.sender,
@@ -6671,6 +6945,7 @@ library LiquidationLogic {
 
     IAToken(vars.debtReserveCache.aTokenAddress).handleRepayment(
       msg.sender,
+      params.user,
       vars.actualDebtToLiquidate
     );
 
@@ -6744,11 +7019,12 @@ library LiquidationLogic {
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
@@ -6807,15 +7083,7 @@ library LiquidationLogic {
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
@@ -6850,16 +7118,7 @@ library LiquidationLogic {
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
 
@@ -6922,7 +7181,7 @@ library LiquidationLogic {
    * @return The maximum amount that is possible to liquidate given all the liquidation constraints (user balance, close factor)
    * @return The amount to repay with the liquidation
    * @return The fee taken from the liquidation bonus amount to be paid to the protocol
-   **/
+   */
   function _calculateAvailableCollateralToLiquidate(
     DataTypes.ReserveData storage collateralReserve,
     DataTypes.ReserveCache memory debtReserveCache,
@@ -6932,15 +7191,7 @@ library LiquidationLogic {
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
@@ -6950,8 +7201,8 @@ library LiquidationLogic {
     vars.debtAssetDecimals = debtReserveCache.reserveConfiguration.getDecimals();
 
     unchecked {
-      vars.collateralAssetUnit = 10**vars.collateralDecimals;
-      vars.debtAssetUnit = 10**vars.debtAssetDecimals;
+      vars.collateralAssetUnit = 10 ** vars.collateralDecimals;
+      vars.debtAssetUnit = 10 ** vars.debtAssetDecimals;
     }
 
     vars.liquidationProtocolFeePercentage = collateralReserve
@@ -7028,7 +7279,7 @@ library BridgeLogic {
    * @param onBehalfOf The address that will receive the aTokens
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function executeMintUnbacked(
     mapping(address => DataTypes.ReserveData) storage reservesData,
     mapping(uint256 => address) storage reservesList,
@@ -7043,14 +7294,17 @@ library BridgeLogic {
 
     reserve.updateState(reserveCache);
 
-    ValidationLogic.validateSupply(reserveCache, amount);
+    ValidationLogic.validateSupply(reserveCache, reserve, amount);
 
     uint256 unbackedMintCap = reserveCache.reserveConfiguration.getUnbackedMintCap();
     uint256 reserveDecimals = reserveCache.reserveConfiguration.getDecimals();
 
     uint256 unbacked = reserve.unbacked += amount.toUint128();
 
-    require(unbacked <= unbackedMintCap * (10**reserveDecimals), Errors.UNBACKED_MINT_CAP_EXCEEDED);
+    require(
+      unbacked <= unbackedMintCap * (10 ** reserveDecimals),
+      Errors.UNBACKED_MINT_CAP_EXCEEDED
+    );
 
     reserve.updateInterestRates(reserveCache, asset, 0, 0);
 
@@ -7063,11 +7317,12 @@ library BridgeLogic {
 
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
@@ -7080,20 +7335,22 @@ library BridgeLogic {
 
   /**
    * @notice Back the current unbacked with `amount` and pay `fee`.
+   * @dev It is not possible to back more than the existing unbacked amount of the reserve
    * @dev Emits the `BackUnbacked` event
    * @param reserve The reserve to back unbacked for
    * @param asset The address of the underlying asset to repay
    * @param amount The amount to back
    * @param fee The amount paid in fees
    * @param protocolFeeBps The fraction of fees in basis points paid to the protocol
-   **/
+   * @return The backed amount
+   */
   function executeBackUnbacked(
     DataTypes.ReserveData storage reserve,
     address asset,
     uint256 amount,
     uint256 fee,
     uint256 protocolFeeBps
-  ) external {
+  ) external returns (uint256) {
     DataTypes.ReserveCache memory reserveCache = reserve.cache();
 
     reserve.updateState(reserveCache);
@@ -7105,7 +7362,8 @@ library BridgeLogic {
     uint256 added = backingAmount + fee;
 
     reserveCache.nextLiquidityIndex = reserve.cumulateToLiquidityIndex(
-      IERC20(reserveCache.aTokenAddress).totalSupply(),
+      IERC20(reserveCache.aTokenAddress).totalSupply() +
+        uint256(reserve.accruedToTreasury).rayMul(reserveCache.nextLiquidityIndex),
       feeToLP
     );
 
@@ -7117,6 +7375,8 @@ library BridgeLogic {
     IERC20(asset).safeTransferFrom(msg.sender, reserveCache.aTokenAddress, added);
 
     emit BackUnbacked(asset, msg.sender, backingAmount, fee);
+
+    return backingAmount;
   }
 }
 
@@ -7124,7 +7384,7 @@ library BridgeLogic {
  * @title IERC20WithPermit
  * @author Aave
  * @notice Interface for the permit function (EIP-2612)
- **/
+ */
 interface IERC20WithPermit is IERC20 {
   /**
    * @notice Allow passing a signed message to approve spending
@@ -7149,177 +7409,6 @@ interface IERC20WithPermit is IERC20 {
   ) external;
 }
 
-/**
- * @title IACLManager
- * @author Aave
- * @notice Defines the basic interface for the ACL Manager
- **/
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
-   * @notice Removes an admin as FlashBorrower
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
@@ -7380,16 +7469,16 @@ contract PoolStorage {
  * @dev To be covered by a proxy contract, owned by the PoolAddressesProvider of the specific market
  * @dev All admin functions are callable by the PoolConfigurator contract defined also in the
  *   PoolAddressesProvider
- **/
+ */
 contract Pool is VersionedInitializable, PoolStorage, IPool {
   using ReserveLogic for DataTypes.ReserveData;
 
-  uint256 public constant POOL_REVISION = 0x1;
+  uint256 public constant POOL_REVISION = 0x2;
   IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
 
   /**
    * @dev Only pool configurator can call functions marked by this modifier.
-   **/
+   */
   modifier onlyPoolConfigurator() {
     _onlyPoolConfigurator();
     _;
@@ -7397,7 +7486,7 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
 
   /**
    * @dev Only pool admin can call functions marked by this modifier.
-   **/
+   */
   modifier onlyPoolAdmin() {
     _onlyPoolAdmin();
     _;
@@ -7405,7 +7494,7 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
 
   /**
    * @dev Only bridge can call functions marked by this modifier.
-   **/
+   */
   modifier onlyBridge() {
     _onlyBridge();
     _;
@@ -7450,7 +7539,7 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
    * PoolAddressesProvider of the market.
    * @dev Caching the address of the PoolAddressesProvider in order to reduce gas consumption on subsequent operations
    * @param provider The address of the PoolAddressesProvider
-   **/
+   */
   function initialize(IPoolAddressesProvider provider) external virtual initializer {
     require(provider == ADDRESSES_PROVIDER, Errors.INVALID_ADDRESSES_PROVIDER);
     _maxStableRateBorrowSizePercent = 0.25e4;
@@ -7481,8 +7570,9 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
     address asset,
     uint256 amount,
     uint256 fee
-  ) external virtual override onlyBridge {
-    BridgeLogic.executeBackUnbacked(_reserves[asset], asset, amount, fee, _bridgeProtocolFee);
+  ) external virtual override onlyBridge returns (uint256) {
+    return
+      BridgeLogic.executeBackUnbacked(_reserves[asset], asset, amount, fee, _bridgeProtocolFee);
   }
 
   /// @inheritdoc IPool
@@ -7684,11 +7774,10 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
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
@@ -7793,18 +7882,16 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
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
@@ -7834,46 +7921,30 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
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
 
@@ -7990,36 +8061,29 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
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
 
@@ -8033,25 +8097,19 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
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
 
@@ -8077,12 +8135,9 @@ contract Pool is VersionedInitializable, PoolStorage, IPool {
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
