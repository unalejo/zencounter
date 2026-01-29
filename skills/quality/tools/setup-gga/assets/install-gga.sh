#!/usr/bin/env bash
# Install GGA (Gentleman Guardian Angel) AI code review tool
# Supports: Homebrew (preferred) and manual installation from GitHub

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== GGA Installation ===${NC}"
echo ""

# Check if GGA already installed
if command -v gga &> /dev/null; then
  echo -e "${GREEN}✓ GGA is already installed${NC}"
  gga --version
  exit 0
fi

# Try Homebrew first (official method)
if command -v brew &> /dev/null; then
  echo -e "${YELLOW}Installing GGA via Homebrew...${NC}"
  brew tap gentleman-programming/tap
  brew install gga
  echo -e "${GREEN}✓ GGA installed via Homebrew${NC}"
else
  echo -e "${YELLOW}Homebrew not found, installing GGA manually...${NC}"
  echo "This will clone from GitHub and run the local install script."
  echo ""

  # Create temporary directory
  TEMP_DIR=$(mktemp -d)
  trap "rm -rf $TEMP_DIR" EXIT

  # Clone repository
  echo -e "${YELLOW}Cloning GGA repository...${NC}"
  git clone https://github.com/Gentleman-Programming/gentleman-guardian-angel.git "$TEMP_DIR"

  # Run installation
  echo -e "${YELLOW}Running GGA installation...${NC}"
  cd "$TEMP_DIR"

  # Check for install script
  if [[ -f "install.sh" ]]; then
    chmod +x install.sh
    ./install.sh
  else
    # Alternative: try to build/install from source
    echo -e "${YELLOW}Running installation from source...${NC}"
    if [[ -f "Makefile" ]]; then
      make install
    elif [[ -f "setup.py" ]]; then
      pip install --upgrade pip
      pip install -e .
    else
      echo -e "${RED}Error: Could not find installation method${NC}"
      exit 1
    fi
  fi

  cd -
  echo -e "${GREEN}✓ GGA installed from source${NC}"
fi

echo ""

# Verify installation
echo -e "${YELLOW}Verifying GGA installation...${NC}"
if ! command -v gga &> /dev/null; then
  echo -e "${RED}Error: GGA installation failed or command not in PATH${NC}"
  echo "Please add GGA to your PATH or install manually from:"
  echo "https://github.com/Gentleman-Programming/gentleman-guardian-angel"
  exit 1
fi

echo -e "${GREEN}✓ GGA installed successfully${NC}"
gga --version

echo ""
echo -e "${GREEN}✅ GGA installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Run: ./skills/quality/tools/setup-gga/assets/detect-hooks.sh"
echo "2. Run: ./skills/quality/tools/setup-gga/assets/integrate-hooks.sh"
echo "3. Test: gga run --dry-run"
echo ""
