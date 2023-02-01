# Aave 3.0.1 upgrade proposal

## Summary

This proposal contains a generic payload that can be used to upgrade an existing `Aave V3` pool to the new `Aave V3.0.1`.

Therefore the proposal upgrades:

- **AAVE_PROTOCOL_DATA_PROVIDER**: There are significant changes that are required for properly handling the newly introduced

Upgrades that were skipped as they seemed unnecessary:

- **ACL_MANAGER**:

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
