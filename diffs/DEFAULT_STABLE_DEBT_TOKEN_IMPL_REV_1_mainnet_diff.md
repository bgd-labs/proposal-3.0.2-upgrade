```diff
diff --git a/src/downloads/mainnet/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol b/src/downloads/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol
index e0763e5..8a4f8b5 100644
--- a/src/downloads/mainnet/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol
+++ b/src/downloads/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol
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
@@ -295,11 +291,10 @@ library MathUtils {
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
@@ -366,11 +361,10 @@ library MathUtils {
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
@@ -441,7 +435,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -487,11 +481,7 @@ interface IAaveIncentivesController {
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
@@ -796,11 +786,7 @@ library DataTypes {
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
@@ -1213,11 +1199,7 @@ interface IPool {
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
@@ -1230,12 +1212,7 @@ interface IPool {
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
@@ -1274,11 +1251,7 @@ interface IPool {
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
@@ -1415,7 +1388,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -1442,7 +1415,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -1468,7 +1441,9 @@ interface IPool {
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
@@ -1511,8 +1486,10 @@ interface IPool {
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
@@ -1520,28 +1497,28 @@ interface IPool {
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
@@ -1709,11 +1686,7 @@ interface IPool {
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
@@ -1727,12 +1700,7 @@ interface IPool {
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
@@ -1847,13 +1815,7 @@ interface IStableDebtToken is IInitializableDebtToken {
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
@@ -1895,15 +1857,7 @@ interface IStableDebtToken is IInitializableDebtToken {
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
@@ -2139,12 +2093,10 @@ abstract contract DebtTokenBase is
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
 
@@ -2154,11 +2106,7 @@ abstract contract DebtTokenBase is
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
@@ -2169,11 +2117,7 @@ abstract contract DebtTokenBase is
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
@@ -2672,12 +2616,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
@@ -2734,13 +2673,10 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
 
@@ -2779,11 +2715,10 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
@@ -2794,11 +2729,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
@@ -2820,11 +2751,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
@@ -2865,7 +2792,7 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
   using WadRayMath for uint256;
   using SafeCast for uint256;
 
-  uint256 public constant DEBT_TOKEN_REVISION = 0x1;
+  uint256 public constant DEBT_TOKEN_REVISION = 0x2;
 
   // Map of users address and the timestamp of their last update (userAddress => lastUpdateTimestamp)
   mapping(address => uint40) internal _timestamps;
@@ -2879,10 +2806,9 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
    * @dev Constructor.
    * @param pool The address of the Pool contract
    */
-  constructor(IPool pool)
-    DebtTokenBase()
-    IncentivizedERC20(pool, 'STABLE_DEBT_TOKEN_IMPL', 'STABLE_DEBT_TOKEN_IMPL', 0)
-  {
+  constructor(
+    IPool pool
+  ) DebtTokenBase() IncentivizedERC20(pool, 'STABLE_DEBT_TOKEN_IMPL', 'STABLE_DEBT_TOKEN_IMPL', 0) {
     // Intentionally left blank
   }
 
@@ -2966,17 +2892,7 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
     address onBehalfOf,
     uint256 amount,
     uint256 rate
-  )
-    external
-    virtual
-    override
-    onlyPool
-    returns (
-      bool,
-      uint256,
-      uint256
-    )
-  {
+  ) external virtual override onlyPool returns (bool, uint256, uint256) {
     MintLocalVars memory vars;
 
     if (user != onBehalfOf) {
@@ -3025,13 +2941,10 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
   }
 
   /// @inheritdoc IStableDebtToken
-  function burn(address from, uint256 amount)
-    external
-    virtual
-    override
-    onlyPool
-    returns (uint256, uint256)
-  {
+  function burn(
+    address from,
+    uint256 amount
+  ) external virtual override onlyPool returns (uint256, uint256) {
     (, uint256 currentBalance, uint256 balanceIncrease) = _calculateBalanceIncrease(from);
 
     uint256 previousSupply = totalSupply();
@@ -3104,15 +3017,9 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
    * @return The new principal balance
    * @return The balance increase
    */
-  function _calculateBalanceIncrease(address user)
-    internal
-    view
-    returns (
-      uint256,
-      uint256,
-      uint256
-    )
-  {
+  function _calculateBalanceIncrease(
+    address user
+  ) internal view returns (uint256, uint256, uint256) {
     uint256 previousPrincipalBalance = super.balanceOf(user);
 
     if (previousPrincipalBalance == 0) {
@@ -3129,17 +3036,7 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
   }
 
   /// @inheritdoc IStableDebtToken
-  function getSupplyData()
-    external
-    view
-    override
-    returns (
-      uint256,
-      uint256,
-      uint256,
-      uint40
-    )
-  {
+  function getSupplyData() external view override returns (uint256, uint256, uint256, uint40) {
     uint256 avgRate = _avgStableRate;
     return (super.totalSupply(), _calcTotalSupply(avgRate), avgRate, _totalSupplyTimestamp);
   }
@@ -3196,11 +3093,7 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
    * @param amount The amount being minted
    * @param oldTotalSupply The total supply before the minting event
    */
-  function _mint(
-    address account,
-    uint256 amount,
-    uint256 oldTotalSupply
-  ) internal {
+  function _mint(address account, uint256 amount, uint256 oldTotalSupply) internal {
     uint128 castAmount = amount.toUint128();
     uint128 oldAccountBalance = _userState[account].balance;
     _userState[account].balance = oldAccountBalance + castAmount;
@@ -3216,11 +3109,7 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
    * @param amount The amount being burned
    * @param oldTotalSupply The total supply before the burning event
    */
-  function _burn(
-    address account,
-    uint256 amount,
-    uint256 oldTotalSupply
-  ) internal {
+  function _burn(address account, uint256 amount, uint256 oldTotalSupply) internal {
     uint128 castAmount = amount.toUint128();
     uint128 oldAccountBalance = _userState[account].balance;
     _userState[account].balance = oldAccountBalance - castAmount;
@@ -3251,11 +3140,7 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
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
