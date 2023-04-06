# Aave 3.0.1 upgrade proposal

## Process

To figure out which contracts require an update and which don't we compared the contracts of `Aave V3 Polygon` with the contracts deployed on `Aave V3 Ethereum`.
Upon closer inspection the following contracts should be upgraded in the v3.0.1 upgrade process:

- AAVE_PROTOCOL_DATA_PROVIDER
- POOL_CONFIGURATOR
- POOL
- A_TOKEN_IMPL
- VARIABLE_DEBT_TOKEN_IMPL
- STABLE_DEBT_TOKEN_IMPL

You can find the full diffs in the [diffs](./diffs/) folder.

The `AAVE_PROTOCOL_DATA_PROVIDER` is not upgradable, but is only referenced on the `PoolAddressesProvider`, so the proposal will just update the address.
The `POOL` and `POOL_CONFIGURATOR` are upgradable and can be upgraded by the `PoolAddressesProvider`.
The `A`, `VARIABLE_DEBT` and `STABLE_DEBT` - token implementations are upgradable and can be upgraded by the `PoolConfigurator` and need to be upgraded per token.

We then created a generic proposal payload which can be reused across all pools & networks.
The [generic payload](./src/contracts/V301UpgradePayload.sol) needs to be executed via `delegatecall` by the `cross-chain-executors` or `guardians` of the respective networks.
Upon execution the payload will perform all the implementation upgrades & replace the `AAVE_PROTOCOL_DATA_PROVIDER` reference.
The v3.0.1 upgrade introduces a new `flashloanable` configuration boolean per asset, as this value resides on a previously unused storage space, if will default to `false` effectively disabling flashloans. Therefore to create the proposal in a non-breaking manner, it will also set `flashLoanable` to `true` for all assets.
To keep the proposal execution within reasonable gas limits, the generic `V301UpgradePayload` expects to be initialized with [pre-deployed implementations](./scripts/DeployPayloads.s.sol).

As `Polygon`, `Optimism` and `Arbitrum` are controlled by crosschain-Governance, the [Proposal](./scripts/CreateProposal.t.sol) will forward execution to these 3 chains. For the other ones, a successfull Proposal will be seen as signal to coordinate the upgrade with respective guardians.

## Diff summary

Therefore the proposal upgrades:

- **AAVE_PROTOCOL_DATA_PROVIDER**: There are relevant changes in regards to `flashloanable`

  - [CODE DIFF](./diffs/AAVE_PROTOCOL_DATA_PROVIDER_diff.md)
  - Storage diff is irrelevant as it's not a proxy

- **POOL_CONFIGURATOR**: There are relevant changes in regards to `flashloanable`

  - [CODE DIFF](./diffs/POOL_CONFIGURATOR_IMPL_diff.md)
  - [STORAGE DIFF](./diffs/PoolConfigurator_layout_diff.md)

- **POOL**: There are relevant logic changes

  - [CODE DIFF](./diffs/POOL_IMPL_diff.md)
  - [STORAGE DIFF](./diffs/Pool_layout_diff.md)

- **A_TOKEN_IMPL**: There are relevant changes in regards to events and libraries

  - [CODE DIFF](./diffs/DEFAULT_A_TOKEN_IMPL_diff.md)
  - [STORAGE DIFF](./diffs/AToken_layout_diff.md)

- **VARIABLE_DEBT_TOKEN_IMPL**: There are relevant changes in regards to events and libraries

  - [CODE DIFF](./diffs/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1_diff.md)
  - [STORAGE DIFF](./diffs/VariableDebtToken_layout_diff.md)

- **STABLE_DEBT_TOKEN_IMPL**: There are relevant changes in regards to events

  - [CODE DIFF](./diffs/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1_diff.md)
  - [STORAGE DIFF](./diffs/StableDebtToken_layout_diff.md)

Upgrades that were skipped as they seem unnecessary:

- **ACL_MANAGER**: only changes are in unused parts of libraries and documentation

  - [CODE DIFF](./diffs/ACL_MANAGER_diff.md)

- **COLLECTOR/COLLECTOR_CONTROLLER**: are currently not tied to a protocol version and will be aligned in a different proposal

- **RESERVE_INTEREST_RATE**: there are method visibility changes, which are irrelevant for existing reserves and we think it's reasonable to migrate over time organically

  - [CODE DIFF](./diffs/DEFAULT_RESERVE_INTEREST_RATE_STRATEGY_diff.md)

- **EMISSION_CONTROLLER**: only changes are in documentation

  - [CODE DIFF](./diffs/EMISSION_MANAGER_diff.md)

- **ORACLE**: only changes are in unused parts of libraries and documentation

  - [CODE DIFF](./diffs/ORACLE_diff.md)

