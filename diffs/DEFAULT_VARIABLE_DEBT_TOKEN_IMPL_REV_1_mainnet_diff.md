```diff
diff --git a/src/downloads/mainnet/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1.sol b/src/downloads/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1.sol
index caaf644..c530596 100644
--- a/src/downloads/mainnet/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1.sol
+++ b/src/downloads/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1.sol
@@ -2954,7 +2954,7 @@ contract VariableDebtToken is DebtTokenBase, ScaledBalanceTokenBase, IVariableDe
   using WadRayMath for uint256;
   using SafeCast for uint256;
 
-  uint256 public constant DEBT_TOKEN_REVISION = 0x1;
+  uint256 public constant DEBT_TOKEN_REVISION = 0x2;
 
   /**
    * @dev Constructor.
```
