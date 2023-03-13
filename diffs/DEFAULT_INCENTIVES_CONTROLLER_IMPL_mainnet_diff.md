```diff
diff --git a/src/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol b/src/downloads/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
index d1de49d..98162ee 100644
--- a/src/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
+++ b/src/downloads/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
@@ -530,6 +530,16 @@ interface IRewardsDistributor {
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
@@ -601,7 +611,13 @@ interface IRewardsDistributor {
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
@@ -660,14 +676,13 @@ interface IRewardsDistributor {
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
 
 interface ITransferStrategyBase {
@@ -787,10 +802,7 @@ library RewardsDataTypes {
  **/
 abstract contract RewardsDistributor is IRewardsDistributor {
   using SafeCast for uint256;
-
   // Manager of incentives
-  address public immutable EMISSION_MANAGER;
-  // Deprecated: This storage slot is kept for backwards compatibility purposes.
   address internal _emissionManager;
 
   // Map of rewarded asset addresses and their data (assetAddress => assetData)
@@ -806,19 +818,22 @@ abstract contract RewardsDistributor is IRewardsDistributor {
   address[] internal _assetsList;
 
   modifier onlyEmissionManager() {
-    require(msg.sender == EMISSION_MANAGER, 'ONLY_EMISSION_MANAGER');
+    require(msg.sender == _emissionManager, 'ONLY_EMISSION_MANAGER');
     _;
   }
 
-  constructor(address emissionManager) {
-    EMISSION_MANAGER = emissionManager;
-  }
-
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
@@ -828,24 +843,28 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
 
@@ -875,10 +894,12 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
@@ -897,10 +918,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
@@ -970,7 +988,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
       (uint256 newIndex, ) = _updateRewardData(
         rewardConfig,
         IScaledBalanceToken(asset).scaledTotalSupply(),
-        10 ** decimals
+        10**decimals
       );
 
       uint256 oldEmissionPerSecond = rewardConfig.emissionPerSecond;
@@ -1025,7 +1043,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
       (uint256 newIndex, ) = _updateRewardData(
         rewardConfig,
         rewardsInput[i].totalSupply,
-        10 ** decimals
+        10**decimals
       );
 
       // Configure emission and distribution end of the reward per asset
@@ -1122,7 +1140,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
     uint256 assetUnit;
     uint256 numAvailableRewards = _assets[asset].availableRewardsCount;
     unchecked {
-      assetUnit = 10 ** _assets[asset].decimals;
+      assetUnit = 10**_assets[asset].decimals;
     }
 
     if (numAvailableRewards == 0) {
@@ -1217,7 +1235,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
     RewardsDataTypes.RewardData storage rewardData = _assets[userAssetBalance.asset].rewards[
       reward
     ];
-    uint256 assetUnit = 10 ** _assets[userAssetBalance.asset].decimals;
+    uint256 assetUnit = 10**_assets[userAssetBalance.asset].decimals;
     (, uint256 nextIndex) = _getAssetIndex(rewardData, userAssetBalance.totalSupply, assetUnit);
 
     return
@@ -1293,10 +1311,11 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
@@ -1305,7 +1324,22 @@ abstract contract RewardsDistributor is IRewardsDistributor {
 
   /// @inheritdoc IRewardsDistributor
   function getEmissionManager() external view returns (address) {
-    return EMISSION_MANAGER;
+    return _emissionManager;
+  }
+
+  /// @inheritdoc IRewardsDistributor
+  function setEmissionManager(address emissionManager) external onlyEmissionManager {
+    _setEmissionManager(emissionManager);
+  }
+
+  /**
+   * @dev Updates the address of the emission manager
+   * @param emissionManager The address of the new EmissionManager
+   */
+  function _setEmissionManager(address emissionManager) internal {
+    address previousEmissionManager = _emissionManager;
+    _emissionManager = emissionManager;
+    emit EmissionManagerUpdated(previousEmissionManager, emissionManager);
   }
 }
 
@@ -1414,15 +1448,14 @@ interface IRewardsController is IRewardsDistributor {
 
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
@@ -1516,7 +1549,7 @@ interface IRewardsController is IRewardsDistributor {
 contract RewardsController is RewardsDistributor, VersionedInitializable, IRewardsController {
   using SafeCast for uint256;
 
-  uint256 public constant REVISION = 1;
+  uint256 public constant REVISION = 2;
 
   // This mapping allows whitelisted addresses to claim on behalf of others
   // useful for contracts that hold tokens to be rewarded but don't have any native logic to claim Liquidity Mining rewards
@@ -1539,13 +1572,13 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
     _;
   }
 
-  constructor(address emissionManager) RewardsDistributor(emissionManager) {}
-
   /**
    * @dev Initialize for RewardsController
-   * @dev It expects an address as argument since its initialized via PoolAddressesProvider._updateImpl()
+   * @param emissionManager address of the EmissionManager
    **/
-  function initialize(address) external initializer {}
+  function initialize(address emissionManager) external initializer {
+    _setEmissionManager(emissionManager);
+  }
 
   /// @inheritdoc IRewardsController
   function getClaimer(address user) external view override returns (address) {
@@ -1571,9 +1604,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1588,23 +1623,27 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
 
@@ -1642,10 +1681,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1667,9 +1707,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
 
@@ -1685,10 +1727,12 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1795,7 +1839,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1826,10 +1874,9 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
