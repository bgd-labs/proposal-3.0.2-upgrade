| Name                    | Type                                                   | Slot | Offset | Bytes | Contract                                                                                 |
|-------------------------|--------------------------------------------------------|------|--------|-------|------------------------------------------------------------------------------------------|
| lastInitializedRevision | uint256                                                | 0    | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| initializing            | bool                                                   | 1    | 0      | 1     | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| ______gap               | uint256[50]                                            | 2    | 0      | 1600  | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _nonces                 | mapping(address => uint256)                            | 52   | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _domainSeparator        | bytes32                                                | 53   | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _borrowAllowances       | mapping(address => mapping(address => uint256))        | 54   | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _underlyingAsset        | address                                                | 55   | 0      | 20    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _userState              | mapping(address => struct IncentivizedERC20.UserState) | 56   | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _allowances             | mapping(address => mapping(address => uint256))        | 57   | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _totalSupply            | uint256                                                | 58   | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _name                   | string                                                 | 59   | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _symbol                 | string                                                 | 60   | 0      | 32    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _decimals               | uint8                                                  | 61   | 0      | 1     | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
| _incentivesController   | contract IAaveIncentivesController                     | 61   | 1      | 20    | lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken |
