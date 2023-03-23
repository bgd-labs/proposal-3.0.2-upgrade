```diff
diff --git a/src/downloads/mainnet/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1.sol b/src/downloads/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1.sol
index caaf644..da71029 100644
--- a/src/downloads/mainnet/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1.sol
+++ b/src/downloads/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1.sol
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
@@ -598,7 +594,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -932,11 +928,7 @@ library DataTypes {
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
@@ -1349,11 +1341,7 @@ interface IPool {
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
@@ -1366,12 +1354,7 @@ interface IPool {
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
@@ -1410,11 +1393,7 @@ interface IPool {
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
@@ -1551,7 +1530,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -1578,7 +1557,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -1604,7 +1583,9 @@ interface IPool {
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
@@ -1647,8 +1628,10 @@ interface IPool {
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
@@ -1656,28 +1639,28 @@ interface IPool {
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
@@ -1845,11 +1828,7 @@ interface IPool {
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
@@ -1863,12 +1842,7 @@ interface IPool {
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
@@ -1885,11 +1859,7 @@ interface IAaveIncentivesController {
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
@@ -2041,11 +2011,7 @@ interface IVariableDebtToken is IScaledBalanceToken, IInitializableDebtToken {
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
@@ -2262,12 +2228,10 @@ abstract contract DebtTokenBase is
   }
 
   /// @inheritdoc ICreditDelegationToken
-  function borrowAllowance(address fromUser, address toUser)
-    external
-    view
-    override
-    returns (uint256)
-  {
+  function borrowAllowance(
+    address fromUser,
+    address toUser
+  ) external view override returns (uint256) {
     return _borrowAllowances[fromUser][toUser];
   }
 
@@ -2277,11 +2241,7 @@ abstract contract DebtTokenBase is
    * @param delegatee The address receiving the delegated borrowing power
    * @param amount The allowance amount being delegated.
    */
-  function _approveDelegation(
-    address delegator,
-    address delegatee,
-    uint256 amount
-  ) internal {
+  function _approveDelegation(address delegator, address delegatee, uint256 amount) internal {
     _borrowAllowances[delegator][delegatee] = amount;
     emit BorrowAllowanceDelegated(delegator, delegatee, _underlyingAsset, amount);
   }
@@ -2292,11 +2252,7 @@ abstract contract DebtTokenBase is
    * @param delegatee The address receiving the delegated borrowing power
    * @param amount The amount to subtract from the current allowance
    */
-  function _decreaseBorrowAllowance(
-    address delegator,
-    address delegatee,
-    uint256 amount
-  ) internal {
+  function _decreaseBorrowAllowance(address delegator, address delegatee, uint256 amount) internal {
     uint256 newAllowance = _borrowAllowances[delegator][delegatee] - amount;
 
     _borrowAllowances[delegator][delegatee] = newAllowance;
@@ -2541,12 +2497,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
    * @param symbol The symbol of the token
    * @param decimals The number of decimals of the token
    */
-  constructor(
-    IPool pool,
-    string memory name,
-    string memory symbol,
-    uint8 decimals
-  ) {
+  constructor(IPool pool, string memory name, string memory symbol, uint8 decimals) {
     _addressesProvider = pool.ADDRESSES_PROVIDER();
     _name = name;
     _symbol = symbol;
@@ -2603,13 +2554,10 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
   }
 
   /// @inheritdoc IERC20
-  function allowance(address owner, address spender)
-    external
-    view
-    virtual
-    override
-    returns (uint256)
-  {
+  function allowance(
+    address owner,
+    address spender
+  ) external view virtual override returns (uint256) {
     return _allowances[owner][spender];
   }
 
@@ -2648,11 +2596,10 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
    * @param subtractedValue The amount being subtracted to the allowance
    * @return `true`
    */
-  function decreaseAllowance(address spender, uint256 subtractedValue)
-    external
-    virtual
-    returns (bool)
-  {
+  function decreaseAllowance(
+    address spender,
+    uint256 subtractedValue
+  ) external virtual returns (bool) {
     _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
     return true;
   }
@@ -2663,11 +2610,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
    * @param recipient The destination address
    * @param amount The amount getting transferred
    */
-  function _transfer(
-    address sender,
-    address recipient,
-    uint128 amount
-  ) internal virtual {
+  function _transfer(address sender, address recipient, uint128 amount) internal virtual {
     uint128 oldSenderBalance = _userState[sender].balance;
     _userState[sender].balance = oldSenderBalance - amount;
     uint128 oldRecipientBalance = _userState[recipient].balance;
@@ -2689,11 +2632,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
    * @param spender The address approved for spending
    * @param amount The amount of tokens to approve spending of
    */
-  function _approve(
-    address owner,
-    address spender,
-    uint256 amount
-  ) internal virtual {
+  function _approve(address owner, address spender, uint256 amount) internal virtual {
     _allowances[owner][spender] = amount;
     emit Approval(owner, spender, amount);
   }
@@ -2814,12 +2753,9 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
   }
 
   /// @inheritdoc IScaledBalanceToken
-  function getScaledUserBalanceAndSupply(address user)
-    external
-    view
-    override
-    returns (uint256, uint256)
-  {
+  function getScaledUserBalanceAndSupply(
+    address user
+  ) external view override returns (uint256, uint256) {
     return (super.balanceOf(user), super.totalSupply());
   }
 
@@ -2874,12 +2810,7 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
    * @param amount The amount getting burned
    * @param index The variable debt index of the reserve
    */
-  function _burnScaled(
-    address user,
-    address target,
-    uint256 amount,
-    uint256 index
-  ) internal {
+  function _burnScaled(address user, address target, uint256 amount, uint256 index) internal {
     uint256 amountScaled = amount.rayDiv(index);
     require(amountScaled != 0, Errors.INVALID_BURN_AMOUNT);
 
@@ -2910,12 +2841,7 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
    * @param amount The amount getting transferred
    * @param index The next liquidity index of the reserve
    */
-  function _transfer(
-    address sender,
-    address recipient,
-    uint256 amount,
-    uint256 index
-  ) internal {
+  function _transfer(address sender, address recipient, uint256 amount, uint256 index) internal {
     uint256 senderScaledBalance = super.balanceOf(sender);
     uint256 senderBalanceIncrease = senderScaledBalance.rayMul(index) -
       senderScaledBalance.rayMul(_userState[sender].additionalData);
@@ -2954,13 +2880,15 @@ contract VariableDebtToken is DebtTokenBase, ScaledBalanceTokenBase, IVariableDe
   using WadRayMath for uint256;
   using SafeCast for uint256;
 
-  uint256 public constant DEBT_TOKEN_REVISION = 0x1;
+  uint256 public constant DEBT_TOKEN_REVISION = 0x2;
 
   /**
    * @dev Constructor.
    * @param pool The address of the Pool contract
    */
-  constructor(IPool pool)
+  constructor(
+    IPool pool
+  )
     DebtTokenBase()
     ScaledBalanceTokenBase(pool, 'VARIABLE_DEBT_TOKEN_IMPL', 'VARIABLE_DEBT_TOKEN_IMPL', 0)
   {
@@ -3063,11 +2991,7 @@ contract VariableDebtToken is DebtTokenBase, ScaledBalanceTokenBase, IVariableDe
     revert(Errors.OPERATION_NOT_SUPPORTED);
   }
 
-  function transferFrom(
-    address,
-    address,
-    uint256
-  ) external virtual override returns (bool) {
+  function transferFrom(address, address, uint256) external virtual override returns (bool) {
     revert(Errors.OPERATION_NOT_SUPPORTED);
   }
 
```
