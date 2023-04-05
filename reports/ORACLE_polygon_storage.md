| Name            | Type                                             | Slot | Offset | Bytes | Contract                                    |
|-----------------|--------------------------------------------------|------|--------|-------|---------------------------------------------|
| assetsSources   | mapping(address => contract AggregatorInterface) | 0    | 0      | 32    | src/downloads/polygon/ORACLE.sol:AaveOracle |
| _fallbackOracle | contract IPriceOracleGetter                      | 1    | 0      | 20    | src/downloads/polygon/ORACLE.sol:AaveOracle |
