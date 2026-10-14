#!/usr/bin/env bash
# Install the /hackaton skill for Claude Code, Codex, OpenCode and other harnesses that read SKILL.md folders.
# Default targets: ~/.agents/skills (Codex user scope, OpenCode) and ~/.claude/skills (Claude Code).
# Usage: bash install.sh [--symlink] [--dest DIR]...   (--dest replaces the default targets)
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/skills/hackaton"
[ -f "$SRC/SKILL.md" ] || { echo "skills/hackaton/SKILL.md not found next to install.sh" >&2; exit 1; }

mode=copy
dests=()
while [ $# -gt 0 ]; do
  case "$1" in
    --symlink) mode=symlink ;;
    --dest) shift; dests+=("${1:-}") ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done
[ ${#dests[@]} -eq 0 ] && dests=("$HOME/.agents/skills" "$HOME/.claude/skills")

for d in "${dests[@]}"; do
  [ -n "$d" ] || { echo "empty --dest" >&2; exit 1; }
  mkdir -p "$d"
  target="$d/hackaton"
  rm -rf "$target"   # only our own skill folder, never the parent
  if [ "$mode" = symlink ]; then ln -s "$SRC" "$target"; else cp -r "$SRC" "$target"; fi
  echo "installed ($mode): $target"
done
echo "Restart or reload your agent. Then check dependencies: bash <dest>/hackaton/scripts/check-deps.sh"
