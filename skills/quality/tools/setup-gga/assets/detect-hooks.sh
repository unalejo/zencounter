#!/usr/bin/env bash
# Detect the hook system used in the project
# Output: husky, pre-commit, git-native, or none

set -e

PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Priority detection: husky → pre-commit → git-native → none

# 1. Check for husky (npm projects)
if [[ -f "package.json" ]] && grep -q '"husky"' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Detected husky${NC}" >&2
  echo "husky"
  exit 0
fi

# 2. Check for pre-commit (Python/multi-language)
if [[ -f ".pre-commit-config.yaml" ]]; then
  echo -e "${GREEN}✓ Detected pre-commit${NC}" >&2
  echo "pre-commit"
  exit 0
fi

# 3. Check for git-native hooks
if [[ -d ".git/hooks" ]] && [[ -f ".git/hooks/pre-commit" ]]; then
  echo -e "${GREEN}✓ Detected git-native hooks${NC}" >&2
  echo "git-native"
  exit 0
fi

# 4. No hook system found
echo -e "${GREEN}✓ No hook system detected${NC}" >&2
echo "none"
exit 0
