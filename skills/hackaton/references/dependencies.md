# Dependencies

Skills, plugins and tools that `/hackaton` chains. Repos were verified to exist (stars/licenses as of 2026-10). Run `bash ~/.claude/skills/hackaton/scripts/check-deps.sh` to see which are missing.

Rules for the agent:
- Never install silently. Tell the user what is missing, show the command from this file, and let the user run `/plugin ...` commands (agent cannot). Plain shell installs (`winget`, `pip`, `git clone`) need the user's OK first.
- Everything below is third-party code. Read a repo's skill files and scripts before the first install, as with any dependency.
- Missing optional dependency: continue the flow without it and say so.

## Core (used in every hackathon)

| Name | What for | Source repo | Install |
|---|---|---|---|
| caveman | terse chat, saves tokens | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | `/plugin marketplace add JuliusBrussee/caveman` then `/plugin install caveman@caveman` |
| rtk | filtered shell output (hook rewrites commands) | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) | Windows `winget install rtk-ai.rtk`; macOS/Linux `brew install rtk`; then `rtk init -g` and restart Claude. Verify with `rtk gain` (a different crate also named rtk exists) |
| ponytail | stop over-building | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | `/plugin marketplace add DietrichGebert/ponytail` then `/plugin install ponytail@ponytail` |
| superpowers | brainstorming, plans, TDD, review, verification | [obra/superpowers](https://github.com/obra/superpowers) | `/plugin install superpowers@claude-plugins-official` |

## Recommended

| Name | What for | Source repo | Install |
|---|---|---|---|
| antislop | avoid generic AI-looking UI/copy | [miqdadbadjuber/anti-slop](https://github.com/miqdadbadjuber/anti-slop) | `/plugin marketplace add miqdadbadjuber/anti-slop` then `/plugin install antislop@anti-slop` |
| frontend-design | distinctive UI quickly | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) (also [anthropics/skills](https://github.com/anthropics/skills)) | `/plugin install frontend-design@claude-plugins-official` |
| agent-reach | research sponsors, docs, prior art, videos | [Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) | Ask Claude: "install Agent Reach, safe check first: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md". Default is check-only; `--system` installs need explicit approval |
| ecc | security-review, defi/EVM helpers, many review skills | [affaan-m/ECC](https://github.com/affaan-m/ECC) | `/plugin marketplace add affaan-m/ECC` then `/plugin install ecc@ecc` (large; install only if wanted) |
| ppt-master | pitch deck when required | [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) | `/plugin marketplace add hugohe3/ppt-master` then `/plugin install ppt-master@ppt-master`; then `pip install -r requirements.txt` from the installed location |
| playwright | recorded demo fallback, UI flow checks, screenshots | skill: [openai/skills](https://github.com/openai/skills) `skills/.curated/playwright`; CLI: [microsoft/playwright-cli](https://github.com/microsoft/playwright-cli) | copy the skill folder to `~/.claude/skills/playwright`; install the CLI per its README |
| graphify | map an existing codebase before changing it | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) (formerly safishamsi/graphify) | `uv tool install graphifyy` then `graphify install` (check the README for current steps) |

## Web3 mode (only when the project is web3)

| Name | What for | Source repo | Install |
|---|---|---|---|
| solskill | Solidity write standards, BattleChain | [Cyfrin/solskill](https://github.com/Cyfrin/solskill) (AGPL-3.0) | `/plugin marketplace add Cyfrin/solskill` then `/plugin install solidity@solskill` (+ `battlechain@solskill`, `battlechain-tutorial@solskill` for BattleChain tracks) |
| pashov skills | x-ray, solidity-auditor, fizz (fuzz suites) | [pashov/skills](https://github.com/pashov/skills) (MIT) | `git clone https://github.com/pashov/skills`, copy `x-ray`, `solidity-auditor`, `fizz` into `~/.claude/skills/` |
| midnight skills | Compact, Midnight API, concepts, network | [mzf11125/midnight_agent_skills](https://github.com/mzf11125/midnight_agent_skills) (MIT) | `git clone`, copy `midnight-concepts`, `midnight-compact`, `midnight-api`, `midnight-network` into `~/.claude/skills/` |

Optional per ecosystem (not installed by default, ask first):
- Solana: [sendaifun/skills](https://github.com/sendaifun/skills) (helius, jupiter, metaplex, phantom, pinocchio...).
- Uniswap/DeFi: [Uniswap/uniswap-ai](https://github.com/Uniswap/uniswap-ai): `/plugin marketplace add uniswap/uniswap-ai`, then `/plugin install uniswap-viem` (also `uniswap-trading`, `uniswap-hooks`).
- Celo / MiniPay: [celo-org/agent-skills](https://github.com/celo-org/agent-skills).
- Broad catalog (pick single skills, do not install all): [andresdefi/cryptoskills](https://github.com/andresdefi/cryptoskills).
- Contract security research: [awarexone/web3-bug-bounty-hunting-ai-skills](https://github.com/awarexone/web3-bug-bounty-hunting-ai-skills).

## Updating

Plugins: `/plugin marketplace update` then reinstall or update the plugin. Copied skills: re-clone and copy again (delete the old folder first so it does not nest).
