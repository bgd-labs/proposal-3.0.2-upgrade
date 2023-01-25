```diff
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
similarity index 98%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
index 7dc5593..326d738 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
similarity index 88%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
index 0269305..6303454 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 import {IERC20} from './IERC20.sol';
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
similarity index 100%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/interfaces/IScaledBalanceToken.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol
similarity index 71%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/interfaces/IScaledBalanceToken.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol
index 89ccddf..fe311fb 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/interfaces/IScaledBalanceToken.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/interfaces/IScaledBalanceToken.sol
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
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
similarity index 99%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
index 570c319..d24312b 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol
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
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/misc/interfaces/IEACAggregatorProxy.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol
similarity index 100%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/misc/interfaces/IEACAggregatorProxy.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/RewardsController.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/RewardsController.sol
similarity index 99%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/RewardsController.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/RewardsController.sol
index f147d1e..cfa4d82 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/RewardsController.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/RewardsController.sol
@@ -18,7 +18,7 @@ import {IEACAggregatorProxy} from '../misc/interfaces/IEACAggregatorProxy.sol';
 contract RewardsController is RewardsDistributor, VersionedInitializable, IRewardsController {
   using SafeCast for uint256;
 
-  uint256 public constant REVISION = 2;
+  uint256 public constant REVISION = 1;
 
   // This mapping allows whitelisted addresses to claim on behalf of others
   // useful for contracts that hold tokens to be rewarded but don't have any native logic to claim Liquidity Mining rewards
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/RewardsDistributor.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/RewardsDistributor.sol
similarity index 100%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/RewardsDistributor.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/RewardsDistributor.sol
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/interfaces/IRewardsController.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol
similarity index 100%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/interfaces/IRewardsController.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/interfaces/IRewardsDistributor.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol
similarity index 100%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/interfaces/IRewardsDistributor.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/interfaces/ITransferStrategyBase.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol
similarity index 100%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/interfaces/ITransferStrategyBase.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/libraries/RewardsDataTypes.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol
similarity index 100%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/lib/aave-v3-periphery/contracts/rewards/libraries/RewardsDataTypes.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL/RewardsController/@aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol
```
