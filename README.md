# Aave 3.0.1 upgrade proposal

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

## Scripts

To identify differences between the deploy `3.0.0` and the new `3.0.1` version of the aave protocol the `diff.js` utility generates a code diff between `AaveV3Ethereum` and `AaveV3Polygon`.
