#!/usr/bin/env bash
# Integrate GGA into the project's hook system
# Intelligently handles: husky, pre-commit, git-native, or creates new hooks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== GGA Hook Integration ===${NC}"
echo ""

# Verify GGA is installed
if ! command -v gga &> /dev/null; then
  echo -e "${RED}Error: GGA is not installed${NC}"
  echo "Run: $SCRIPT_DIR/install-gga.sh"
  exit 1
fi

# Detect hook system
HOOK_SYSTEM=$("$SCRIPT_DIR/detect-hooks.sh" 2>&1 | tail -1)

echo "Hook system: $HOOK_SYSTEM"
echo ""

case "$HOOK_SYSTEM" in
  husky)
    echo -e "${YELLOW}Integrating GGA into husky...${NC}"
    HOOK_FILE=".husky/pre-commit"

    # Check for duplicates
    if [[ -f "$HOOK_FILE" ]] && grep -q "gga run" "$HOOK_FILE"; then
      echo -e "${GREEN}✓ GGA already integrated in husky${NC}"
      exit 0
    fi

    # Backup original
    if [[ -f "$HOOK_FILE" ]]; then
      BACKUP_FILE="$HOOK_FILE.backup.$(date +%s)"
      cp "$HOOK_FILE" "$BACKUP_FILE"
      echo -e "${GREEN}✓ Backed up to: $BACKUP_FILE${NC}"
    fi

    # Create or append
    if [[ ! -f "$HOOK_FILE" ]]; then
      mkdir -p .husky
      cat > "$HOOK_FILE" << 'EOF'
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

gga run --staged || exit 1
EOF
    else
      # Insert before exec if it exists, otherwise append
      if grep -q "^exec" "$HOOK_FILE"; then
        sed -i.bak '/^exec/i gga run --staged || exit 1' "$HOOK_FILE"
        rm -f "$HOOK_FILE.bak"
      else
        echo "" >> "$HOOK_FILE"
        echo "gga run --staged || exit 1" >> "$HOOK_FILE"
      fi
    fi

    chmod +x "$HOOK_FILE"
    echo -e "${GREEN}✓ GGA integrated into .husky/pre-commit${NC}"
    ;;

  pre-commit)
    echo -e "${YELLOW}Integrating GGA into pre-commit...${NC}"
    HOOK_FILE=".pre-commit-config.yaml"

    # Check for duplicates
    if grep -q "gga" "$HOOK_FILE" 2>/dev/null; then
      echo -e "${GREEN}✓ GGA already integrated in pre-commit${NC}"
      exit 0
    fi

    # Backup original
    if [[ -f "$HOOK_FILE" ]]; then
      BACKUP_FILE="$HOOK_FILE.backup.$(date +%s)"
      cp "$HOOK_FILE" "$BACKUP_FILE"
      echo -e "${GREEN}✓ Backed up to: $BACKUP_FILE${NC}"
    fi

    # Add GGA to pre-commit config
    cat >> "$HOOK_FILE" << 'EOF'

# GGA AI Code Review
- repo: local
  hooks:
    - id: gga-review
      name: GGA AI Code Review
      entry: gga run
      language: system
      pass_filenames: false
      stages: [commit]
EOF

    # Reinstall hooks
    pre-commit install || true

    echo -e "${GREEN}✓ GGA integrated into .pre-commit-config.yaml${NC}"
    ;;

  git-native|none)
    echo -e "${YELLOW}Integrating GGA into git hooks...${NC}"
    HOOK_FILE=".git/hooks/pre-commit"

    # Create .git/hooks directory if needed
    mkdir -p .git/hooks

    # Check for duplicates
    if [[ -f "$HOOK_FILE" ]] && grep -q "gga run" "$HOOK_FILE"; then
      echo -e "${GREEN}✓ GGA already integrated in git hooks${NC}"
      exit 0
    fi

    # Backup original if exists
    if [[ -f "$HOOK_FILE" ]]; then
      BACKUP_FILE="$HOOK_FILE.backup.$(date +%s)"
      cp "$HOOK_FILE" "$BACKUP_FILE"
      echo -e "${GREEN}✓ Backed up to: $BACKUP_FILE${NC}"
    fi

    # Create or append hook
    if [[ ! -f "$HOOK_FILE" ]]; then
      cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash
# Git pre-commit hook: GGA AI Code Review
gga run --staged || exit 1
EOF
    else
      cat >> "$HOOK_FILE" << 'EOF'

# GGA AI Code Review
gga run --staged || exit 1
EOF
    fi

    chmod +x "$HOOK_FILE"
    echo -e "${GREEN}✓ GGA integrated into .git/hooks/pre-commit${NC}"
    ;;

  *)
    echo -e "${RED}Error: Unknown hook system: $HOOK_SYSTEM${NC}"
    exit 1
    ;;
esac

echo ""

# Test integration
echo -e "${YELLOW}Testing GGA integration...${NC}"
if gga run --dry-run > /dev/null 2>&1; then
  echo -e "${GREEN}✓ GGA test passed${NC}"
else
  echo -e "${YELLOW}⚠ GGA test inconclusive (may need configuration)${NC}"
fi

echo ""
echo -e "${GREEN}✅ GGA hook integration complete!${NC}"
echo ""
echo "Usage:"
echo "  - Commit files: git add . && git commit -m 'message'"
echo "  - Bypass hooks: git commit --no-verify"
echo "  - Rollback: mv $HOOK_FILE.backup.TIMESTAMP $HOOK_FILE"
echo ""
