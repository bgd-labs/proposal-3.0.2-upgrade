```diff
diff --git a/src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol b/src/downloads/DEFAULT_A_TOKEN_IMPL_REV_1.sol
index dd155ea..61d1748 100644
--- a/src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol
+++ b/src/downloads/DEFAULT_A_TOKEN_IMPL_REV_1.sol
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
@@ -85,11 +81,7 @@ interface IERC20 {
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
@@ -110,12 +102,7 @@ library GPv2SafeERC20 {
 
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
@@ -594,7 +581,7 @@ library Errors {
   string public constant PRICE_ORACLE_SENTINEL_CHECK_FAILED = '59'; // 'Price oracle sentinel validation failed'
   string public constant ASSET_NOT_BORROWABLE_IN_ISOLATION = '60'; // 'Asset is not borrowable in isolation mode'
   string public constant RESERVE_ALREADY_INITIALIZED = '61'; // 'Reserve has already been initialized'
-  string public constant USER_IN_ISOLATION_MODE = '62'; // 'User is in isolation mode'
+  string public constant USER_IN_ISOLATION_MODE_OR_LTV_ZERO = '62'; // 'User is in isolation mode or ltv is zero'
   string public constant INVALID_LTV = '63'; // 'Invalid ltv parameter for the reserve'
   string public constant INVALID_LIQ_THRESHOLD = '64'; // 'Invalid liquidity threshold parameter for the reserve'
   string public constant INVALID_LIQ_BONUS = '65'; // 'Invalid liquidity bonus parameter for the reserve'
@@ -1052,11 +1039,7 @@ library DataTypes {
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
@@ -1469,11 +1452,7 @@ interface IPool {
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
@@ -1486,12 +1465,7 @@ interface IPool {
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
@@ -1530,11 +1504,7 @@ interface IPool {
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
@@ -1671,7 +1641,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanReceiver interface
    * @param assets The addresses of the assets being flash-borrowed
    * @param amounts The amounts of the assets being flash-borrowed
@@ -1698,7 +1668,7 @@ interface IPool {
    * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
    * as long as the amount taken plus a fee is returned.
    * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
-   * into consideration. For further details please visit https://developers.aave.com
+   * into consideration. For further details please visit https://docs.aave.com/developers/
    * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
    * @param asset The address of the asset being flash-borrowed
    * @param amount The amount of the asset being flash-borrowed
@@ -1724,7 +1694,9 @@ interface IPool {
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
@@ -1767,8 +1739,10 @@ interface IPool {
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
@@ -1776,28 +1750,28 @@ interface IPool {
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
@@ -1965,11 +1939,7 @@ interface IPool {
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
@@ -1983,12 +1953,7 @@ interface IPool {
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
@@ -2075,11 +2040,7 @@ interface IAaveIncentivesController {
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
@@ -2172,12 +2133,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -2192,11 +2148,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -2215,11 +2167,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -2275,11 +2223,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
 
 /*
@@ -2539,12 +2483,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
@@ -2601,13 +2540,10 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
 
@@ -2646,11 +2582,10 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
@@ -2661,11 +2596,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
@@ -2687,11 +2618,7 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
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
@@ -2812,12 +2739,9 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
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
 
@@ -2872,12 +2796,7 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
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
 
@@ -2908,12 +2827,7 @@ abstract contract ScaledBalanceTokenBase is MintableIncentivizedERC20, IScaledBa
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
@@ -3022,7 +2936,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   bytes32 public constant PERMIT_TYPEHASH =
     keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
 
-  uint256 public constant ATOKEN_REVISION = 0x1;
+  uint256 public constant ATOKEN_REVISION = 0x2;
 
   address internal _treasury;
   address internal _underlyingAsset;
@@ -3036,10 +2950,9 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @dev Constructor.
    * @param pool The address of the Pool contract
    */
-  constructor(IPool pool)
-    ScaledBalanceTokenBase(pool, 'ATOKEN_IMPL', 'ATOKEN_IMPL', 0)
-    EIP712Base()
-  {
+  constructor(
+    IPool pool
+  ) ScaledBalanceTokenBase(pool, 'ATOKEN_IMPL', 'ATOKEN_IMPL', 0) EIP712Base() {
     // Intentionally left blank
   }
 
@@ -3120,13 +3033,9 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   }
 
   /// @inheritdoc IERC20
-  function balanceOf(address user)
-    public
-    view
-    virtual
-    override(IncentivizedERC20, IERC20)
-    returns (uint256)
-  {
+  function balanceOf(
+    address user
+  ) public view virtual override(IncentivizedERC20, IERC20) returns (uint256) {
     return super.balanceOf(user).rayMul(POOL.getReserveNormalizedIncome(_underlyingAsset));
   }
 
@@ -3199,12 +3108,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @param amount The amount getting transferred
    * @param validate True if the transfer needs to be validated, false otherwise
    */
-  function _transfer(
-    address from,
-    address to,
-    uint256 amount,
-    bool validate
-  ) internal virtual {
+  function _transfer(address from, address to, uint256 amount, bool validate) internal virtual {
     address underlyingAsset = _underlyingAsset;
 
     uint256 index = POOL.getReserveNormalizedIncome(underlyingAsset);
@@ -3227,11 +3131,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @param to The destination address
    * @param amount The amount getting transferred
    */
-  function _transfer(
-    address from,
-    address to,
-    uint128 amount
-  ) internal virtual override {
+  function _transfer(address from, address to, uint128 amount) internal virtual override {
     _transfer(from, to, amount, true);
   }
 
@@ -3257,11 +3157,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   }
 
   /// @inheritdoc IAToken
-  function rescueTokens(
-    address token,
-    address to,
-    uint256 amount
-  ) external override onlyPoolAdmin {
+  function rescueTokens(address token, address to, uint256 amount) external override onlyPoolAdmin {
     require(token != _underlyingAsset, Errors.UNDERLYING_CANNOT_BE_RESCUED);
     IERC20(token).safeTransfer(to, amount);
   }
```
