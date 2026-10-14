# Environment readiness

Run in Phase 0 and again right after intake, before any design work. Goal: no time lost to missing tools, keys or faucet funds.

Run `bash <skill-dir>/scripts/check-env.sh` (read-only; prints tool versions and non-secret hints, never env var values). Report MISSING items that the chosen stack needs, with the install hint. Ignore the web3 block for non-web3 projects.

## Checklist (record results in STATE.md)

Accounts and access
- [ ] Registered on the hackathon platform; team formed and teammates added; submission page opened once to see every required field.
- [ ] Sponsor portals / APIs joined for each sponsor track in scope; API keys obtained.
- [ ] Hosting account ready (see `ship.md`): login works, project created.
- [ ] Repo created, teammates have write access, default branch protected only as much as the team agrees.

Secrets
- [ ] Every key lives in a gitignored `.env`; `.env.example` lists names only; nothing in chat, docs or client bundle.
- [ ] Keys have spend limits or quotas where the provider allows it.

Tooling
- [ ] Versions from `check-env.sh` match the stack (runtime, package manager, framework CLI, container runtime if needed).
- [ ] A clean install (`install` + `build` + `test`) of the project template works before writing features.
- [ ] Disk space and battery/power plan for the whole event; second machine or cloud dev box if the first dies.

Web3 only
- [ ] RPC provider keys created (public RPCs rate-limit during hackathons); fallback RPC noted.
- [ ] **Request faucet funds in the first hour.** Faucets rate-limit per address and per day, some need a social account or small mainnet balance; ask early, and for several burner addresses (deployer, demo user, spare). Record balances in `docs/hackathon/DEPLOYMENTS.md`.
- [ ] Burner wallets created with an encrypted keystore; no real-fund keys on this machine's `.env`.
- [ ] Wallet extension installed and tested on the target testnet; add-network flow known.
- [ ] Explorer API key if contract verification needs one.

AI projects (see `ai-projects.md`)
- [ ] Model provider key works with a one-line test call; quota and rate limits known.
- [ ] Spend cap or alert configured.

## Rules to repeat to the user
- Missing tool or key: tell the user the exact fix and the source. Do not install global tools or create accounts without the user's OK.
- Never ask the user to paste a key into chat; point them to the `.env` file.
