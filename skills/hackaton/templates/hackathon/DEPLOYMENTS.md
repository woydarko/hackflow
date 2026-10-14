# Deployments

Judges and teammates read this to reproduce the on-chain demo. Testnet only unless the user explicitly approved mainnet. Never put private keys or seed phrases here.

## Network
| Field | Value |
| --- | --- |
| Chain / ecosystem | [e.g. Base Sepolia, Solana devnet, Midnight testnet] |
| Chain ID / cluster | [Value] |
| RPC URL (public) | [URL] |
| Fallback RPC | [URL] |
| Block explorer | [URL] |
| Faucet | [URL] |

## Contracts / programs
| Name | Address / program ID | Deploy tx | Verified on explorer | Source path |
| --- | --- | --- | --- | --- |
| [Contract] | [0x... / base58] | [tx hash link] | [Yes / No] | [src/...] |

## Roles and keys (names only)
| Role | Address | Key storage |
| --- | --- | --- |
| Deployer | [Address] | [Encrypted keystore / burner, name only] |
| Admin / owner | [Address] | [Single key = known risk in demo; multisig after hackathon] |
| Demo user wallet | [Address] | [Pre-funded burner] |

## Demo state
- Pre-funded wallets: [Addresses and balances]
- Seed data already on-chain: [Description]
- Reference transactions for the demo script: [tx hash links, in order]
- Fallback if RPC or chain is down: [Recorded video / mocked adapter / cached responses]

## Frontend config
- Env var names (not values): [e.g. NEXT_PUBLIC_CHAIN_ID, NEXT_PUBLIC_CONTRACT_ADDRESS]
- Network switch / add-network prompt tested with a fresh wallet: [Yes / No]
- ABI / IDL committed at: [Path]

## Known risks (honest list)
- [e.g. Owner is a single EOA; no timelock; oracle mocked; AI audit only, not a guarantee]
