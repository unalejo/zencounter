#!/usr/bin/env bash
# Interactive quality setup interview
# Gathers user preferences and runs appropriate quality setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/../../.."
PROJECT_ROOT="${1:-.}"

cd "$PROJECT_ROOT"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║     Quality Assurance Setup Guide      ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Detect project type
echo -e "${YELLOW}Detecting project type...${NC}"
PROJECT_TYPE=$("$SCRIPT_DIR/detect-project.sh" "$PROJECT_ROOT")
echo -e "${GREEN}✓ Detected: $PROJECT_TYPE${NC}"
echo ""

# Handle unknown projects
if [[ "$PROJECT_TYPE" == "unknown" ]]; then
  echo -e "${YELLOW}No recognized project files found.${NC}"
  echo "This script works best with:"
  echo "  • Node.js/TypeScript projects (package.json)"
  echo "  • Python projects (pyproject.toml, requirements.txt)"
  echo "  • Go projects (go.mod)"
  echo "  • Rust projects (Cargo.toml)"
  echo ""
  read -p "Continue anyway? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
  fi
fi

# Quality setup options
echo -e "${BLUE}Quality Setup Options:${NC}"
echo ""

# Option 1: Research modern tools
echo "1. Research modern tools with WebSearch?"
echo "   • Finds state-of-the-art linting/formatting tools"
echo "   • Compares performance and adoption metrics"
echo "   • Proposes better alternatives if available"
echo "   • Shows diffs and asks for confirmation"
echo -n "   Enable research? (y/n) [default: n] > "
read -r RESEARCH_CHOICE
RESEARCH_TOOLS=false
[[ "$RESEARCH_CHOICE" == "y" || "$RESEARCH_CHOICE" == "Y" ]] && RESEARCH_TOOLS=true

echo ""

# Option 2: Enable AI code review
echo "2. Enable AI code review with GGA?"
echo "   • Installs Gentleman Guardian Angel"
echo "   • Integrates with existing hooks"
echo "   • Runs automated architectural review"
echo -n "   Enable AI review? (y/n) [default: n] > "
read -r GGA_CHOICE
ENABLE_GGA=false
[[ "$GGA_CHOICE" == "y" || "$GGA_CHOICE" == "Y" ]] && ENABLE_GGA=true

echo ""
echo -e "${BLUE}Setup Summary:${NC}"
echo "  Project type: $PROJECT_TYPE"
echo "  Research tools: $RESEARCH_TOOLS"
echo "  AI code review: $ENABLE_GGA"
echo ""

# Confirm before proceeding
echo -n "Proceed with setup? (y/n) [default: y] > "
read -r CONFIRM
if [[ "$CONFIRM" == "n" || "$CONFIRM" == "N" ]]; then
  echo "Setup cancelled."
  exit 0
fi

echo ""
echo -e "${YELLOW}Starting quality setup...${NC}"
echo ""

# Step 1: Run stack skill
case "$PROJECT_TYPE" in
  javascript|typescript)
    echo -e "${YELLOW}Running JavaScript/TypeScript quality setup...${NC}"
    "$SKILLS_DIR/quality/stacks/javascript/assets/install-js-quality.sh" "$PROJECT_ROOT"
    ;;
  python)
    echo -e "${YELLOW}Running Python quality setup...${NC}"
    "$SKILLS_DIR/quality/stacks/python/assets/install-py-quality.sh" "$PROJECT_ROOT"
    ;;
  monorepo)
    echo -e "${YELLOW}Monorepo detected. Setting up all stacks...${NC}"
    if [[ -f "package.json" ]]; then
      echo "  • Setting up JavaScript/TypeScript..."
      "$SKILLS_DIR/quality/stacks/javascript/assets/install-js-quality.sh" "$PROJECT_ROOT" || true
    fi
    if [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]]; then
      echo "  • Setting up Python..."
      "$SKILLS_DIR/quality/stacks/python/assets/install-py-quality.sh" "$PROJECT_ROOT" || true
    fi
    ;;
  *)
    echo -e "${YELLOW}Stack installer not available for $PROJECT_TYPE${NC}"
    echo "Available: javascript, typescript, python"
    exit 1
    ;;
esac

echo ""

# Step 2: Quality evolution (research tools)
if [[ "$RESEARCH_TOOLS" == "true" ]]; then
  echo -e "${YELLOW}Researching modern tools...${NC}"
  if [[ -f "$SKILLS_DIR/quality/quality-evolution/assets/evolution-report-template.md" ]]; then
    # Call quality-evolution via wrapper if available
    echo "Tool research would be invoked here"
    echo "(This typically requires AI agent integration)"
  else
    echo "Quality evolution skill not available"
  fi
  echo ""
fi

# Step 3: GGA integration
if [[ "$ENABLE_GGA" == "true" ]]; then
  echo -e "${YELLOW}Setting up GGA AI code review...${NC}"

  # Check if GGA is installed
  if ! command -v gga &> /dev/null; then
    echo "Installing GGA..."
    "$SKILLS_DIR/quality/tools/setup-gga/assets/install-gga.sh" "$PROJECT_ROOT"
  fi

  # Integrate GGA hooks
  echo "Integrating GGA into hooks..."
  "$SKILLS_DIR/quality/tools/setup-gga/assets/integrate-hooks.sh" "$PROJECT_ROOT"
  echo ""
fi

echo -e "${GREEN}✅ Quality setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Review configuration files created"
echo "2. Test linting: ruff check . (Python) or npm run lint (JS)"
echo "3. Test formatting: ruff format . (Python) or npm run format (JS)"
echo "4. Commit and test hooks: git add . && git commit -m 'chore: verify quality gates'"
echo ""
echo "Resources:"
echo "  • ESLint: https://eslint.org"
echo "  • Ruff: https://docs.astral.sh/ruff/"
echo "  • GGA: https://github.com/Gentleman-Programming/gentleman-guardian-angel"
echo ""