- **POOL_ADDRESS_PROVIDER_REGISTRY**: only changes are in unused parts of libraries and documentation

  - [CODE DIFF](./diffs/POOL_ADDRESSES_PROVIDER_diff.md)

- **WETH_GATEWAY**: only changes are in unused parts of libraries and documentation

  - [CODE DIFF](./diffs/WETH_GATEWAY_diff.md)

## Scripts

To identify differences between the deploy `3.0.0` and the new `3.0.1` version of the aave protocol the `node diff.js` utility generates a code diff between `AaveV3Ethereum` and `AaveV3Polygon`.
Therefore we took all relevant addresses from `AaveAddressBook` downloaded their source from etherscan/polygonscan and diffed them. Checkout [diff.js](./diff.js) for reference.

## Security procedures

### Configuration snapshots

1. We generated configuration snapshots from before proposal execution.
2. Simulated the proposal execution on a fork & generated a new configuration snapshot.
3. Diffed them to ensure only the desired parts have changed.

Snapshots:

- [Polygon](./diffs/pre-upgrade-polygon_post-upgrade-polygon.md)
- [Avalanche](./diffs/pre-upgrade-avalanche_post-upgrade-avalanche.md)
- [Optimism](./diffs/pre-upgrade-optimism_post-upgrade-optimism.md)
- [Arbitrum](./diffs/pre-upgrade-arbitrum_post-upgrade-arbitrum.md)
- [Fantom](./diffs/pre-upgrade-fantom_post-upgrade-fantom.md)
- [Harmony](./diffs/pre-upgrade-harmony_post-upgrade-harmony.md)

### Storage layout

To ensure storage compatibility between new and old implementations we created storage layout snapshots for v3 and v3.0.1 contracts and diffed them.
You can find the snapshots in the [reports](./reports/) directory and a diff for all the storage-layouts within the [diffs](./diffs/) folder.

### E2E tests

We simulated the proposal execution and afterwards ran our E2E test suite, covering supply, withdraw and borrow of all listed assets on a respective pool(excluding fantom & harmony as all assets are frozen on these networks).

## Development

This project uses [Foundry](https://getfoundry.sh). See the [book](https://book.getfoundry.sh/getting-started/installation.html) for detailed instructions on how to install and use Foundry.
The template ships with sensible default so you can use default `foundry` commands without resorting to `MakeFile`.

### Setup

```sh
cp .env.example .env
forge install
```

### Test

```sh
forge test
```

### Step 1

FOUNDRY_LIBRARIES=lib/aave-v3-core/contracts/protocol/libraries/logic/BorrowLogic.sol:BorrowLogic:0x5d834EAD0a80CF3b88c06FeeD6e8E0Fcae2daEE5,lib/aave-v3-core/contracts/protocol/libraries/logic/BridgeLogic.sol:BridgeLogic:0x57572C9e795F4B6A748EFBeAB7E0a1B9996A0A24,lib/aave-v3-core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol:ConfiguratorLogic:0x7406aba1Aa5fE5cd71d958CE10fc28c416a33aA0,lib/aave-v3-core/contracts/protocol/libraries/logic/EModeLogic.sol:EModeLogic:0xeAbd65827E91Ac3aE5471C11A329fbc675cA46d6

### Step 2

FOUNDRY_LIBRARIES=lib/aave-v3-core/contracts/protocol/libraries/logic/BorrowLogic.sol:BorrowLogic:0x5d834EAD0a80CF3b88c06FeeD6e8E0Fcae2daEE5,lib/aave-v3-core/contracts/protocol/libraries/logic/BridgeLogic.sol:BridgeLogic:0x57572C9e795F4B6A748EFBeAB7E0a1B9996A0A24,lib/aave-v3-core/contracts/protocol/libraries/logic/ConfiguratorLogic.sol:ConfiguratorLogic:0x7406aba1Aa5fE5cd71d958CE10fc28c416a33aA0,lib/aave-v3-core/contracts/protocol/libraries/logic/EModeLogic.sol:EModeLogic:0xeAbd65827E91Ac3aE5471C11A329fbc675cA46d6,lib/aave-v3-core/contracts/protocol/libraries/logic/FlashLoanLogic.sol:FlashLoanLogic:0x0A62276bFBF1Ad8443f37Da8630d407408085c8b,lib/aave-v3-core/contracts/protocol/libraries/logic/LiquidationLogic.sol:LiquidationLogic:0xe175De51F29d822b86e46A9A61246Ec90631210D,lib/aave-v3-core/contracts/protocol/libraries/logic/PoolLogic.sol:PoolLogic:0xD5256981e08492AFc543aF2a779Af989E9f9F7e7,lib/aave-v3-core/contracts/protocol/libraries/logic/SupplyLogic.sol:SupplyLogic:0x39dF4b1329D41A9AE20e17BeFf39aAbd2f049128
