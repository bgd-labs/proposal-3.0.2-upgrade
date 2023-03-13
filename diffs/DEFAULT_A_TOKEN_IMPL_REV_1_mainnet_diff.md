```diff
diff --git a/src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol b/src/downloads/DEFAULT_A_TOKEN_IMPL_REV_1.sol
index dd155ea..1b84ad9 100644
--- a/src/downloads/mainnet/DEFAULT_A_TOKEN_IMPL_REV_1.sol
+++ b/src/downloads/DEFAULT_A_TOKEN_IMPL_REV_1.sol
@@ -3022,7 +3022,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   bytes32 public constant PERMIT_TYPEHASH =
     keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
 
-  uint256 public constant ATOKEN_REVISION = 0x1;
+  uint256 public constant ATOKEN_REVISION = 0x2;
 
   address internal _treasury;
   address internal _underlyingAsset;
```
