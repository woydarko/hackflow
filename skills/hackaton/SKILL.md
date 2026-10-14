---
name: hackaton
description: Hackathon workflow orchestrator. Use when the user types /hackaton or says they are joining/starting a hackathon, needs to ship a demo fast, or wants hackathon project docs (PRD, ARCHITECTURE, AGENTS.md, etc.) set up. Chains caveman, rtk, ponytail, superpowers, and the 8-document architecture bundle into one time-boxed flow - intake, docs, plan, build, verify, demo.
argument-hint: "[init | docs | plan | build | verify | demo | status]"
---

# /hackaton

Time-boxed hackathon flow. Ship a working, demoable thing. Judges see the demo, not the code.

Arg routing: no arg or `init` -> Phase 0+1. `docs` -> Phase 2. `plan` -> 3. `build` -> 4. `verify` -> 5. `demo` -> 6. `status` -> print phase table + what is done/unknown.

## Principles

- **Demo path first.** One golden user journey working end to end beats ten half features.
- **Minimal code.** Native/stdlib/existing lib before new dependency. No abstractions not needed by the demo.
- **Terse output.** Caveman full level for chat. Code, commits, docs, README: normal prose.
- **Evidence over claims.** Say "Not run" until a command actually ran and passed.
- **Do not invent** requirements, commands, credentials, or test results. Unknown -> ask or mark `Unresolved`.
- Deploy, prod data changes, external messaging, spending money: only with explicit user OK.

## Phase 0 - Toolchain check (once per project)

Check silently, report one line each, install nothing without telling the user:

| Tool | Check | Role |
|---|---|---|
| caveman | `/caveman` skill exists | terse chat, save tokens |
| rtk | `rtk --version` | token-filtered shell output (hook rewrites commands) |
| ponytail | plugin `ponytail@ponytail` listed in `~/.claude/plugins/installed_plugins.json` | stop over-building |
| superpowers | plugin `superpowers@claude-plugins-official` listed | brainstorming, plans, TDD, review, verification |

If ponytail missing, tell user to run (they must run it, agent cannot):
```
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
```
If a tool is absent, continue without it; do not block.

## Phase 1 - Intake (ask once, one message, then stop and wait)

Ask only what is unknown. Skip anything already in the repo/docs:

1. Hackathon name, theme/tracks, **deadline** (date+time+timezone), submission format (repo, video, deck, live demo).
2. **Judging criteria** and sponsor prizes/APIs (these drive scope).
3. Team size + who does what. Skills of each.
4. Idea (or "need ideas" -> propose 3 with the demo moment for each).
5. Platform + stack preference/constraints. Existing repo? Path.
6. Must-use tech/APIs/credits.

Then compute a **time budget**: split remaining hours ~ 10% docs/plan, 60% build, 10% verify, 20% demo/submission buffer. State it. Re-announce at each phase transition.

## Phase 2 - Docs setup (8-document architecture bundle)

Templates: `~/.claude/skills/hackaton/templates/` (AGENTS.md + docs/{PRD,DESIGN_SYSTEM,ARCHITECTURE,DATABASE,SECURITY,CODE_STYLE,TESTING}.md). Source: Docs_Architecture_Bundle. Keep this folder as the pristine copy; never edit it.

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
   - AGENTS.md: point to docs, fill Owner / Approved commands / Sensitive systems / Blocking unknowns.
5. Label every undecided choice `Proposal - needs approval`. Never leave a draft masquerading as final.
6. Consistency pass across all 8 (scope, naming, stack, roles, acceptance criteria). Report contradictions.
7. Show a short summary and ask approval. Stop. Do not write app code in this phase.

When requirements change later, update affected docs together.

## Phase 3 - Plan

Use `superpowers:brainstorming` only if the idea is still fuzzy (cap at a few questions; hackathon time is short). Then `superpowers:writing-plans`, with these hackathon constraints:
- Tasks ordered so the **golden path is demoable as early as possible** (walking skeleton first, then polish).
- Each task: file paths, verification step, time estimate. Mark each `core` or `stretch`.
- Cut line: everything `stretch` is dropped automatically if behind schedule.
- Use `superpowers:using-git-worktrees` only when parallel work by multiple agents is needed; otherwise stay on one branch.
Get user approval of the plan, then stop.

## Phase 4 - Build

- Execute via `superpowers:subagent-driven-development` (thorough) or `superpowers:executing-plans` (cheaper, preferred when low on time/credits). Independent tasks -> `superpowers:dispatching-parallel-agents`.
- TDD (`superpowers:test-driven-development`) **only on core logic** (parsing, scoring, money, auth, data transforms). UI glue and demo scaffolding: smoke test is enough. State this choice in the plan, do not silently skip.
- Ponytail rules apply: need it at all? existing/native solution? smallest diff? No speculative config, no generic layers.
- UI: use `frontend-design` + `antislop-ui` to avoid generic AI look. Mobile width check if demo may be on phone.
- Research needed (sponsor API, prior art): `agent-reach` / WebSearch, keep notes in `docs/` not in chat.
- Stuck >15 min on one bug: `superpowers:systematic-debugging`; if still stuck, cut or mock it and note in `Unresolved`.
- Commit small and often (so a broken last-minute change can be reverted). Use `rtk` for git/test output.
- Checkpoint every ~hour: print remaining time, done/total core tasks, cut decision.

## Phase 5 - Verify (before demo, not after)

1. `superpowers:verification-before-completion`: run real build/test/lint commands from CODE_STYLE/TESTING, paste actual results. Update TESTING.md `Results`: `Passed` / `Failed` / `Not run`.
2. Golden path end to end on a **clean checkout / fresh env** (missing env var, missing seed data are the usual demo killers).
3. Quick security pass: no secrets in repo or client bundle (`security-review` skill or grep for key patterns), `.env` ignored, `.env.example` present.
4. Fallbacks: demo works with no network? Prepare mock/recorded data for any flaky external API.
5. `superpowers:requesting-code-review` on the final diff only if time remains.

## Phase 6 - Demo and submission

Produce, in the repo:
- `README.md`: one-line pitch, problem, solution, screenshot/GIF, tech stack, **run in under 5 commands**, team, what is real vs mocked (be honest).
- `docs/DEMO.md`: 2-3 min script. Hook (10s) -> problem (20s) -> golden path live (60-90s) -> architecture/tech (20s) -> what's next (10s). List exact click path, seed data, backup recording plan.
- Submission checklist: repo public/accessible, license, deployed URL tested from another device, video uploaded, form fields filled, track/prize boxes ticked, submitted **before** deadline minus 30 min.
- Pitch deck only if required: use `ppt-master` skill.
Then `superpowers:finishing-a-development-branch` for merge/tag. Deploying requires explicit user OK.

## Output style

- Chat: caveman full. Phase transitions: one status line: `Phase N done | time left | next`.
- Questions: batched, numbered, answerable in one reply.
- End every phase with exactly one decision for the user (approve / change), then stop.
