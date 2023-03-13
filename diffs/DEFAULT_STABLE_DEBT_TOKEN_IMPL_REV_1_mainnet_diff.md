```diff
diff --git a/src/downloads/mainnet/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol b/src/downloads/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol
index e0763e5..46b7d82 100644
--- a/src/downloads/mainnet/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol
+++ b/src/downloads/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1.sol
@@ -2865,7 +2865,7 @@ contract StableDebtToken is DebtTokenBase, IncentivizedERC20, IStableDebtToken {
   using WadRayMath for uint256;
   using SafeCast for uint256;
 
-  uint256 public constant DEBT_TOKEN_REVISION = 0x1;
+  uint256 public constant DEBT_TOKEN_REVISION = 0x2;
 
   // Map of users address and the timestamp of their last update (userAddress => lastUpdateTimestamp)
   mapping(address => uint40) internal _timestamps;
```
