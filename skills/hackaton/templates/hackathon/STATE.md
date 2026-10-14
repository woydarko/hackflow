# Hackathon State

Single source of truth for `/hackaton`. Update at every phase change and checkpoint. Read this first when resuming a session.

## Event
- Name: [Hackathon name]
- Lead (sole editor of this file in team mode): [Name]
- Tracks / prizes targeted: [List]
- Deadline: [YYYY-MM-DD HH:MM timezone]
- Internal submit target: [Deadline minus 30 min]
- Submission format: [Repo / video / deck / live demo / form URL]

## Judging criteria
| Criterion | Weight (if known) | Feature / evidence that covers it |
| --- | --- | --- |
| [Criterion] | [Weight] | [F-xx or artifact] |

## Hackathon rules (binding points from the official rules page)
- Rules page: [URL]
- Code origin (written during the event? templates / prior work allowed?): [Answer]
- AI tools / models allowed and disclosure required: [Answer]
- Team size, tracks per project, eligibility (age, region, KYC): [Answer]
- License / open-source requirement, IP ownership: [Answer]
- Required or forbidden APIs / SDKs: [Answer]
- Submission language and limits: [Answer]

## Environment readiness
- check-env.sh run at: [timestamp] - missing: [List or none]
- Accounts, keys (names only), hosting, repo access: [Done / Open items]
- Web3: faucet funds requested at [timestamp], balances in DEPLOYMENTS.md: [Done / Open]
- AI: provider key tested, spend cap set: [Done / Open / n.a.]

## Phase cursor and clock
Current phase: [0 toolchain | 1 intake | 2 docs | 3 plan | 4 build | 5 verify | 6 demo]
Last updated: [timestamp from `date`]

| Phase | Status | Budget | Planned start -> end | Actual end | Notes |
| --- | --- | --- | --- | --- | --- |
| 1 Intake | Not started | [h] | [time -> time] | | |
| 2 Design + docs | Not started | [h] | [time -> time] | | |
| 3 Plan | Not started | [h] | [time -> time] | | |
| 4 Build | Not started | [h] | [time -> time] | | |
| 5 Verify | Not started | [h] | [time -> time] | | |
| 6 Demo and submit | Not started | [h] | [time -> time] | | |

Over-budget warnings sent: [Phase, time]

## Idea filter result
- One-sentence pitch: [Problem -> solution -> user]
- Measurable impact claim: [e.g. minutes saved, errors reduced]
- Existing APIs/tools combined: [2-3 items]
- Visible output for judges: [UI / output]
- Passed filter: [Yes / No - reason]

## Web3 (if applicable)
- Ecosystem / chain: [EVM chain, Solana cluster, Midnight, other]
- Network: [Testnet name / chain ID]
- Testnet deploys pre-approved: [Yes / No] (mainnet always needs per-action approval)
- Sponsor protocols or bounty tracks: [List]
- Audit gate: x-ray [Not run / Done] | solidity-auditor [Not run / Done] | fizz [Not run / Skipped / Done] | tests [Not run / Passed / Failed]
- Deployments file: docs/hackathon/DEPLOYMENTS.md

## Scope
- Ship now (core): [Task IDs]
- Stretch (auto-cut if behind): [Task IDs]
- Post-hackathon: [Ideas deferred]

## Hourly checkpoints (lead consolidates from `docs/hackathon/log/*.md`; solo: write here)
| Time | Time left | Core done / total | Cut decision |
| --- | --- | --- | --- |

## Unresolved
- [Question] - owner: [Name]
