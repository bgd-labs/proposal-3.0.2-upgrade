```diff
diff --git a/src/downloads/polygon/EMISSION_MANAGER.sol b/src/downloads/EMISSION_MANAGER.sol
index 1d8e522..b897653 100644
--- a/src/downloads/polygon/EMISSION_MANAGER.sol
+++ b/src/downloads/EMISSION_MANAGER.sol
@@ -1,5 +1,5 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity ^0.8.10;
 
 /*
  * @dev Provides information about the current execution context, including the
@@ -165,22 +165,33 @@ library RewardsDataTypes {
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
@@ -303,6 +314,21 @@ interface IRewardsDistributor {
       uint256
     );
 
+  /**
+   * @dev Calculates the next value of an specific distribution index, with validations.
+   * @param asset The incentivized asset
+   * @param reward The reward token of the incentivized asset
+   * @return The old index of the asset distribution
+   * @return The new index of the asset distribution
+   **/
+  function getAssetIndex(address asset, address reward)
+    external
+    view
+    returns(
+      uint256,
+      uint256
+    );
+
   /**
    * @dev Returns the list of available reward token addresses of an incentivized asset
    * @param asset The incentivized asset
@@ -473,10 +499,10 @@ interface IRewardsController is IRewardsDistributor {
   function configureAssets(RewardsDataTypes.RewardsConfigInput[] memory config) external;
 
   /**
-   * @dev Called by the corresponding asset on any update that affects the rewards distribution
-   * @param user The address of the user
-   * @param userBalance The user balance of the asset
-   * @param totalSupply The total supply of the asset
+   * @dev Called by the corresponding asset on transfer hook in order to update the rewards distribution.
+   * @param user The address of the user whose asset balance has changed 
+   * @param userBalance The previous user balance prior to balance change 
+   * @param totalSupply The total supply of the asset prior to user balance change
    **/
   function handleAction(
     address user,
@@ -727,18 +753,20 @@ contract EmissionManager is Ownable, IEmissionManager {
   }
 
   /// @inheritdoc IEmissionManager
-  function setTransferStrategy(
-    address reward,
-    ITransferStrategyBase transferStrategy
-  ) external override onlyEmissionAdmin(reward) {
+  function setTransferStrategy(address reward, ITransferStrategyBase transferStrategy)
+    external
+    override
+    onlyEmissionAdmin(reward)
+  {
     _rewardsController.setTransferStrategy(reward, transferStrategy);
   }
 
   /// @inheritdoc IEmissionManager
-  function setRewardOracle(
-    address reward,
-    IEACAggregatorProxy rewardOracle
-  ) external override onlyEmissionAdmin(reward) {
+  function setRewardOracle(address reward, IEACAggregatorProxy rewardOracle)
+    external
+    override
+    onlyEmissionAdmin(reward)
+  {
     _rewardsController.setRewardOracle(reward, rewardOracle);
   }
 
```
