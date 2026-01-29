---
name: quality-javascript
description: >
  Configures ESLint, Prettier, husky, and lint-staged for JavaScript/TypeScript projects.
  Trigger: When setting up JS/TS quality tools, configuring ESLint, installing Prettier.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Setting up JavaScript quality tools'
    - 'Configuring ESLint'
    - 'Installing Prettier for JavaScript'
allowed-tools: [Bash, Read, Edit, Write]
---

## When to Use

Use this skill when:

- Setting up a new JavaScript or TypeScript project
- Configuring ESLint for code quality
- Installing Prettier for consistent code formatting
- Setting up git hooks with husky for automatic linting on commit

## Critical Patterns

### Pattern 1: TypeScript Detection

Automatically detects TypeScript projects by checking for `tsconfig.json` and installs TypeScript-specific ESLint plugins.

### Pattern 2: Deterministic Configuration

Uses ESLint flat config (v9+) for modern configuration. For legacy projects, includes migration guide.

### Pattern 3: Pre-commit Hooks

Integrates with husky to run linting and formatting automatically on commit via lint-staged.

## Installation Requirements

This skill will install:

- **ESLint**: Linting and bug detection
- **Prettier**: Code formatting (consistent style)
- **husky**: Git hooks manager
- **lint-staged**: Run linters only on staged files

For TypeScript projects, also installs:

- `@typescript-eslint/parser`
- `@typescript-eslint/eslint-plugin`

## Commands

```bash
# Interactive setup
./skills/quality/stacks/javascript/assets/install-js-quality.sh

# Verify setup
npm run lint
npm run format:check

# Test pre-commit hook
git add .
git commit -m "test: verify hooks"

# Fix issues automatically
npm run lint -- --fix
npm run format
```

## Configuration Files

### eslint.config.js

Uses ESLint 9+ flat config format. Configurable rules for:

- Bug detection (no-unused-vars, no-console)
- Code style consistency
- TypeScript-specific rules (if detected)

### prettier.config.js

Sane defaults with:

- 100 character line length
- Single quotes
- Trailing commas (ES5)
- 2-space indentation

### package.json Scripts

Added after installation:

- `lint` - Run ESLint
- `format` - Format with Prettier
- `format:check` - Check formatting without changes

## Resources

- **ESLint**: https://eslint.org
- **Prettier**: https://prettier.io
- **husky**: https://typicode.github.io/husky/
- **lint-staged**: https://github.com/okonet/lint-staged
