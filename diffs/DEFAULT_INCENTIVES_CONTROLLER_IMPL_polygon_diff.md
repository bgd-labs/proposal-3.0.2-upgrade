```diff
diff --git a/src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol b/src/downloads/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
index e0da3f2..98162ee 100644
--- a/src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
+++ b/src/downloads/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol
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
@@ -333,17 +333,17 @@ library SafeCast {
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
@@ -353,13 +353,14 @@ interface IScaledBalanceToken {
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
@@ -374,7 +375,7 @@ interface IScaledBalanceToken {
    * at the moment of the update
    * @param user The user whose balance is calculated
    * @return The scaled balance of the user
-   **/
+   */
   function scaledBalanceOf(address user) external view returns (uint256);
 
   /**
@@ -382,20 +383,20 @@ interface IScaledBalanceToken {
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
 
@@ -529,6 +530,16 @@ interface IRewardsDistributor {
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
@@ -600,7 +611,13 @@ interface IRewardsDistributor {
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
@@ -659,14 +676,13 @@ interface IRewardsDistributor {
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
@@ -786,10 +802,7 @@ library RewardsDataTypes {
  **/
 abstract contract RewardsDistributor is IRewardsDistributor {
   using SafeCast for uint256;
-
   // Manager of incentives
-  address public immutable EMISSION_MANAGER;
-  // Deprecated: This storage slot is kept for backwards compatibility purposes.
   address internal _emissionManager;
 
   // Map of rewarded asset addresses and their data (assetAddress => assetData)
@@ -805,19 +818,22 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
@@ -827,24 +843,28 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
 
@@ -874,10 +894,12 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
@@ -896,10 +918,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
@@ -969,7 +988,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
       (uint256 newIndex, ) = _updateRewardData(
         rewardConfig,
         IScaledBalanceToken(asset).scaledTotalSupply(),
-        10 ** decimals
+        10**decimals
       );
 
       uint256 oldEmissionPerSecond = rewardConfig.emissionPerSecond;
@@ -1024,7 +1043,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
       (uint256 newIndex, ) = _updateRewardData(
         rewardConfig,
         rewardsInput[i].totalSupply,
-        10 ** decimals
+        10**decimals
       );
 
       // Configure emission and distribution end of the reward per asset
@@ -1121,7 +1140,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
     uint256 assetUnit;
     uint256 numAvailableRewards = _assets[asset].availableRewardsCount;
     unchecked {
-      assetUnit = 10 ** _assets[asset].decimals;
+      assetUnit = 10**_assets[asset].decimals;
     }
 
     if (numAvailableRewards == 0) {
@@ -1216,7 +1235,7 @@ abstract contract RewardsDistributor is IRewardsDistributor {
     RewardsDataTypes.RewardData storage rewardData = _assets[userAssetBalance.asset].rewards[
       reward
     ];
-    uint256 assetUnit = 10 ** _assets[userAssetBalance.asset].decimals;
+    uint256 assetUnit = 10**_assets[userAssetBalance.asset].decimals;
     (, uint256 nextIndex) = _getAssetIndex(rewardData, userAssetBalance.totalSupply, assetUnit);
 
     return
@@ -1292,10 +1311,11 @@ abstract contract RewardsDistributor is IRewardsDistributor {
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
@@ -1304,7 +1324,22 @@ abstract contract RewardsDistributor is IRewardsDistributor {
 
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
 
@@ -1413,15 +1448,14 @@ interface IRewardsController is IRewardsDistributor {
 
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
@@ -1538,13 +1572,13 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1570,9 +1604,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1587,23 +1623,27 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
 
@@ -1641,10 +1681,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1666,9 +1707,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
 
@@ -1684,10 +1727,12 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1794,7 +1839,11 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
@@ -1825,10 +1874,9 @@ contract RewardsController is RewardsDistributor, VersionedInitializable, IRewar
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
