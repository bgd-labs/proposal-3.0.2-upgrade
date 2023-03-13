| Name                            | Type                                                      | Slot | Offset | Bytes | Contract                                 |
|---------------------------------|-----------------------------------------------------------|------|--------|-------|------------------------------------------|
| lastInitializedRevision         | uint256                                                   | 0    | 0      | 32    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| initializing                    | bool                                                      | 1    | 0      | 1     | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| ______gap                       | uint256[50]                                               | 2    | 0      | 1600  | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _reserves                       | mapping(address => struct DataTypes.ReserveData)          | 52   | 0      | 32    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _usersConfig                    | mapping(address => struct DataTypes.UserConfigurationMap) | 53   | 0      | 32    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _reservesList                   | mapping(uint256 => address)                               | 54   | 0      | 32    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _eModeCategories                | mapping(uint8 => struct DataTypes.EModeCategory)          | 55   | 0      | 32    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _usersEModeCategory             | mapping(address => uint8)                                 | 56   | 0      | 32    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _bridgeProtocolFee              | uint256                                                   | 57   | 0      | 32    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _flashLoanPremiumTotal          | uint128                                                   | 58   | 0      | 16    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _flashLoanPremiumToProtocol     | uint128                                                   | 58   | 16     | 16    | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _maxStableRateBorrowSizePercent | uint64                                                    | 59   | 0      | 8     | src/downloads/mainnet/POOL_IMPL.sol:Pool |
| _reservesCount                  | uint16                                                    | 59   | 8      | 2     | src/downloads/mainnet/POOL_IMPL.sol:Pool |
