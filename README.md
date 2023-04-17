# Aave 3.0.2 upgrade proposal

## Context

The [v3.0.1](https://github.com/aave/aave-v3-core/tree/feat/3.0.1) upgrade introduces a new `flashloanable` configuration boolean per asset, as this value resides on a previously unused storage space, if will default to `false` effectively disabling flashloans. Therefore to create the proposal in a non-breaking manner, it will also set `flashLoanable` to `true` for all assets.
To keep the proposal execution within reasonable gas limits, the generic `V301L2UpgradePayload` expects to be initialized with [pre-deployed implementations](./scripts/DeployPayloads.s.sol).

The [v3.0.2](https://github.com/aave/aave-v3-core/pull/832) upgrade includes improvements to the handling of isolation mode, LTV0, and flashBorrower initiated flashloans. The changes are isolated to the poolImplementation.

## Process

### 3.0.0 -> 3.0.2

To figure out which contracts require an update and which don't we compared the contracts of `Aave V3 Polygon` with the [v3.0.2 release branch](https://github.com/aave/aave-v3-core/tree/feat/3.0.2).
Upon closer inspection the following contracts should be upgraded in the v3.0.0 -> v3.0.2 upgrade process:

- AAVE_PROTOCOL_DATA_PROVIDER
- POOL_CONFIGURATOR
- POOL
- A_TOKEN_IMPL
- VARIABLE_DEBT_TOKEN_IMPL
- STABLE_DEBT_TOKEN_IMPL

You can find the full diffs in the [diffs](./diffs/) folder suffixed with `polygon_diff`.

The `AAVE_PROTOCOL_DATA_PROVIDER` is not upgradable, but is only referenced on the `PoolAddressesProvider`, so the proposal will just update the address.
The `POOL` and `POOL_CONFIGURATOR` are upgradable and can be upgraded by the `PoolAddressesProvider`.
The `A`, `VARIABLE_DEBT` and `STABLE_DEBT` - token implementations are upgradable and can be upgraded by the `PoolConfigurator` and need to be upgraded per token.

We then created a generic proposal payload which can be reused across all l2 pools & networks.
The [generic payload](./src/contracts/V301UpgradePayload.sol#L58) needs to be executed via `delegatecall` by the `cross-chain-executors` or `guardians` of the respective networks.
Upon execution the payload will perform all the implementation upgrades & replace the `AAVE_PROTOCOL_DATA_PROVIDER` reference.
Dependent on the network it will also add the `ISOLATED_COLLATERAL_SUPPLIER_ROLE` to the swapCollateral & migrationHelper contracts, to maintain pre-upgrade behavior.

### 3.0.1 -> 3.0.2

As the `ethereum v3 pool` also requires an update we also compared the contracts of `Aave V3 Ethereum` with the [v3.0.2 release branch](https://github.com/aave/aave-v3-core/tree/feat/3.0.2).
While the 3.0.2 upgrade generates a rather huge diff, most changes are related to linting which is irrelevant for compiled bytecode & the code execution.
Therefore the only relevant changes can be found in in `POOL`.

You can find the full diffs in the [diffs](./diffs/) folder suffixed with `mainnet_diff`.

We then created a mainnet proposal payload which handles the 3.0.1 -> 3.0.2 upgrade.
The [mainnet payload](./src/contracts/V301UpgradePayload.sol#L16) needs to be executed via `delegatecall` and will upgrade the `POOL` implementation and grant `ISOLATED_COLLATERAL_SUPPLIER_ROLE` to the mainnet swapCollateral & migrationHelper contracts, to maintain pre-upgrade behavior.

The v3.0.2 upgrade was reviewed by [Certora](https://github.com/aave/aave-v3-core/blob/1eca85884836bffa851e463c8240705c6ad91e17/certora/Aave_V3.0.2_PR_820_Report_Mar2023.pdf)

## Diff summary

Therefore the proposal upgrades:

- **AAVE_PROTOCOL_DATA_PROVIDER**: There are relevant changes in regards to `flashloanable`

  - [MAINNET CODE DIFF](./diffs/AAVE_PROTOCOL_DATA_PROVIDER_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/AAVE_PROTOCOL_DATA_PROVIDER_polygon_diff.md)
  - Storage diff is irrelevant as it's not a proxy

- **POOL_CONFIGURATOR**: There are relevant changes in regards to `flashloanable`

  - [MAINNET CODE DIFF](./diffs/POOL_CONFIGURATOR_IMPL_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/POOL_CONFIGURATOR_IMPL_polygon_diff.md)
  - [MAINNET STORAGE DIFF](./diffs/POOL_CONFIGURATOR_IMPL_mainnet_storage_diff.md)
  - [POLYGON STORAGE DIFF](./diffs/POOL_CONFIGURATOR_IMPL_polygon_storage_diff.md)

- **POOL**: There are relevant logic changes

  - [MAINNET CODE DIFF](./diffs/POOL_IMPL_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/POOL_IMPL_polygon_diff.md)
  - [MAINNET STORAGE DIFF](./diffs/POOL_IMPL_mainnet_storage_diff.md)
  - [POLYGON STORAGE DIFF](./diffs/POOL_IMPL_polygon_storage_diff.md)

- **A_TOKEN_IMPL**: There are relevant changes in regards to events and libraries

  - [MAINNET CODE DIFF](./diffs/DEFAULT_A_TOKEN_IMPL_REV_1_mainnet_diff.md)
  - [CODE DIFF](./diffs/DEFAULT_A_TOKEN_IMPL_REV_1_polygon_diff.md)
  - [MAINNET STORAGE DIFF](./diffs/DEFAULT_A_TOKEN_IMPL_REV_1_mainnet_storage_diff.md)
  - [POLYGON STORAGE DIFF](./diffs/DEFAULT_A_TOKEN_IMPL_REV_1_polygon_storage_diff.md)

- **VARIABLE_DEBT_TOKEN_IMPL**: There are relevant changes in regards to events and libraries

  - [MAINNET CODE DIFF](./diffs/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1_polygon_diff.md)
  - [MAINNET STORAGE DIFF](./diffs/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1_mainnet_storage_diff.md)
  - [POLYGON STORAGE DIFF](./diffs/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1_polygon_storage_diff.md)

- **STABLE_DEBT_TOKEN_IMPL**: There are relevant changes in regards to events

  - [MAINNET CODE DIFF](./diffs/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1_polygon_diff.md)
  - [MAINNET STORAGE DIFF](./diffs/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1_mainnet_storage_diff.md)
  - [POLYGON STORAGE DIFF](./diffs/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1_polygon_storage_diff.md)

Upgrades that were skipped as they seem unnecessary:

- **ACL_MANAGER**: only changes are in unused parts of libraries and documentation

  - [MAINNET CODE DIFF](./diffs/ACL_MANAGER_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/ACL_MANAGER_polygon_diff.md)

- **COLLECTOR/COLLECTOR_CONTROLLER**: are currently not tied to a protocol version and will be aligned in a different proposal

- **EMISSION_CONTROLLER**: only changes are in documentation

  - [MAINNET CODE DIFF](./diffs/EMISSION_MANAGER_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/EMISSION_MANAGER_polygon_diff.md)

- **ORACLE**: only changes are in unused parts of libraries and documentation

  - [MAINNET CODE DIFF](./diffs/AORACLE_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/ORACLE_polygon_diff.md)

- **POOL_ADDRESS_PROVIDER_REGISTRY**: only changes are in unused parts of libraries and documentation

  - [MAINNET CODE DIFF](./diffs/POOL_ADDRESSES_PROVIDER_mainnet_diff.md)
  - [POLYGON CODE DIFF](./diffs/POOL_ADDRESSES_PROVIDER_polygon_diff.md)

## Scripts

To identify differences between the deploy `3.0.0` and the new `3.0.2` version of the aave protocol the `node diff.js` utility generates a code diff between the deployed `AaveV3Ethereum`/`AaveV3Polygon` and the [v3.0.2 branch](https://github.com/aave/aave-v3-core/tree/feat/3.0.2).
Therefore we took all relevant addresses from `AaveAddressBook` downloaded their source from etherscan/polygonscan and diffed them. Checkout [diff.js](./diff.js) for reference.

## Security procedures

### Configuration snapshots

1. We generated configuration snapshots from before proposal execution.
2. Simulated the proposal execution on a fork & generated a new configuration snapshot.
3. Diffed them to ensure only the desired parts have changed.

Snapshots:

- [Mainnet](./diffs/pre-upgrade-mainnet_post-upgrade-mainnet.md)
- [Polygon](./diffs/pre-upgrade-polygon_post-upgrade-polygon.md)
- [Avalanche](./diffs/pre-upgrade-avalanche_post-upgrade-avalanche.md)
- [Optimism](./diffs/pre-upgrade-optimism_post-upgrade-optimism.md)
- [Arbitrum](./diffs/pre-upgrade-arbitrum_post-upgrade-arbitrum.md)
- [Fantom](./diffs/pre-upgrade-fantom_post-upgrade-fantom.md)

### Storage layout

To ensure storage compatibility between new and old implementations we created storage layout snapshots for v3 and v3.0.2 contracts and diffed them.
You can find the snapshots in the [reports](./reports/) directory and a diff for all the storage-layouts within the [diffs](./diffs/) folder.

### Audits

The changes for 3.0.1 have been audited by [sigma prime](https://github.com/aave/aave-v3-core/blob/master/audits/23-12-2022_SigmaPrime_AaveV3-0-1.pdf) and [PeckShield](https://github.com/aave/aave-v3-core/blob/master/audits/09-12-2022_PeckShield_AaveV3-0-1.pdf).

The changes for 3.0.2 have been audited by [Certora](./audits/Aave_V3.0.2_PR_820_Report_Mar2023.pdf) & [sigma prime](TBA).

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
