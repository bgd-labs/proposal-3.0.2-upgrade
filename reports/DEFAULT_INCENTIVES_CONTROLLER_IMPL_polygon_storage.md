| Name                    | Type                                                  | Slot | Offset | Bytes | Contract                                                                       |
|-------------------------|-------------------------------------------------------|------|--------|-------|--------------------------------------------------------------------------------|
| _emissionManager        | address                                               | 0    | 0      | 20    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| _assets                 | mapping(address => struct RewardsDataTypes.AssetData) | 1    | 0      | 32    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| _isRewardEnabled        | mapping(address => bool)                              | 2    | 0      | 32    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| _rewardsList            | address[]                                             | 3    | 0      | 32    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| _assetsList             | address[]                                             | 4    | 0      | 32    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| lastInitializedRevision | uint256                                               | 5    | 0      | 32    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| initializing            | bool                                                  | 6    | 0      | 1     | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| ______gap               | uint256[50]                                           | 7    | 0      | 1600  | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| _authorizedClaimers     | mapping(address => address)                           | 57   | 0      | 32    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| _transferStrategy       | mapping(address => contract ITransferStrategyBase)    | 58   | 0      | 32    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
| _rewardOracle           | mapping(address => contract IEACAggregatorProxy)      | 59   | 0      | 32    | src/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER_IMPL.sol:RewardsController |
