| Name            | Type                                             | Slot | Offset | Bytes | Contract                                                  |
|-----------------|--------------------------------------------------|------|--------|-------|-----------------------------------------------------------|
| assetsSources   | mapping(address => contract AggregatorInterface) | 0    | 0      | 32    | lib/aave-v3-core/contracts/misc/AaveOracle.sol:AaveOracle |
| _fallbackOracle | contract IPriceOracleGetter                      | 1    | 0      | 20    | lib/aave-v3-core/contracts/misc/AaveOracle.sol:AaveOracle |
