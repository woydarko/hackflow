---
name: hackaton
description: Hackathon workflow orchestrator built on the superpowers workflow. Use when the user types /hackaton or says they are joining/starting a hackathon, needs to ship a demo fast, or wants hackathon project docs (PRD, ARCHITECTURE, AGENTS.md, etc.) set up. Runs superpowers (brainstorming, plans, TDD, reviews, verification) as the backbone and wraps it with hackathon intake, state, the 8-document architecture bundle, pitch and submission, plus caveman, rtk and ponytail. Has a web3 mode (chain detection, contract audit gate, testnet deploy checklist).
argument-hint: "[init | deps | docs | plan | build | verify | demo | retro | status]"
---

# /hackaton

Hackathon flow: ship a working, demoable thing. Judges see the demo, not the code. This skill does not replace anything: it unifies existing skills into one flow, with **superpowers as the backbone**.

## Conventions

This skill must work in Claude Code, Codex, OpenCode and any other harness that reads `SKILL.md` folders. Nothing below is specific to one of them unless stated.

- `<skill-dir>` = the folder containing this SKILL.md (the base directory the harness shows or returns when it loads the skill). `templates/`, `references/`, `scripts/` are relative to it. If the harness does not tell you, find the folder named `hackaton` that contains `SKILL.md` under `~/.agents/skills`, `~/.claude/skills`, `~/.codex/skills`, `~/.config/opencode/skills`, or the project's `.agents/skills`, `.claude/skills`, `.opencode/skills`. Never hardcode one harness's path.
- Invocation differs: Claude Code `/hackaton <arg>`, Codex `$hackaton <arg>`, OpenCode and others by asking to "use the hackaton skill" (its `skill` tool). Treat the argument as plain words after the skill name.
- Skills are written as `name` (provider), e.g. `brainstorming` (superpowers). Claude Code lists plugin skills as `provider:name` (`superpowers:brainstorming`); other harnesses use the plain name. Resolve against the available-skills list. If a non-core skill is unavailable, say so and follow its intent by hand.
- Superpowers skills that dispatch subagents (`subagent-driven-development`, `dispatching-parallel-agents`) need subagent support. If the harness has none, use `executing-plans`, as superpowers itself documents.
- Project memory file: write the resume pointer into `AGENTS.md` (read by Codex, OpenCode and most others). Harnesses with their own memory file (Claude Code `CLAUDE.md`, others) get a one-line file that includes `AGENTS.md` using that tool's include syntax.
- Commands starting with `/plugin` exist only in Claude Code and only the user can run them. Other harnesses use their own plugin or skill installers (see `references/dependencies.md`).
- The helper scripts are bash. If bash is unavailable (plain PowerShell), do the same checks by listing the folders and tools by hand and say so.

## Backbone: superpowers comes first

Follow `using-superpowers`. Its skills are mandatory workflow, not suggestions, and run in their own order and with their own rules. **If this file and a superpowers skill ever disagree, superpowers wins.** /hackaton only adds hackathon context around them:

| Phase | Superpowers skills (mandatory) | Hackathon layer added by /hackaton |
|---|---|---|
| 1 Intake | - | event facts, idea filter, STATE.md / TEAM.md |
| 2 Design + docs | `brainstorming` | docs bundle filled from the approved design |
| 3 Plan | `using-git-worktrees`, `writing-plans` | core/stretch marks, cut-list, owners |
| 4 Build | `subagent-driven-development` (or `executing-plans` if the user picks it), `test-driven-development`, `requesting-code-review`, `receiving-code-review`, `systematic-debugging`, `dispatching-parallel-agents` | feature flags, hourly checkpoints, handoff notes |
| 5 Verify | `verification-before-completion`, final `requesting-code-review` | clean-env run, demo rehearsals, web3 audit gate |
| 6 Ship | `finishing-a-development-branch` | README, DEMO, PITCH, SUBMISSION, submission checklist |
| 7 Retro | - | RETRO.md, cleanup, improvements fed back into this skill |

## Routing

No arg or `init` -> Phase 0+1. `deps` -> Phase 0 only. `docs` -> 2. `plan` -> 3. `build` -> 4. `verify` -> 5. `demo` -> 6. `retro` -> 7. `status` -> read `docs/hackathon/STATE.md` plus every `docs/hackathon/log/*.md` and print phase cursor, time left, the phase clock table (planned vs actual end per phase), core done/total, open blockers, unresolved items, and any over-budget warning (see **Clock and budget**).

