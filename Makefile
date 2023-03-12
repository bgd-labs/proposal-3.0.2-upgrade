# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes --via-ir
test   :; forge test -vvv

# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
storage-layout :; forge inspect ${contract} storage-layout --pretty > reports/${name}_layout.md
git-diff :
	@mkdir -p diffs
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md

# Deploy Payloads
deploy-mainnet-ledger :;  forge script scripts/DeployPayloads.s.sol:DeployMainnet --rpc-url mainnet --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv --slow
deploy-polygon-ledger :;  forge script scripts/DeployPayloads.s.sol:DeployPolygon --rpc-url polygon --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv --slow
deploy-optimism-ledger :;  forge script scripts/DeployPayloads.s.sol:DeployOptimism --rpc-url optimism --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv --slow
deploy-arbitrum-ledger :;  forge script scripts/DeployPayloads.s.sol:DeployArbitrum --rpc-url arbitrum --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv --slow
deploy-avalanche-ledger :;  forge script scripts/DeployPayloads.s.sol:DeployAvalanche --rpc-url avalanche --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv --slow
deploy-fantom-ledger :;  forge script scripts/DeployPayloads.s.sol:DeployFantom --rpc-url fantom --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv --slow
deploy-harmony-ledger :;  forge script scripts/DeployPayloads.s.sol:DeployHarmony --rpc-url harmony --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} -vvvv --slow

# Create Proposal
create-proposal-ledger :; forge script scripts/CreateProposal.s.sol:CreateUpgradeProposal --rpc-url mainnet --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} -vvvv

storage-diff :
	forge inspect lib/aave-v3-core/contracts/protocol/pool/Pool.sol:Pool storage-layout --pretty > reports/Pool_v301_layout.md
	forge inspect lib/aave-v3-core/contracts/protocol/pool/L2Pool.sol:L2Pool storage-layout --pretty > reports/L2Pool_v301_layout.md
	forge inspect lib/aave-v3-core/contracts/protocol/pool/PoolConfigurator.sol:PoolConfigurator storage-layout --pretty > reports/PoolConfigurator_v301_layout.md
	forge inspect lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken storage-layout --pretty > reports/AToken_v301_layout.md
	forge inspect lib/aave-v3-core/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken storage-layout --pretty > reports/VariableDebtToken_v301_layout.md
	forge inspect lib/aave-v3-core/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/StableDebtToken_v301_layout.md
	forge inspect downloads/polygon/POOL_IMPL/Pool/@aave/core-v3/contracts/protocol/pool/Pool.sol:Pool storage-layout --pretty > reports/Pool_layout.md
	forge inspect downloads/optimism/L2_POOL_IMPL/L2Pool/@aave/core-v3/contracts/protocol/pool/L2Pool.sol:L2Pool storage-layout --pretty > reports/L2Pool_layout.md
	forge inspect downloads/polygon/POOL_CONFIGURATOR_IMPL/PoolConfigurator/@aave/core-v3/contracts/protocol/pool/PoolConfigurator.sol:PoolConfigurator storage-layout --pretty > reports/PoolConfigurator_layout.md
	forge inspect downloads/polygon/DEFAULT_A_TOKEN_IMPL_REV_1/AToken/@aave/core-v3/contracts/protocol/tokenization/AToken.sol:AToken storage-layout --pretty > reports/AToken_layout.md
	forge inspect downloads/polygon/DEFAULT_VARIABLE_DEBT_TOKEN_IMPL_REV_1/VariableDebtToken/@aave/core-v3/contracts/protocol/tokenization/VariableDebtToken.sol:VariableDebtToken storage-layout --pretty > reports/VariableDebtToken_layout.md
	forge inspect downloads/polygon/DEFAULT_STABLE_DEBT_TOKEN_IMPL_REV_1/StableDebtToken/@aave/core-v3/contracts/protocol/tokenization/StableDebtToken.sol:StableDebtToken storage-layout --pretty > reports/StableDebtToken_layout.md
	make git-diff before=reports/Pool_layout.md after=reports/Pool_v301_layout.md out=Pool_layout_diff
	make git-diff before=reports/L2Pool_layout.md after=reports/L2Pool_v301_layout.md out=L2Pool_layout_diff
	make git-diff before=reports/PoolConfigurator_layout.md after=reports/PoolConfigurator_v301_layout.md out=PoolConfigurator_layout_diff
	make git-diff before=reports/AToken_layout.md after=reports/AToken_v301_layout.md out=AToken_layout_diff
	make git-diff before=reports/VariableDebtToken_layout.md after=reports/VariableDebtToken_v301_layout.md out=VariableDebtToken_layout_diff
	make git-diff before=reports/StableDebtToken_layout.md after=reports/StableDebtToken_v301_layout.md out=StableDebtToken_layout_diff
