```diff
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseAdminUpgradeabilityProxy.sol b/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseAdminUpgradeabilityProxy.sol
deleted file mode 100644
index 4bab099..0000000
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseAdminUpgradeabilityProxy.sol
+++ /dev/null
@@ -1,126 +0,0 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
-
-import './UpgradeabilityProxy.sol';
-
-/**
- * @title BaseAdminUpgradeabilityProxy
- * @dev This contract combines an upgradeability proxy with an authorization
- * mechanism for administrative tasks.
- * All external functions in this contract must be guarded by the
- * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
- * feature proposal that would enable this to be done automatically.
- */
-contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
-  /**
-   * @dev Emitted when the administration has been transferred.
-   * @param previousAdmin Address of the previous admin.
-   * @param newAdmin Address of the new admin.
-   */
-  event AdminChanged(address previousAdmin, address newAdmin);
-
-  /**
-   * @dev Storage slot with the admin of the contract.
-   * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
-   * validated in the constructor.
-   */
-  bytes32 internal constant ADMIN_SLOT =
-    0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
-
-  /**
-   * @dev Modifier to check whether the `msg.sender` is the admin.
-   * If it is, it will run the function. Otherwise, it will delegate the call
-   * to the implementation.
-   */
-  modifier ifAdmin() {
-    if (msg.sender == _admin()) {
-      _;
-    } else {
-      _fallback();
-    }
-  }
-
-  /**
-   * @return The address of the proxy admin.
-   */
-  function admin() external ifAdmin returns (address) {
-    return _admin();
-  }
-
-  /**
-   * @return The address of the implementation.
-   */
-  function implementation() external ifAdmin returns (address) {
-    return _implementation();
-  }
-
-  /**
-   * @dev Changes the admin of the proxy.
-   * Only the current admin can call this function.
-   * @param newAdmin Address to transfer proxy administration to.
-   */
-  function changeAdmin(address newAdmin) external ifAdmin {
-    require(newAdmin != address(0), 'Cannot change the admin of a proxy to the zero address');
-    emit AdminChanged(_admin(), newAdmin);
-    _setAdmin(newAdmin);
-  }
-
-  /**
-   * @dev Upgrade the backing implementation of the proxy.
-   * Only the admin can call this function.
-   * @param newImplementation Address of the new implementation.
-   */
-  function upgradeTo(address newImplementation) external ifAdmin {
-    _upgradeTo(newImplementation);
-  }
-
-  /**
-   * @dev Upgrade the backing implementation of the proxy and call a function
-   * on the new implementation.
-   * This is useful to initialize the proxied contract.
-   * @param newImplementation Address of the new implementation.
-   * @param data Data to send as msg.data in the low level call.
-   * It should include the signature and the parameters of the function to be called, as described in
-   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
-   */
-  function upgradeToAndCall(address newImplementation, bytes calldata data)
-    external
-    payable
-    ifAdmin
-  {
-    _upgradeTo(newImplementation);
-    (bool success, ) = newImplementation.delegatecall(data);
-    require(success);
-  }
-
-  /**
-   * @return adm The admin slot.
-   */
-  function _admin() internal view returns (address adm) {
-    bytes32 slot = ADMIN_SLOT;
-    //solium-disable-next-line
-    assembly {
-      adm := sload(slot)
-    }
-  }
-
-  /**
-   * @dev Sets the address of the proxy admin.
-   * @param newAdmin Address of the new proxy admin.
-   */
-  function _setAdmin(address newAdmin) internal {
-    bytes32 slot = ADMIN_SLOT;
-    //solium-disable-next-line
-    assembly {
-      sstore(slot, newAdmin)
-    }
-  }
-
-  /**
-   * @dev Only fall back when the sender is not the admin.
-   */
-  function _willFallback() internal virtual override {
-    require(msg.sender != _admin(), 'Cannot call fallback function from the proxy admin');
-    super._willFallback();
-  }
-}
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableAdminUpgradeabilityProxy.sol b/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableAdminUpgradeabilityProxy.sol
deleted file mode 100644
index 49ca134..0000000
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableAdminUpgradeabilityProxy.sol
+++ /dev/null
@@ -1,42 +0,0 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
-
-import './BaseAdminUpgradeabilityProxy.sol';
-import './InitializableUpgradeabilityProxy.sol';
-
-/**
- * @title InitializableAdminUpgradeabilityProxy
- * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for
- * initializing the implementation, admin, and init data.
- */
-contract InitializableAdminUpgradeabilityProxy is
-  BaseAdminUpgradeabilityProxy,
-  InitializableUpgradeabilityProxy
-{
-  /**
-   * Contract initializer.
-   * @param logic address of the initial implementation.
-   * @param admin Address of the proxy administrator.
-   * @param data Data to send as msg.data to the implementation to initialize the proxied contract.
-   * It should include the signature and the parameters of the function to be called, as described in
-   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
-   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
-   */
-  function initialize(
-    address logic,
-    address admin,
-    bytes memory data
-  ) public payable {
-    require(_implementation() == address(0));
-    InitializableUpgradeabilityProxy.initialize(logic, data);
-    assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
-    _setAdmin(admin);
-  }
-
-  /**
-   * @dev Only fall back when the sender is not the admin.
-   */
-  function _willFallback() internal override(BaseAdminUpgradeabilityProxy, Proxy) {
-    BaseAdminUpgradeabilityProxy._willFallback();
-  }
-}
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/UpgradeabilityProxy.sol b/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/UpgradeabilityProxy.sol
deleted file mode 100644
index 896707a..0000000
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/UpgradeabilityProxy.sol
+++ /dev/null
@@ -1,28 +0,0 @@
-// SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.8.10;
-
-import './BaseUpgradeabilityProxy.sol';
-
-/**
- * @title UpgradeabilityProxy
- * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
- * implementation and init data.
- */
-contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
-  /**
-   * @dev Contract constructor.
-   * @param _logic Address of the initial implementation.
-   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
-   * It should include the signature and the parameters of the function to be called, as described in
-   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
-   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
-   */
-  constructor(address _logic, bytes memory _data) payable {
-    assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
-    _setImplementation(_logic);
-    if (_data.length > 0) {
-      (bool success, ) = _logic.delegatecall(_data);
-      require(success);
-    }
-  }
-}
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
similarity index 98%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
index c6dcfda..66cf8b8 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Address.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
similarity index 98%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
index bf52cd5..805fb57 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 import './Proxy.sol';
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
similarity index 96%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
index 5ecec08..d76a024 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 import './BaseUpgradeabilityProxy.sol';
diff --git a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
similarity index 98%
rename from downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
rename to downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
index 44b790d..6f68021 100644
--- a/downloads/polygon/DEFAULT_INCENTIVES_CONTROLLER/InitializableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/dependencies/openzeppelin/upgradeability/Proxy.sol
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: agpl-3.0
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity 0.8.10;
 
 /**
diff --git a/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
new file mode 100644
index 0000000..87550c2
--- /dev/null
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity 0.8.10;
+
+import {BaseUpgradeabilityProxy} from '../../../dependencies/openzeppelin/upgradeability/BaseUpgradeabilityProxy.sol';
+
+/**
+ * @title BaseImmutableAdminUpgradeabilityProxy
+ * @author Aave, inspired by the OpenZeppelin upgradeability proxy pattern
+ * @notice This contract combines an upgradeability proxy with an authorization
+ * mechanism for administrative tasks.
+ * @dev The admin role is stored in an immutable, which helps saving transactions costs
+ * All external functions in this contract must be guarded by the
+ * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
+ * feature proposal that would enable this to be done automatically.
+ */
+contract BaseImmutableAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
+  address internal immutable _admin;
+
+  /**
+   * @dev Constructor.
+   * @param admin The address of the admin
+   */
+  constructor(address admin) {
+    _admin = admin;
+  }
+
+  modifier ifAdmin() {
+    if (msg.sender == _admin) {
+      _;
+    } else {
+      _fallback();
+    }
+  }
+
+  /**
+   * @notice Return the admin address
+   * @return The address of the proxy admin.
+   */
+  function admin() external ifAdmin returns (address) {
+    return _admin;
+  }
+
+  /**
+   * @notice Return the implementation address
+   * @return The address of the implementation.
+   */
+  function implementation() external ifAdmin returns (address) {
+    return _implementation();
+  }
+
+  /**
+   * @notice Upgrade the backing implementation of the proxy.
+   * @dev Only the admin can call this function.
+   * @param newImplementation The address of the new implementation.
+   */
+  function upgradeTo(address newImplementation) external ifAdmin {
+    _upgradeTo(newImplementation);
+  }
+
+  /**
+   * @notice Upgrade the backing implementation of the proxy and call a function
+   * on the new implementation.
+   * @dev This is useful to initialize the proxied contract.
+   * @param newImplementation The address of the new implementation.
+   * @param data Data to send as msg.data in the low level call.
+   * It should include the signature and the parameters of the function to be called, as described in
+   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
+   */
+  function upgradeToAndCall(address newImplementation, bytes calldata data)
+    external
+    payable
+    ifAdmin
+  {
+    _upgradeTo(newImplementation);
+    (bool success, ) = newImplementation.delegatecall(data);
+    require(success);
+  }
+
+  /**
+   * @notice Only fall back when the sender is not the admin.
+   */
+  function _willFallback() internal virtual override {
+    require(msg.sender != _admin, 'Cannot call fallback function from the proxy admin');
+    super._willFallback();
+  }
+}
diff --git a/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol
new file mode 100644
index 0000000..655e5f9
--- /dev/null
+++ b/downloads/mainnet/DEFAULT_INCENTIVES_CONTROLLER/InitializableImmutableAdminUpgradeabilityProxy/@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/InitializableImmutableAdminUpgradeabilityProxy.sol
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: AGPL-3.0
+pragma solidity 0.8.10;
+
+import {InitializableUpgradeabilityProxy} from '../../../dependencies/openzeppelin/upgradeability/InitializableUpgradeabilityProxy.sol';
+import {Proxy} from '../../../dependencies/openzeppelin/upgradeability/Proxy.sol';
+import {BaseImmutableAdminUpgradeabilityProxy} from './BaseImmutableAdminUpgradeabilityProxy.sol';
+
+/**
+ * @title InitializableAdminUpgradeabilityProxy
+ * @author Aave
+ * @dev Extends BaseAdminUpgradeabilityProxy with an initializer function
+ */
+contract InitializableImmutableAdminUpgradeabilityProxy is
+  BaseImmutableAdminUpgradeabilityProxy,
+  InitializableUpgradeabilityProxy
+{
+  /**
+   * @dev Constructor.
+   * @param admin The address of the admin
+   */
+  constructor(address admin) BaseImmutableAdminUpgradeabilityProxy(admin) {
+    // Intentionally left blank
+  }
+
+  /// @inheritdoc BaseImmutableAdminUpgradeabilityProxy
+  function _willFallback() internal override(BaseImmutableAdminUpgradeabilityProxy, Proxy) {
+    BaseImmutableAdminUpgradeabilityProxy._willFallback();
+  }
+}
```
