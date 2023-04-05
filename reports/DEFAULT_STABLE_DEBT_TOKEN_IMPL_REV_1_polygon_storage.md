| Name                    | Type                                                   | Slot | Offset | Bytes | Contract                                                                       |
|-------------------------|--------------------------------------------------------|------|--------|-------|--------------------------------------------------------------------------------|
| lastInitializedRevision | uint256                                                | 0    | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| initializing            | bool                                                   | 1    | 0      | 1     | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| ______gap               | uint256[50]                                            | 2    | 0      | 1600  | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _nonces                 | mapping(address => uint256)                            | 52   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _domainSeparator        | bytes32                                                | 53   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _borrowAllowances       | mapping(address => mapping(address => uint256))        | 54   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _underlyingAsset        | address                                                | 55   | 0      | 20    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _userState              | mapping(address => struct IncentivizedERC20.UserState) | 56   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _allowances             | mapping(address => mapping(address => uint256))        | 57   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _totalSupply            | uint256                                                | 58   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _name                   | string                                                 | 59   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _symbol                 | string                                                 | 60   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _decimals               | uint8                                                  | 61   | 0      | 1     | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _incentivesController   | contract IAaveIncentivesController                     | 61   | 1      | 20    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _timestamps             | mapping(address => uint40)                             | 62   | 0      | 32    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _avgStableRate          | uint128                                                | 63   | 0      | 16    | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
| _totalSupplyTimestamp   | uint40                                                 | 63   | 16     | 5     | src/downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol:StableDebtToken |
