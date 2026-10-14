# hackflow

**An all-in hackathon workflow for AI coding agents.** One skill, `/hackaton`, takes a team from the rules page to a submitted project and a retro. It does not replace existing skills: it unifies them, with [superpowers](https://github.com/obra/superpowers) as the backbone, and wraps them with everything a hackathon needs that a normal project does not (deadline clock, judging criteria, rules compliance, pitch, demo, submission).

- **Superpowers first.** Brainstorming, plans, TDD, code review and verification run exactly as superpowers defines them. On any conflict, superpowers wins.
- **All in, always.** No lite or short mode. When time runs out, features are cut, never process steps.
- **Evidence over claims.** Nothing is reported as passing until a command actually ran.
- **Safe by default.** Testnet only, no keys in chat or repo, every production deploy or external message needs your OK.
- **Portable.** One `SKILL.md` folder for Claude Code, Codex, OpenCode and other harnesses that read skill folders.

## Contents

[How it works](#how-it-works) · [What it creates](#what-it-creates-in-your-project) · [Quick start](#quick-start) · [Supported harnesses](#supported-harnesses) · [Dependencies](#dependencies) · [Modes](#modes) · [Team use](#team-use) · [Repository layout](#repository-layout) · [Development](#development) · [Status](#status-and-limitations) · [Credits](#credits) · [License](#license)

## How it works

`/hackaton` runs seven phases. Each phase ends with one decision for you (approve or change), then stops.

| Phase | What happens | Superpowers skills used |
|---|---|---|
| 0 Toolchain | Dependency check, environment check, accounts, keys, faucet funds | - |
| 1 Intake | Event facts, deadline, judging criteria, **rules and eligibility**, idea filter, phase clock | - |
| 2 Design + docs | Approved design feeds eight project documents plus a UI addendum | `brainstorming` |
| 3 Plan | Isolated workspace, task plan marked core vs stretch, cut-list, hosting chosen | `using-git-worktrees`, `writing-plans` |
| 4 Build | Plan executed with tests first and reviews between tasks; hourly checkpoints | `subagent-driven-development` or `executing-plans`, `test-driven-development`, `requesting-code-review`, `systematic-debugging` |
| 5 Verify | Clean-environment run, rules compliance, visual QA, five demo rehearsals, web3 audit gate | `verification-before-completion`, `requesting-code-review` |
| 6 Ship | README, demo script, pitch, submission draft, deploy, demo video | `finishing-a-development-branch` |
| 7 Retro | Planned-vs-actual review, cleanup of keys and paid services, improvements fed back | - |

Time is tracked with absolute timestamps. At 80% of a phase budget the skill warns you; when a phase runs over, the only options it offers are feature cuts.

## What it creates in your project

```text
your-project/
├── AGENTS.md                     project rules + pointer to the hackathon state
├── CLAUDE.md                     includes AGENTS.md (Claude Code)
├── README.md                     written in Phase 6
└── docs/
    ├── PRD.md  DESIGN_SYSTEM.md  ARCHITECTURE.md  DATABASE.md
    ├── SECURITY.md  CODE_STYLE.md  TESTING.md
    ├── DEMO.md                   demo script, failure plan, judge Q&A, rehearsal log
    └── hackathon/
        ├── STATE.md              deadline, rules, phase clock, scope, checkpoints
        ├── TEAM.md               owners, integration points, agreements
        ├── log/<handle>.md       per-person checkpoints, blockers, handoffs
        ├── PITCH.md  SUBMISSION.md  RETRO.md
        └── DEPLOYMENTS.md        web3 only: networks, addresses, demo wallets, known risks
```

The eight architecture documents (`AGENTS.md` plus seven in `docs/`) follow the Docs Architecture Bundle. They are filled completely, in dependency order, and undecided choices are labeled as proposals until you approve them.

## Quick start

```bash
git clone https://github.com/woydarko/hackflow.git
cd hackflow
bash install.sh                  # macOS / Linux / Git Bash
```

```powershell
.\install.ps1                    # Windows PowerShell
```

Restart or reload your agent, then:

```text
/hackaton deps        check dependencies and environment (read-only)
/hackaton             start: toolchain check, then intake
/hackaton status      phase, time left, open blockers, over-budget warnings
```

Other arguments: `docs`, `plan`, `build`, `verify`, `demo`, `retro`. Every argument except `init` and `deps` first checks that `docs/hackathon/STATE.md` exists and otherwise offers Phase 1.

The installer copies the skill into `~/.agents/skills` and `~/.claude/skills`, replacing only an existing `hackaton` folder. Options: `--symlink` (one copy that follows `git pull`), `--dest DIR` (custom folders).

## Supported harnesses

The skill resolves its own folder at run time and never hardcodes one harness's path. Locations below come from each harness's official documentation.

| Harness | User-level skills folder | Invoke |
|---|---|---|
| Claude Code | `~/.claude/skills` | `/hackaton deps` |
| Codex | `~/.agents/skills` (project: `.agents/skills`) | `$hackaton deps` |
| OpenCode | `~/.config/opencode/skills`; also reads `~/.agents/skills` and `~/.claude/skills` | ask to "use the hackaton skill, deps" |
| Others | their skills folder, or `npx skills add woydarko/hackflow` (untested) | by skill name |

- Progress notes are written to `AGENTS.md`, which Codex, OpenCode and most harnesses read.
- `/plugin ...` commands exist only in Claude Code; other harnesses install dependencies their own way (see the [dependencies guide](skills/hackaton/references/dependencies.md)).
- The helper scripts are bash (Git Bash or WSL on Windows). Without bash the skill falls back to checking by hand.

## Dependencies

Superpowers is **required**: it is the backbone of the flow, and `/hackaton` stops until it is installed. Everything else is optional; the skill reports what is missing, shows the install command and source repo, and continues. Nothing is installed silently, and all of it is third-party code you should read before installing.

```bash
bash ~/.claude/skills/hackaton/scripts/check-deps.sh       # or: /hackaton deps
```

| Tier | Dependency | Source |
|---|---|---|
| required | superpowers | [obra/superpowers](https://github.com/obra/superpowers) |
| core | caveman | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) |
| core | rtk | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) |
| core | ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
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

## Modes

Detected from the brief and the repository, then confirmed with you. Each mode loads its own guide only when needed.

- **Web3** ([`web3.md`](skills/hackaton/references/web3.md)): chain detection (EVM, Midnight, Solana, Move), testnet-only safety rules, one-time testnet deploy approval, an audit gate (`x-ray`, `solidity-auditor`, `fizz`, tests), a testnet submission checklist and a `DEPLOYMENTS.md` record.
- **AI** ([`ai-projects.md`](skills/hackaton/references/ai-projects.md)): server-side keys, cost caps, replay mode for the demo, an eval set, prompt-injection checks, AI-usage disclosure.
- **UI** ([`ui-design.md`](skills/hackaton/references/ui-design.md)): an addendum to `DESIGN_SYSTEM.md` (screen inventory, wireframes, type scale, color roles, motion, voice, do/don't list), a build order and a visual QA checklist.

Other guides: [`env-readiness.md`](skills/hackaton/references/env-readiness.md) (accounts, keys, faucet funds, with `check-env.sh`) and [`ship.md`](skills/hackaton/references/ship.md) (deploy, demo video, submission mechanics).

## Team use

To avoid git conflicts, `STATE.md` has a single editor (the lead). Everyone else, human or agent, appends checkpoints, blockers and handoff notes to their own `docs/hackathon/log/<handle>.md`. The skill also adds `docs/hackathon/log/*.md merge=union` to the project's `.gitattributes`, so concurrent appends merge instead of conflicting. `/hackaton status` aggregates all logs.

## Repository layout

```text
hackflow/
├── install.sh  install.ps1       installers
├── .gitattributes                forces LF for shell scripts
└── skills/hackaton/
    ├── SKILL.md                  the skill
    ├── references/               on-demand guides (web3, AI, UI, env, ship, dependencies)
    ├── templates/                architecture pack + hackathon templates
    └── scripts/                  check-deps.sh  check-env.sh  lint-skill.py
```

## Development

```bash
python skills/hackaton/scripts/lint-skill.py
```

The linter checks the frontmatter rules shared by Claude Code, Codex and OpenCode (name equals folder, lowercase hyphenated, description at most 1024 characters) and that every referenced path exists. Run it before every commit.

## Status and limitations

Checked so far: linter, dependency and environment scripts on Windows (Git Bash), both installers in temporary folders, the `merge=union` behavior, and the mechanical steps of phases 0 to 2 on a toy project.

Not yet checked:
- A full run through a real hackathon (the heavy phases are delegated to superpowers and have not been timed against a real deadline).
- Running inside Codex and OpenCode themselves; their behavior is taken from official documentation.
- `npx skills add woydarko/hackflow`.

Treat the first real hackathon as the test, and record what breaks in `RETRO.md`.

## Credits

- [superpowers](https://github.com/obra/superpowers) by Jesse Vincent: the workflow this skill is built on.
- The eight-document architecture pack follows the Docs Architecture Bundle from mikenwo.ai.
- [caveman](https://github.com/JuliusBrussee/caveman), [rtk](https://github.com/rtk-ai/rtk) and [ponytail](https://github.com/DietrichGebert/ponytail) for terse output, token-efficient shell output and minimal code.
- [pashov/skills](https://github.com/pashov/skills), [Cyfrin/solskill](https://github.com/Cyfrin/solskill) and the Midnight skills for the web3 audit and standards layer.

## License

No license has been chosen yet, so all rights are reserved until a `LICENSE` file is added. The bundled architecture templates originate from a third-party pack; confirm its terms before redistributing them.
