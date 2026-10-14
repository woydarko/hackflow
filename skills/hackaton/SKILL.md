---
name: hackaton
description: Hackathon workflow orchestrator. Use when the user types /hackaton or says they are joining/starting a hackathon, needs to ship a demo fast, or wants hackathon project docs (PRD, ARCHITECTURE, AGENTS.md, etc.) set up. Chains caveman, rtk, ponytail, superpowers, and the 8-document architecture bundle into one time-boxed flow - intake, docs, plan, build, verify, demo. Has a web3 mode (chain detection, contract audit gate, testnet deploy checklist).
argument-hint: "[init | deps | docs | plan | build | verify | demo | status]"
---

# /hackaton

Time-boxed hackathon flow. Ship a working, demoable thing. Judges see the demo, not the code.

## Conventions

- `<skill-dir>` = the folder containing this SKILL.md (the "base directory" shown when the skill loads). `templates/`, `references/`, `scripts/` below are relative to it. Never assume `~/.claude`; this skill also runs from `~/.codex/skills` and other agents' skill folders.
- Skills are written as `name` (provider), e.g. `brainstorming` (superpowers). Claude Code lists plugin skills as `provider:name` (`superpowers:brainstorming`); other agents use the plain name. Resolve against the available-skills list. If a skill is unavailable, say so and follow its intent by hand; never block.
- Commands starting with `/plugin` exist only in Claude Code and only the user can run them.

## Routing

No arg or `init` -> Phase 0+1. `deps` -> Phase 0 only. `docs` -> 2. `plan` -> 3. `build` -> 4. `verify` -> 5. `demo` -> 6. `status` -> read `docs/hackathon/STATE.md` and print phase cursor, time left, core done/total, unresolved items.

**Guard:** every arg except `init` and `deps` first checks that `docs/hackathon/STATE.md` exists. If missing, say so and offer Phase 1 before doing anything else. Never build against an unknown deadline, scope or judging criteria.

## Principles

- **Demo path first.** One golden user journey working end to end beats ten half features.
- **Minimal code.** Native/stdlib/existing lib before new dependency. No abstractions not needed by the demo.
- **Terse output.** Caveman full level for chat (if installed); code, commits, docs, README in normal prose.
- **Evidence over claims.** Say "Not run" until a command actually ran and passed.
- **Do not invent** requirements, commands, credentials, or test results. Unknown -> ask or mark `Unresolved`.
- **Approvals.** Production deploys, prod data changes, external messaging and spending money need explicit user OK each time. Web3 exception: if the user approved testnet/devnet deploys once at intake (recorded in STATE.md as `Testnet deploys pre-approved: Yes`), those need no further OK. Mainnet and real funds always need per-action approval.

## Phase 0 - Toolchain check (once per project)

Run `bash <skill-dir>/scripts/check-deps.sh` (read-only). It detects the agent environment, lists core / recommended / web3 dependencies as OK or MISSING with their source GitHub repo, and prints one line per item. Report missing items in one line each.

