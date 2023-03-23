```diff
diff --git a/src/downloads/mainnet/EMISSION_MANAGER.sol b/src/downloads/EMISSION_MANAGER.sol
index 1dc7788..9a6151e 100644
--- a/src/downloads/mainnet/EMISSION_MANAGER.sol
+++ b/src/downloads/EMISSION_MANAGER.sol
@@ -730,18 +730,20 @@ contract EmissionManager is Ownable, IEmissionManager {
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
