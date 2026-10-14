#!/usr/bin/env bash
# Read-only dependency report for /hackaton. Works for Claude Code, Codex and any agent that keeps skills in a folder.
# Sources and install commands: ../references/dependencies.md
SKILL_DIRS=("$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.agents/skills")
PLUGIN_FILE="$HOME/.claude/plugins/installed_plugins.json"

has_skill()  { local d; for d in "${SKILL_DIRS[@]}"; do [ -f "$d/$1/SKILL.md" ] && return 0; done; return 1; }
has_plugin() { grep -q "\"$1\"" "$PLUGIN_FILE" 2>/dev/null; }
has_cmd()    { command -v "$1" >/dev/null 2>&1; }

# A check is one or more kind:target joined by '+'; any match counts as installed.
has_any() {
  local part
  IFS='+' read -ra parts <<< "$1"
  for part in "${parts[@]}"; do
    "has_${part%%:*}" "${part#*:}" && return 0
  done
  return 1
}

echo "Agent environments found:"
for d in "${SKILL_DIRS[@]}"; do [ -d "$d" ] && echo "  $d"; done
[ -f "$PLUGIN_FILE" ] && echo "  Claude Code plugins: $PLUGIN_FILE"
echo

missing=0
# tier | name | check | source repo
while IFS='|' read -r tier name check repo; do
  [ -z "$tier" ] && continue
  if has_any "$check"; then status="OK     "; else status="MISSING"; missing=$((missing+1)); fi
  printf '%-11s %-8s %-17s %s\n' "$tier" "$status" "$name" "$repo"
done <<'EOF'
core|caveman|plugin:caveman@caveman+skill:caveman|JuliusBrussee/caveman
core|rtk|cmd:rtk|rtk-ai/rtk
core|ponytail|plugin:ponytail@ponytail+skill:ponytail|DietrichGebert/ponytail
core|superpowers|plugin:superpowers@claude-plugins-official+skill:brainstorming|obra/superpowers
recommended|antislop|plugin:antislop@anti-slop+skill:antislop|miqdadbadjuber/anti-slop
recommended|frontend-design|skill:frontend-design|anthropics/claude-plugins-official
recommended|agent-reach|skill:agent-reach|Panniantong/Agent-Reach
recommended|ecc|plugin:ecc@ecc+skill:ecc-guide|affaan-m/ECC
recommended|ppt-master|skill:ppt-master|hugohe3/ppt-master
recommended|playwright|skill:playwright|openai/skills (playwright)
recommended|graphify|skill:graphify|Graphify-Labs/graphify
web3|solidity|plugin:solidity@solskill+skill:solidity|Cyfrin/solskill
web3|x-ray|skill:x-ray|pashov/skills
web3|solidity-auditor|skill:solidity-auditor|pashov/skills
web3|fizz|skill:fizz|pashov/skills
web3|midnight-compact|skill:midnight-compact|mzf11125/midnight_agent_skills
EOF
echo
echo "$missing missing. Install commands: $(cd "$(dirname "$0")/.." && pwd)/references/dependencies.md"