**Guard:** every arg except `init` and `deps` first checks that `docs/hackathon/STATE.md` exists. If missing, say so and offer Phase 1 before doing anything else. Never build against an unknown deadline, scope or judging criteria.

## Principles

- **All in, always.** No lite or short mode: every phase, document and checklist runs in full whatever the event length. When time is short, cut features (`stretch` items), never process steps.
- **Superpowers first.** See Backbone. Do not skip, shorten or reorder its workflow to save time.
- **Demo path first.** One golden user journey working end to end beats ten half features.
- **Minimal code.** Native/stdlib/existing lib before new dependency. No abstractions not needed by the demo (ponytail).
- **Terse output.** Caveman full level for chat (if installed); code, commits, docs, README in normal prose.
- **Evidence over claims.** Say "Not run" until a command actually ran and passed.
- **Do not invent** requirements, commands, credentials, or test results. Unknown -> ask or mark `Unresolved`.
- **Approvals.** Production deploys, prod data changes, external messaging and spending money need explicit user OK each time. Web3 exception: if the user approved testnet/devnet deploys once at intake (recorded in STATE.md as `Testnet deploys pre-approved: Yes`), those need no further OK. Mainnet and real funds always need per-action approval.

## Clock and budget

The agent has no built-in clock. Run `date '+%Y-%m-%d %H:%M %z'` (numeric offset; zone names like `SEAST` are ambiguous) at session start, at every checkpoint and at every phase boundary, and keep absolute times with that offset in the STATE.md phase table (planned start/end, actual end). Convert the deadline the user gives (it may be in another timezone) to the same offset before computing time left.
- **80% of a phase budget used:** warn once: "Phase N at 80%: X left, Y core tasks open."
- **Phase over budget:** say so, show the overrun, and offer only feature cuts (drop `stretch`, shrink scope, mock a dependency). Never offer to skip superpowers steps, docs or checks.
- **Behind at 50% of build:** propose the cut-list right then, not at the end.
- **Final 3 hours:** print time left in every reply.
- Suggest to the user once: `/loop 60m /hackaton status` in Claude Code (or a phone/desk timer elsewhere) so the check happens even when nobody types. Only the user can start it.

## Phase 0 - Toolchain check (once per project)

Run `bash <skill-dir>/scripts/check-deps.sh` (read-only). It detects the agent environment and lists core / recommended / web3 dependencies as OK or MISSING with their source GitHub repo. Report missing items in one line each.

**Superpowers is the only blocking dependency.** The script cannot see every harness's plugin registry. If it reports superpowers MISSING but `brainstorming` appears in your available-skills list, treat it as installed. Otherwise, if it is MISSING, stop here, show the install command from `references/dependencies.md`, and continue only after the user has installed it. For every other MISSING item show the install command and source repo, let the user run it (shell installs need the user's OK), then continue without it if the user declines, saying so. Never install silently; third-party code should be read before first install. Core = superpowers, caveman, rtk, ponytail.

Then check environment readiness: run `bash <skill-dir>/scripts/check-env.sh` and work through `references/env-readiness.md` (accounts, secrets, tooling, and for web3 **request faucet funds in the first hour**). Record results in STATE.md.

Also detect the project type. If the brief or project is web3 (see **Web3 mode**) or has an AI feature (see **AI mode**), follow those sections in every phase.

## Phase 1 - Intake

Gather the event facts and pick the idea. Send **one batched message** with every question below that is still unknown (skip anything already in the repo or docs), then stop and wait. After the answers, ask any remaining blocker **one question at a time**, writing each answer to STATE.md immediately.

1. Hackathon name, theme/tracks, **deadline** (date+time+timezone), submission format (repo, video, deck, live demo).
2. **Judging criteria** and sponsor prizes/APIs (these drive scope).
3. Team size + who does what. Skills of each.
4. Idea (or "need ideas" -> propose 3 with the demo moment for each).
5. Platform + stack preference/constraints. Existing repo? Path.
6. Must-use tech/APIs/credits.
7. Web3 only: chain/ecosystem and track, sponsor protocols or bounties, wallets and faucets, whether contracts must be deployed for judging, and **"May I deploy to testnet/devnet without asking each time?"** (record the answer).
8. **Rules and eligibility**: must code be written during the event (are pre-existing code, templates or a prior project allowed)? Are AI tools or specific models allowed, and must their use be disclosed? Team size limits, open-source/license requirement, allowed and required APIs/SDKs, IP ownership, prize eligibility (age, region, KYC), submission language, tracks per project. Ask for the rules page link and read it yourself; write the binding points into STATE.md under `Hackathon rules`.

