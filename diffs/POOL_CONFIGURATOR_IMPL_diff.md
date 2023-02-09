```diff
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
index c6dcfda..66cf8b8 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
index bf52cd5..805fb57 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 import './Proxy.sol';
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
index 5ecec08..d76a024 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 import './BaseUpgradeabilityProxy.sol';
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
index 44b790d..6f68021 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IACLManager.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IACLManager.sol
index 4bb6e64..d5d97ce 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IACLManager.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IACLManager.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {IPoolAddressesProvider} from './IPoolAddressesProvider.sol';
 
@@ -7,7 +7,7 @@ import {IPoolAddressesProvider} from './IPoolAddressesProvider.sol';
  * @title IACLManager
  * @author Aave
  * @notice Defines the basic interface for the ACL Manager
- **/
+ */
 interface IACLManager {
   /**
    * @notice Returns the contract address of the PoolAddressesProvider
@@ -123,7 +123,7 @@ interface IACLManager {
   function addFlashBorrower(address borrower) external;
 
   /**
-   * @notice Removes an admin as FlashBorrower
+   * @notice Removes an address as FlashBorrower
    * @param borrower The address of the FlashBorrower to remove
    */
   function removeFlashBorrower(address borrower) external;
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
index d0663cd..0cfc559 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IAaveIncentivesController.sol
@@ -1,176 +1,23 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
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
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol
index ba0ca82..0b16baa 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableAToken.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {IAaveIncentivesController} from './IAaveIncentivesController.sol';
 import {IPool} from './IPool.sol';
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
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol
index 740cb8c..ad8cd7c 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IInitializableDebtToken.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {IAaveIncentivesController} from './IAaveIncentivesController.sol';
 import {IPool} from './IPool.sol';
@@ -8,7 +8,7 @@ import {IPool} from './IPool.sol';
  * @title IInitializableDebtToken
  * @author Aave
  * @notice Interface for the initialize function common between debt tokens
- **/
+ */
 interface IInitializableDebtToken {
   /**
    * @dev Emitted when a debt token is initialized
@@ -19,7 +19,7 @@ interface IInitializableDebtToken {
    * @param debtTokenName The name of the debt token
    * @param debtTokenSymbol The symbol of the debt token
    * @param params A set of encoded parameters for additional initialization
-   **/
+   */
   event Initialized(
     address indexed underlyingAsset,
     address indexed pool,
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPool.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPool.sol
index 7f64b4a..3faed92 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPool.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPool.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {IPoolAddressesProvider} from './IPoolAddressesProvider.sol';
 import {DataTypes} from '../protocol/libraries/types/DataTypes.sol';
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
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
index 01a126b..587a0d0 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
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
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolConfigurator.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolConfigurator.sol
index d84454a..457ce66 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolConfigurator.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolConfigurator.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 import {ConfiguratorInputTypes} from '../protocol/libraries/types/ConfiguratorInputTypes.sol';
 
@@ -7,7 +7,7 @@ import {ConfiguratorInputTypes} from '../protocol/libraries/types/ConfiguratorIn
  * @title IPoolConfigurator
  * @author Aave
  * @notice Defines the basic interface for a Pool configurator.
- **/
+ */
 interface IPoolConfigurator {
   /**
    * @dev Emitted when a reserve is initialized.
@@ -16,7 +16,7 @@ interface IPoolConfigurator {
    * @param stableDebtToken The address of the associated stable rate debt token
    * @param variableDebtToken The address of the associated variable rate debt token
    * @param interestRateStrategyAddress The address of the interest rate strategy for the reserve
-   **/
+   */
   event ReserveInitialized(
     address indexed asset,
     address indexed aToken,
@@ -29,16 +29,23 @@ interface IPoolConfigurator {
    * @dev Emitted when borrowing is enabled or disabled on a reserve.
    * @param asset The address of the underlying asset of the reserve
    * @param enabled True if borrowing is enabled, false otherwise
-   **/
+   */
   event ReserveBorrowing(address indexed asset, bool enabled);
 
+  /**
+   * @dev Emitted when flashloans are enabled or disabled on a reserve.
+   * @param asset The address of the underlying asset of the reserve
+   * @param enabled True if flashloans are enabled, false otherwise
+   */
+  event ReserveFlashLoaning(address indexed asset, bool enabled);
+
   /**
    * @dev Emitted when the collateralization risk parameters for the specified asset are updated.
    * @param asset The address of the underlying asset of the reserve
    * @param ltv The loan to value of the asset when used as collateral
    * @param liquidationThreshold The threshold at which loans using this asset as collateral will be considered undercollateralized
    * @param liquidationBonus The bonus liquidators receive to liquidate this asset
-   **/
+   */
   event CollateralConfigurationChanged(
     address indexed asset,
     uint256 ltv,
@@ -50,34 +57,34 @@ interface IPoolConfigurator {
    * @dev Emitted when stable rate borrowing is enabled or disabled on a reserve
    * @param asset The address of the underlying asset of the reserve
    * @param enabled True if stable rate borrowing is enabled, false otherwise
-   **/
+   */
   event ReserveStableRateBorrowing(address indexed asset, bool enabled);
 
   /**
    * @dev Emitted when a reserve is activated or deactivated
    * @param asset The address of the underlying asset of the reserve
    * @param active True if reserve is active, false otherwise
-   **/
+   */
   event ReserveActive(address indexed asset, bool active);
 
   /**
    * @dev Emitted when a reserve is frozen or unfrozen
    * @param asset The address of the underlying asset of the reserve
    * @param frozen True if reserve is frozen, false otherwise
-   **/
+   */
   event ReserveFrozen(address indexed asset, bool frozen);
 
   /**
    * @dev Emitted when a reserve is paused or unpaused
    * @param asset The address of the underlying asset of the reserve
    * @param paused True if reserve is paused, false otherwise
-   **/
+   */
   event ReservePaused(address indexed asset, bool paused);
 
   /**
    * @dev Emitted when a reserve is dropped.
    * @param asset The address of the underlying asset of the reserve
-   **/
+   */
   event ReserveDropped(address indexed asset);
 
   /**
@@ -85,7 +92,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param oldReserveFactor The old reserve factor, expressed in bps
    * @param newReserveFactor The new reserve factor, expressed in bps
-   **/
+   */
   event ReserveFactorChanged(
     address indexed asset,
     uint256 oldReserveFactor,
@@ -97,7 +104,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param oldBorrowCap The old borrow cap
    * @param newBorrowCap The new borrow cap
-   **/
+   */
   event BorrowCapChanged(address indexed asset, uint256 oldBorrowCap, uint256 newBorrowCap);
 
   /**
@@ -105,7 +112,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param oldSupplyCap The old supply cap
    * @param newSupplyCap The new supply cap
-   **/
+   */
   event SupplyCapChanged(address indexed asset, uint256 oldSupplyCap, uint256 newSupplyCap);
 
   /**
@@ -113,7 +120,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param oldFee The old liquidation protocol fee, expressed in bps
    * @param newFee The new liquidation protocol fee, expressed in bps
-   **/
+   */
   event LiquidationProtocolFeeChanged(address indexed asset, uint256 oldFee, uint256 newFee);
 
   /**
@@ -133,7 +140,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param oldCategoryId The old eMode asset category
    * @param newCategoryId The new eMode asset category
-   **/
+   */
   event EModeAssetCategoryChanged(address indexed asset, uint8 oldCategoryId, uint8 newCategoryId);
 
   /**
@@ -144,7 +151,7 @@ interface IPoolConfigurator {
    * @param liquidationBonus The liquidationBonus for the asset category in eMode
    * @param oracle The optional address of the price oracle specific for this category
    * @param label A human readable identifier for the category
-   **/
+   */
   event EModeCategoryAdded(
     uint8 indexed categoryId,
     uint256 ltv,
@@ -159,7 +166,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param oldStrategy The address of the old interest strategy contract
    * @param newStrategy The address of the new interest strategy contract
-   **/
+   */
   event ReserveInterestRateStrategyChanged(
     address indexed asset,
     address oldStrategy,
@@ -171,7 +178,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param proxy The aToken proxy address
    * @param implementation The new aToken implementation
-   **/
+   */
   event ATokenUpgraded(
     address indexed asset,
     address indexed proxy,
@@ -183,7 +190,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param proxy The stable debt token proxy address
    * @param implementation The new aToken implementation
-   **/
+   */
   event StableDebtTokenUpgraded(
     address indexed asset,
     address indexed proxy,
@@ -195,7 +202,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param proxy The variable debt token proxy address
    * @param implementation The new aToken implementation
-   **/
+   */
   event VariableDebtTokenUpgraded(
     address indexed asset,
     address indexed proxy,
@@ -207,7 +214,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param oldDebtCeiling The old debt ceiling
    * @param newDebtCeiling The new debt ceiling
-   **/
+   */
   event DebtCeilingChanged(address indexed asset, uint256 oldDebtCeiling, uint256 newDebtCeiling);
 
   /**
@@ -215,7 +222,7 @@ interface IPoolConfigurator {
    * @param asset The address of the underlying asset of the reserve
    * @param oldState The old siloed borrowing state
    * @param newState The new siloed borrowing state
-   **/
+   */
   event SiloedBorrowingChanged(address indexed asset, bool oldState, bool newState);
 
   /**
@@ -229,7 +236,7 @@ interface IPoolConfigurator {
    * @dev Emitted when the total premium on flashloans is updated.
    * @param oldFlashloanPremiumTotal The old premium, expressed in bps
    * @param newFlashloanPremiumTotal The new premium, expressed in bps
-   **/
+   */
   event FlashloanPremiumTotalUpdated(
     uint128 oldFlashloanPremiumTotal,
     uint128 newFlashloanPremiumTotal
@@ -239,7 +246,7 @@ interface IPoolConfigurator {
    * @dev Emitted when the part of the premium that goes to protocol is updated.
    * @param oldFlashloanPremiumToProtocol The old premium, expressed in bps
    * @param newFlashloanPremiumToProtocol The new premium, expressed in bps
-   **/
+   */
   event FlashloanPremiumToProtocolUpdated(
     uint128 oldFlashloanPremiumToProtocol,
     uint128 newFlashloanPremiumToProtocol
@@ -249,32 +256,32 @@ interface IPoolConfigurator {
    * @dev Emitted when the reserve is set as borrowable/non borrowable in isolation mode.
    * @param asset The address of the underlying asset of the reserve
    * @param borrowable True if the reserve is borrowable in isolation, false otherwise
-   **/
+   */
   event BorrowableInIsolationChanged(address asset, bool borrowable);
 
   /**
    * @notice Initializes multiple reserves.
    * @param input The array of initialization parameters
-   **/
+   */
   function initReserves(ConfiguratorInputTypes.InitReserveInput[] calldata input) external;
 
   /**
    * @dev Updates the aToken implementation for the reserve.
    * @param input The aToken update parameters
-   **/
+   */
   function updateAToken(ConfiguratorInputTypes.UpdateATokenInput calldata input) external;
 
   /**
    * @notice Updates the stable debt token implementation for the reserve.
    * @param input The stableDebtToken update parameters
-   **/
+   */
   function updateStableDebtToken(ConfiguratorInputTypes.UpdateDebtTokenInput calldata input)
     external;
 
   /**
    * @notice Updates the variable debt token implementation for the asset.
    * @param input The variableDebtToken update parameters
-   **/
+   */
   function updateVariableDebtToken(ConfiguratorInputTypes.UpdateDebtTokenInput calldata input)
     external;
 
@@ -283,7 +290,7 @@ interface IPoolConfigurator {
    * @dev Can only be disabled (set to false) if stable borrowing is disabled
    * @param asset The address of the underlying asset of the reserve
    * @param enabled True if borrowing needs to be enabled, false otherwise
-   **/
+   */
   function setReserveBorrowing(address asset, bool enabled) external;
 
   /**
@@ -294,7 +301,7 @@ interface IPoolConfigurator {
    * @param ltv The loan to value of the asset when used as collateral
    * @param liquidationThreshold The threshold at which loans using this asset as collateral will be considered undercollateralized
    * @param liquidationBonus The bonus liquidators receive to liquidate this asset
-   **/
+   */
   function configureReserveAsCollateral(
     address asset,
     uint256 ltv,
@@ -307,14 +314,21 @@ interface IPoolConfigurator {
    * @dev Can only be enabled (set to true) if borrowing is enabled
    * @param asset The address of the underlying asset of the reserve
    * @param enabled True if stable rate borrowing needs to be enabled, false otherwise
-   **/
+   */
   function setReserveStableRateBorrowing(address asset, bool enabled) external;
 
+  /**
+   * @notice Enable or disable flashloans on a reserve
+   * @param asset The address of the underlying asset of the reserve
+   * @param enabled True if flashloans need to be enabled, false otherwise
+   */
+  function setReserveFlashLoaning(address asset, bool enabled) external;
+
   /**
    * @notice Activate or deactivate a reserve
    * @param asset The address of the underlying asset of the reserve
    * @param active True if the reserve needs to be active, false otherwise
-   **/
+   */
   function setReserveActive(address asset, bool active) external;
 
   /**
@@ -322,7 +336,7 @@ interface IPoolConfigurator {
    * or rate swap but allows repayments, liquidations, rate rebalances and withdrawals.
    * @param asset The address of the underlying asset of the reserve
    * @param freeze True if the reserve needs to be frozen, false otherwise
-   **/
+   */
   function setReserveFreeze(address asset, bool freeze) external;
 
   /**
@@ -333,7 +347,7 @@ interface IPoolConfigurator {
    * consistency in the debt ceiling calculations
    * @param asset The address of the underlying asset of the reserve
    * @param borrowable True if the asset should be borrowable in isolation, false otherwise
-   **/
+   */
   function setBorrowableInIsolation(address asset, bool borrowable) external;
 
   /**
@@ -341,21 +355,21 @@ interface IPoolConfigurator {
    * swap interest rate, liquidate, atoken transfers).
    * @param asset The address of the underlying asset of the reserve
    * @param paused True if pausing the reserve, false if unpausing
-   **/
+   */
   function setReservePause(address asset, bool paused) external;
 
   /**
    * @notice Updates the reserve factor of a reserve.
    * @param asset The address of the underlying asset of the reserve
    * @param newReserveFactor The new reserve factor of the reserve
-   **/
+   */
   function setReserveFactor(address asset, uint256 newReserveFactor) external;
 
   /**
    * @notice Sets the interest rate strategy of a reserve.
    * @param asset The address of the underlying asset of the reserve
    * @param newRateStrategyAddress The address of the new interest strategy contract
-   **/
+   */
   function setReserveInterestRateStrategyAddress(address asset, address newRateStrategyAddress)
     external;
 
@@ -363,42 +377,42 @@ interface IPoolConfigurator {
    * @notice Pauses or unpauses all the protocol reserves. In the paused state all the protocol interactions
    * are suspended.
    * @param paused True if protocol needs to be paused, false otherwise
-   **/
+   */
   function setPoolPause(bool paused) external;
 
   /**
    * @notice Updates the borrow cap of a reserve.
    * @param asset The address of the underlying asset of the reserve
    * @param newBorrowCap The new borrow cap of the reserve
-   **/
+   */
   function setBorrowCap(address asset, uint256 newBorrowCap) external;
 
   /**
    * @notice Updates the supply cap of a reserve.
    * @param asset The address of the underlying asset of the reserve
    * @param newSupplyCap The new supply cap of the reserve
-   **/
+   */
   function setSupplyCap(address asset, uint256 newSupplyCap) external;
 
   /**
    * @notice Updates the liquidation protocol fee of reserve.
    * @param asset The address of the underlying asset of the reserve
    * @param newFee The new liquidation protocol fee of the reserve, expressed in bps
-   **/
+   */
   function setLiquidationProtocolFee(address asset, uint256 newFee) external;
 
   /**
    * @notice Updates the unbacked mint cap of reserve.
    * @param asset The address of the underlying asset of the reserve
    * @param newUnbackedMintCap The new unbacked mint cap of the reserve
-   **/
+   */
   function setUnbackedMintCap(address asset, uint256 newUnbackedMintCap) external;
 
   /**
    * @notice Assign an efficiency mode (eMode) category to asset.
    * @param asset The address of the underlying asset of the reserve
    * @param newCategoryId The new category id of the asset
-   **/
+   */
   function setAssetEModeCategory(address asset, uint8 newCategoryId) external;
 
   /**
@@ -413,7 +427,7 @@ interface IPoolConfigurator {
    * @param liquidationBonus The liquidation bonus associated with the category
    * @param oracle The oracle associated with the category
    * @param label A label identifying the category
-   **/
+   */
   function setEModeCategory(
     uint8 categoryId,
     uint16 ltv,
@@ -426,7 +440,7 @@ interface IPoolConfigurator {
   /**
    * @notice Drops a reserve entirely.
    * @param asset The address of the reserve to drop
-   **/
+   */
   function dropReserve(address asset) external;
 
   /**
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolDataProvider.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolDataProvider.sol
index 331653a..e299d3f 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolDataProvider.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/interfaces/IPoolDataProvider.sol
@@ -1,7 +1,128 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
+import {IPoolAddressesProvider} from './IPoolAddressesProvider.sol';
+
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
+  function getReserveConfigurationData(address asset)
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
+  function getReserveCaps(address asset)
+    external
+    view
+    returns (uint256 borrowCap, uint256 supplyCap);
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
@@ -17,7 +138,7 @@ interface IPoolDataProvider {
    * @return liquidityIndex The liquidity index of the reserve
    * @return variableBorrowIndex The variable borrow index of the reserve
    * @return lastUpdateTimestamp The timestamp of the last update of the reserve
-   **/
+   */
   function getReserveData(address asset)
     external
     view
@@ -40,13 +161,76 @@ interface IPoolDataProvider {
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
+  function getUserReserveData(address asset, address user)
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
+  function getReserveTokensAddresses(address asset)
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
+  function getInterestRateStrategyAddress(address asset)
+    external
+    view
+    returns (address irStrategyAddress);
+
+  /**
+   * @notice Returns whether the reserve has FlashLoans enabled or disabled
+   * @param asset The address of the underlying asset of the reserve
+   * @return True if FlashLoans are enabled, false otherwise
+   */
+  function getFlashLoanEnabled(address asset) external view returns (bool);
 }
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
index 570c319..d24312b 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
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
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
index ed38c5c..6ef2d4d 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/configuration/ReserveConfiguration.sol
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
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
index 640e463..1dacaf3 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol
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
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/logic/ConfiguratorLogic.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/logic/ConfiguratorLogic.sol
index c29afa0..5cfba95 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/logic/ConfiguratorLogic.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/logic/ConfiguratorLogic.sol
@@ -4,7 +4,6 @@ pragma solidity 0.8.10;
 import {IPool} from '../../../interfaces/IPool.sol';
 import {IInitializableAToken} from '../../../interfaces/IInitializableAToken.sol';
 import {IInitializableDebtToken} from '../../../interfaces/IInitializableDebtToken.sol';
-import {IAaveIncentivesController} from '../../../interfaces/IAaveIncentivesController.sol';
 import {InitializableImmutableAdminUpgradeabilityProxy} from '../aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol';
 import {ReserveConfiguration} from '../configuration/ReserveConfiguration.sol';
 import {DataTypes} from '../types/DataTypes.sol';
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol
index 5306105..c000be3 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 /**
  * @title PercentageMath library
@@ -7,7 +7,7 @@ pragma solidity 0.8.10;
  * @notice Provides functions to perform percentage calculations
  * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
  * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
- **/
+ */
 library PercentageMath {
   // Maximum percentage factor (100.00%)
   uint256 internal constant PERCENTAGE_FACTOR = 1e4;
@@ -21,7 +21,7 @@ library PercentageMath {
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return result value percentmul percentage
-   **/
+   */
   function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
     // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
     assembly {
@@ -44,7 +44,7 @@ library PercentageMath {
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return result value percentdiv percentage
-   **/
+   */
   function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256 result) {
     // to avoid overflow, value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR
     assembly {
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol
index 61de06a..2294735 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 library ConfiguratorInputTypes {
   struct InitReserveInput {
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
index 7113a0a..c40d732 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: BUSL-1.1
-pragma solidity 0.8.10;
+pragma solidity ^0.8.0;
 
 library DataTypes {
   struct ReserveData {
diff --git a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/pool/PoolConfigurator.sol b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/pool/PoolConfigurator.sol
index b99610c..4d98e10 100644
--- a/downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/pool/PoolConfigurator.sol
+++ b/downloads/mainnet/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/pool/PoolConfigurator.sol
@@ -18,7 +18,7 @@ import {IPoolDataProvider} from '../../interfaces/IPoolDataProvider.sol';
  * @title PoolConfigurator
  * @author Aave
  * @dev Implements the configuration methods for the Aave protocol
- **/
+ */
 contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   using PercentageMath for uint256;
   using ReserveConfiguration for DataTypes.ReserveConfigurationMap;
@@ -28,7 +28,7 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
 
   /**
    * @dev Only pool admin can call functions marked by this modifier.
-   **/
+   */
   modifier onlyPoolAdmin() {
     _onlyPoolAdmin();
     _;
@@ -36,7 +36,7 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
 
   /**
    * @dev Only emergency admin can call functions marked by this modifier.
-   **/
+   */
   modifier onlyEmergencyAdmin() {
     _onlyEmergencyAdmin();
     _;
@@ -44,7 +44,7 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
 
   /**
    * @dev Only emergency or pool admin can call functions marked by this modifier.
-   **/
+   */
   modifier onlyEmergencyOrPoolAdmin() {
     _onlyPoolOrEmergencyAdmin();
     _;
@@ -52,7 +52,7 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
 
   /**
    * @dev Only asset listing or pool admin can call functions marked by this modifier.
-   **/
+   */
   modifier onlyAssetListingOrPoolAdmins() {
     _onlyAssetListingOrPoolAdmins();
     _;
@@ -60,7 +60,7 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
 
   /**
    * @dev Only risk or pool admin can call functions marked by this modifier.
-   **/
+   */
   modifier onlyRiskOrPoolAdmins() {
     _onlyRiskOrPoolAdmins();
     _;
@@ -191,6 +191,19 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
     emit ReserveStableRateBorrowing(asset, enabled);
   }
 
+  /// @inheritdoc IPoolConfigurator
+  function setReserveFlashLoaning(address asset, bool enabled)
+    external
+    override
+    onlyRiskOrPoolAdmins
+  {
+    DataTypes.ReserveConfigurationMap memory currentConfig = _pool.getConfiguration(asset);
+
+    currentConfig.setFlashLoanEnabled(enabled);
+    _pool.setConfiguration(asset, currentConfig);
+    emit ReserveFlashLoaning(asset, enabled);
+  }
+
   /// @inheritdoc IPoolConfigurator
   function setReserveActive(address asset, bool active) external override onlyPoolAdmin {
     if (!active) _checkNoSuppliers(asset);
@@ -480,9 +493,11 @@ contract PoolConfigurator is VersionedInitializable, IPoolConfigurator {
   }
 
   function _checkNoSuppliers(address asset) internal view {
-    uint256 totalATokens = IPoolDataProvider(_addressesProvider.getPoolDataProvider())
-      .getATokenTotalSupply(asset);
-    require(totalATokens == 0, Errors.RESERVE_LIQUIDITY_NOT_ZERO);
+    (, uint256 accruedToTreasury, uint256 totalATokens, , , , , , , , , ) = IPoolDataProvider(
+      _addressesProvider.getPoolDataProvider()
+    ).getReserveData(asset);
+
+    require(totalATokens == 0 && accruedToTreasury == 0, Errors.RESERVE_LIQUIDITY_NOT_ZERO);
   }
 
   function _checkNoBorrowers(address asset) internal view {
```
