#!/usr/bin/env bash
# Install and configure JavaScript quality tools
# Installs: ESLint, Prettier, husky, lint-staged

set -e

PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== JavaScript Quality Setup ===${NC}"
echo ""

# Verify we're in a Node.js project
if [[ ! -f "package.json" ]]; then
  echo -e "${RED}Error: package.json not found${NC}"
  exit 1
fi

# Detect TypeScript
HAS_TYPESCRIPT=false
if [[ -f "tsconfig.json" ]]; then
  HAS_TYPESCRIPT=true
  echo -e "${GREEN}✓ TypeScript detected${NC}"
fi

# Install dependencies
echo -e "${YELLOW}Installing quality tools...${NC}"
npm install --save-dev eslint prettier husky lint-staged

if [[ "$HAS_TYPESCRIPT" == "true" ]]; then
  echo -e "${YELLOW}Installing TypeScript-specific tools...${NC}"
  npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin
fi

# Create ESLint config
echo -e "${YELLOW}Configuring ESLint...${NC}"
cat > eslint.config.js << 'EOF'
import js from '@eslint/js';

const config = {
  languageOptions: {
    ecmaVersion: 2024,
    sourceType: 'module',
  },
  rules: {
    'no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
    'no-console': 'off',
  },
};

export default [
  js.configs.recommended,
  config,
];
EOF

echo -e "${GREEN}✓ Created eslint.config.js${NC}"

# Create Prettier config
echo -e "${YELLOW}Configuring Prettier...${NC}"
cat > prettier.config.js << 'EOF'
export default {
  semi: true,
  singleQuote: true,
  trailingComma: 'es5',
  printWidth: 100,
  tabWidth: 2,
  useTabs: false,
  arrowParens: 'always',
};
EOF

echo -e "${GREEN}✓ Created prettier.config.js${NC}"

# Initialize husky
echo -e "${YELLOW}Initializing husky...${NC}"
npx husky init

# Create pre-commit hook
echo -e "${YELLOW}Configuring pre-commit hook...${NC}"
cat > .husky/pre-commit << 'EOF'
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx lint-staged
EOF

chmod +x .husky/pre-commit
echo -e "${GREEN}✓ Created .husky/pre-commit${NC}"

# Configure lint-staged
echo -e "${YELLOW}Configuring lint-staged...${NC}"
npm pkg set lint-staged.'*.{js,jsx,ts,tsx}'[0]="eslint --fix"
npm pkg set lint-staged.'*.{js,jsx,ts,tsx,json,css,md}'[1]="prettier --write"

# Add npm scripts
echo -e "${YELLOW}Adding npm scripts...${NC}"
npm pkg set scripts.lint="eslint ."
npm pkg set scripts.format="prettier --write ."
npm pkg set scripts.format:check="prettier --check ."

echo ""
echo -e "${GREEN}✅ JavaScript quality setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Review eslint.config.js and prettier.config.js"
echo "2. Run: npm run lint"
echo "3. Run: npm run format:check"
echo "4. Commit to test hooks: git add . && git commit -m 'chore: verify quality gates'"
echo ""
