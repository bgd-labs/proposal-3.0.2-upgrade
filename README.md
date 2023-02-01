# Aave 3.0.1 upgrade proposal

## Summary

This proposal contains a generic payload that can be used to upgrade an existing `Aave V3` pool to the new `Aave V3.0.1`.

Therefore the proposal upgrades:

- **AAVE_PROTOCOL_DATA_PROVIDER**: There are relevant changes in regards to `flashloanable`

- **POOL_CONFIGURATOR**: There are relevant changes in regards to `flashloanable`

- **POOL**: There are relevant logic changes

- **A_TOKEN_IMPL**: There are relevant changes in regards to events and libraries

- **VARIABLE_DEBT_TOKEN_IMPL**: There are relevant changes in regards to events and libraries

- **STABLE_DEBT_TOKEN_IMPL**: There are relevant changes in regards to events

Upgrades that were skipped as they seem unnecessary:

- **ACL_MANAGER**: only changes are in unused parts of libraries and documentation

- **COLLECTOR/COLLECTOR_CONTROLLER**: are currently not tied to a protocol version and will be aligned in a different proposal

- **RESERVE_INTEREST_RATE**: there are method visibility changes, which are irrelevant for existing reserves and we think it's reasonable to migrate over time organically

- **EMISSION_CONTROLLER**: only changes are in documentation

- **ORACLE**: only changes are in unused parts of libraries and documentation

- **POOL_ADDRESS_PROVIDER_REGISTRY**: only changes are in unused parts of libraries and documentation

- **WETH_GATEWAY**: only changes are in unused parts of libraries and documentation

In addition to the upgrade, the newly introduced `flashloanable` flag is set to `true` for all assets.

## Scripts

To identify differences between the deploy `3.0.0` and the new `3.0.1` version of the aave protocol the `node diff.js` utility generates a code diff between `AaveV3Ethereum` and `AaveV3Polygon`.
Therefore we took all relevant addresses from `AaveAddressBook` downloaded their source from etherscan/polygonscan and diffed them. Checkout [diff.js](./diff.js) for reference.

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
