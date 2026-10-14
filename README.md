# hackflow

Claude Code skill `/hackaton`: an all-in hackathon workflow (intake, design + docs, plan, build, verify, demo, retro) built on the superpowers workflow as its backbone, plus caveman, rtk, ponytail and an 8-document project architecture pack. Has a web3 mode (chain detection, contract audit gate, testnet checklist).

## Install

Works with Claude Code, Codex, OpenCode and other harnesses that read `SKILL.md` folders. The installer copies the skill into `~/.agents/skills` (Codex and OpenCode) and `~/.claude/skills` (Claude Code), replacing only an existing `hackaton` folder:

```bash
bash install.sh               # macOS / Linux / Git Bash
bash install.sh --symlink     # one copy that follows git pull
bash install.sh --dest DIR    # your own folder(s) instead of the defaults
```

```powershell
.\install.ps1                 # Windows PowerShell
```

Restart or reload your agent afterwards.

| Harness | Skill folder (user level) | Invoke |
|---|---|---|
| Claude Code | `~/.claude/skills` | `/hackaton deps` |
| Codex | `~/.agents/skills` (project: `.agents/skills`) | `$hackaton deps` |
| OpenCode | `~/.config/opencode/skills`; also reads `~/.agents/skills` and `~/.claude/skills` | ask "use the hackaton skill, deps" |
| Other harnesses | their skills folder, or `npx skills add woydarko/hackflow` (untested) | by skill name |

Notes:
- Folder locations come from each harness's official docs. The skill never hardcodes one path: it resolves its own folder at run time.
- `/plugin ...` commands are Claude Code only. Other harnesses install dependencies their own way (see the dependencies guide below).
- The helper scripts are bash (Git Bash or WSL on Windows). Without bash the skill falls back to checking by hand.
- Progress notes go to `AGENTS.md`, which Codex, OpenCode and most harnesses read; Claude Code gets a `CLAUDE.md` that includes it.

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

`/hackaton [init | deps | docs | plan | build | verify | demo | retro | status]`

`templates/` holds the pristine AGENTS.md + docs/*.md pack (docs phase) and `templates/hackathon/` (STATE, TEAM, LOG, PITCH, DEPLOYMENTS, DEMO, SUBMISSION, RETRO) used for state, team coordination, pitch, and on-chain deployments. `references/` holds on-demand guides: `env-readiness.md` (accounts, keys, faucet funds, with `scripts/check-env.sh`), `ship.md` (deploy, demo video, submission), `ui-design.md` (UI addendum for DESIGN_SYSTEM.md: screens, wireframes, type scale, motion, voice, visual QA), `web3.md` and `ai-projects.md` (loaded only for web3 / AI projects), and `dependencies.md`.

## Teams

To avoid git conflicts in a team, `STATE.md` has one editor (the lead) and everyone else appends to their own `docs/hackathon/log/<handle>.md`; the skill also adds `docs/hackathon/log/*.md merge=union` to the project's `.gitattributes` so concurrent appends merge cleanly.

## Development

`python skills/hackaton/scripts/lint-skill.py` checks the frontmatter rules shared by Claude Code, Codex and OpenCode (name equals folder, description <= 1024 chars) and that every referenced path exists. Run it before committing.
