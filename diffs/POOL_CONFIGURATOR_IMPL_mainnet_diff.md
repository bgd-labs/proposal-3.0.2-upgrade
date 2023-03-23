```diff
diff --git a/src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol b/src/downloads/POOL_CONFIGURATOR_IMPL.sol
index 24c3413..30b3749 100644
--- a/src/downloads/mainnet/POOL_CONFIGURATOR_IMPL.sol
+++ b/src/downloads/POOL_CONFIGURATOR_IMPL.sol
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
@@ -1607,11 +1554,7 @@ interface IPool {
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
@@ -1624,12 +1567,7 @@ interface IPool {
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
@@ -1668,11 +1606,7 @@ interface IPool {
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
@@ -1809,7 +1743,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -1836,7 +1770,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -1862,7 +1796,9 @@ interface IPool {
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
@@ -1905,8 +1841,10 @@ interface IPool {
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
@@ -1914,28 +1852,28 @@ interface IPool {
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
@@ -2103,11 +2041,7 @@ interface IPool {
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
@@ -2121,12 +2055,7 @@ interface IPool {
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
@@ -2143,11 +2072,7 @@ interface IAaveIncentivesController {
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
@@ -2527,11 +2452,10 @@ contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
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
@@ -2646,9 +2570,10 @@ library ConfiguratorLogic {
    * @param pool The Pool in which the reserve will be initialized
    * @param input The needed parameters for the initialization
    */
-  function executeInitReserve(IPool pool, ConfiguratorInputTypes.InitReserveInput calldata input)
-    public
-  {
+  function executeInitReserve(
+    IPool pool,
+    ConfiguratorInputTypes.InitReserveInput calldata input
+  ) public {
     address aTokenProxyAddress = _initTokenWithProxy(
       input.aTokenImpl,
       abi.encodeWithSelector(
@@ -2832,10 +2757,10 @@ library ConfiguratorLogic {
    * @param initParams The parameters that is passed to the implementation to initialize
    * @return The address of initialized proxy
    */
-  function _initTokenWithProxy(address implementation, bytes memory initParams)
-    internal
-    returns (address)
-  {
+  function _initTokenWithProxy(
+    address implementation,
+    bytes memory initParams
+  ) internal returns (address) {
     InitializableImmutableAdminUpgradeabilityProxy proxy = new InitializableImmutableAdminUpgradeabilityProxy(
         address(this)
       );
@@ -3137,15 +3062,17 @@ interface IPoolConfigurator {
    * @notice Updates the stable debt token implementation for the reserve.
    * @param input The stableDebtToken update parameters
    */
-  function updateStableDebtToken(ConfiguratorInputTypes.UpdateDebtTokenInput calldata input)
-    external;
+  function updateStableDebtToken(
+    ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
+  ) external;
 
   /**
    * @notice Updates the variable debt token implementation for the asset.
    * @param input The variableDebtToken update parameters
    */
-  function updateVariableDebtToken(ConfiguratorInputTypes.UpdateDebtTokenInput calldata input)
-    external;
+  function updateVariableDebtToken(
+    ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
+  ) external;
 
   /**
    * @notice Configures borrowing on a reserve.
@@ -3232,8 +3159,10 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param newRateStrategyAddress The address of the new interest strategy contract
    */
-  function setReserveInterestRateStrategyAddress(address asset, address newRateStrategyAddress)
-    external;
+  function setReserveInterestRateStrategyAddress(
+    address asset,
+    address newRateStrategyAddress
+  ) external;
 
   /**
    * @notice Pauses or unpauses all the protocol reserves. In the paused state all the protocol interactions
@@ -3559,7 +3488,9 @@ interface IPoolDataProvider {
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
@@ -3588,10 +3519,9 @@ interface IPoolDataProvider {
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
@@ -3650,7 +3580,9 @@ interface IPoolDataProvider {
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
@@ -3697,7 +3629,10 @@ interface IPoolDataProvider {
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
@@ -3719,7 +3654,9 @@ interface IPoolDataProvider {
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
@@ -3733,10 +3670,9 @@ interface IPoolDataProvider {
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
@@ -3798,7 +3734,7 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     _;
   }
 
-  uint256 public constant CONFIGURATOR_REVISION = 0x1;
+  uint256 public constant CONFIGURATOR_REVISION = 0x2;
 
   /// @inheritdoc VersionedInitializable
   function getRevision() internal pure virtual override returns (uint256) {
@@ -3811,11 +3747,9 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function initReserves(ConfiguratorInputTypes.InitReserveInput[] calldata input)
-    external
-    override
-    onlyAssetListingOrPoolAdmins
-  {
+  function initReserves(
+    ConfiguratorInputTypes.InitReserveInput[] calldata input
+  ) external override onlyAssetListingOrPoolAdmins {
     IPool cachedPool = _pool;
     for (uint256 i = 0; i < input.length; i++) {
       ConfiguratorLogic.executeInitReserve(cachedPool, input[i]);
@@ -3829,29 +3763,23 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function updateAToken(ConfiguratorInputTypes.UpdateATokenInput calldata input)
-    external
-    override
-    onlyPoolAdmin
-  {
+  function updateAToken(
+    ConfiguratorInputTypes.UpdateATokenInput calldata input
+  ) external override onlyPoolAdmin {
     ConfiguratorLogic.executeUpdateAToken(_pool, input);
   }
 
   /// @inheritdoc IPoolConfigurator
-  function updateStableDebtToken(ConfiguratorInputTypes.UpdateDebtTokenInput calldata input)
-    external
-    override
-    onlyPoolAdmin
-  {
+  function updateStableDebtToken(
+    ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
+  ) external override onlyPoolAdmin {
     ConfiguratorLogic.executeUpdateStableDebtToken(_pool, input);
   }
 
   /// @inheritdoc IPoolConfigurator
-  function updateVariableDebtToken(ConfiguratorInputTypes.UpdateDebtTokenInput calldata input)
-    external
-    override
-    onlyPoolAdmin
-  {
+  function updateVariableDebtToken(
+    ConfiguratorInputTypes.UpdateDebtTokenInput calldata input
+  ) external override onlyPoolAdmin {
     ConfiguratorLogic.executeUpdateVariableDebtToken(_pool, input);
   }
 
@@ -3909,11 +3837,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setReserveStableRateBorrowing(address asset, bool enabled)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setReserveStableRateBorrowing(
+    address asset,
+    bool enabled
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     if (enabled) {
       require(currentConfig.getBorrowingEnabled(), Errors.BORROWING_NOT_ENABLED);
@@ -3924,11 +3851,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setReserveFlashLoaning(address asset, bool enabled)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setReserveFlashLoaning(
+    address asset,
+    bool enabled
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
 
     currentConfig.setFlashLoanEnabled(enabled);
@@ -3954,11 +3880,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setBorrowableInIsolation(address asset, bool borrowable)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setBorrowableInIsolation(
+    address asset,
+    bool borrowable
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     currentConfig.setBorrowableInIsolation(borrowable);
     _pool.setConfiguration(asset, currentConfig);
@@ -3974,11 +3899,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setReserveFactor(address asset, uint256 newReserveFactor)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setReserveFactor(
+    address asset,
+    uint256 newReserveFactor
+  ) external override onlyRiskOrPoolAdmins {
     require(newReserveFactor <= PercentageMath.PERCENTAGE_FACTOR, Errors.INVALID_RESERVE_FACTOR);
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     uint256 oldReserveFactor = currentConfig.getReserveFactor();
@@ -3988,11 +3912,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setDebtCeiling(address asset, uint256 newDebtCeiling)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setDebtCeiling(
+    address asset,
+    uint256 newDebtCeiling
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
 
     uint256 oldDebtCeiling = currentConfig.getDebtCeiling();
@@ -4010,11 +3933,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setSiloedBorrowing(address asset, bool newSiloed)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setSiloedBorrowing(
+    address asset,
+    bool newSiloed
+  ) external override onlyRiskOrPoolAdmins {
     if (newSiloed) {
       _checkNoBorrowers(asset);
     }
@@ -4030,11 +3952,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setBorrowCap(address asset, uint256 newBorrowCap)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setBorrowCap(
+    address asset,
+    uint256 newBorrowCap
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     uint256 oldBorrowCap = currentConfig.getBorrowCap();
     currentConfig.setBorrowCap(newBorrowCap);
@@ -4043,11 +3964,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setSupplyCap(address asset, uint256 newSupplyCap)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setSupplyCap(
+    address asset,
+    uint256 newSupplyCap
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     uint256 oldSupplyCap = currentConfig.getSupplyCap();
     currentConfig.setSupplyCap(newSupplyCap);
@@ -4056,11 +3976,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setLiquidationProtocolFee(address asset, uint256 newFee)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setLiquidationProtocolFee(
+    address asset,
+    uint256 newFee
+  ) external override onlyRiskOrPoolAdmins {
     require(newFee <= PercentageMath.PERCENTAGE_FACTOR, Errors.INVALID_LIQUIDATION_PROTOCOL_FEE);
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     uint256 oldFee = currentConfig.getLiquidationProtocolFee();
@@ -4124,11 +4043,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setAssetEModeCategory(address asset, uint8 newCategoryId)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setAssetEModeCategory(
+    address asset,
+    uint8 newCategoryId
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
 
     if (newCategoryId != 0) {
@@ -4145,11 +4063,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setUnbackedMintCap(address asset, uint256 newUnbackedMintCap)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setUnbackedMintCap(
+    address asset,
+    uint256 newUnbackedMintCap
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
     uint256 oldUnbackedMintCap = currentConfig.getUnbackedMintCap();
     currentConfig.setUnbackedMintCap(newUnbackedMintCap);
@@ -4158,11 +4075,10 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function setReserveInterestRateStrategyAddress(address asset, address newRateStrategyAddress)
-    external
-    override
-    onlyRiskOrPoolAdmins
-  {
+  function setReserveInterestRateStrategyAddress(
+    address asset,
+    address newRateStrategyAddress
+  ) external override onlyRiskOrPoolAdmins {
     DataTypes.ReserveData memory reserve = _pool.getReserveData(asset);
     address oldRateStrategyAddress = reserve.interestRateStrategyAddress;
     _pool.setReserveInterestRateStrategyAddress(asset, newRateStrategyAddress);
@@ -4192,11 +4108,9 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function updateFlashloanPremiumTotal(uint128 newFlashloanPremiumTotal)
-    external
-    override
-    onlyPoolAdmin
-  {
+  function updateFlashloanPremiumTotal(
+    uint128 newFlashloanPremiumTotal
+  ) external override onlyPoolAdmin {
     require(
       newFlashloanPremiumTotal <= PercentageMath.PERCENTAGE_FACTOR,
       Errors.FLASHLOAN_PREMIUM_INVALID
@@ -4207,11 +4121,9 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   /// @inheritdoc IPoolConfigurator
-  function updateFlashloanPremiumToProtocol(uint128 newFlashloanPremiumToProtocol)
-    external
-    override
-    onlyPoolAdmin
-  {
+  function updateFlashloanPremiumToProtocol(
+    uint128 newFlashloanPremiumToProtocol
+  ) external override onlyPoolAdmin {
     require(
       newFlashloanPremiumToProtocol <= PercentageMath.PERCENTAGE_FACTOR,
       Errors.FLASHLOAN_PREMIUM_INVALID
```
