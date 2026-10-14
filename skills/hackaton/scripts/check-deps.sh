#!/usr/bin/env bash
# Read-only: report which /hackaton dependencies are installed. See references/dependencies.md for sources.
PLUGINS="$HOME/.claude/plugins/installed_plugins.json"
SKILLS="$HOME/.claude/skills"

has_plugin() { grep -q "\"$1\"" "$PLUGINS" 2>/dev/null; }
has_skill()  { [ -f "$SKILLS/$1/SKILL.md" ]; }
has_cmd()    { command -v "$1" >/dev/null 2>&1; }

# tier | name | check kind:target | source repo
while IFS='|' read -r tier name check repo; do
  [ -z "$tier" ] && continue
  kind="${check%%:*}"; target="${check#*:}"
  if "has_$kind" "$target"; then status="OK     "; else status="MISSING"; fi
  printf '%-11s %-8s %-17s %s\n' "$tier" "$status" "$name" "$repo"
done <<'EOF'
core|caveman|plugin:caveman@caveman|JuliusBrussee/caveman
core|rtk|cmd:rtk|rtk-ai/rtk
core|ponytail|plugin:ponytail@ponytail|DietrichGebert/ponytail
core|superpowers|plugin:superpowers@claude-plugins-official|obra/superpowers
recommended|antislop|plugin:antislop@anti-slop|miqdadbadjuber/anti-slop
recommended|frontend-design|skill:frontend-design|anthropics/claude-plugins-official
recommended|agent-reach|skill:agent-reach|Panniantong/Agent-Reach
recommended|ecc|plugin:ecc@ecc|affaan-m/ECC
recommended|ppt-master|skill:ppt-master|hugohe3/ppt-master
recommended|playwright|skill:playwright|openai/skills (playwright)
recommended|graphify|skill:graphify|Graphify-Labs/graphify
web3|solidity|plugin:solidity@solskill|Cyfrin/solskill
web3|x-ray|skill:x-ray|pashov/skills
web3|solidity-auditor|skill:solidity-auditor|pashov/skills
web3|fizz|skill:fizz|pashov/skills
web3|midnight-compact|skill:midnight-compact|mzf11125/midnight_agent_skills
EOF
echo
echo "Install commands: ~/.claude/skills/hackaton/references/dependencies.md"
