# hackflow

Claude Code skill `/hackaton`: a time-boxed hackathon workflow (intake, docs, plan, build, verify, demo) that chains caveman, rtk, ponytail, superpowers and an 8-document project architecture pack.

## Install

```bash
mkdir -p ~/.claude/skills
cp -r skills/hackaton ~/.claude/skills/hackaton
```

Optional companions (the skill checks for them and continues without):

```
/plugin install superpowers@claude-plugins-official
/plugin marketplace add dietrichgebert/ponytail
/plugin install ponytail@ponytail
```

Web3 mode companions (optional, third-party; read them before installing):

```
/plugin marketplace add Cyfrin/solskill
/plugin install solidity@solskill
git clone https://github.com/pashov/skills  # copy solidity-auditor, x-ray, fizz into ~/.claude/skills/
```

## Use

`/hackaton [init | docs | plan | build | verify | demo | status]`

`templates/` holds the pristine AGENTS.md + docs/*.md pack (docs phase) and `templates/hackathon/` (STATE, TEAM, PITCH, DEPLOYMENTS) used for state, team coordination, and pitch.
