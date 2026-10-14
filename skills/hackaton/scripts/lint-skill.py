#!/usr/bin/env python3
"""Read-only lint for the /hackaton skill. Run from anywhere: python scripts/lint-skill.py

Checks the rules that Claude Code, Codex and OpenCode share:
- SKILL.md has YAML frontmatter with `name` (lowercase, hyphens, equals the folder name) and `description` (<= 1024 chars)
- every `references/...`, `templates/...`, `scripts/...` path mentioned in SKILL.md and references/ exists
- no hardcoded single-harness skill path is used as an instruction (informational list only)
Exit code 1 when a check fails.
"""
import os
import re
import sys

skill_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
errors = []


def read(path):
    with open(os.path.join(skill_dir, path), encoding="utf-8") as f:
        return f.read()


skill = read("SKILL.md")
m = re.match(r"---\n(.*?)\n---\n", skill, re.S)
if not m:
    errors.append("SKILL.md: missing YAML frontmatter")
    fm = {}
else:
    fm = dict(re.findall(r"^([A-Za-z-]+):\s*(.*)$", m.group(1), re.M))

name = fm.get("name", "")
if name != os.path.basename(skill_dir):
    errors.append(f"frontmatter name '{name}' != folder '{os.path.basename(skill_dir)}'")
if not re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", name):
    errors.append(f"name '{name}' must be lowercase letters, digits and single hyphens")
desc = fm.get("description", "")
if not 1 <= len(desc) <= 1024:
    errors.append(f"description length {len(desc)} not in 1..1024")

files = ["SKILL.md"] + ["references/" + f for f in sorted(os.listdir(os.path.join(skill_dir, "references")))]
path_re = re.compile(r"`((?:references|templates|scripts)/[A-Za-z0-9_./-]+)`")
for f in files:
    for p in sorted(set(path_re.findall(read(f)))):
        if not os.path.exists(os.path.join(skill_dir, p.rstrip("/"))):
            errors.append(f"{f}: referenced path not found: {p}")

print(f"skill: {name}  description: {len(desc)} chars  SKILL.md: {len(skill.splitlines())} lines")
hard = [f for f in files if "~/.claude/skills/hackaton" in read(f)]
if hard:
    print("note: hardcoded ~/.claude/skills/hackaton in:", ", ".join(hard))
if errors:
    print("FAIL")
    for e in errors:
        print(" -", e)
    sys.exit(1)
print("OK")
