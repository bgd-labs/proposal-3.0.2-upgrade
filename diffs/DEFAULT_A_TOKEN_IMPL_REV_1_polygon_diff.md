```diff
diff --git a/src/downloads/polygon/DEFAULT_A_TOKEN_IMPL_REV_1.sol b/src/downloads/DEFAULT_A_TOKEN_IMPL_REV_1.sol
index 9195c28..1b84ad9 100644
--- a/src/downloads/polygon/DEFAULT_A_TOKEN_IMPL_REV_1.sol
+++ b/src/downloads/DEFAULT_A_TOKEN_IMPL_REV_1.sol
@@ -503,13 +503,13 @@ abstract contract VersionedInitializable {
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
@@ -581,13 +581,12 @@ library Errors {
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
@@ -624,6 +623,7 @@ library Errors {
   string public constant STABLE_BORROWING_ENABLED = '88'; // 'Stable borrowing is enabled'
   string public constant SILOED_BORROWING_VIOLATION = '89'; // 'User is trying to borrow multiple assets including a siloed one'
   string public constant RESERVE_DEBT_NOT_ZERO = '90'; // the total debt of the reserve needs to be 0
+  string public constant FLASHLOAN_DISABLED = '91'; // FlashLoaning for this asset is disabled
 }
 
 /**
@@ -633,7 +633,7 @@ library Errors {
  * @dev Provides mul and div function for wads (decimal numbers with 18 digits of precision) and rays (decimal numbers
  * with 27 digits of precision)
  * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
- **/
+ */
 library WadRayMath {
   // HALF_WAD and HALF_RAY expressed with extended notation as constant with operations are not supported in Yul assembly
   uint256 internal constant WAD = 1e18;
@@ -650,7 +650,7 @@ library WadRayMath {
    * @param a Wad
    * @param b Wad
    * @return c = a*b, in wad
-   **/
+   */
   function wadMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - HALF_WAD) / b
     assembly {
@@ -668,7 +668,7 @@ library WadRayMath {
    * @param a Wad
    * @param b Wad
    * @return c = a/b, in wad
-   **/
+   */
   function wadDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - halfB) / WAD
     assembly {
@@ -686,7 +686,7 @@ library WadRayMath {
    * @param a Ray
    * @param b Ray
    * @return c = a raymul b
-   **/
+   */
   function rayMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - HALF_RAY) / b
     assembly {
@@ -704,7 +704,7 @@ library WadRayMath {
    * @param a Ray
    * @param b Ray
    * @return c = a raydiv b
-   **/
+   */
   function rayDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
     // to avoid overflow, a <= (type(uint256).max - halfB) / RAY
     assembly {
@@ -721,7 +721,7 @@ library WadRayMath {
    * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
    * @param a Ray
    * @return b = a converted to wad, rounded half up to the nearest wad
-   **/
+   */
   function rayToWad(uint256 a) internal pure returns (uint256 b) {
     assembly {
       b := div(a, WAD_RAY_RATIO)
@@ -737,7 +737,7 @@ library WadRayMath {
    * @dev assembly optimized for improved gas savings, see https://twitter.com/transmissions11/status/1451131036377571328
    * @param a Wad
    * @return b = a converted in ray
-   **/
+   */
   function wadToRay(uint256 a) internal pure returns (uint256 b) {
     // to avoid overflow, b/WAD_RAY_RATIO == a
     assembly {
@@ -754,7 +754,7 @@ library WadRayMath {
  * @title IPoolAddressesProvider
  * @author Aave
  * @notice Defines the basic interface for a Pool Addresses Provider.
- **/
+ */
 interface IPoolAddressesProvider {
   /**
    * @dev Emitted when the market identifier is updated.
@@ -849,7 +849,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Returns the id of the Aave market to which this contract points to.
    * @return The market id
-   **/
+   */
   function getMarketId() external view returns (string memory);
 
   /**
@@ -891,27 +891,27 @@ interface IPoolAddressesProvider {
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
@@ -935,7 +935,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the ACL manager.
    * @param newAclManager The address of the new ACLManager
-   **/
+   */
   function setACLManager(address newAclManager) external;
 
   /**
@@ -959,7 +959,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the price oracle sentinel.
    * @param newPriceOracleSentinel The address of the new PriceOracleSentinel
-   **/
+   */
   function setPriceOracleSentinel(address newPriceOracleSentinel) external;
 
   /**
@@ -971,7 +971,7 @@ interface IPoolAddressesProvider {
   /**
    * @notice Updates the address of the data provider.
    * @param newDataProvider The address of the new DataProvider
-   **/
+   */
   function setPoolDataProvider(address newDataProvider) external;
 }
 
@@ -1245,7 +1245,7 @@ library DataTypes {
  * @title IPool
  * @author Aave
  * @notice Defines the basic interface for an Aave Pool.
- **/
+ */
 interface IPool {
   /**
    * @dev Emitted on mintUnbacked()
@@ -1254,7 +1254,7 @@ interface IPool {
    * @param onBehalfOf The beneficiary of the supplied assets, receiving the aTokens
    * @param amount The amount of supplied assets
    * @param referralCode The referral code used
-   **/
+   */
   event MintUnbacked(
     address indexed reserve,
     address user,
@@ -1269,7 +1269,7 @@ interface IPool {
    * @param backer The address paying for the backing
    * @param amount The amount added as backing
    * @param fee The amount paid in fees
-   **/
+   */
   event BackUnbacked(address indexed reserve, address indexed backer, uint256 amount, uint256 fee);
 
   /**
@@ -1279,7 +1279,7 @@ interface IPool {
    * @param onBehalfOf The beneficiary of the supply, receiving the aTokens
    * @param amount The amount supplied
    * @param referralCode The referral code used
-   **/
+   */
   event Supply(
     address indexed reserve,
     address user,
@@ -1294,7 +1294,7 @@ interface IPool {
    * @param user The address initiating the withdrawal, owner of aTokens
    * @param to The address that will receive the underlying
    * @param amount The amount to be withdrawn
-   **/
+   */
   event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);
 
   /**
@@ -1307,7 +1307,7 @@ interface IPool {
    * @param interestRateMode The rate mode: 1 for Stable, 2 for Variable
    * @param borrowRate The numeric rate at which the user has borrowed, expressed in ray
    * @param referralCode The referral code used
-   **/
+   */
   event Borrow(
     address indexed reserve,
     address user,
@@ -1325,7 +1325,7 @@ interface IPool {
    * @param repayer The address of the user initiating the repay(), providing the funds
    * @param amount The amount repaid
    * @param useATokens True if the repayment is done using aTokens, `false` if done with underlying asset directly
-   **/
+   */
   event Repay(
     address indexed reserve,
     address indexed user,
@@ -1339,7 +1339,7 @@ interface IPool {
    * @param reserve The address of the underlying asset of the reserve
    * @param user The address of the user swapping his rate mode
    * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
-   **/
+   */
   event SwapBorrowRateMode(
     address indexed reserve,
     address indexed user,
@@ -1357,28 +1357,28 @@ interface IPool {
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
@@ -1390,7 +1390,7 @@ interface IPool {
    * @param interestRateMode The flashloan mode: 0 for regular flashloan, 1 for Stable debt, 2 for Variable debt
    * @param premium The fee flash borrowed
    * @param referralCode The referral code used
-   **/
+   */
   event FlashLoan(
     address indexed target,
     address initiator,
@@ -1411,7 +1411,7 @@ interface IPool {
    * @param liquidator The address of the liquidator
    * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
    * to receive the underlying collateral asset directly
-   **/
+   */
   event LiquidationCall(
     address indexed collateralAsset,
     address indexed debtAsset,
@@ -1430,7 +1430,7 @@ interface IPool {
    * @param variableBorrowRate The next variable borrow rate
    * @param liquidityIndex The next liquidity index
    * @param variableBorrowIndex The next variable borrow index
-   **/
+   */
   event ReserveDataUpdated(
     address indexed reserve,
     uint256 liquidityRate,
@@ -1444,17 +1444,17 @@ interface IPool {
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
@@ -1463,16 +1463,17 @@ interface IPool {
   ) external;
 
   /**
-   * @dev Back the current unbacked underlying with `amount` and pay `fee`.
+   * @notice Back the current unbacked underlying with `amount` and pay `fee`.
    * @param asset The address of the underlying asset to back
    * @param amount The amount to back
    * @param fee The amount paid in fees
-   **/
+   * @return The backed amount
+   */
   function backUnbacked(
     address asset,
     uint256 amount,
     uint256 fee
-  ) external;
+  ) external returns (uint256);
 
   /**
    * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
@@ -1484,7 +1485,7 @@ interface IPool {
    *   is a different wallet
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function supply(
     address asset,
     uint256 amount,
@@ -1506,7 +1507,7 @@ interface IPool {
    * @param permitV The V parameter of ERC712 permit sig
    * @param permitR The R parameter of ERC712 permit sig
    * @param permitS The S parameter of ERC712 permit sig
-   **/
+   */
   function supplyWithPermit(
     address asset,
     uint256 amount,
@@ -1528,7 +1529,7 @@ interface IPool {
    *   wants to receive it on his own wallet, or a different address if the beneficiary is a
    *   different wallet
    * @return The final amount withdrawn
-   **/
+   */
   function withdraw(
     address asset,
     uint256 amount,
@@ -1549,7 +1550,7 @@ interface IPool {
    * @param onBehalfOf The address of the user who will receive the debt. Should be the address of the borrower itself
    * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
    * if he has been given credit delegation allowance
-   **/
+   */
   function borrow(
     address asset,
     uint256 amount,
@@ -1569,7 +1570,7 @@ interface IPool {
    * user calling the function if he wants to reduce/remove his own debt, or the address of any other
    * other borrower whose debt should be removed
    * @return The final amount repaid
-   **/
+   */
   function repay(
     address asset,
     uint256 amount,
@@ -1592,7 +1593,7 @@ interface IPool {
    * @param permitR The R parameter of ERC712 permit sig
    * @param permitS The S parameter of ERC712 permit sig
    * @return The final amount repaid
-   **/
+   */
   function repayWithPermit(
     address asset,
     uint256 amount,
@@ -1615,7 +1616,7 @@ interface IPool {
    * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
    * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
    * @return The final amount repaid
-   **/
+   */
   function repayWithATokens(
     address asset,
     uint256 amount,
@@ -1626,7 +1627,7 @@ interface IPool {
    * @notice Allows a borrower to swap his debt between stable and variable mode, or vice versa
    * @param asset The address of the underlying asset borrowed
    * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
-   **/
+   */
   function swapBorrowRateMode(address asset, uint256 interestRateMode) external;
 
   /**
@@ -1637,14 +1638,14 @@ interface IPool {
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
@@ -1657,7 +1658,7 @@ interface IPool {
    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
    * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
    * to receive the underlying collateral asset directly
-   **/
+   */
   function liquidationCall(
     address collateralAsset,
     address debtAsset,
@@ -1682,7 +1683,7 @@ interface IPool {
    * @param params Variadic packed params to pass to the receiver as extra information
    * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function flashLoan(
     address receiverAddress,
     address[] calldata assets,
@@ -1704,7 +1705,7 @@ interface IPool {
    * @param params Variadic packed params to pass to the receiver as extra information
    * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function flashLoanSimple(
     address receiverAddress,
     address asset,
@@ -1722,7 +1723,7 @@ interface IPool {
    * @return currentLiquidationThreshold The liquidation threshold of the user
    * @return ltv The loan to value of The user
    * @return healthFactor The current health factor of the user
-   **/
+   */
   function getUserAccountData(address user)
     external
     view
@@ -1744,7 +1745,7 @@ interface IPool {
    * @param stableDebtAddress The address of the StableDebtToken that will be assigned to the reserve
    * @param variableDebtAddress The address of the VariableDebtToken that will be assigned to the reserve
    * @param interestRateStrategyAddress The address of the interest rate strategy contract
-   **/
+   */
   function initReserve(
     address asset,
     address aTokenAddress,
@@ -1757,7 +1758,7 @@ interface IPool {
    * @notice Drop a reserve
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
-   **/
+   */
   function dropReserve(address asset) external;
 
   /**
@@ -1765,7 +1766,7 @@ interface IPool {
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
    * @param rateStrategyAddress The address of the interest rate strategy contract
-   **/
+   */
   function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
     external;
 
@@ -1774,7 +1775,7 @@ interface IPool {
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
    * @param configuration The new configuration bitmap
-   **/
+   */
   function setConfiguration(address asset, DataTypes.ReserveConfigurationMap calldata configuration)
     external;
 
@@ -1782,7 +1783,7 @@ interface IPool {
    * @notice Returns the configuration of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The configuration of the reserve
-   **/
+   */
   function getConfiguration(address asset)
     external
     view
@@ -1792,14 +1793,14 @@ interface IPool {
    * @notice Returns the configuration of the user across all the reserves
    * @param user The user address
    * @return The configuration of the user
-   **/
+   */
   function getUserConfiguration(address user)
     external
     view
     returns (DataTypes.UserConfigurationMap memory);
 
   /**
-   * @notice Returns the normalized income normalized income of the reserve
+   * @notice Returns the normalized income of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The reserve's normalized income
    */
@@ -1807,6 +1808,13 @@ interface IPool {
 
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
@@ -1816,7 +1824,7 @@ interface IPool {
    * @notice Returns the state and configuration of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The state and configuration data of the reserve
-   **/
+   */
   function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
 
   /**
@@ -1842,20 +1850,20 @@ interface IPool {
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
@@ -1948,7 +1956,7 @@ interface IPool {
   /**
    * @notice Mints the assets accrued through the reserve factor to the treasury in the form of aTokens
    * @param assets The list of reserves for which the minting needs to be executed
-   **/
+   */
   function mintToTreasury(address[] calldata assets) external;
 
   /**
@@ -1974,7 +1982,7 @@ interface IPool {
    *   is a different wallet
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function deposit(
     address asset,
     uint256 amount,
@@ -1986,17 +1994,17 @@ interface IPool {
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
@@ -2006,13 +2014,14 @@ interface IScaledBalanceToken {
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
@@ -2027,7 +2036,7 @@ interface IScaledBalanceToken {
    * at the moment of the update
    * @param user The user whose balance is calculated
    * @return The scaled balance of the user
-   **/
+   */
   function scaledBalanceOf(address user) external view returns (uint256);
 
   /**
@@ -2035,20 +2044,20 @@ interface IScaledBalanceToken {
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
 
@@ -2056,181 +2065,28 @@ interface IScaledBalanceToken {
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
   function handleAction(
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
     address user,
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
+    uint256 totalSupply,
+    uint256 userBalance
+  ) external;
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
@@ -2242,7 +2098,7 @@ interface IInitializableAToken {
    * @param aTokenName The name of the aToken
    * @param aTokenSymbol The symbol of the aToken
    * @param params A set of encoded parameters for additional initialization
-   **/
+   */
   event Initialized(
     address indexed underlyingAsset,
     address indexed pool,
@@ -2281,15 +2137,15 @@ interface IInitializableAToken {
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
@@ -2315,7 +2171,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param receiverOfUnderlying The address that will receive the underlying
    * @param amount The amount being burned
    * @param index The next liquidity index of the reserve
-   **/
+   */
   function burn(
     address from,
     address receiverOfUnderlying,
@@ -2335,7 +2191,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param from The address getting liquidated, current owner of the aTokens
    * @param to The recipient
    * @param value The amount of tokens getting transferred
-   **/
+   */
   function transferOnLiquidation(
     address from,
     address to,
@@ -2345,10 +2201,10 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -2356,9 +2212,14 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * transfer is concluded. However in the future there may be aTokens that allow for example to stake the underlying
    * to receive LM rewards. In that case, `handleRepayment()` would perform the staking of the underlying asset.
    * @param user The user executing the repayment
+   * @param onBehalfOf The address of the user who will get his debt reduced/removed
    * @param amount The amount getting repaid
-   **/
-  function handleRepayment(address user, uint256 amount) external;
+   */
+  function handleRepayment(
+    address user,
+    address onBehalfOf,
+    uint256 amount
+  ) external;
 
   /**
    * @notice Allow passing a signed message to approve spending
@@ -2385,13 +2246,13 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -2405,7 +2266,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @notice Returns the nonce for owner.
    * @param owner The address of the owner
    * @return The nonce of the owner
-   **/
+   */
   function nonces(address owner) external view returns (uint256);
 
   /**
@@ -2454,7 +2315,7 @@ interface IERC20Detailed is IERC20 {
  * @title IACLManager
  * @author Aave
  * @notice Defines the basic interface for the ACL Manager
- **/
+ */
 interface IACLManager {
   /**
    * @notice Returns the contract address of the PoolAddressesProvider
@@ -2570,7 +2431,7 @@ interface IACLManager {
   function addFlashBorrower(address borrower) external;
 
   /**
-   * @notice Removes an admin as FlashBorrower
+   * @notice Removes an address as FlashBorrower
    * @param borrower The address of the FlashBorrower to remove
    */
   function removeFlashBorrower(address borrower) external;
@@ -2625,14 +2486,14 @@ interface IACLManager {
  * @title IncentivizedERC20
  * @author Aave, inspired by the Openzeppelin ERC20 implementation
  * @notice Basic ERC20 implementation
- **/
+ */
 abstract contract IncentivizedERC20 is Context, IERC20Detailed {
   using WadRayMath for uint256;
   using SafeCast for uint256;
 
   /**
    * @dev Only pool admin can call functions marked by this modifier.
-   **/
+   */
   modifier onlyPoolAdmin() {
     IACLManager aclManager = IACLManager(_addressesProvider.getACLManager());
     require(aclManager.isPoolAdmin(msg.sender), Errors.CALLER_NOT_POOL_ADMIN);
@@ -2641,7 +2502,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
 
   /**
    * @dev Only pool can call functions marked by this modifier.
-   **/
+   */
   modifier onlyPool() {
     require(_msgSender() == address(POOL), Errors.CALLER_MUST_BE_POOL);
     _;
@@ -2719,7 +2580,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
   /**
    * @notice Returns the address of the Incentives Controller contract
    * @return The address of the Incentives Controller
-   **/
+   */
   function getIncentivesController() external view virtual returns (IAaveIncentivesController) {
     return _incentivesController;
   }
@@ -2727,7 +2588,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
   /**
    * @notice Sets a new Incentives Controller
    * @param controller the new Incentives controller
-   **/
+   */
   function setIncentivesController(IAaveIncentivesController controller) external onlyPoolAdmin {
     _incentivesController = controller;
   }
@@ -2773,7 +2634,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
    * @param spender The user allowed to spend on behalf of _msgSender()
    * @param addedValue The amount being added to the allowance
    * @return `true`
-   **/
+   */
   function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
     _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
     return true;
@@ -2784,7 +2645,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
    * @param spender The user allowed to spend on behalf of _msgSender()
    * @param subtractedValue The amount being subtracted to the allowance
    * @return `true`
-   **/
+   */
   function decreaseAllowance(address spender, uint256 subtractedValue)
     external
     virtual
@@ -2818,7 +2679,6 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
         incentivesControllerLocal.handleAction(recipient, currentTotalSupply, oldRecipientBalance);
       }
     }
-    emit Transfer(sender, recipient, amount);
   }
 
   /**
@@ -2865,7 +2725,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
  * @title MintableIncentivizedERC20
  * @author Aave
  * @notice Implements mint and burn functions for IncentivizedERC20
- **/
+ */
 abstract contract MintableIncentivizedERC20 is IncentivizedERC20 {
   /**
    * @dev Constructor.
@@ -2925,7 +2785,7 @@ abstract contract MintableIncentivizedERC20 is IncentivizedERC20 {
  * @title ScaledBalanceTokenBase
  * @author Aave
  * @notice Basic ERC20 implementation of scaled balance token
- **/
+ */
 abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBalanceToken {
   using WadRayMath for uint256;
   using SafeCast for uint256;
@@ -2978,7 +2838,7 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
    * @param amount The amount of tokens getting minted
    * @param index The next liquidity index of the reserve
    * @return `true` if the the previous balance of the user was 0
-   **/
+   */
   function _mintScaled(
     address caller,
     address onBehalfOf,
@@ -3008,9 +2868,10 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
    * @dev In some instances, a burn transaction will emit a mint event
    * if the amount to burn is less than the interest that the user accrued
    * @param user The user which debt is burnt
+   * @param target The address that will receive the underlying, if any
    * @param amount The amount getting burned
    * @param index The variable debt index of the reserve
-   **/
+   */
   function _burnScaled(
     address user,
     address target,
@@ -3038,6 +2899,46 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
       emit Burn(user, target, amountToBurn, balanceIncrease, index);
     }
   }
+
+  /**
+   * @notice Implements the basic logic to transfer scaled balance tokens between two users
+   * @dev It emits a mint event with the interest accrued per user
+   * @param sender The source address
+   * @param recipient The destination address
+   * @param amount The amount getting transferred
+   * @param index The next liquidity index of the reserve
+   */
+  function _transfer(
+    address sender,
+    address recipient,
+    uint256 amount,
+    uint256 index
+  ) internal {
+    uint256 senderScaledBalance = super.balanceOf(sender);
+    uint256 senderBalanceIncrease = senderScaledBalance.rayMul(index) -
+      senderScaledBalance.rayMul(_userState[sender].additionalData);
+
+    uint256 recipientScaledBalance = super.balanceOf(recipient);
+    uint256 recipientBalanceIncrease = recipientScaledBalance.rayMul(index) -
+      recipientScaledBalance.rayMul(_userState[recipient].additionalData);
+
+    _userState[sender].additionalData = index.toUint128();
+    _userState[recipient].additionalData = index.toUint128();
+
+    super._transfer(sender, recipient, amount.rayDiv(index).toUint128());
+
+    if (senderBalanceIncrease > 0) {
+      emit Transfer(address(0), sender, senderBalanceIncrease);
+      emit Mint(_msgSender(), sender, senderBalanceIncrease, senderBalanceIncrease, index);
+    }
+
+    if (sender != recipient && recipientBalanceIncrease > 0) {
+      emit Transfer(address(0), recipient, recipientBalanceIncrease);
+      emit Mint(_msgSender(), recipient, recipientBalanceIncrease, recipientBalanceIncrease, index);
+    }
+
+    emit Transfer(sender, recipient, amount);
+  }
 }
 
 /**
@@ -3121,7 +3022,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   bytes32 public constant PERMIT_TYPEHASH =
     keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
 
-  uint256 public constant ATOKEN_REVISION = 0x1;
+  uint256 public constant ATOKEN_REVISION = 0x2;
 
   address internal _treasury;
   address internal _underlyingAsset;
@@ -3152,7 +3053,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
     string calldata aTokenName,
     string calldata aTokenSymbol,
     bytes calldata params
-  ) external override initializer {
+  ) public virtual override initializer {
     require(initializingPool == POOL, Errors.POOL_ADDRESSES_DO_NOT_MATCH);
     _setName(aTokenName);
     _setSymbol(aTokenSymbol);
@@ -3200,7 +3101,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   }
 
   /// @inheritdoc IAToken
-  function mintToTreasury(uint256 amount, uint256 index) external override onlyPool {
+  function mintToTreasury(uint256 amount, uint256 index) external virtual override onlyPool {
     if (amount == 0) {
       return;
     }
@@ -3212,12 +3113,10 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
     address from,
     address to,
     uint256 value
-  ) external override onlyPool {
+  ) external virtual override onlyPool {
     // Being a normal transfer, the Transfer() and BalanceTransfer() are emitted
     // so no need to emit a specific event here
     _transfer(from, to, value, false);
-
-    emit Transfer(from, to, value);
   }
 
   /// @inheritdoc IERC20
@@ -3258,7 +3157,11 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   }
 
   /// @inheritdoc IAToken
-  function handleRepayment(address user, uint256 amount) external virtual override onlyPool {
+  function handleRepayment(
+    address user,
+    address onBehalfOf,
+    uint256 amount
+  ) external virtual override onlyPool {
     // Intentionally left blank
   }
 
@@ -3295,13 +3198,13 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @param to The destination address
    * @param amount The amount getting transferred
    * @param validate True if the transfer needs to be validated, false otherwise
-   **/
+   */
   function _transfer(
     address from,
     address to,
     uint256 amount,
     bool validate
-  ) internal {
+  ) internal virtual {
     address underlyingAsset = _underlyingAsset;
 
     uint256 index = POOL.getReserveNormalizedIncome(underlyingAsset);
@@ -3309,13 +3212,13 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
     uint256 fromBalanceBefore = super.balanceOf(from).rayMul(index);
     uint256 toBalanceBefore = super.balanceOf(to).rayMul(index);
 
-    super._transfer(from, to, amount.rayDiv(index).toUint128());
+    super._transfer(from, to, amount, index);
 
     if (validate) {
       POOL.finalizeTransfer(underlyingAsset, from, to, amount, fromBalanceBefore, toBalanceBefore);
     }
 
-    emit BalanceTransfer(from, to, amount, index);
+    emit BalanceTransfer(from, to, amount.rayDiv(index), index);
   }
 
   /**
@@ -3323,18 +3226,18 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @param from The source address
    * @param to The destination address
    * @param amount The amount getting transferred
-   **/
+   */
   function _transfer(
     address from,
     address to,
     uint128 amount
-  ) internal override {
+  ) internal virtual override {
     _transfer(from, to, amount, true);
   }
 
   /**
    * @dev Overrides the base function to fully implement IAToken
-   * @dev see `IncentivizedERC20.DOMAIN_SEPARATOR()` for more detailed documentation
+   * @dev see `EIP712Base.DOMAIN_SEPARATOR()` for more detailed documentation
    */
   function DOMAIN_SEPARATOR() public view override(IAToken, EIP712Base) returns (bytes32) {
     return super.DOMAIN_SEPARATOR();
@@ -3342,7 +3245,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
 
   /**
    * @dev Overrides the base function to fully implement IAToken
-   * @dev see `IncentivizedERC20.nonces()` for more detailed documentation
+   * @dev see `EIP712Base.nonces()` for more detailed documentation
    */
   function nonces(address owner) public view override(IAToken, EIP712Base) returns (uint256) {
     return super.nonces(owner);
```
