```diff
diff --git a/src/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol b/src/downloads/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
index d1de49d..1105c92 100644
--- a/src/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
+++ b/src/downloads/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
@@ -457,11 +457,7 @@ interface IERC20 {
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
@@ -815,10 +811,17 @@ abstract contract RewardsDistributor is IRewardsDistributor {
   }
 
   /// @inheritdoc IRewardsDistributor
-  function getRewardsData(
-    address asset,
-    address reward
-  ) public view override returns (uint256, uint256, uint256, uint256) {
+  function getRewardsData(address asset, address reward)
+    public
+    view
+    override
+    returns (
+      uint256,
+      uint256,
+      uint256,
+      uint256
+    )
+  {
     return (
       _assets[asset].rewards[reward].index,
       _assets[asset].rewards[reward].emissionPerSecond,
@@ -828,24 +831,28 @@ abstract contract RewardsDistributor is IRewardsDistributor {
   }
 
   /// @inheritdoc IRewardsDistributor
-  function getAssetIndex(
-    address asset,
-    address reward
-  ) external view override returns (uint256, uint256) {
+  function getAssetIndex(address asset, address reward)
+    external
+    view
+    override
+    returns (uint256, uint256)
+  {
     RewardsDataTypes.RewardData storage rewardData = _assets[asset].rewards[reward];
     return
       _getAssetIndex(
         rewardData,
         IScaledBalanceToken(asset).scaledTotalSupply(),
-        10 ** _assets[asset].decimals
+        10**_assets[asset].decimals
       );
   }
 
   /// @inheritdoc IRewardsDistributor
-  function getDistributionEnd(
-    address asset,
-    address reward
-  ) external view override returns (uint256) {
+  function getDistributionEnd(address asset, address reward)
+    external
+    view
+    override
+    returns (uint256)
+  {
     return _assets[asset].rewards[reward].distributionEnd;
   }
 
@@ -875,10 +882,12 @@ abstract contract RewardsDistributor is IRewardsDistributor {
   }
 
   /// @inheritdoc IRewardsDistributor
-  function getUserAccruedRewards(
-    address user,
-    address reward
-  ) external view override returns (uint256) {
+  function getUserAccruedRewards(address user, address reward)
+    external
+    view
+    override
+    returns (uint256)
+  {
     uint256 totalAccrued;
     for (uint256 i = 0; i < _assetsList.length; i++) {
       totalAccrued += _assets[_assetsList[i]].rewards[reward].usersData[user].accrued;
@@ -897,10 +906,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
   }
 
   /// @inheritdoc IRewardsDistributor
-  function getAllUserRewards(
-    address[] calldata assets,
-    address user
-  )
+  function getAllUserRewards(address[] calldata assets, address user)
     external
     view
     override
@@ -970,7 +976,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
       (uint256 newIndex, ) = _updateRewardData(
         rewardConfig,
         IScaledBalanceToken(asset).scaledTotalSupply(),
-        10 ** decimals
+        10**decimals
       );
 
       uint256 oldEmissionPerSecond = rewardConfig.emissionPerSecond;
@@ -1025,7 +1031,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
       (uint256 newIndex, ) = _updateRewardData(
         rewardConfig,
         rewardsInput[i].totalSupply,
-        10 ** decimals
+        10**decimals
       );
 
       // Configure emission and distribution end of the reward per asset
@@ -1122,7 +1128,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
     uint256 assetUnit;
     uint256 numAvailableRewards = _assets[asset].availableRewardsCount;
     unchecked {
-      assetUnit = 10 ** _assets[asset].decimals;
+      assetUnit = 10**_assets[asset].decimals;
     }
 
     if (numAvailableRewards == 0) {
@@ -1217,7 +1223,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
     RewardsDataTypes.RewardData storage rewardData = _assets[userAssetBalance.asset].rewards[
       reward
     ];
-    uint256 assetUnit = 10 ** _assets[userAssetBalance.asset].decimals;
+    uint256 assetUnit = 10**_assets[userAssetBalance.asset].decimals;
     (, uint256 nextIndex) = _getAssetIndex(rewardData, userAssetBalance.totalSupply, assetUnit);
 
     return
@@ -1293,10 +1299,11 @@ abstract contract RewardsDistributor is IRewardsDistributor {
    * @param user Address of the user
    * @return userAssetBalances contains a list of structs with user balance and total supply of the given assets
    */
-  function _getUserAssetBalances(
-    address[] calldata assets,
-    address user
-  ) internal view virtual returns (RewardsDataTypes.UserAssetBalance[] memory userAssetBalances);
+  function _getUserAssetBalances(address[] calldata assets, address user)
+    internal
+    view
+    virtual
+    returns (RewardsDataTypes.UserAssetBalance[] memory userAssetBalances);
 
   /// @inheritdoc IRewardsDistributor
   function getAssetDecimals(address asset) external view returns (uint8) {
@@ -1571,9 +1578,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
   }
 
   /// @inheritdoc IRewardsController
-  function configureAssets(
-    RewardsDataTypes.RewardsConfigInput[] memory config
-  ) external override onlyEmissionManager {
+  function configureAssets(RewardsDataTypes.RewardsConfigInput[] memory config)
+    external
+    override
+    onlyEmissionManager
+  {
     for (uint256 i = 0; i < config.length; i++) {
       // Get the current Scaled Total Supply of AToken or Debt token
       config[i].totalSupply = IScaledBalanceToken(config[i].asset).scaledTotalSupply();
@@ -1588,23 +1597,27 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
   }
 
   /// @inheritdoc IRewardsController
-  function setTransferStrategy(
-    address reward,
-    ITransferStrategyBase transferStrategy
-  ) external onlyEmissionManager {
+  function setTransferStrategy(address reward, ITransferStrategyBase transferStrategy)
+    external
+    onlyEmissionManager
+  {
     _installTransferStrategy(reward, transferStrategy);
   }
 
   /// @inheritdoc IRewardsController
-  function setRewardOracle(
-    address reward,
-    IEACAggregatorProxy rewardOracle
-  ) external onlyEmissionManager {
+  function setRewardOracle(address reward, IEACAggregatorProxy rewardOracle)
+    external
+    onlyEmissionManager
+  {
     _setRewardOracle(reward, rewardOracle);
   }
 
   /// @inheritdoc IRewardsController
-  function handleAction(address user, uint256 totalSupply, uint256 userBalance) external override {
+  function handleAction(
+    address user,
+    uint256 totalSupply,
+    uint256 userBalance
+  ) external override {
     _updateData(msg.sender, user, userBalance, totalSupply);
   }
 
@@ -1642,10 +1655,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
   }
 
   /// @inheritdoc IRewardsController
-  function claimAllRewards(
-    address[] calldata assets,
-    address to
-  ) external override returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
+  function claimAllRewards(address[] calldata assets, address to)
+    external
+    override
+    returns (address[] memory rewardsList, uint256[] memory claimedAmounts)
+  {
     require(to != address(0), 'INVALID_TO_ADDRESS');
     return _claimAllRewards(assets, msg.sender, msg.sender, to);
   }
@@ -1667,9 +1681,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
   }
 
   /// @inheritdoc IRewardsController
-  function claimAllRewardsToSelf(
-    address[] calldata assets
-  ) external override returns (address[] memory rewardsList, uint256[] memory claimedAmounts) {
+  function claimAllRewardsToSelf(address[] calldata assets)
+    external
+    override
+    returns (address[] memory rewardsList, uint256[] memory claimedAmounts)
+  {
     return _claimAllRewards(assets, msg.sender, msg.sender, msg.sender);
   }
 
@@ -1685,10 +1701,12 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
    * @param user Address of the user
    * @return userAssetBalances contains a list of structs with user balance and total supply of the given assets
    */
-  function _getUserAssetBalances(
-    address[] calldata assets,
-    address user
-  ) internal view override returns (RewardsDataTypes.UserAssetBalance[] memory userAssetBalances) {
+  function _getUserAssetBalances(address[] calldata assets, address user)
+    internal
+    view
+    override
+    returns (RewardsDataTypes.UserAssetBalance[] memory userAssetBalances)
+  {
     userAssetBalances = new RewardsDataTypes.UserAssetBalance[](assets.length);
     for (uint256 i = 0; i < assets.length; i++) {
       userAssetBalances[i].asset = assets[i];
@@ -1795,7 +1813,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
    * @param reward Address of the reward token
    * @param amount Amount of rewards to transfer
    */
-  function _transferRewards(address to, address reward, uint256 amount) internal {
+  function _transferRewards(
+    address to,
+    address reward,
+    uint256 amount
+  ) internal {
     ITransferStrategyBase transferStrategy = _transferStrategy[reward];
 
     bool success = transferStrategy.performTransfer(to, reward, amount);
@@ -1826,10 +1848,9 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
    * @param reward The address of the reward token
    * @param transferStrategy The address of the reward TransferStrategy
    */
-  function _installTransferStrategy(
-    address reward,
-    ITransferStrategyBase transferStrategy
-  ) internal {
+  function _installTransferStrategy(address reward, ITransferStrategyBase transferStrategy)
+    internal
+  {
     require(address(transferStrategy) != address(0), 'STRATEGY_CAN_NOT_BE_ZERO');
     require(_isContract(address(transferStrategy)) == true, 'STRATEGY_MUST_BE_CONTRACT');
 
```
