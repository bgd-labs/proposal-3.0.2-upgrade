```diff
diff --git a/downloads/mainnet/COLLECTOR_CONTROLLER/AaveEcosystemReserveController/Contract.sol b/downloads/mainnet/COLLECTOR_CONTROLLER/AaveEcosystemReserveController/Contract.sol
new file mode 100644
index 0000000..9528d23
--- /dev/null
+++ b/downloads/mainnet/COLLECTOR_CONTROLLER/AaveEcosystemReserveController/Contract.sol
@@ -0,0 +1,444 @@
+// SPDX-License-Identifier: MIT
+pragma solidity 0.8.11;
+
+// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
+
+
+
+// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
+
+
+
+/**
+ * @dev Provides information about the current execution context, including the
+ * sender of the transaction and its data. While these are generally available
+ * via msg.sender and msg.data, they should not be accessed in such a direct
+ * manner, since when dealing with meta-transactions the account sending and
+ * paying for execution may not be the actual sender (as far as an application
+ * is concerned).
+ *
+ * This contract is only required for intermediate, library-like contracts.
+ */
+abstract contract Context {
+    function _msgSender() internal view virtual returns (address) {
+        return msg.sender;
+    }
+
+    function _msgData() internal view virtual returns (bytes calldata) {
+        return msg.data;
+    }
+}
+
+/**
+ * @dev Contract module which provides a basic access control mechanism, where
+ * there is an account (an owner) that can be granted exclusive access to
+ * specific functions.
+ *
+ * By default, the owner account will be the one that deploys the contract. This
+ * can later be changed with {transferOwnership}.
+ *
+ * This module is used through inheritance. It will make available the modifier
+ * `onlyOwner`, which can be applied to your functions to restrict their use to
+ * the owner.
+ */
+abstract contract Ownable is Context {
+    address private _owner;
+
+    event OwnershipTransferred(
+        address indexed previousOwner,
+        address indexed newOwner
+    );
+
+    /**
+     * @dev Initializes the contract setting the deployer as the initial owner.
+     */
+    constructor() {
+        _transferOwnership(_msgSender());
+    }
+
+    /**
+     * @dev Returns the address of the current owner.
+     */
+    function owner() public view virtual returns (address) {
+        return _owner;
+    }
+
+    /**
+     * @dev Throws if called by any account other than the owner.
+     */
+    modifier onlyOwner() {
+        require(owner() == _msgSender(), "Ownable: caller is not the owner");
+        _;
+    }
+
+    /**
+     * @dev Leaves the contract without owner. It will not be possible to call
+     * `onlyOwner` functions anymore. Can only be called by the current owner.
+     *
+     * NOTE: Renouncing ownership will leave the contract without an owner,
+     * thereby removing any functionality that is only available to the owner.
+     */
+    function renounceOwnership() public virtual onlyOwner {
+        _transferOwnership(address(0));
+    }
+
+    /**
+     * @dev Transfers ownership of the contract to a new account (`newOwner`).
+     * Can only be called by the current owner.
+     */
+    function transferOwnership(address newOwner) public virtual onlyOwner {
+        require(
+            newOwner != address(0),
+            "Ownable: new owner is the zero address"
+        );
+        _transferOwnership(newOwner);
+    }
+
+    /**
+     * @dev Transfers ownership of the contract to a new account (`newOwner`).
+     * Internal function without access restriction.
+     */
+    function _transferOwnership(address newOwner) internal virtual {
+        address oldOwner = _owner;
+        _owner = newOwner;
+        emit OwnershipTransferred(oldOwner, newOwner);
+    }
+}
+interface IStreamable {
+    struct Stream {
+        uint256 deposit;
+        uint256 ratePerSecond;
+        uint256 remainingBalance;
+        uint256 startTime;
+        uint256 stopTime;
+        address recipient;
+        address sender;
+        address tokenAddress;
+        bool isEntity;
+    }
+
+    event CreateStream(
+        uint256 indexed streamId,
+        address indexed sender,
+        address indexed recipient,
+        uint256 deposit,
+        address tokenAddress,
+        uint256 startTime,
+        uint256 stopTime
+    );
+
+    event WithdrawFromStream(
+        uint256 indexed streamId,
+        address indexed recipient,
+        uint256 amount
+    );
+
+    event CancelStream(
+        uint256 indexed streamId,
+        address indexed sender,
+        address indexed recipient,
+        uint256 senderBalance,
+        uint256 recipientBalance
+    );
+
+    function balanceOf(uint256 streamId, address who)
+        external
+        view
+        returns (uint256 balance);
+
+    function getStream(uint256 streamId)
+        external
+        view
+        returns (
+            address sender,
+            address recipient,
+            uint256 deposit,
+            address token,
+            uint256 startTime,
+            uint256 stopTime,
+            uint256 remainingBalance,
+            uint256 ratePerSecond
+        );
+
+    function createStream(
+        address recipient,
+        uint256 deposit,
+        address tokenAddress,
+        uint256 startTime,
+        uint256 stopTime
+    ) external returns (uint256 streamId);
+
+    function withdrawFromStream(uint256 streamId, uint256 funds)
+        external
+        returns (bool);
+
+    function cancelStream(uint256 streamId) external returns (bool);
+
+    function initialize(address fundsAdmin) external;
+}
+interface IERC20 {
+  /**
+   * @dev Returns the amount of tokens in existence.
+   */
+  function totalSupply() external view returns (uint256);
+
+  /**
+   * @dev Returns the amount of tokens owned by `account`.
+   */
+  function balanceOf(address account) external view returns (uint256);
+
+  /**
+   * @dev Moves `amount` tokens from the caller's account to `recipient`.
+   *
+   * Returns a boolean value indicating whether the operation succeeded.
+   *
+   * Emits a {Transfer} event.
+   */
+  function transfer(address recipient, uint256 amount) external returns (bool);
+
+  /**
+   * @dev Returns the remaining number of tokens that `spender` will be
+   * allowed to spend on behalf of `owner` through {transferFrom}. This is
+   * zero by default.
+   *
+   * This value changes when {approve} or {transferFrom} are called.
+   */
+  function allowance(address owner, address spender) external view returns (uint256);
+
+  /**
+   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
+   *
+   * Returns a boolean value indicating whether the operation succeeded.
+   *
+   * IMPORTANT: Beware that changing an allowance with this method brings the risk
+   * that someone may use both the old and the new allowance by unfortunate
+   * transaction ordering. One possible solution to mitigate this race
+   * condition is to first reduce the spender's allowance to 0 and set the
+   * desired value afterwards:
+   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
+   *
+   * Emits an {Approval} event.
+   */
+  function approve(address spender, uint256 amount) external returns (bool);
+
+  /**
+   * @dev Moves `amount` tokens from `sender` to `recipient` using the
+   * allowance mechanism. `amount` is then deducted from the caller's
+   * allowance.
+   *
+   * Returns a boolean value indicating whether the operation succeeded.
+   *
+   * Emits a {Transfer} event.
+   */
+  function transferFrom(
+    address sender,
+    address recipient,
+    uint256 amount
+  ) external returns (bool);
+
+  /**
+   * @dev Emitted when `value` tokens are moved from one account (`from`) to
+   * another (`to`).
+   *
+   * Note that `value` may be zero.
+   */
+  event Transfer(address indexed from, address indexed to, uint256 value);
+
+  /**
+   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
+   * a call to {approve}. `value` is the new allowance.
+   */
+  event Approval(address indexed owner, address indexed spender, uint256 value);
+}
+
+interface IAdminControlledEcosystemReserve {
+    /** @notice Emitted when the funds admin changes
+     * @param fundsAdmin The new funds admin
+     **/
+    event NewFundsAdmin(address indexed fundsAdmin);
+
+    /** @notice Returns the mock ETH reference address
+     * @return address The address
+     **/
+    function ETH_MOCK_ADDRESS() external pure returns (address);
+
+    /**
+     * @notice Return the funds admin, only entity to be able to interact with this contract (controller of reserve)
+     * @return address The address of the funds admin
+     **/
+    function getFundsAdmin() external view returns (address);
+
+    /**
+     * @dev Function for the funds admin to give ERC20 allowance to other parties
+     * @param token The address of the token to give allowance from
+     * @param recipient Allowance's recipient
+     * @param amount Allowance to approve
+     **/
+    function approve(
+        IERC20 token,
+        address recipient,
+        uint256 amount
+    ) external;
+
+    /**
+     * @notice Function for the funds admin to transfer ERC20 tokens to other parties
+     * @param token The address of the token to transfer
+     * @param recipient Transfer's recipient
+     * @param amount Amount to transfer
+     **/
+    function transfer(
+        IERC20 token,
+        address recipient,
+        uint256 amount
+    ) external;
+}
+interface IAaveEcosystemReserveController {
+    /**
+     * @notice Proxy function for ERC20's approve(), pointing to a specific collector contract
+     * @param collector The collector contract with funds (Aave ecosystem reserve)
+     * @param token The asset address
+     * @param recipient Allowance's recipient
+     * @param amount Allowance to approve
+     **/
+    function approve(
+        address collector,
+        IERC20 token,
+        address recipient,
+        uint256 amount
+    ) external;
+
+    /**
+     * @notice Proxy function for ERC20's transfer(), pointing to a specific collector contract
+     * @param collector The collector contract with funds (Aave ecosystem reserve)
+     * @param token The asset address
+     * @param recipient Transfer's recipient
+     * @param amount Amount to transfer
+     **/
+    function transfer(
+        address collector,
+        IERC20 token,
+        address recipient,
+        uint256 amount
+    ) external;
+
+    /**
+     * @notice Proxy function to create a stream of token on a specific collector contract
+     * @param collector The collector contract with funds (Aave ecosystem reserve)
+     * @param recipient The recipient of the stream of token
+     * @param deposit Total amount to be streamed
+     * @param tokenAddress The ERC20 token to use as streaming asset
+     * @param startTime The unix timestamp for when the stream starts
+     * @param stopTime The unix timestamp for when the stream stops
+     * @return uint256 The stream id created
+     **/
+    function createStream(
+        address collector,
+        address recipient,
+        uint256 deposit,
+        IERC20 tokenAddress,
+        uint256 startTime,
+        uint256 stopTime
+    ) external returns (uint256);
+
+    /**
+     * @notice Proxy function to withdraw from a stream of token on a specific collector contract
+     * @param collector The collector contract with funds (Aave ecosystem reserve)
+     * @param streamId The id of the stream to withdraw tokens from
+     * @param funds Amount to withdraw
+     * @return bool If the withdrawal finished properly
+     **/
+    function withdrawFromStream(
+        address collector,
+        uint256 streamId,
+        uint256 funds
+    ) external returns (bool);
+
+    /**
+     * @notice Proxy function to cancel a stream of token on a specific collector contract
+     * @param collector The collector contract with funds (Aave ecosystem reserve)
+     * @param streamId The id of the stream to cancel
+     * @return bool If the cancellation happened correctly
+     **/
+    function cancelStream(address collector, uint256 streamId)
+        external
+        returns (bool);
+}
+
+
+contract AaveEcosystemReserveController is
+    Ownable,
+    IAaveEcosystemReserveController
+{
+    /**
+     * @notice Constructor.
+     * @param aaveGovShortTimelock The address of the Aave's governance executor, owning this contract
+     */
+    constructor(address aaveGovShortTimelock) {
+        transferOwnership(aaveGovShortTimelock);
+    }
+
+    /// @inheritdoc IAaveEcosystemReserveController
+    function approve(
+        address collector,
+        IERC20 token,
+        address recipient,
+        uint256 amount
+    ) external onlyOwner {
+        IAdminControlledEcosystemReserve(collector).approve(
+            token,
+            recipient,
+            amount
+        );
+    }
+
+    /// @inheritdoc IAaveEcosystemReserveController
+    function transfer(
+        address collector,
+        IERC20 token,
+        address recipient,
+        uint256 amount
+    ) external onlyOwner {
+        IAdminControlledEcosystemReserve(collector).transfer(
+            token,
+            recipient,
+            amount
+        );
+    }
+
+    /// @inheritdoc IAaveEcosystemReserveController
+    function createStream(
+        address collector,
+        address recipient,
+        uint256 deposit,
+        IERC20 tokenAddress,
+        uint256 startTime,
+        uint256 stopTime
+    ) external onlyOwner returns (uint256) {
+        return
+            IStreamable(collector).createStream(
+                recipient,
+                deposit,
+                address(tokenAddress),
+                startTime,
+                stopTime
+            );
+    }
+
+    /// @inheritdoc IAaveEcosystemReserveController
+    function withdrawFromStream(
+        address collector,
+        uint256 streamId,
+        uint256 funds
+    ) external onlyOwner returns (bool) {
+        return IStreamable(collector).withdrawFromStream(streamId, funds);
+    }
+
+    /// @inheritdoc IAaveEcosystemReserveController
+    function cancelStream(address collector, uint256 streamId)
+        external
+        onlyOwner
+        returns (bool)
+    {
+        return IStreamable(collector).cancelStream(streamId);
+    }
+}
\ No newline at end of file
diff --git a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol b/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol
deleted file mode 100644
index 445ee64..0000000
--- a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Context.sol
+++ /dev/null
@@ -1,23 +0,0 @@
-// SPDX-License-Identifier: MIT
-pragma solidity 0.8.10;
-
-/*
- * @dev Provides information about the current execution context, including the
- * sender of the transaction and its data. While these are generally available
- * via msg.sender and msg.data, they should not be accessed in such a direct
- * manner, since when dealing with GSN meta-transactions the account sending and
- * paying for execution may not be the actual sender (as far as an application
- * is concerned).
- *
- * This contract is only required for intermediate, library-like contracts.
- */
-abstract contract Context {
-  function _msgSender() internal view virtual returns (address payable) {
-    return payable(msg.sender);
-  }
-
-  function _msgData() internal view virtual returns (bytes memory) {
-    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
-    return msg.data;
-  }
-}
diff --git a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol b/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
deleted file mode 100644
index 326d738..0000000
--- a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol
+++ /dev/null
@@ -1,80 +0,0 @@
-// SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
-
-/**
- * @dev Interface of the ERC20 standard as defined in the EIP.
- */
-interface IERC20 {
-  /**
-   * @dev Returns the amount of tokens in existence.
-   */
-  function totalSupply() external view returns (uint256);
-
-  /**
-   * @dev Returns the amount of tokens owned by `account`.
-   */
-  function balanceOf(address account) external view returns (uint256);
-
-  /**
-   * @dev Moves `amount` tokens from the caller's account to `recipient`.
-   *
-   * Returns a boolean value indicating whether the operation succeeded.
-   *
-   * Emits a {Transfer} event.
-   */
-  function transfer(address recipient, uint256 amount) external returns (bool);
-
-  /**
-   * @dev Returns the remaining number of tokens that `spender` will be
-   * allowed to spend on behalf of `owner` through {transferFrom}. This is
-   * zero by default.
-   *
-   * This value changes when {approve} or {transferFrom} are called.
-   */
-  function allowance(address owner, address spender) external view returns (uint256);
-
-  /**
-   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
-   *
-   * Returns a boolean value indicating whether the operation succeeded.
-   *
-   * IMPORTANT: Beware that changing an allowance with this method brings the risk
-   * that someone may use both the old and the new allowance by unfortunate
-   * transaction ordering. One possible solution to mitigate this race
-   * condition is to first reduce the spender's allowance to 0 and set the
-   * desired value afterwards:
-   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
-   *
-   * Emits an {Approval} event.
-   */
-  function approve(address spender, uint256 amount) external returns (bool);
-
-  /**
-   * @dev Moves `amount` tokens from `sender` to `recipient` using the
-   * allowance mechanism. `amount` is then deducted from the caller's
-   * allowance.
-   *
-   * Returns a boolean value indicating whether the operation succeeded.
-   *
-   * Emits a {Transfer} event.
-   */
-  function transferFrom(
-    address sender,
-    address recipient,
-    uint256 amount
-  ) external returns (bool);
-
-  /**
-   * @dev Emitted when `value` tokens are moved from one account (`from`) to
-   * another (`to`).
-   *
-   * Note that `value` may be zero.
-   */
-  event Transfer(address indexed from, address indexed to, uint256 value);
-
-  /**
-   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
-   * a call to {approve}. `value` is the new allowance.
-   */
-  event Approval(address indexed owner, address indexed spender, uint256 value);
-}
diff --git a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol b/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol
deleted file mode 100644
index 020feec..0000000
--- a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol
+++ /dev/null
@@ -1,69 +0,0 @@
-// SPDX-License-Identifier: MIT
-
-pragma solidity 0.8.10;
-
-import './Context.sol';
-
-/**
- * @dev Contract module which provides a basic access control mechanism, where
- * there is an account (an owner) that can be granted exclusive access to
- * specific functions.
- *
- * By default, the owner account will be the one that deploys the contract. This
- * can later be changed with {transferOwnership}.
- *
- * This module is used through inheritance. It will make available the modifier
- * `onlyOwner`, which can be applied to your functions to restrict their use to
- * the owner.
- */
-contract Ownable is Context {
-  address private _owner;
-
-  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
-
-  /**
-   * @dev Initializes the contract setting the deployer as the initial owner.
-   */
-  constructor() {
-    address msgSender = _msgSender();
-    _owner = msgSender;
-    emit OwnershipTransferred(address(0), msgSender);
-  }
-
-  /**
-   * @dev Returns the address of the current owner.
-   */
-  function owner() public view returns (address) {
-    return _owner;
-  }
-
-  /**
-   * @dev Throws if called by any account other than the owner.
-   */
-  modifier onlyOwner() {
-    require(_owner == _msgSender(), 'Ownable: caller is not the owner');
-    _;
-  }
-
-  /**
-   * @dev Leaves the contract without owner. It will not be possible to call
-   * `onlyOwner` functions anymore. Can only be called by the current owner.
-   *
-   * NOTE: Renouncing ownership will leave the contract without an owner,
-   * thereby removing any functionality that is only available to the owner.
-   */
-  function renounceOwnership() public virtual onlyOwner {
-    emit OwnershipTransferred(_owner, address(0));
-    _owner = address(0);
-  }
-
-  /**
-   * @dev Transfers ownership of the contract to a new account (`newOwner`).
-   * Can only be called by the current owner.
-   */
-  function transferOwnership(address newOwner) public virtual onlyOwner {
-    require(newOwner != address(0), 'Ownable: new owner is the zero address');
-    emit OwnershipTransferred(_owner, newOwner);
-    _owner = newOwner;
-  }
-}
diff --git a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/periphery-v3/contracts/treasury/CollectorController.sol b/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/periphery-v3/contracts/treasury/CollectorController.sol
deleted file mode 100644
index e4d6cea..0000000
--- a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/periphery-v3/contracts/treasury/CollectorController.sol
+++ /dev/null
@@ -1,56 +0,0 @@
-// SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
-
-import {Ownable} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol';
-import {IERC20} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
-import {ICollector} from './interfaces/ICollector.sol';
-
-/**
- * @title CollectorController
- * @notice The CollectorController contracts allows the owner of the contract
-           to approve or transfer tokens from the specified collector proxy contract.
-           The admin of the Collector proxy can't be the same as the fundsAdmin address.
-           This is needed due the usage of transparent proxy pattern.
- * @author Aave
- **/
-contract CollectorController is Ownable {
-  /**
-   * @dev Constructor setups the ownership of the contract
-   * @param owner The address of the owner of the CollectorController
-   */
-  constructor(address owner) {
-    transferOwnership(owner);
-  }
-
-  /**
-   * @dev Transfer an amount of tokens to the recipient.
-   * @param collector The address of the collector contract
-   * @param token The address of the asset
-   * @param recipient The address of the entity to transfer the tokens.
-   * @param amount The amount to be transferred.
-   */
-  function approve(
-    address collector,
-    IERC20 token,
-    address recipient,
-    uint256 amount
-  ) external onlyOwner {
-    ICollector(collector).approve(token, recipient, amount);
-  }
-
-  /**
-   * @dev Transfer an amount of tokens to the recipient.
-   * @param collector The address of the collector contract to retrieve funds from (e.g. Aave ecosystem reserve)
-   * @param token The address of the asset
-   * @param recipient The address of the entity to transfer the tokens.
-   * @param amount The amount to be transferred.
-   */
-  function transfer(
-    address collector,
-    IERC20 token,
-    address recipient,
-    uint256 amount
-  ) external onlyOwner {
-    ICollector(collector).transfer(token, recipient, amount);
-  }
-}
diff --git a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/periphery-v3/contracts/treasury/interfaces/ICollector.sol b/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/periphery-v3/contracts/treasury/interfaces/ICollector.sol
deleted file mode 100644
index aa22875..0000000
--- a/downloads/polygon/COLLECTOR_CONTROLLER/CollectorController/@aave/periphery-v3/contracts/treasury/interfaces/ICollector.sol
+++ /dev/null
@@ -1,60 +0,0 @@
-// SPDX-License-Identifier: AGPL-3.0
-pragma solidity 0.8.10;
-
-import {IERC20} from '@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
-
-/**
- * @title ICollector
- * @notice Defines the interface of the Collector contract
- * @author Aave
- **/
-interface ICollector {
-  /**
-   * @dev Emitted during the transfer of ownership of the funds administrator address
-   * @param fundsAdmin The new funds administrator address
-   **/
-  event NewFundsAdmin(address indexed fundsAdmin);
-
-  /**
-   * @dev Retrieve the current implementation Revision of the proxy
-   * @return The revision version
-   */
-  function REVISION() external view returns (uint256);
-
-  /**
-   * @dev Retrieve the current funds administrator
-   * @return The address of the funds administrator
-   */
-  function getFundsAdmin() external view returns (address);
-
-  /**
-   * @dev Approve an amount of tokens to be pulled by the recipient.
-   * @param token The address of the asset
-   * @param recipient The address of the entity allowed to pull tokens
-   * @param amount The amount allowed to be pulled. If zero it will revoke the approval.
-   */
-  function approve(
-    IERC20 token,
-    address recipient,
-    uint256 amount
-  ) external;
-
-  /**
-   * @dev Transfer an amount of tokens to the recipient.
-   * @param token The address of the asset
-   * @param recipient The address of the entity to transfer the tokens.
-   * @param amount The amount to be transferred.
-   */
-  function transfer(
-    IERC20 token,
-    address recipient,
-    uint256 amount
-  ) external;
-
-  /**
-   * @dev Transfer the ownership of the funds administrator role.
-          This function should only be callable by the current funds administrator.
-   * @param admin The address of the new funds administrator
-   */
-  function setFundsAdmin(address admin) external;
-}
```