Then compute a **time budget** and state it: default split ~15% design + docs + plan, 55% build (including TDD and reviews), 10% verify, 20% demo/submission buffer. Web3 mode: 15% / 50% / 15% (verify + audit) / 20%. Turn the split into **absolute planned start/end times per phase** (run `date` for now) and write them in the STATE.md phase table. Re-announce at each phase transition.

### Idea filter (run on every candidate idea before Phase 2)

Reject or rework the idea if any answer is no:
1. **One sentence**: problem -> solution -> specific user. A non-technical judge understands it in 2 minutes.
2. **Measurable impact claim**: time saved, errors cut, cost reduced. Mark estimates as estimates.
3. **Integration over invention**: combines 2-3 existing APIs/tools/platforms. No training models from scratch, no research-paper projects. Web3: a small novel contract that composes with a sponsor protocol or existing standards counts as passing.
4. **Visible output**: a UI or result judges can see in the demo, not slides or mockups.
5. **Not a generic AI wrapper**: name the integration, data, workflow, or UX that makes it more than a prompt on top of a model.
6. **Hair on fire**: a real user is hurting today; say who and what they do now. "Why now?" has an answer.
7. **Fits the clock**: the golden path is buildable in the core budget.

Write the result into STATE.md. If the user brings no idea, propose 3 that pass the filter, each with its demo moment.

### Persist state

As soon as the batched intake answers arrive (before any follow-up question) create `docs/hackathon/STATE.md` and `docs/hackathon/TEAM.md` from `templates/hackathon/` (skip TEAM.md for solo), so every later answer is written straight into them. Fill event, deadline, judging criteria, hackathon rules, phase clock, idea filter result, env readiness results, testnet pre-approval. Never guess a deadline.

Then make resume work in a fresh session, because this skill only loads when invoked: add to the project's `AGENTS.md` (create a minimal one if missing) the line `Hackathon project: before any work read docs/hackathon/STATE.md and docs/hackathon/TEAM.md, and follow the phase and cut-list recorded there.` For Claude Code also ensure a root `CLAUDE.md` exists containing `@AGENTS.md`, since it reads CLAUDE.md, not AGENTS.md.

**Team mode (more than one person or agent)**: avoid git conflicts by giving every writer its own file. `STATE.md` is edited only by the lead (name them in STATE.md). Everyone else records checkpoints, blockers and handoff notes in their own append-only `docs/hackathon/log/<handle>.md` (from `templates/hackathon/LOG.md`; handle = git user name as a lowercase slug). Add the line `docs/hackathon/log/*.md merge=union` to the project's `.gitattributes` (create it if missing) so concurrent appends merge instead of conflicting. Run `git pull --rebase` before editing any shared hackathon file and commit + push right after. The lead folds the logs into STATE.md at phase boundaries. Solo: skip the log folder and write checkpoints straight into STATE.md.

## Phase 2 - Design and docs (8-document architecture bundle)

1. Run `brainstorming` (superpowers) on the chosen idea. Feed it the Phase 1 facts as constraints: deadline, judging criteria, sponsor requirements, stack, team. Its approved design is the single source for the docs below; do not ask the user the same things twice.
2. Set up the docs. Templates live in `templates/` (pristine, never edit): `AGENTS.md` + `docs/{PRD,DESIGN_SYSTEM,ARCHITECTURE,DATABASE,SECURITY,CODE_STYLE,TESTING}.md` from Docs_Architecture_Bundle, and `hackathon/{STATE,TEAM,PITCH,DEPLOYMENTS,SUBMISSION}.md` copied to `docs/hackathon/` when needed (STATE/TEAM in Phase 1, DEPLOYMENTS in Phase 2 for web3, PITCH and SUBMISSION in Phase 6), plus `hackathon/DEMO.md` copied to `docs/DEMO.md` in Phase 6.

