| Name                    | Type                                                   | Slot | Offset | Bytes | Contract                                                    |
|-------------------------|--------------------------------------------------------|------|--------|-------|-------------------------------------------------------------|
| lastInitializedRevision | uint256                                                | 0    | 0      | 32    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| initializing            | bool                                                   | 1    | 0      | 1     | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| ______gap               | uint256[50]                                            | 2    | 0      | 1600  | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _userState              | mapping(address => struct IncentivizedERC20.UserState) | 52   | 0      | 32    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _allowances             | mapping(address => mapping(address => uint256))        | 53   | 0      | 32    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _totalSupply            | uint256                                                | 54   | 0      | 32    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _name                   | string                                                 | 55   | 0      | 32    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _symbol                 | string                                                 | 56   | 0      | 32    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _decimals               | uint8                                                  | 57   | 0      | 1     | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _incentivesController   | contract IAaveIncentivesController                     | 57   | 1      | 20    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _nonces                 | mapping(address => uint256)                            | 58   | 0      | 32    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _domainSeparator        | bytes32                                                | 59   | 0      | 32    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _treasury               | address                                                | 60   | 0      | 20    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
| _underlyingAsset        | address                                                | 61   | 0      | 20    | src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol:AToken |
