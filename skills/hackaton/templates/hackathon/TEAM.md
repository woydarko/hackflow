# Team

Ask every agent session to read this file and AGENTS.md before starting. Update when ownership or blockers change.

## Members and ownership
| Person | Role / strengths | Owns (features, files, folders) | Agent session |
| --- | --- | --- | --- |
| [Name] | [Frontend / backend / design / pitch] | [F-01, /app/...] | [Branch or worktree] |

Rule: one owner per file area. Touch another owner's area only after telling them.

## Integration points
| From | To | Contract (API path, event, shared type) | Status |
| --- | --- | --- | --- |
| [Component] | [Component] | [Where it is defined] | [Agreed / Draft] |

## Open blockers (summary; each person records their own in `docs/hackathon/log/<handle>.md`)
| Blocker | Blocks | Owner | Since | Workaround / cut plan |
| --- | --- | --- | --- | --- |

## Working agreements
- Branches: [Naming, who merges, how often]
- Commit small and often; never force-push shared branches.
- Feature flags: unfinished features stay behind [flag mechanism] so the demo path always works.
- Handoff note at each shift change, written in your own log file `docs/hackathon/log/<handle>.md`: [What is done, what is next, what is broken].
- STATE.md has one editor (the lead); everything else goes in your own log. Run `git pull --rebase` before editing shared files.
- Shared secrets: [Where they live; names only, never values].

## Schedule
| Time | Who | What |
| --- | --- | --- |
| [Time] | [Name] | [Sleep / demo rehearsal / submit] |
