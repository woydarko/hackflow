# hackflow

Claude Code skill `/hackaton`: a time-boxed hackathon workflow (intake, docs, plan, build, verify, demo) that chains caveman, rtk, ponytail, superpowers and an 8-document project architecture pack. Has a web3 mode (chain detection, contract audit gate, testnet checklist).

## Install the skill

macOS / Linux / Git Bash. Remove the old folder first so a re-install does not nest (`~/.claude/skills/hackaton/hackaton`):

```bash
mkdir -p ~/.claude/skills
rm -rf ~/.claude/skills/hackaton
cp -r skills/hackaton ~/.claude/skills/
```

Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force "$HOME\.claude\skills" | Out-Null
Remove-Item -Recurse -Force "$HOME\.claude\skills\hackaton" -ErrorAction SilentlyContinue
Copy-Item -Recurse skills\hackaton "$HOME\.claude\skills\"
```

Restart or reload Claude Code afterwards.

### Other agents (Codex, Cursor, Gemini CLI, ...)

The `SKILL.md` format is shared, so copy `skills/hackaton` into the agent's skills folder (Codex: `~/.codex/skills/`). The skill never assumes `~/.claude`: it resolves its own folder and `scripts/check-deps.sh` looks in `~/.claude/skills`, `~/.codex/skills` and `~/.agents/skills`. `/plugin ...` commands are Claude Code only; see [dependencies](skills/hackaton/references/dependencies.md) for the cross-agent options (`npx skills add owner/repo` works for several of the dependencies; `npx skills add woydarko/hackflow` should work for this repo but is untested).

## Dependencies

The skill chains other skills and tools. Check what is missing (read-only):

```bash
bash ~/.claude/skills/hackaton/scripts/check-deps.sh
```

or run `/hackaton deps`. Every dependency, its source GitHub repo and install command is listed in [`skills/hackaton/references/dependencies.md`](skills/hackaton/references/dependencies.md). Summary:

| Tier | Dependency | Source repo |
|---|---|---|
| core | caveman | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |
| core | rtk | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) |
| core | ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| core | superpowers | [obra/superpowers](https://github.com/obra/superpowers) |
| recommended | antislop | [miqdadbadjuber/anti-slop](https://github.com/miqdadbadjuber/anti-slop) |
| recommended | frontend-design | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) |
| recommended | agent-reach | [Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) |
| recommended | ecc | [affaan-m/ECC](https://github.com/affaan-m/ECC) |
| recommended | ppt-master | [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) |
| recommended | playwright | [openai/skills](https://github.com/openai/skills), [microsoft/playwright-cli](https://github.com/microsoft/playwright-cli) |
| recommended | graphify | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) |
| web3 | solskill | [Cyfrin/solskill](https://github.com/Cyfrin/solskill) (AGPL-3.0, install separately) |
| web3 | pashov skills | [pashov/skills](https://github.com/pashov/skills) |
| web3 | midnight skills | [mzf11125/midnight_agent_skills](https://github.com/mzf11125/midnight_agent_skills) |

All dependencies are optional: the skill reports what is missing and continues without it. They are third-party code, so read them before installing.

## Use

`/hackaton [init | deps | docs | plan | build | verify | demo | status]`

`templates/` holds the pristine AGENTS.md + docs/*.md pack (docs phase) and `templates/hackathon/` (STATE, TEAM, PITCH, DEPLOYMENTS) used for state, team coordination, pitch, and on-chain deployments. `references/web3.md` is loaded only for web3 projects.
