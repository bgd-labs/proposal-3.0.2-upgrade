```diff
diff --git a/src/downloads/mainnet/EMISSION_MANAGER.sol b/src/downloads/EMISSION_MANAGER.sol
index 1dc7788..b897653 100644
--- a/src/downloads/mainnet/EMISSION_MANAGER.sol
+++ b/src/downloads/EMISSION_MANAGER.sol
@@ -240,6 +240,16 @@ interface IRewardsDistributor {
     uint256 rewardsAccrued
   );
 
+  /**
+   * @dev Emitted when the emission manager address is updated.
+   * @param oldEmissionManager The address of the old emission manager
+   * @param newEmissionManager The address of the new emission manager
+   */
+  event EmissionManagerUpdated(
+    address indexed oldEmissionManager,
+    address indexed newEmissionManager
+  );
+
   /**
    * @dev Sets the end date for the distribution
    * @param asset The asset to incentivize
@@ -311,7 +321,13 @@ interface IRewardsDistributor {
    * @return The old index of the asset distribution
    * @return The new index of the asset distribution
    **/
-  function getAssetIndex(address asset, address reward) external view returns (uint256, uint256);
+  function getAssetIndex(address asset, address reward)
+    external
+    view
+    returns(
+      uint256,
+      uint256
+    );
 
   /**
    * @dev Returns the list of available reward token addresses of an incentivized asset
@@ -370,14 +386,13 @@ interface IRewardsDistributor {
    * @dev Returns the address of the emission manager
    * @return The address of the EmissionManager
    */
-  function EMISSION_MANAGER() external view returns (address);
-
-  /**
-   * @dev Returns the address of the emission manager.
-   * Deprecated: This getter is maintained for compatibility purposes. Use the `EMISSION_MANAGER()` function instead.
-   * @return The address of the EmissionManager
-   */
   function getEmissionManager() external view returns (address);
+
+  /**
+   * @dev Updates the address of the emission manager
+   * @param emissionManager The address of the new EmissionManager
+   */
+  function setEmissionManager(address emissionManager) external;
 }
 
 /**
@@ -485,15 +500,14 @@ interface IRewardsController is IRewardsDistributor {
 
   /**
    * @dev Called by the corresponding asset on transfer hook in order to update the rewards distribution.
-   * @dev The units of `totalSupply` and `userBalance` should be the same.
    * @param user The address of the user whose asset balance has changed 
-   * @param totalSupply The total supply of the asset prior to user balance change
    * @param userBalance The previous user balance prior to balance change 
+   * @param totalSupply The total supply of the asset prior to user balance change
    **/
   function handleAction(
     address user,
-    uint256 totalSupply,
-    uint256 userBalance
+    uint256 userBalance,
+    uint256 totalSupply
   ) external;
 
   /**
@@ -665,6 +679,13 @@ interface IEmissionManager {
    */
   function setClaimer(address user, address claimer) external;
 
+  /**
+   * @dev Updates the address of the emission manager
+   * @dev Only callable by the owner of the EmissionManager
+   * @param emissionManager The address of the new EmissionManager
+   */
+  function setEmissionManager(address emissionManager) external;
+
   /**
    * @dev Updates the admin of the reward emission
    * @dev Only callable by the owner of the EmissionManager
@@ -715,9 +736,11 @@ contract EmissionManager is Ownable, IEmissionManager {
 
   /**
    * Constructor.
+   * @param controller The address of the RewardsController contract
    * @param owner The address of the owner
    */
-  constructor(address owner) {
+  constructor(address controller, address owner) {
+    _rewardsController = IRewardsController(controller);
     transferOwnership(owner);
   }
 
@@ -730,18 +753,20 @@ contract EmissionManager is Ownable, IEmissionManager {
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
 
@@ -771,6 +796,11 @@ contract EmissionManager is Ownable, IEmissionManager {
     _rewardsController.setClaimer(user, claimer);
   }
 
+  /// @inheritdoc IEmissionManager
+  function setEmissionManager(address emissionManager) external override onlyOwner {
+    _rewardsController.setEmissionManager(emissionManager);
+  }
+
   /// @inheritdoc IEmissionManager
   function setEmissionAdmin(address reward, address admin) external override onlyOwner {
     address oldAdmin = _emissionAdmins[reward];
```
