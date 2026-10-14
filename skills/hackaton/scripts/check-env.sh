#!/usr/bin/env bash
# Read-only environment report for /hackaton. Prints tool versions and non-secret project hints.
# Never prints environment variable values. Checklist: ../references/env-readiness.md

ver() { # label, then the command and its args
  local label="$1"; shift
  if command -v "$1" >/dev/null 2>&1; then
    printf '%-12s OK       %s\n' "$label" "$("$@" 2>&1 | head -1)"
  else
    printf '%-12s MISSING\n' "$label"
  fi
}

echo "== general"
ver git git --version
ver node node --version
ver npm npm --version
ver pnpm pnpm --version
ver bun bun --version
if command -v python3 >/dev/null 2>&1; then ver python python3 --version; else ver python python --version; fi
ver uv uv --version
ver docker docker --version
ver gh gh --version
ver cargo cargo --version

echo
echo "== web3 (only needed for web3 projects)"
ver forge forge --version
ver cast cast --version
ver anvil anvil --version
ver solana solana --version
ver anchor anchor --version

echo
echo "== project hints (current directory: $(pwd))"
[ -f .env.example ] && echo ".env.example   present" || echo ".env.example   missing"
if [ -f .env ]; then
  if git check-ignore -q .env 2>/dev/null; then echo ".env           present, git-ignored"
  else echo "WARNING: .env is present but NOT git-ignored (or not a git repo)"; fi
else
  echo ".env           absent"
fi
[ -f docs/hackathon/STATE.md ] && echo "STATE.md       present" || echo "STATE.md       missing (run /hackaton init)"
echo
echo "Next: tick the checklist in $(cd "$(dirname "$0")/.." && pwd)/references/env-readiness.md (accounts, keys, faucet funds)."