For anything MISSING, read `references/dependencies.md`, show the user the exact install command and source repo, and let the user run it (shell installs need the user's OK). Never install silently; third-party code should be read before first install. A missing dependency never blocks the flow: continue without it and say so. Core = caveman, rtk, ponytail, superpowers.

Also detect the chain/ecosystem. If the brief or project is web3 (see **Web3 mode** below), follow it in every phase.

## Phase 1 - Intake

Send **one batched message** with every question below that is still unknown (skip anything already in the repo or docs), then stop and wait. After the answers, ask any remaining blocker **one question at a time**, writing each answer to STATE.md immediately.

1. Hackathon name, theme/tracks, **deadline** (date+time+timezone), submission format (repo, video, deck, live demo).
2. **Judging criteria** and sponsor prizes/APIs (these drive scope).
3. Team size + who does what. Skills of each.
4. Idea (or "need ideas" -> propose 3 with the demo moment for each).
5. Platform + stack preference/constraints. Existing repo? Path.
6. Must-use tech/APIs/credits.
7. Web3 only: chain/ecosystem and track, sponsor protocols or bounties, wallets and faucets, whether contracts must be deployed for judging, and **"May I deploy to testnet/devnet without asking each time?"** (record the answer).

Then compute a **time budget** and state it: default split ~10% docs/plan, 60% build, 10% verify, 20% demo/submission buffer. Web3 mode: 10% / 55% / 15% (verify + audit) / 20%. Re-announce at each phase transition.

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

Right after intake create `docs/hackathon/STATE.md` and `docs/hackathon/TEAM.md` from `templates/hackathon/` (skip TEAM.md for solo). Fill event, deadline, judging criteria, budget, idea filter result, testnet pre-approval. Never guess a deadline.

Then make resume work in a fresh session, because this skill only loads when invoked: add to the project's `AGENTS.md` (create a minimal one if missing) the line `Hackathon project: before any work read docs/hackathon/STATE.md and docs/hackathon/TEAM.md, and follow the phase and cut-list recorded there.` For Claude Code also ensure a root `CLAUDE.md` exists containing `@AGENTS.md`, since it reads CLAUDE.md, not AGENTS.md.

## Phase 2 - Docs setup (8-document architecture bundle)

Templates live in `templates/` (pristine, never edit): `AGENTS.md` + `docs/{PRD,DESIGN_SYSTEM,ARCHITECTURE,DATABASE,SECURITY,CODE_STYLE,TESTING}.md` from Docs_Architecture_Bundle, and `hackathon/{STATE,TEAM,PITCH,DEPLOYMENTS}.md` copied to `docs/hackathon/` when needed (STATE/TEAM in Phase 1, DEPLOYMENTS in Phase 2 for web3, PITCH in Phase 6).

Procedure:
1. Inspect project. List which of the 8 destination files already exist.
2. Copy only missing files to the project (`AGENTS.md` at root, seven files in `docs/`). Existing file -> propose section-level merge, ask before replacing. Do not touch unrelated files.
3. Fill in **dependency order**: PRD -> DESIGN_SYSTEM -> ARCHITECTURE -> DATABASE -> SECURITY -> CODE_STYLE -> TESTING -> AGENTS.md.
4. **Hackathon-lite fill rules** (the bundle is written for a full project; compress it):
   - PRD: MVP = golden path only. Feature table limited to Must items, each with a Given/When/Then. "Explicitly excluded" must be filled; it protects the deadline. Add a `Demo moment` line (the 10 seconds judges remember) and a `Judging criteria -> feature` mapping.
   - DESIGN_SYSTEM: 5-8 tokens, one primary component set. Delegate visual quality to `frontend-design` / `antislop-ui` skills.
   - ARCHITECTURE: stack table + request flow + project structure. Pick boring tech the team already knows.
   - DATABASE: if no persistence needed, write `Not required for MVP` (or SQLite/JSON/mock). Keep Entities + Access rules only.
   - SECURITY: secrets are env var names only, server-side checks for anything with user data, no keys in client bundle. Residual risks listed, not hidden.
   - CODE_STYLE / TESTING: record only **verified** commands (read `package.json` / config). Not configured -> write `Not configured`. Testing matrix = golden path + 1-2 failure cases + permission case if auth exists.
   - AGENTS.md: point to docs, fill Owner / Approved commands / Sensitive systems / Blocking unknowns, and keep the STATE.md/TEAM.md line from Phase 1.
5. Label every undecided choice `Proposal - needs approval`. Never leave a draft masquerading as final.
6. Consistency pass across all 8 (scope, naming, stack, roles, acceptance criteria). Report contradictions.
7. Show a short summary and ask approval. Stop. Do not write app code in this phase.

When requirements change later, update affected docs together.

## Phase 3 - Plan

Use `brainstorming` (superpowers) only if the idea is still fuzzy (cap at a few questions; hackathon time is short). Then `writing-plans`, with these hackathon constraints (they override the defaults of the helper skills):
- Tasks ordered so the **golden path is demoable as early as possible** (walking skeleton first, then polish).
- Each task: file paths, verification step, time estimate. Mark each `core` or `stretch`.
- Cut line: everything `stretch` is dropped automatically if behind schedule. Split the plan into **ship now** vs **post-hackathon** and record both in STATE.md.
- Scope-cut prompt when scope creeps: "What are the minimum 3 features for a working demo?"
- Team: assign one owner per file area in TEAM.md and list integration points (API paths, shared types) before anyone builds.
- Use `using-git-worktrees` only when parallel work by multiple agents is needed; otherwise stay on one branch.
Get user approval of the plan, then stop.

## Phase 4 - Build

- Execute via `subagent-driven-development` (thorough) or `executing-plans` (cheaper, preferred when low on time/credits). Independent tasks -> `dispatching-parallel-agents`.
- TDD (`test-driven-development`) **only on core logic** (parsing, scoring, money, auth, data transforms). UI glue and demo scaffolding: smoke test is enough. State this choice in the plan, do not silently skip.
- Ponytail rules apply: need it at all? existing/native solution? smallest diff? No speculative config, no generic layers.
- UI: use `frontend-design` + `antislop-ui` to avoid generic AI look. Mobile width check if demo may be on phone.
- Research needed (sponsor API, prior art): `agent-reach` / web search, keep notes in `docs/` not in chat.
- Stuck >15 min on one bug: `systematic-debugging`; if still stuck, cut or mock it and note in `Unresolved`.
- Commit small and often (so a broken last-minute change can be reverted). Use `rtk` for git/test output if installed.
- Unfinished features go behind a feature flag so the demo path always works.
- Checkpoint every ~hour (use the system clock, e.g. `date`, for real timestamps): print remaining time, done/total core tasks, cut decision, and append a row to the STATE.md checkpoint table. Update TEAM.md blockers. Write a short handoff note at each shift change.

## Phase 5 - Verify (before demo, not after)

1. `verification-before-completion`: run real build/test/lint commands from CODE_STYLE/TESTING, paste actual results. Update TESTING.md `Results`: `Passed` / `Failed` / `Not run`.
2. Golden path end to end on a **clean checkout / fresh env** (missing env var, missing seed data are the usual demo killers).
3. Quick security pass: no secrets in repo or client bundle (`security-review` skill or grep for key patterns), `.env` ignored, `.env.example` present.
4. Fallbacks: demo works with no network? Prepare mock/recorded data for any flaky external API.
5. Pre-demo checklist: env vars documented, database seeded with demo data, error boundaries and loading/empty/error states on every demo screen, no dead buttons on the golden path.
6. **Rehearse the full demo at least 5 times**, fixing each failure point. Most hackathon failures are demo crashes.
7. `requesting-code-review` on the final diff only if time remains.

## Phase 6 - Demo and submission

Produce, in the repo:
- `README.md`: one-line pitch, problem, solution, screenshot/GIF, tech stack, **run in under 5 commands**, team, what is real vs mocked (be honest).
- `docs/DEMO.md`: 2-3 min script. Hook (10s) -> problem (20s) -> golden path live (60-90s) -> architecture/tech (20s) -> what's next (10s). List exact click path, seed data, backup recording plan.
- `docs/hackathon/PITCH.md` (from template): one-liner, problem evidence, why now, demo moment, why-not-a-wrapper, business model canvas (lite), market, criteria map. Judges often score investability and clarity, so spend leftover time here, not on extra features.
- Submission writeup, written for human **and LLM-assisted judges** (grading increasingly reads the writeup, every linked project, and every video): consistent structure, track named explicitly, self-contained (do not rely on reading the code), map each judging criterion to evidence, every link public and openable without login, every video reachable, claims match what is real vs mocked.
- Submission checklist: repo public/accessible, license, deployed URL tested from another device and logged out, video uploaded and playable, form fields filled, track/prize boxes ticked, submitted **before** deadline minus 30 min.
- Pitch deck only if required: use `ppt-master` skill.
Then `finishing-a-development-branch` for merge/tag.

## Web3 mode

Activate when the brief mentions a chain/token/wallet/dApp/DeFi/NFT/DAO, or the repo has `foundry.toml`, `hardhat.config.*`, `*.sol`, `*.compact`, `Anchor.toml`, `Move.toml`, or deps like `viem`/`wagmi`/`ethers`/`@solana/web3.js`. Then read `references/web3.md` and apply its safety rules and per-phase hooks in every phase. Not web3: skip it.

## Output style

- Phase transitions: one status line: `Phase N done | time left | next`.
- Questions: the Phase 1 intake is one batched, numbered message; later blockers one at a time.
- End every phase with exactly one decision for the user (approve / change), then stop.