Procedure:
1. Inspect project. List which of the 8 destination files already exist.
2. Copy only missing files to the project (`AGENTS.md` at root, seven files in `docs/`). Existing file -> propose section-level merge, ask before replacing. Exception: an `AGENTS.md` that holds only the Phase 1 resume pointer is replaced by the template with that pointer line kept at the top, no question. Do not touch unrelated files.
3. Fill in **dependency order**: PRD -> DESIGN_SYSTEM -> ARCHITECTURE -> DATABASE -> SECURITY -> CODE_STYLE -> TESTING -> AGENTS.md.
4. **Fill every section of every template completely**, whatever the event length. Hackathon additions on top of the bundle:
   - PRD: add a `Demo moment` line (the 10 seconds judges remember) and a `Judging criteria -> feature` mapping. Every feature gets Given/When/Then acceptance criteria. "Explicitly excluded" must be filled; it protects the deadline.
   - DESIGN_SYSTEM (when the project has a UI): fill the bundle sections completely, then append the hackathon UI addendum from `references/ui-design.md` (screen inventory, flow, wireframes, type scale, color roles, motion, voice, demo conditions, component inventory, do/don't list, decisions log). Use `frontend-design` / `antislop-ui` for direction and Figma or Pencil tools for wireframes when available. No UI: write "No UI" with the reason.
   - ARCHITECTURE: complete stack table, boundaries, request flow, interfaces, project structure and operations. Prefer technology the team already knows.
   - DATABASE: full entities, schema, relationships, access rules, migrations. If the project truly has no persistence, state that and why.
   - SECURITY: complete. Secrets are env var names only, server-side checks for anything with user data, no keys in client bundle. Residual risks listed, not hidden.
   - CODE_STYLE / TESTING: record only **verified** commands (read `package.json` / config); otherwise write `Not configured`. The test matrix covers every PRD feature, its failure cases, and permission cases.
   - AGENTS.md: point to docs, fill Owner / Approved commands / Sensitive systems / Blocking unknowns, and keep the STATE.md/TEAM.md line from Phase 1.
5. Label every undecided choice `Proposal - needs approval`. Never leave a draft masquerading as final.
6. Consistency pass across all 8 (scope, naming, stack, roles, acceptance criteria). Report contradictions.
7. Show a short summary and ask approval of design + docs together. Stop. Do not write app code in this phase.

When requirements change later, update affected docs together.

## Phase 3 - Plan

After approval run `using-git-worktrees`, then `writing-plans` (superpowers), unchanged. Hackathon layer on top of the plan it produces:
- Order tasks so the **golden path is demoable as early as possible** (walking skeleton first, then polish) as long as that does not break the plan's own dependency order.
- Mark each task `core` or `stretch`. Cut line: `stretch` is dropped automatically if behind schedule. Record **ship now** vs **post-hackathon** in STATE.md.
- Scope-cut prompt when scope creeps: "What are the minimum 3 features for a working demo?"
- Team: assign one owner per file area in TEAM.md and list integration points (API paths, shared types) before anyone builds.
- Deploy early: read `references/ship.md`, pick hosting in ARCHITECTURE.md Operations, and schedule a walking-skeleton deploy by ~40% of the build budget (production deploys still need the user's OK).
Get user approval of the plan, then stop.

## Phase 4 - Build

Execute the plan with `subagent-driven-development` (or `executing-plans` if the user chooses it), with `test-driven-development` for all implementation code, `requesting-code-review` / `receiving-code-review` between tasks, `systematic-debugging` for bugs, and `dispatching-parallel-agents` for independent tasks, all as defined by superpowers. Hackathon layer:
- Ponytail rules apply: need it at all? existing/native solution? smallest diff? No speculative config, no generic layers.
- UI (if any): build in the order given in `references/ui-design.md` (tokens, shell, golden-path screens from the approved wireframes, all states, then motion), using `frontend-design` + `antislop-ui` to avoid the generic AI look. No hardcoded colors, fonts or spacing outside the tokens.
- Research needed (sponsor API, prior art): `agent-reach` / web search, keep notes in `docs/` not in chat.
- A bug that survives `systematic-debugging` and blocks the golden path: mock or cut it, note in `Unresolved` and STATE.md, tell the user.
- Commit small and often (so a broken last-minute change can be reverted). Use `rtk` for git/test output if installed.
- Unfinished features go behind a feature flag so the demo path always works.
- Checkpoint every ~hour and at every phase boundary (see **Clock and budget**): print remaining time, done/total core tasks, cut decision, and append a row to your own log `docs/hackathon/log/<handle>.md` (solo: the STATE.md checkpoint table). Record blockers there too, and write a short handoff note in the log at each shift change.

## Phase 5 - Verify (before demo, not after)

1. `verification-before-completion` (superpowers): run real build/test/lint commands from CODE_STYLE/TESTING, paste actual results. Update TESTING.md `Results`: `Passed` / `Failed` / `Not run`.
2. Golden path end to end on a **clean checkout / fresh env** (missing env var, missing seed data are the usual demo killers).
3. Quick security pass: no secrets in repo or client bundle (`security-review` skill or grep for key patterns), `.env` ignored, `.env.example` present.
4. Fallbacks: demo works with no network? Prepare mock/recorded data for any flaky external API.
5. Pre-demo checklist: env vars documented, database seeded with demo data, error boundaries and loading/empty/error states on every demo screen, no dead buttons on the golden path. UI projects also run the visual QA checklist in `references/ui-design.md`.
6. **Rehearse the full demo at least 5 times**, fixing each failure point. Most hackathon failures are demo crashes.
7. Final `requesting-code-review` (superpowers) on the whole branch.
8. **Rules compliance**: re-read STATE.md `Hackathon rules` and check each binding rule against the repo and the submission (code origin, AI disclosure, license, team, required APIs). A violation is a blocker; tell the user.

## Phase 6 - Demo and submission

Read `references/ship.md` first (deploy checks, demo video, submission mechanics) and follow it. Produce, in the repo:
- `README.md`: one-line pitch, problem, solution, screenshot/GIF, tech stack, **run in under 5 commands**, team, what is real vs mocked (be honest), and the AI-usage disclosure if the rules require it (AI coding assistants included).
- `docs/DEMO.md` (from `templates/hackathon/DEMO.md`): 2-3 min script (hook 10s -> problem 20s -> golden path 60-90s -> tech 20s -> next 10s), setup checklist, exact click path, seed data, failure plan, judge Q&A prep, backup recording, and the rehearsal log (at least 5 runs).
- `docs/hackathon/PITCH.md` (from template): one-liner, problem evidence, why now, demo moment, why-not-a-wrapper, business model canvas, market, criteria map. Judges often score investability and clarity, so spend leftover time here, not on extra features.
- Submission writeup in `docs/hackathon/SUBMISSION.md` (from `templates/hackathon/SUBMISSION.md`: form fields, criteria map, sponsor requirements, link checks, rules compliance, submission log), written for human **and LLM-assisted judges** (grading increasingly reads the writeup, every linked project, and every video): consistent structure, track named explicitly, self-contained (do not rely on reading the code), map each judging criterion to evidence, every link public and openable without login, every video reachable, claims match what is real vs mocked.
- Submission checklist: repo public/accessible, license, deployed URL tested from another device and logged out, video uploaded and playable, form fields filled, track/prize boxes ticked, submitted **before** deadline minus 30 min.
- Pitch deck only if required: use `ppt-master` skill.
Then run `finishing-a-development-branch` (superpowers) for merge/PR/tag.

## Phase 7 - Retro and cleanup (after submission)

Run when the submission is in, or with `retro`. It is outside the time budget and may happen days later, for example when results arrive.
1. Copy `templates/hackathon/RETRO.md` to `docs/hackathon/RETRO.md` and fill it from evidence: the STATE.md clock (planned vs actual), the logs, git history, the submission, and any judge feedback the user shares. Facts first, opinions second.
2. Work through its cleanup checklist: shut down or downgrade hosting and paid services, revoke or rotate API keys and burner keys, close sponsor sandboxes, tag the final state, decide archive vs keep public. Each action that deletes or changes a live resource needs the user's OK.
3. Review the post-hackathon list in STATE.md and ask whether to continue the project.
4. Write concrete improvements for this skill under "Improvements to feed back into /hackaton" and offer to apply them. Any external message (thanks, posts) is drafted, never sent, without the user's OK.
5. End with one decision for the user.

## Web3 mode

Activate when the brief mentions a chain/token/wallet/dApp/DeFi/NFT/DAO, or the repo has `foundry.toml`, `hardhat.config.*`, `*.sol`, `*.compact`, `Anchor.toml`, `Move.toml`, or deps like `viem`/`wagmi`/`ethers`/`@solana/web3.js`. Then read `references/web3.md` and apply its safety rules and per-phase hooks in every phase. Not web3: skip it.

## AI mode

Activate when the idea or repo has an LLM, agent, RAG, vision, voice or ML feature (deps like `@anthropic-ai/sdk`, `openai`, `ai`, `langchain`, `transformers`, `torch`, or a brief that says chatbot/agent/assistant). Then read `references/ai-projects.md` and apply its per-phase guidance (server-side keys, cost caps, replay mode for the demo, eval set, prompt-injection checks, AI disclosure) on top of every phase. Not an AI project: skip it.

## Output style

- Phase transitions: one status line: `Phase N done | time left | next`.
- Questions: the Phase 1 intake is one batched, numbered message; later blockers one at a time (superpowers skills keep their own questioning style).
- End every phase with exactly one decision for the user (approve / change), then stop.
