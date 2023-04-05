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

# Deploy libraries
deploy-libs-broadcast :
	forge script -vvvv scripts/lib/LibraryPreCompileOne.sol --rpc-url ${chain} --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --broadcast --verify --slow && \
	sleep 1 && \
	forge script -vvvv scripts/lib/LibraryPreCompileTwo.sol --rpc-url ${chain} --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --broadcast --verify --slow

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
