```diff
diff --git a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol
index ddb6f13..13fd081 100644
--- a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol
+++ b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/misc/interfaces/IEACAggregatorProxy.sol
@@ -1,5 +1,5 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.10;
 
 interface IEACAggregatorProxy {
   function decimals() external view returns (uint8);
diff --git a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/EmissionManager.sol b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/EmissionManager.sol
index fe49e77..7216518 100644
--- a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/EmissionManager.sol
+++ b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/EmissionManager.sol
@@ -1,5 +1,5 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.10;
 
 import {Ownable} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol';
 import {IEACAggregatorProxy} from '../misc/interfaces/IEACAggregatorProxy.sol';
@@ -29,11 +29,9 @@ contract EmissionManager is Ownable, IEmissionManager {
 
   /**
    * Constructor.
-   * @param controller The address of the RewardsController contract
    * @param owner The address of the owner
    */
-  constructor(address controller, address owner) {
-    _rewardsController = IRewardsController(controller);
+  constructor(address owner) {
     transferOwnership(owner);
   }
 
@@ -89,11 +87,6 @@ contract EmissionManager is Ownable, IEmissionManager {
     _rewardsController.setClaimer(user, claimer);
   }
 
-  /// @inheritdoc IEmissionManager
-  function setEmissionManager(address emissionManager) external override onlyOwner {
-    _rewardsController.setEmissionManager(emissionManager);
-  }
-
   /// @inheritdoc IEmissionManager
   function setEmissionAdmin(address reward, address admin) external override onlyOwner {
     address oldAdmin = _emissionAdmins[reward];
diff --git a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IEmissionManager.sol b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IEmissionManager.sol
index b31d338..944a5f9 100644
--- a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IEmissionManager.sol
+++ b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IEmissionManager.sol
@@ -1,5 +1,5 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.10;
 
 import {IEACAggregatorProxy} from '../../misc/interfaces/IEACAggregatorProxy.sol';
 import {RewardsDataTypes} from '../libraries/RewardsDataTypes.sol';
@@ -92,13 +92,6 @@ interface IEmissionManager {
    */
   function setClaimer(address user, address claimer) external;
 
-  /**
-   * @dev Updates the address of the emission manager
-   * @dev Only callable by the owner of the EmissionManager
-   * @param emissionManager The address of the new EmissionManager
-   */
-  function setEmissionManager(address emissionManager) external;
-
   /**
    * @dev Updates the admin of the reward emission
    * @dev Only callable by the owner of the EmissionManager
diff --git a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol
index 706e3cd..506bf78 100644
--- a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol
+++ b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsController.sol
@@ -1,5 +1,5 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.10;
 
 import {IRewardsDistributor} from './IRewardsDistributor.sol';
 import {ITransferStrategyBase} from './ITransferStrategyBase.sol';
@@ -110,15 +110,16 @@ interface IRewardsController is IRewardsDistributor {
   function configureAssets(RewardsDataTypes.RewardsConfigInput[] memory config) external;
 
   /**
-   * @dev Called by the corresponding asset on any update that affects the rewards distribution
-   * @param user The address of the user
-   * @param userBalance The user balance of the asset
-   * @param totalSupply The total supply of the asset
+   * @dev Called by the corresponding asset on transfer hook in order to update the rewards distribution.
+   * @dev The units of `totalSupply` and `userBalance` should be the same.
+   * @param user The address of the user whose asset balance has changed
+   * @param totalSupply The total supply of the asset prior to user balance change
+   * @param userBalance The previous user balance prior to balance change
    **/
   function handleAction(
     address user,
-    uint256 userBalance,
-    uint256 totalSupply
+    uint256 totalSupply,
+    uint256 userBalance
   ) external;
 
   /**
diff --git a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol
index 431fdfe..c18de27 100644
--- a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol
+++ b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/IRewardsDistributor.sol
@@ -1,5 +1,5 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.10;
 
 /**
  * @title IRewardsDistributor
@@ -45,16 +45,6 @@ interface IRewardsDistributor {
     uint256 rewardsAccrued
   );
 
-  /**
-   * @dev Emitted when the emission manager address is updated.
-   * @param oldEmissionManager The address of the old emission manager
-   * @param newEmissionManager The address of the new emission manager
-   */
-  event EmissionManagerUpdated(
-    address indexed oldEmissionManager,
-    address indexed newEmissionManager
-  );
-
   /**
    * @dev Sets the end date for the distribution
    * @param asset The asset to incentivize
@@ -119,6 +109,15 @@ interface IRewardsDistributor {
       uint256
     );
 
+  /**
+   * @dev Calculates the next value of an specific distribution index, with validations.
+   * @param asset The incentivized asset
+   * @param reward The reward token of the incentivized asset
+   * @return The old index of the asset distribution
+   * @return The new index of the asset distribution
+   **/
+  function getAssetIndex(address asset, address reward) external view returns (uint256, uint256);
+
   /**
    * @dev Returns the list of available reward token addresses of an incentivized asset
    * @param asset The incentivized asset
@@ -176,11 +175,12 @@ interface IRewardsDistributor {
    * @dev Returns the address of the emission manager
    * @return The address of the EmissionManager
    */
+  function EMISSION_MANAGER() external view returns (address);
+
+  /**
+   * @dev Returns the address of the emission manager.
+   * Deprecated: This getter is maintained for compatibility purposes. Use the `EMISSION_MANAGER()` function instead.
+   * @return The address of the EmissionManager
+   */
   function getEmissionManager() external view returns (address);
-
-  /**
-   * @dev Updates the address of the emission manager
-   * @param emissionManager The address of the new EmissionManager
-   */
-  function setEmissionManager(address emissionManager) external;
 }
diff --git a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol
index 46d67b0..b1007a0 100644
--- a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol
+++ b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/interfaces/ITransferStrategyBase.sol
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
+pragma solidity ^0.8.10;
 
 interface ITransferStrategyBase {
   event EmergencyWithdrawal(
diff --git a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol
index e8e631c..64e0957 100644
--- a/downloads/polygon/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol
+++ b/downloads/mainnet/EMISSION_MANAGER/EmissionManager/@aave/periphery-v3/contracts/rewards/libraries/RewardsDataTypes.sol
@@ -1,5 +1,5 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.10;
 
 import {ITransferStrategyBase} from '../interfaces/ITransferStrategyBase.sol';
 import {IEACAggregatorProxy} from '../../misc/interfaces/IEACAggregatorProxy.sol';
@@ -22,22 +22,33 @@ library RewardsDataTypes {
   }
 
   struct UserData {
-    uint104 index; // matches reward index
+    // Liquidity index of the reward distribution for the user
+    uint104 index;
+    // Amount of accrued rewards for the user since last user index update
     uint128 accrued;
   }
 
   struct RewardData {
+    // Liquidity index of the reward distribution
     uint104 index;
+    // Amount of reward tokens distributed per second
     uint88 emissionPerSecond;
+    // Timestamp of the last reward index update
     uint32 lastUpdateTimestamp;
+    // The end of the distribution of rewards (in seconds)
     uint32 distributionEnd;
+    // Map of user addresses and their rewards data (userAddress => userData)
     mapping(address => UserData) usersData;
   }
 
   struct AssetData {
+    // Map of reward token addresses and their data (rewardTokenAddress => rewardData)
     mapping(address => RewardData) rewards;
+    // List of reward token addresses for the asset
     mapping(uint128 => address) availableRewards;
+    // Count of reward tokens for the asset
     uint128 availableRewardsCount;
+    // Number of decimals of the asset
     uint8 decimals;
   }
 }
```
