```diff
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
index 7dc5593..326d738 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IAToken.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IAToken.sol
index dc3b48a..441d3a2 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IAToken.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IAToken.sol
@@ -9,15 +9,15 @@ import {IInitializableAToken} from './IInitializableAToken.sol';
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
@@ -43,7 +43,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param receiverOfUnderlying The address that will receive the underlying
    * @param amount The amount being burned
    * @param index The next liquidity index of the reserve
-   **/
+   */
   function burn(
     address from,
     address receiverOfUnderlying,
@@ -63,7 +63,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @param from The address getting liquidated, current owner of the aTokens
    * @param to The recipient
    * @param value The amount of tokens getting transferred
-   **/
+   */
   function transferOnLiquidation(
     address from,
     address to,
@@ -73,10 +73,10 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -84,9 +84,14 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -113,13 +118,13 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
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
@@ -133,7 +138,7 @@ interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
    * @notice Returns the nonce for owner.
    * @param owner The address of the owner
    * @return The nonce of the owner
-   **/
+   */
   function nonces(address owner) external view returns (uint256);
 
   /**
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
index 3ae73de..0cfc559 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
@@ -5,172 +5,19 @@ pragma solidity ^0.8.0;
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
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol
index d34bdd8..0b16baa 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol
@@ -8,7 +8,7 @@ import {IPool} from './IPool.sol';
  * @title IInitializableAToken
  * @author Aave
  * @notice Interface for the initialize function on AToken
- **/
+ */
 interface IInitializableAToken {
   /**
    * @dev Emitted when an aToken is initialized
@@ -20,7 +20,7 @@ interface IInitializableAToken {
    * @param aTokenName The name of the aToken
    * @param aTokenSymbol The symbol of the aToken
    * @param params A set of encoded parameters for additional initialization
-   **/
+   */
   event Initialized(
     address indexed underlyingAsset,
     address indexed pool,
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IPool.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IPool.sol
index 0bea9aa..3faed92 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IPool.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IPool.sol
@@ -8,7 +8,7 @@ import {DataTypes} from '../protocol/libraries/types/DataTypes.sol';
  * @title IPool
  * @author Aave
  * @notice Defines the basic interface for an Aave Pool.
- **/
+ */
 interface IPool {
   /**
    * @dev Emitted on mintUnbacked()
@@ -17,7 +17,7 @@ interface IPool {
    * @param onBehalfOf The beneficiary of the supplied assets, receiving the aTokens
    * @param amount The amount of supplied assets
    * @param referralCode The referral code used
-   **/
+   */
   event MintUnbacked(
     address indexed reserve,
     address user,
@@ -32,7 +32,7 @@ interface IPool {
    * @param backer The address paying for the backing
    * @param amount The amount added as backing
    * @param fee The amount paid in fees
-   **/
+   */
   event BackUnbacked(address indexed reserve, address indexed backer, uint256 amount, uint256 fee);
 
   /**
@@ -42,7 +42,7 @@ interface IPool {
    * @param onBehalfOf The beneficiary of the supply, receiving the aTokens
    * @param amount The amount supplied
    * @param referralCode The referral code used
-   **/
+   */
   event Supply(
     address indexed reserve,
     address user,
@@ -57,7 +57,7 @@ interface IPool {
    * @param user The address initiating the withdrawal, owner of aTokens
    * @param to The address that will receive the underlying
    * @param amount The amount to be withdrawn
-   **/
+   */
   event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);
 
   /**
@@ -70,7 +70,7 @@ interface IPool {
    * @param interestRateMode The rate mode: 1 for Stable, 2 for Variable
    * @param borrowRate The numeric rate at which the user has borrowed, expressed in ray
    * @param referralCode The referral code used
-   **/
+   */
   event Borrow(
     address indexed reserve,
     address user,
@@ -88,7 +88,7 @@ interface IPool {
    * @param repayer The address of the user initiating the repay(), providing the funds
    * @param amount The amount repaid
    * @param useATokens True if the repayment is done using aTokens, `false` if done with underlying asset directly
-   **/
+   */
   event Repay(
     address indexed reserve,
     address indexed user,
@@ -102,7 +102,7 @@ interface IPool {
    * @param reserve The address of the underlying asset of the reserve
    * @param user The address of the user swapping his rate mode
    * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
-   **/
+   */
   event SwapBorrowRateMode(
     address indexed reserve,
     address indexed user,
@@ -120,28 +120,28 @@ interface IPool {
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
@@ -153,7 +153,7 @@ interface IPool {
    * @param interestRateMode The flashloan mode: 0 for regular flashloan, 1 for Stable debt, 2 for Variable debt
    * @param premium The fee flash borrowed
    * @param referralCode The referral code used
-   **/
+   */
   event FlashLoan(
     address indexed target,
     address initiator,
@@ -174,7 +174,7 @@ interface IPool {
    * @param liquidator The address of the liquidator
    * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
    * to receive the underlying collateral asset directly
-   **/
+   */
   event LiquidationCall(
     address indexed collateralAsset,
     address indexed debtAsset,
@@ -193,7 +193,7 @@ interface IPool {
    * @param variableBorrowRate The next variable borrow rate
    * @param liquidityIndex The next liquidity index
    * @param variableBorrowIndex The next variable borrow index
-   **/
+   */
   event ReserveDataUpdated(
     address indexed reserve,
     uint256 liquidityRate,
@@ -207,17 +207,17 @@ interface IPool {
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
@@ -226,16 +226,17 @@ interface IPool {
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
@@ -247,7 +248,7 @@ interface IPool {
    *   is a different wallet
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function supply(
     address asset,
     uint256 amount,
@@ -269,7 +270,7 @@ interface IPool {
    * @param permitV The V parameter of ERC712 permit sig
    * @param permitR The R parameter of ERC712 permit sig
    * @param permitS The S parameter of ERC712 permit sig
-   **/
+   */
   function supplyWithPermit(
     address asset,
     uint256 amount,
@@ -291,7 +292,7 @@ interface IPool {
    *   wants to receive it on his own wallet, or a different address if the beneficiary is a
    *   different wallet
    * @return The final amount withdrawn
-   **/
+   */
   function withdraw(
     address asset,
     uint256 amount,
@@ -312,7 +313,7 @@ interface IPool {
    * @param onBehalfOf The address of the user who will receive the debt. Should be the address of the borrower itself
    * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
    * if he has been given credit delegation allowance
-   **/
+   */
   function borrow(
     address asset,
     uint256 amount,
@@ -332,7 +333,7 @@ interface IPool {
    * user calling the function if he wants to reduce/remove his own debt, or the address of any other
    * other borrower whose debt should be removed
    * @return The final amount repaid
-   **/
+   */
   function repay(
     address asset,
     uint256 amount,
@@ -355,7 +356,7 @@ interface IPool {
    * @param permitR The R parameter of ERC712 permit sig
    * @param permitS The S parameter of ERC712 permit sig
    * @return The final amount repaid
-   **/
+   */
   function repayWithPermit(
     address asset,
     uint256 amount,
@@ -378,7 +379,7 @@ interface IPool {
    * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
    * @param interestRateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
    * @return The final amount repaid
-   **/
+   */
   function repayWithATokens(
     address asset,
     uint256 amount,
@@ -389,7 +390,7 @@ interface IPool {
    * @notice Allows a borrower to swap his debt between stable and variable mode, or vice versa
    * @param asset The address of the underlying asset borrowed
    * @param interestRateMode The current interest rate mode of the position being swapped: 1 for Stable, 2 for Variable
-   **/
+   */
   function swapBorrowRateMode(address asset, uint256 interestRateMode) external;
 
   /**
@@ -400,14 +401,14 @@ interface IPool {
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
@@ -420,7 +421,7 @@ interface IPool {
    * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
    * @param receiveAToken True if the liquidators wants to receive the collateral aTokens, `false` if he wants
    * to receive the underlying collateral asset directly
-   **/
+   */
   function liquidationCall(
     address collateralAsset,
     address debtAsset,
@@ -445,7 +446,7 @@ interface IPool {
    * @param params Variadic packed params to pass to the receiver as extra information
    * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function flashLoan(
     address receiverAddress,
     address[] calldata assets,
@@ -467,7 +468,7 @@ interface IPool {
    * @param params Variadic packed params to pass to the receiver as extra information
    * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function flashLoanSimple(
     address receiverAddress,
     address asset,
@@ -485,7 +486,7 @@ interface IPool {
    * @return currentLiquidationThreshold The liquidation threshold of the user
    * @return ltv The loan to value of The user
    * @return healthFactor The current health factor of the user
-   **/
+   */
   function getUserAccountData(address user)
     external
     view
@@ -507,7 +508,7 @@ interface IPool {
    * @param stableDebtAddress The address of the StableDebtToken that will be assigned to the reserve
    * @param variableDebtAddress The address of the VariableDebtToken that will be assigned to the reserve
    * @param interestRateStrategyAddress The address of the interest rate strategy contract
-   **/
+   */
   function initReserve(
     address asset,
     address aTokenAddress,
@@ -520,7 +521,7 @@ interface IPool {
    * @notice Drop a reserve
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
-   **/
+   */
   function dropReserve(address asset) external;
 
   /**
@@ -528,7 +529,7 @@ interface IPool {
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
    * @param rateStrategyAddress The address of the interest rate strategy contract
-   **/
+   */
   function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
     external;
 
@@ -537,7 +538,7 @@ interface IPool {
    * @dev Only callable by the PoolConfigurator contract
    * @param asset The address of the underlying asset of the reserve
    * @param configuration The new configuration bitmap
-   **/
+   */
   function setConfiguration(address asset, DataTypes.ReserveConfigurationMap calldata configuration)
     external;
 
@@ -545,7 +546,7 @@ interface IPool {
    * @notice Returns the configuration of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The configuration of the reserve
-   **/
+   */
   function getConfiguration(address asset)
     external
     view
@@ -555,14 +556,14 @@ interface IPool {
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
@@ -570,6 +571,13 @@ interface IPool {
 
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
@@ -579,7 +587,7 @@ interface IPool {
    * @notice Returns the state and configuration of the reserve
    * @param asset The address of the underlying asset of the reserve
    * @return The state and configuration data of the reserve
-   **/
+   */
   function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);
 
   /**
@@ -605,20 +613,20 @@ interface IPool {
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
@@ -711,7 +719,7 @@ interface IPool {
   /**
    * @notice Mints the assets accrued through the reserve factor to the treasury in the form of aTokens
    * @param assets The list of reserves for which the minting needs to be executed
-   **/
+   */
   function mintToTreasury(address[] calldata assets) external;
 
   /**
@@ -737,7 +745,7 @@ interface IPool {
    *   is a different wallet
    * @param referralCode Code used to register the integrator originating the operation, for potential rewards.
    *   0 if the action is executed directly by the user, without any middle-man
-   **/
+   */
   function deposit(
     address asset,
     uint256 amount,
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
index c3c8617..587a0d0 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
@@ -5,7 +5,7 @@ pragma solidity ^0.8.0;
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
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol
index 89ccddf..fe311fb 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol
@@ -4,17 +4,17 @@ pragma solidity ^0.8.0;
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
@@ -24,13 +24,14 @@ interface IScaledBalanceToken {
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
@@ -45,7 +46,7 @@ interface IScaledBalanceToken {
    * at the moment of the update
    * @param user The user whose balance is calculated
    * @return The scaled balance of the user
-   **/
+   */
   function scaledBalanceOf(address user) external view returns (uint256);
 
   /**
@@ -53,19 +54,19 @@ interface IScaledBalanceToken {
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
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
index ed38c5c..6ef2d4d 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {Errors} from '../helpers/Errors.sol';
 import {DataTypes} from '../types/DataTypes.sol';
@@ -21,6 +21,7 @@ library ReserveConfiguration {
   uint256 internal constant PAUSED_MASK =                    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant BORROWABLE_IN_ISOLATION_MASK =   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant SILOED_BORROWING_MASK =          0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFFF; // prettier-ignore
+  uint256 internal constant FLASHLOAN_ENABLED_MASK =         0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant RESERVE_FACTOR_MASK =            0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant BORROW_CAP_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFF; // prettier-ignore
   uint256 internal constant SUPPLY_CAP_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFF000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // prettier-ignore
@@ -40,8 +41,7 @@ library ReserveConfiguration {
   uint256 internal constant IS_PAUSED_START_BIT_POSITION = 60;
   uint256 internal constant BORROWABLE_IN_ISOLATION_START_BIT_POSITION = 61;
   uint256 internal constant SILOED_BORROWING_START_BIT_POSITION = 62;
-  /// @dev bit 63 reserved
-
+  uint256 internal constant FLASHLOAN_ENABLED_START_BIT_POSITION = 63;
   uint256 internal constant RESERVE_FACTOR_START_BIT_POSITION = 64;
   uint256 internal constant BORROW_CAP_START_BIT_POSITION = 80;
   uint256 internal constant SUPPLY_CAP_START_BIT_POSITION = 116;
@@ -69,7 +69,7 @@ library ReserveConfiguration {
    * @notice Sets the Loan to Value of the reserve
    * @param self The reserve configuration
    * @param ltv The new ltv
-   **/
+   */
   function setLtv(DataTypes.ReserveConfigurationMap memory self, uint256 ltv) internal pure {
     require(ltv <= MAX_VALID_LTV, Errors.INVALID_LTV);
 
@@ -80,7 +80,7 @@ library ReserveConfiguration {
    * @notice Gets the Loan to Value of the reserve
    * @param self The reserve configuration
    * @return The loan to value
-   **/
+   */
   function getLtv(DataTypes.ReserveConfigurationMap memory self) internal pure returns (uint256) {
     return self.data & ~LTV_MASK;
   }
@@ -89,7 +89,7 @@ library ReserveConfiguration {
    * @notice Sets the liquidation threshold of the reserve
    * @param self The reserve configuration
    * @param threshold The new liquidation threshold
-   **/
+   */
   function setLiquidationThreshold(DataTypes.ReserveConfigurationMap memory self, uint256 threshold)
     internal
     pure
@@ -105,7 +105,7 @@ library ReserveConfiguration {
    * @notice Gets the liquidation threshold of the reserve
    * @param self The reserve configuration
    * @return The liquidation threshold
-   **/
+   */
   function getLiquidationThreshold(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -118,7 +118,7 @@ library ReserveConfiguration {
    * @notice Sets the liquidation bonus of the reserve
    * @param self The reserve configuration
    * @param bonus The new liquidation bonus
-   **/
+   */
   function setLiquidationBonus(DataTypes.ReserveConfigurationMap memory self, uint256 bonus)
     internal
     pure
@@ -134,7 +134,7 @@ library ReserveConfiguration {
    * @notice Gets the liquidation bonus of the reserve
    * @param self The reserve configuration
    * @return The liquidation bonus
-   **/
+   */
   function getLiquidationBonus(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -147,7 +147,7 @@ library ReserveConfiguration {
    * @notice Sets the decimals of the underlying asset of the reserve
    * @param self The reserve configuration
    * @param decimals The decimals
-   **/
+   */
   function setDecimals(DataTypes.ReserveConfigurationMap memory self, uint256 decimals)
     internal
     pure
@@ -161,7 +161,7 @@ library ReserveConfiguration {
    * @notice Gets the decimals of the underlying asset of the reserve
    * @param self The reserve configuration
    * @return The decimals of the asset
-   **/
+   */
   function getDecimals(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -174,7 +174,7 @@ library ReserveConfiguration {
    * @notice Sets the active state of the reserve
    * @param self The reserve configuration
    * @param active The active state
-   **/
+   */
   function setActive(DataTypes.ReserveConfigurationMap memory self, bool active) internal pure {
     self.data =
       (self.data & ACTIVE_MASK) |
@@ -185,7 +185,7 @@ library ReserveConfiguration {
    * @notice Gets the active state of the reserve
    * @param self The reserve configuration
    * @return The active state
-   **/
+   */
   function getActive(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~ACTIVE_MASK) != 0;
   }
@@ -194,7 +194,7 @@ library ReserveConfiguration {
    * @notice Sets the frozen state of the reserve
    * @param self The reserve configuration
    * @param frozen The frozen state
-   **/
+   */
   function setFrozen(DataTypes.ReserveConfigurationMap memory self, bool frozen) internal pure {
     self.data =
       (self.data & FROZEN_MASK) |
@@ -205,7 +205,7 @@ library ReserveConfiguration {
    * @notice Gets the frozen state of the reserve
    * @param self The reserve configuration
    * @return The frozen state
-   **/
+   */
   function getFrozen(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~FROZEN_MASK) != 0;
   }
@@ -214,7 +214,7 @@ library ReserveConfiguration {
    * @notice Sets the paused state of the reserve
    * @param self The reserve configuration
    * @param paused The paused state
-   **/
+   */
   function setPaused(DataTypes.ReserveConfigurationMap memory self, bool paused) internal pure {
     self.data =
       (self.data & PAUSED_MASK) |
@@ -225,7 +225,7 @@ library ReserveConfiguration {
    * @notice Gets the paused state of the reserve
    * @param self The reserve configuration
    * @return The paused state
-   **/
+   */
   function getPaused(DataTypes.ReserveConfigurationMap memory self) internal pure returns (bool) {
     return (self.data & ~PAUSED_MASK) != 0;
   }
@@ -238,7 +238,7 @@ library ReserveConfiguration {
    * consistency in the debt ceiling calculations.
    * @param self The reserve configuration
    * @param borrowable True if the asset is borrowable
-   **/
+   */
   function setBorrowableInIsolation(DataTypes.ReserveConfigurationMap memory self, bool borrowable)
     internal
     pure
@@ -256,7 +256,7 @@ library ReserveConfiguration {
    * consistency in the debt ceiling calculations.
    * @param self The reserve configuration
    * @return The borrowable in isolation flag
-   **/
+   */
   function getBorrowableInIsolation(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -270,7 +270,7 @@ library ReserveConfiguration {
    * @dev When this flag is set to true, users borrowing this asset will not be allowed to borrow any other asset.
    * @param self The reserve configuration
    * @param siloed True if the asset is siloed
-   **/
+   */
   function setSiloedBorrowing(DataTypes.ReserveConfigurationMap memory self, bool siloed)
     internal
     pure
@@ -285,7 +285,7 @@ library ReserveConfiguration {
    * @dev When this flag is set to true, users borrowing this asset will not be allowed to borrow any other asset.
    * @param self The reserve configuration
    * @return The siloed borrowing flag
-   **/
+   */
   function getSiloedBorrowing(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -298,7 +298,7 @@ library ReserveConfiguration {
    * @notice Enables or disables borrowing on the reserve
    * @param self The reserve configuration
    * @param enabled True if the borrowing needs to be enabled, false otherwise
-   **/
+   */
   function setBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self, bool enabled)
     internal
     pure
@@ -312,7 +312,7 @@ library ReserveConfiguration {
    * @notice Gets the borrowing state of the reserve
    * @param self The reserve configuration
    * @return The borrowing state
-   **/
+   */
   function getBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -325,7 +325,7 @@ library ReserveConfiguration {
    * @notice Enables or disables stable rate borrowing on the reserve
    * @param self The reserve configuration
    * @param enabled True if the stable rate borrowing needs to be enabled, false otherwise
-   **/
+   */
   function setStableRateBorrowingEnabled(
     DataTypes.ReserveConfigurationMap memory self,
     bool enabled
@@ -339,7 +339,7 @@ library ReserveConfiguration {
    * @notice Gets the stable rate borrowing state of the reserve
    * @param self The reserve configuration
    * @return The stable rate borrowing state
-   **/
+   */
   function getStableRateBorrowingEnabled(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -352,7 +352,7 @@ library ReserveConfiguration {
    * @notice Sets the reserve factor of the reserve
    * @param self The reserve configuration
    * @param reserveFactor The reserve factor
-   **/
+   */
   function setReserveFactor(DataTypes.ReserveConfigurationMap memory self, uint256 reserveFactor)
     internal
     pure
@@ -368,7 +368,7 @@ library ReserveConfiguration {
    * @notice Gets the reserve factor of the reserve
    * @param self The reserve configuration
    * @return The reserve factor
-   **/
+   */
   function getReserveFactor(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -381,7 +381,7 @@ library ReserveConfiguration {
    * @notice Sets the borrow cap of the reserve
    * @param self The reserve configuration
    * @param borrowCap The borrow cap
-   **/
+   */
   function setBorrowCap(DataTypes.ReserveConfigurationMap memory self, uint256 borrowCap)
     internal
     pure
@@ -395,7 +395,7 @@ library ReserveConfiguration {
    * @notice Gets the borrow cap of the reserve
    * @param self The reserve configuration
    * @return The borrow cap
-   **/
+   */
   function getBorrowCap(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -408,7 +408,7 @@ library ReserveConfiguration {
    * @notice Sets the supply cap of the reserve
    * @param self The reserve configuration
    * @param supplyCap The supply cap
-   **/
+   */
   function setSupplyCap(DataTypes.ReserveConfigurationMap memory self, uint256 supplyCap)
     internal
     pure
@@ -422,7 +422,7 @@ library ReserveConfiguration {
    * @notice Gets the supply cap of the reserve
    * @param self The reserve configuration
    * @return The supply cap
-   **/
+   */
   function getSupplyCap(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -435,7 +435,7 @@ library ReserveConfiguration {
    * @notice Sets the debt ceiling in isolation mode for the asset
    * @param self The reserve configuration
    * @param ceiling The maximum debt ceiling for the asset
-   **/
+   */
   function setDebtCeiling(DataTypes.ReserveConfigurationMap memory self, uint256 ceiling)
     internal
     pure
@@ -449,7 +449,7 @@ library ReserveConfiguration {
    * @notice Gets the debt ceiling for the asset if the asset is in isolation mode
    * @param self The reserve configuration
    * @return The debt ceiling (0 = isolation mode disabled)
-   **/
+   */
   function getDebtCeiling(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -462,7 +462,7 @@ library ReserveConfiguration {
    * @notice Sets the liquidation protocol fee of the reserve
    * @param self The reserve configuration
    * @param liquidationProtocolFee The liquidation protocol fee
-   **/
+   */
   function setLiquidationProtocolFee(
     DataTypes.ReserveConfigurationMap memory self,
     uint256 liquidationProtocolFee
@@ -481,7 +481,7 @@ library ReserveConfiguration {
    * @dev Gets the liquidation protocol fee
    * @param self The reserve configuration
    * @return The liquidation protocol fee
-   **/
+   */
   function getLiquidationProtocolFee(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -495,7 +495,7 @@ library ReserveConfiguration {
    * @notice Sets the unbacked mint cap of the reserve
    * @param self The reserve configuration
    * @param unbackedMintCap The unbacked mint cap
-   **/
+   */
   function setUnbackedMintCap(
     DataTypes.ReserveConfigurationMap memory self,
     uint256 unbackedMintCap
@@ -511,7 +511,7 @@ library ReserveConfiguration {
    * @dev Gets the unbacked mint cap of the reserve
    * @param self The reserve configuration
    * @return The unbacked mint cap
-   **/
+   */
   function getUnbackedMintCap(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -524,7 +524,7 @@ library ReserveConfiguration {
    * @notice Sets the eMode asset category
    * @param self The reserve configuration
    * @param category The asset category when the user selects the eMode
-   **/
+   */
   function setEModeCategory(DataTypes.ReserveConfigurationMap memory self, uint256 category)
     internal
     pure
@@ -538,7 +538,7 @@ library ReserveConfiguration {
    * @dev Gets the eMode asset category
    * @param self The reserve configuration
    * @return The eMode category for the asset
-   **/
+   */
   function getEModeCategory(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -547,6 +547,33 @@ library ReserveConfiguration {
     return (self.data & ~EMODE_CATEGORY_MASK) >> EMODE_CATEGORY_START_BIT_POSITION;
   }
 
+  /**
+   * @notice Sets the flashloanable flag for the reserve
+   * @param self The reserve configuration
+   * @param flashLoanEnabled True if the asset is flashloanable, false otherwise
+   */
+  function setFlashLoanEnabled(DataTypes.ReserveConfigurationMap memory self, bool flashLoanEnabled)
+    internal
+    pure
+  {
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
+  function getFlashLoanEnabled(DataTypes.ReserveConfigurationMap memory self)
+    internal
+    pure
+    returns (bool)
+  {
+    return (self.data & ~FLASHLOAN_ENABLED_MASK) != 0;
+  }
+
   /**
    * @notice Gets the configuration flags of the reserve
    * @param self The reserve configuration
@@ -555,7 +582,7 @@ library ReserveConfiguration {
    * @return The state flag representing borrowing enabled
    * @return The state flag representing stableRateBorrowing enabled
    * @return The state flag representing paused
-   **/
+   */
   function getFlags(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -587,7 +614,7 @@ library ReserveConfiguration {
    * @return The state param representing reserve decimals
    * @return The state param representing reserve factor
    * @return The state param representing eMode category
-   **/
+   */
   function getParams(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
@@ -617,7 +644,7 @@ library ReserveConfiguration {
    * @param self The reserve configuration
    * @return The state param representing borrow cap
    * @return The state param representing supply cap.
-   **/
+   */
   function getCaps(DataTypes.ReserveConfigurationMap memory self)
     internal
     pure
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol
index cc9df47..60d7dd3 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {Errors} from '../helpers/Errors.sol';
 import {DataTypes} from '../types/DataTypes.sol';
@@ -23,7 +23,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @param borrowing True if the user is borrowing the reserve, false otherwise
-   **/
+   */
   function setBorrowing(
     DataTypes.UserConfigurationMap storage self,
     uint256 reserveIndex,
@@ -45,7 +45,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @param usingAsCollateral True if the user is using the reserve as collateral, false otherwise
-   **/
+   */
   function setUsingAsCollateral(
     DataTypes.UserConfigurationMap storage self,
     uint256 reserveIndex,
@@ -67,7 +67,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve for borrowing or as collateral, false otherwise
-   **/
+   */
   function isUsingAsCollateralOrBorrowing(
     DataTypes.UserConfigurationMap memory self,
     uint256 reserveIndex
@@ -83,7 +83,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve for borrowing, false otherwise
-   **/
+   */
   function isBorrowing(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
     internal
     pure
@@ -100,7 +100,7 @@ library UserConfiguration {
    * @param self The configuration object
    * @param reserveIndex The index of the reserve in the bitmap
    * @return True if the user has been using a reserve as collateral, false otherwise
-   **/
+   */
   function isUsingAsCollateral(DataTypes.UserConfigurationMap memory self, uint256 reserveIndex)
     internal
     pure
@@ -117,7 +117,7 @@ library UserConfiguration {
    * @dev this uses a simple trick - if a number is a power of two (only one bit set) then n & (n - 1) == 0
    * @param self The configuration object
    * @return True if the user has been supplying as collateral one reserve, false otherwise
-   **/
+   */
   function isUsingAsCollateralOne(DataTypes.UserConfigurationMap memory self)
     internal
     pure
@@ -131,7 +131,7 @@ library UserConfiguration {
    * @notice Checks if a user has been supplying any reserve as collateral
    * @param self The configuration object
    * @return True if the user has been supplying as collateral any reserve, false otherwise
-   **/
+   */
   function isUsingAsCollateralAny(DataTypes.UserConfigurationMap memory self)
     internal
     pure
@@ -145,7 +145,7 @@ library UserConfiguration {
    * @dev this uses a simple trick - if a number is a power of two (only one bit set) then n & (n - 1) == 0
    * @param self The configuration object
    * @return True if the user has been supplying as collateral one reserve, false otherwise
-   **/
+   */
   function isBorrowingOne(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     uint256 borrowingData = self.data & BORROWING_MASK;
     return borrowingData != 0 && (borrowingData & (borrowingData - 1) == 0);
@@ -155,7 +155,7 @@ library UserConfiguration {
    * @notice Checks if a user has been borrowing from any reserve
    * @param self The configuration object
    * @return True if the user has been borrowing any reserve, false otherwise
-   **/
+   */
   function isBorrowingAny(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     return self.data & BORROWING_MASK != 0;
   }
@@ -164,7 +164,7 @@ library UserConfiguration {
    * @notice Checks if a user has not been using any reserve for borrowing or supply
    * @param self The configuration object
    * @return True if the user has not been borrowing or supplying any reserve, false otherwise
-   **/
+   */
   function isEmpty(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
     return self.data == 0;
   }
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
index 640e463..1dacaf3 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
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
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
index 7113a0a..c40d732 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 library DataTypes {
   struct ReserveData {
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/libraries/DataTypesHelper.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/libraries/DataTypesHelper.sol
index 6b613b6..f9f32d1 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/libraries/DataTypesHelper.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/libraries/DataTypesHelper.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.10;
 
 import {IERC20} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
 import {DataTypes} from '@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol';
@@ -7,7 +7,7 @@ import {DataTypes} from '@aave/core-v3/contracts/protocol/libraries/types/DataTy
 /**
  * @title DataTypesHelper
  * @author Aave
- * @dev Helper library to track user current debt balance, used by WETHGateway
+ * @dev Helper library to track user current debt balance, used by WrappedTokenGatewayV3
  */
 library DataTypesHelper {
   /**
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/WrappedTokenGatewayV3.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/WrappedTokenGatewayV3.sol
index 6845023..4ac1d3f 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/WrappedTokenGatewayV3.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/WrappedTokenGatewayV3.sol
@@ -1,253 +1,222 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.10;
 
-import {Ownable} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
-import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
-import {GPv2SafeERC20} from "@aave/core-v3/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol";
-import {IWETH} from "@aave/core-v3/contracts/misc/interfaces/IWETH.sol";
-import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
-import {IAToken} from "@aave/core-v3/contracts/interfaces/IAToken.sol";
-import {ReserveConfiguration} from "@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
-import {UserConfiguration} from "@aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol";
-
-import {DataTypes} from "@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
-import {IWETHGateway} from "@aave/periphery-v3/contracts/misc/interfaces/IWETHGateway.sol";
-import {DataTypesHelper} from "@aave/periphery-v3/contracts/libraries/DataTypesHelper.sol";
+import {Ownable} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol';
+import {IERC20} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
+import {GPv2SafeERC20} from '@aave/core-v3/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol';
+import {IWETH} from '@aave/core-v3/contracts/misc/interfaces/IWETH.sol';
+import {IPool} from '@aave/core-v3/contracts/interfaces/IPool.sol';
+import {IAToken} from '@aave/core-v3/contracts/interfaces/IAToken.sol';
+import {ReserveConfiguration} from '@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol';
+import {UserConfiguration} from '@aave/core-v3/contracts/protocol/libraries/configuration/UserConfiguration.sol';
+import {DataTypes} from '@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol';
+import {IWrappedTokenGatewayV3} from './interfaces/IWrappedTokenGatewayV3.sol';
+import {DataTypesHelper} from '../libraries/DataTypesHelper.sol';
 
 /**
- * @dev This contract is an upgrade of the WETHGateway contract, with immutable pool address.
- * This contract keeps the same interface of the deprecated WETHGateway contract.
+ * @dev This contract is an upgrade of the WrappedTokenGatewayV3 contract, with immutable pool address.
+ * This contract keeps the same interface of the deprecated WrappedTokenGatewayV3 contract.
  */
-contract WrappedTokenGatewayV3 is IWETHGateway, Ownable {
-    using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
-    using UserConfiguration for DataTypes.UserConfigurationMap;
-    using GPv2SafeERC20 for IERC20;
-
-    IWETH internal immutable WETH;
-    IPool internal immutable POOL;
-
-    /**
-     * @dev Sets the WETH address and the PoolAddressesProvider address. Infinite approves pool.
-     * @param weth Address of the Wrapped Ether contract
-     * @param owner Address of the owner of this contract
-     **/
-    constructor(
-        address weth,
-        address owner,
-        IPool pool
-    ) {
-        WETH = IWETH(weth);
-        POOL = pool;
-        transferOwnership(owner);
-        IWETH(weth).approve(address(pool), type(uint256).max);
+contract WrappedTokenGatewayV3 is IWrappedTokenGatewayV3, Ownable {
+  using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
+  using UserConfiguration for DataTypes.UserConfigurationMap;
+  using GPv2SafeERC20 for IERC20;
+
+  IWETH internal immutable WETH;
+  IPool internal immutable POOL;
+
+  /**
+   * @dev Sets the WETH address and the PoolAddressesProvider address. Infinite approves pool.
+   * @param weth Address of the Wrapped Ether contract
+   * @param owner Address of the owner of this contract
+   **/
+  constructor(
+    address weth,
+    address owner,
+    IPool pool
+  ) {
+    WETH = IWETH(weth);
+    POOL = pool;
+    transferOwnership(owner);
+    IWETH(weth).approve(address(pool), type(uint256).max);
+  }
+
+  /**
+   * @dev deposits WETH into the reserve, using native ETH. A corresponding amount of the overlying asset (aTokens)
+   * is minted.
+   * @param onBehalfOf address of the user who will receive the aTokens representing the deposit
+   * @param referralCode integrators are assigned a referral code and can potentially receive rewards.
+   **/
+  function depositETH(
+    address,
+    address onBehalfOf,
+    uint16 referralCode
+  ) external payable override {
+    WETH.deposit{value: msg.value}();
+    POOL.deposit(address(WETH), msg.value, onBehalfOf, referralCode);
+  }
+
+  /**
+   * @dev withdraws the WETH _reserves of msg.sender.
+   * @param amount amount of aWETH to withdraw and receive native ETH
+   * @param to address of the user who will receive native ETH
+   */
+  function withdrawETH(
+    address,
+    uint256 amount,
+    address to
+  ) external override {
+    IAToken aWETH = IAToken(POOL.getReserveData(address(WETH)).aTokenAddress);
+    uint256 userBalance = aWETH.balanceOf(msg.sender);
+    uint256 amountToWithdraw = amount;
+
+    // if amount is equal to uint(-1), the user wants to redeem everything
+    if (amount == type(uint256).max) {
+      amountToWithdraw = userBalance;
     }
-
-    /**
-     * @dev deposits WETH into the reserve, using native ETH. A corresponding amount of the overlying asset (aTokens)
-     * is minted.
-     * @param onBehalfOf address of the user who will receive the aTokens representing the deposit
-     * @param referralCode integrators are assigned a referral code and can potentially receive rewards.
-     **/
-    function depositETH(
-        address,
-        address onBehalfOf,
-        uint16 referralCode
-    ) external payable override {
-        WETH.deposit{value: msg.value}();
-        POOL.deposit(address(WETH), msg.value, onBehalfOf, referralCode);
-    }
-
-    /**
-     * @dev withdraws the WETH _reserves of msg.sender.
-     * @param amount amount of aWETH to withdraw and receive native ETH
-     * @param to address of the user who will receive native ETH
-     */
-    function withdrawETH(
-        address,
-        uint256 amount,
-        address to
-    ) external override {
-        IAToken aWETH = IAToken(
-            POOL.getReserveData(address(WETH)).aTokenAddress
-        );
-        uint256 userBalance = aWETH.balanceOf(msg.sender);
-        uint256 amountToWithdraw = amount;
-
-        // if amount is equal to uint(-1), the user wants to redeem everything
-        if (amount == type(uint256).max) {
-            amountToWithdraw = userBalance;
-        }
-        aWETH.transferFrom(msg.sender, address(this), amountToWithdraw);
-        POOL.withdraw(address(WETH), amountToWithdraw, address(this));
-        WETH.withdraw(amountToWithdraw);
-        _safeTransferETH(to, amountToWithdraw);
-    }
-
-    /**
-     * @dev repays a borrow on the WETH reserve, for the specified amount (or for the whole amount, if uint256(-1) is specified).
-     * @param amount the amount to repay, or uint256(-1) if the user wants to repay everything
-     * @param rateMode the rate mode to repay
-     * @param onBehalfOf the address for which msg.sender is repaying
-     */
-    function repayETH(
-        address,
-        uint256 amount,
-        uint256 rateMode,
-        address onBehalfOf
-    ) external payable override {
-        (uint256 stableDebt, uint256 variableDebt) = DataTypesHelper
-            .getUserCurrentDebt(onBehalfOf, POOL.getReserveData(address(WETH)));
-
-        uint256 paybackAmount = DataTypes.InterestRateMode(rateMode) ==
-            DataTypes.InterestRateMode.STABLE
-            ? stableDebt
-            : variableDebt;
-
-        if (amount < paybackAmount) {
-            paybackAmount = amount;
-        }
-        require(
-            msg.value >= paybackAmount,
-            "msg.value is less than repayment amount"
-        );
-        WETH.deposit{value: paybackAmount}();
-        POOL.repay(address(WETH), msg.value, rateMode, onBehalfOf);
-
-        // refund remaining dust eth
-        if (msg.value > paybackAmount)
-            _safeTransferETH(msg.sender, msg.value - paybackAmount);
-    }
-
-    /**
-     * @dev borrow WETH, unwraps to ETH and send both the ETH and DebtTokens to msg.sender, via `approveDelegation` and onBehalf argument in `Pool.borrow`.
-     * @param amount the amount of ETH to borrow
-     * @param interesRateMode the interest rate mode
-     * @param referralCode integrators are assigned a referral code and can potentially receive rewards
-     */
-    function borrowETH(
-        address,
-        uint256 amount,
-        uint256 interesRateMode,
-        uint16 referralCode
-    ) external override {
-        POOL.borrow(
-            address(WETH),
-            amount,
-            interesRateMode,
-            referralCode,
-            msg.sender
-        );
-        WETH.withdraw(amount);
-        _safeTransferETH(msg.sender, amount);
-    }
-
-    /**
-     * @dev withdraws the WETH _reserves of msg.sender.
-     * @param amount amount of aWETH to withdraw and receive native ETH
-     * @param to address of the user who will receive native ETH
-     * @param deadline validity deadline of permit and so depositWithPermit signature
-     * @param permitV V parameter of ERC712 permit sig
-     * @param permitR R parameter of ERC712 permit sig
-     * @param permitS S parameter of ERC712 permit sig
-     */
-    function withdrawETHWithPermit(
-        address,
-        uint256 amount,
-        address to,
-        uint256 deadline,
-        uint8 permitV,
-        bytes32 permitR,
-        bytes32 permitS
-    ) external override {
-        IAToken aWETH = IAToken(
-            POOL.getReserveData(address(WETH)).aTokenAddress
-        );
-        uint256 userBalance = aWETH.balanceOf(msg.sender);
-        uint256 amountToWithdraw = amount;
-
-        // if amount is equal to uint(-1), the user wants to redeem everything
-        if (amount == type(uint256).max) {
-            amountToWithdraw = userBalance;
-        }
-        // chosing to permit `amount`and not `amountToWithdraw`, easier for frontends, intregrators.
-        aWETH.permit(
-            msg.sender,
-            address(this),
-            amount,
-            deadline,
-            permitV,
-            permitR,
-            permitS
-        );
-        aWETH.transferFrom(msg.sender, address(this), amountToWithdraw);
-        POOL.withdraw(address(WETH), amountToWithdraw, address(this));
-        WETH.withdraw(amountToWithdraw);
-        _safeTransferETH(to, amountToWithdraw);
-    }
-
-    /**
-     * @dev transfer ETH to an address, revert if it fails.
-     * @param to recipient of the transfer
-     * @param value the amount to send
-     */
-    function _safeTransferETH(address to, uint256 value) internal {
-        (bool success, ) = to.call{value: value}(new bytes(0));
-        require(success, "ETH_TRANSFER_FAILED");
+    aWETH.transferFrom(msg.sender, address(this), amountToWithdraw);
+    POOL.withdraw(address(WETH), amountToWithdraw, address(this));
+    WETH.withdraw(amountToWithdraw);
+    _safeTransferETH(to, amountToWithdraw);
+  }
+
+  /**
+   * @dev repays a borrow on the WETH reserve, for the specified amount (or for the whole amount, if uint256(-1) is specified).
+   * @param amount the amount to repay, or uint256(-1) if the user wants to repay everything
+   * @param rateMode the rate mode to repay
+   * @param onBehalfOf the address for which msg.sender is repaying
+   */
+  function repayETH(
+    address,
+    uint256 amount,
+    uint256 rateMode,
+    address onBehalfOf
+  ) external payable override {
+    (uint256 stableDebt, uint256 variableDebt) = DataTypesHelper.getUserCurrentDebt(
+      onBehalfOf,
+      POOL.getReserveData(address(WETH))
+    );
+
+    uint256 paybackAmount = DataTypes.InterestRateMode(rateMode) ==
+      DataTypes.InterestRateMode.STABLE
+      ? stableDebt
+      : variableDebt;
+
+    if (amount < paybackAmount) {
+      paybackAmount = amount;
     }
-
-    /**
-     * @dev transfer ERC20 from the utility contract, for ERC20 recovery in case of stuck tokens due
-     * direct transfers to the contract address.
-     * @param token token to transfer
-     * @param to recipient of the transfer
-     * @param amount amount to send
-     */
-    function emergencyTokenTransfer(
-        address token,
-        address to,
-        uint256 amount
-    ) external onlyOwner {
-        IERC20(token).safeTransfer(to, amount);
-    }
-
-    /**
-     * @dev transfer native Ether from the utility contract, for native Ether recovery in case of stuck Ether
-     * due selfdestructs or transfer ether to pre-computated contract address before deployment.
-     * @param to recipient of the transfer
-     * @param amount amount to send
-     */
-    function emergencyEtherTransfer(address to, uint256 amount)
-        external
-        onlyOwner
-    {
-        _safeTransferETH(to, amount);
-    }
-
-    /**
-     * @dev Get WETH address used by WrappedTokenGateway
-     */
-    function getWETHAddress() external view returns (address) {
-        return address(WETH);
-    }
-
-    /**
-     * @dev Get POOL address used by WrappedTokenGateway
-     */
-    function getPool() external view returns (address) {
-        return address(POOL);
-    }
-
-    /**
-     * @dev Only WETH contract is allowed to transfer ETH here. Prevent other addresses to send Ether to this contract.
-     */
-    receive() external payable {
-        require(msg.sender == address(WETH), "Receive not allowed");
-    }
-
-    /**
-     * @dev Revert fallback calls
-     */
-    fallback() external payable {
-        revert("Fallback not allowed");
+    require(msg.value >= paybackAmount, 'msg.value is less than repayment amount');
+    WETH.deposit{value: paybackAmount}();
+    POOL.repay(address(WETH), msg.value, rateMode, onBehalfOf);
+
+    // refund remaining dust eth
+    if (msg.value > paybackAmount) _safeTransferETH(msg.sender, msg.value - paybackAmount);
+  }
+
+  /**
+   * @dev borrow WETH, unwraps to ETH and send both the ETH and DebtTokens to msg.sender, via `approveDelegation` and onBehalf argument in `Pool.borrow`.
+   * @param amount the amount of ETH to borrow
+   * @param interestRateMode the interest rate mode
+   * @param referralCode integrators are assigned a referral code and can potentially receive rewards
+   */
+  function borrowETH(
+    address,
+    uint256 amount,
+    uint256 interestRateMode,
+    uint16 referralCode
+  ) external override {
+    POOL.borrow(address(WETH), amount, interestRateMode, referralCode, msg.sender);
+    WETH.withdraw(amount);
+    _safeTransferETH(msg.sender, amount);
+  }
+
+  /**
+   * @dev withdraws the WETH _reserves of msg.sender.
+   * @param amount amount of aWETH to withdraw and receive native ETH
+   * @param to address of the user who will receive native ETH
+   * @param deadline validity deadline of permit and so depositWithPermit signature
+   * @param permitV V parameter of ERC712 permit sig
+   * @param permitR R parameter of ERC712 permit sig
+   * @param permitS S parameter of ERC712 permit sig
+   */
+  function withdrawETHWithPermit(
+    address,
+    uint256 amount,
+    address to,
+    uint256 deadline,
+    uint8 permitV,
+    bytes32 permitR,
+    bytes32 permitS
+  ) external override {
+    IAToken aWETH = IAToken(POOL.getReserveData(address(WETH)).aTokenAddress);
+    uint256 userBalance = aWETH.balanceOf(msg.sender);
+    uint256 amountToWithdraw = amount;
+
+    // if amount is equal to type(uint256).max, the user wants to redeem everything
+    if (amount == type(uint256).max) {
+      amountToWithdraw = userBalance;
     }
+    // permit `amount` rather than `amountToWithdraw` to make it easier for front-ends and integrators
+    aWETH.permit(msg.sender, address(this), amount, deadline, permitV, permitR, permitS);
+    aWETH.transferFrom(msg.sender, address(this), amountToWithdraw);
+    POOL.withdraw(address(WETH), amountToWithdraw, address(this));
+    WETH.withdraw(amountToWithdraw);
+    _safeTransferETH(to, amountToWithdraw);
+  }
+
+  /**
+   * @dev transfer ETH to an address, revert if it fails.
+   * @param to recipient of the transfer
+   * @param value the amount to send
+   */
+  function _safeTransferETH(address to, uint256 value) internal {
+    (bool success, ) = to.call{value: value}(new bytes(0));
+    require(success, 'ETH_TRANSFER_FAILED');
+  }
+
+  /**
+   * @dev transfer ERC20 from the utility contract, for ERC20 recovery in case of stuck tokens due
+   * direct transfers to the contract address.
+   * @param token token to transfer
+   * @param to recipient of the transfer
+   * @param amount amount to send
+   */
+  function emergencyTokenTransfer(
+    address token,
+    address to,
+    uint256 amount
+  ) external onlyOwner {
+    IERC20(token).safeTransfer(to, amount);
+  }
+
+  /**
+   * @dev transfer native Ether from the utility contract, for native Ether recovery in case of stuck Ether
+   * due to selfdestructs or ether transfers to the pre-computed contract address before deployment.
+   * @param to recipient of the transfer
+   * @param amount amount to send
+   */
+  function emergencyEtherTransfer(address to, uint256 amount) external onlyOwner {
+    _safeTransferETH(to, amount);
+  }
+
+  /**
+   * @dev Get WETH address used by WrappedTokenGatewayV3
+   */
+  function getWETHAddress() external view returns (address) {
+    return address(WETH);
+  }
+
+  /**
+   * @dev Only WETH contract is allowed to transfer ETH here. Prevent other addresses to send Ether to this contract.
+   */
+  receive() external payable {
+    require(msg.sender == address(WETH), 'Receive not allowed');
+  }
+
+  /**
+   * @dev Revert fallback calls
+   */
+  fallback() external payable {
+    revert('Fallback not allowed');
+  }
 }
diff --git a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/interfaces/IWETHGateway.sol b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/interfaces/IWrappedTokenGatewayV3.sol
similarity index 83%
rename from downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/interfaces/IWETHGateway.sol
rename to downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/interfaces/IWrappedTokenGatewayV3.sol
index 56bafdf..c5ab814 100644
--- a/downloads/polygon/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/interfaces/IWETHGateway.sol
+++ b/downloads/mainnet/WETH_GATEWAY/WrappedTokenGatewayV3/@aave/periphery-v3/contracts/misc/interfaces/IWrappedTokenGatewayV3.sol
@@ -1,7 +1,7 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.10;
 
-interface IWETHGateway {
+interface IWrappedTokenGatewayV3 {
   function depositETH(
     address pool,
     address onBehalfOf,
@@ -24,7 +24,7 @@ interface IWETHGateway {
   function borrowETH(
     address pool,
     uint256 amount,
-    uint256 interesRateMode,
+    uint256 interestRateMode,
     uint16 referralCode
   ) external;
 
```
