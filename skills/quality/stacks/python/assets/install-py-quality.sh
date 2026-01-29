#!/usr/bin/env bash
# Install and configure Python quality tools
# Installs: Ruff, pre-commit

set -e

PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Python Quality Setup ===${NC}"
echo ""

# Verify we're in a Python project
PYTHON_FILES=$(find . -maxdepth 2 -name "*.py" -type f 2>/dev/null | wc -l)
if [[ $PYTHON_FILES -eq 0 ]]; then
  echo -e "${RED}Warning: No Python files found${NC}"
  echo "This script is designed for Python projects"
fi

# Detect package manager
PACKAGE_MANAGER=""
INSTALL_CMD=""
DEV_INSTALL_CMD=""

if [[ -f "uv.lock" ]] || command -v uv &> /dev/null; then
  PACKAGE_MANAGER="uv"
  INSTALL_CMD="uv pip install"
  DEV_INSTALL_CMD="uv pip install"
  echo -e "${GREEN}✓ Detected uv${NC}"
elif [[ -f "poetry.lock" ]] || command -v poetry &> /dev/null; then
  PACKAGE_MANAGER="poetry"
  INSTALL_CMD="poetry add --group dev"
  DEV_INSTALL_CMD="poetry add --group dev"
  echo -e "${GREEN}✓ Detected Poetry${NC}"
elif [[ -f "Pipfile" ]] || command -v pipenv &> /dev/null; then
  PACKAGE_MANAGER="pipenv"
  INSTALL_CMD="pipenv install --dev"
  DEV_INSTALL_CMD="pipenv install --dev"
  echo -e "${GREEN}✓ Detected Pipenv${NC}"
else
  PACKAGE_MANAGER="pip"
  INSTALL_CMD="pip install --upgrade"
  DEV_INSTALL_CMD="pip install --upgrade"
  echo -e "${GREEN}✓ Using pip (default)${NC}"
fi

echo ""

# Install dependencies
echo -e "${YELLOW}Installing quality tools with $PACKAGE_MANAGER...${NC}"
$DEV_INSTALL_CMD ruff pre-commit

echo -e "${GREEN}✓ Ruff and pre-commit installed${NC}"

# Configure Ruff
echo -e "${YELLOW}Configuring Ruff...${NC}"

if [[ -f "pyproject.toml" ]]; then
  # Add Ruff config to existing pyproject.toml
  if ! grep -q "\[tool.ruff\]" pyproject.toml; then
    cat >> pyproject.toml << 'EOF'

[tool.ruff]
line-length = 100
target-version = "py310"

[tool.ruff.lint]
extend-select = ["I", "F", "E", "W"]

[tool.ruff.lint.per-file-ignores]
"__init__.py" = ["F401"]

[tool.ruff.format]
quote-style = "double"
EOF
    echo -e "${GREEN}✓ Added Ruff configuration to pyproject.toml${NC}"
  else
    echo -e "${GREEN}✓ Ruff already configured in pyproject.toml${NC}"
  fi
else
  # Create standalone ruff.toml
  cat > ruff.toml << 'EOF'
# Ruff configuration
line-length = 100
target-version = "py310"

[lint]
extend-select = ["I", "F", "E", "W"]

[lint.per-file-ignores]
"__init__.py" = ["F401"]

[format]
quote-style = "double"
EOF
  echo -e "${GREEN}✓ Created ruff.toml${NC}"
fi

# Create .gitignore entries for Python
if [[ ! -f ".gitignore" ]]; then
  cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
venv/
env/
ENV/
.venv

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# Testing
.pytest_cache/
.coverage
htmlcov/

# Pre-commit
.pre-commit-framework/
EOF
  echo -e "${GREEN}✓ Created .gitignore${NC}"
else
  # Check if Python entries exist
  if ! grep -q "__pycache__" .gitignore; then
    cat >> .gitignore << 'EOF'

# Python
__pycache__/
*.py[cod]
*$py.class
EOF
  fi
fi

# Initialize pre-commit
echo -e "${YELLOW}Initializing pre-commit...${NC}"
if [[ ! -f ".pre-commit-config.yaml" ]]; then
  cat > .pre-commit-config.yaml << 'EOF'
# Pre-commit hooks configuration
# Run: pre-commit run --all-files (to test)
# Run: pre-commit install (to install hooks)

repos:
  # Ruff linting
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.8
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
EOF
  echo -e "${GREEN}✓ Created .pre-commit-config.yaml${NC}"
else
  echo -e "${GREEN}✓ .pre-commit-config.yaml already exists${NC}"
fi

# Install pre-commit hooks
echo -e "${YELLOW}Installing pre-commit hooks...${NC}"
pre-commit install

# Create a pre-push hook as well (optional)
if [[ ! -f ".git/hooks/pre-push" ]]; then
  cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
# Pre-push hook: run full quality checks
echo "Running quality checks before push..."
ruff check . || exit 1
ruff format --check . || exit 1
echo "✓ Quality checks passed"
EOF
  chmod +x .git/hooks/pre-push
  echo -e "${GREEN}✓ Created .git/hooks/pre-push${NC}"
fi

echo ""
echo -e "${GREEN}✅ Python quality setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Review ruff.toml or pyproject.toml [tool.ruff] section"
echo "2. Run: ruff check ."
echo "3. Run: ruff format ."
echo "4. Commit to test hooks: git add . && git commit -m 'chore: verify quality gates'"
echo ""
