---
name: quality-python
description: >
  Configures Ruff (fast linter/formatter) and pre-commit for Python projects.
  Trigger: When setting up Python quality tools, configuring Ruff, installing Python linters.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Setting up Python quality tools'
    - 'Configuring Ruff'
    - 'Installing Python linters'
allowed-tools: [Bash, Read, Edit, Write]
---

## When to Use

Use this skill when:

- Setting up a new Python project
- Configuring Ruff for code linting and formatting
- Installing pre-commit hooks for automatic checks on commit
- Ensuring consistent code quality in Python projects

## Critical Patterns

### Pattern 1: Package Manager Detection

Automatically detects the package manager (uv → poetry → pip) and uses it for installation to match the project's existing workflow.

### Pattern 2: Configuration Strategy

Creates Ruff configuration using the appropriate method:

- If `pyproject.toml` exists: Adds `[tool.ruff]` section to existing file
- Otherwise: Creates standalone `ruff.toml` for simplicity

### Pattern 3: Pre-commit Hooks

Integrates with pre-commit framework to run Ruff automatically on staged files before commit.

## Installation Requirements

This skill will install:

- **Ruff**: Fast Python linter and formatter (replaces black, isort, flake8)
- **pre-commit**: Framework for managing git hooks

Ruff provides:

- Linting (bug detection, code smells)
- Formatting (consistent style, like Black)
- Import sorting (like isort)

## Commands

```bash
# Interactive setup
./skills/quality/stacks/python/assets/install-py-quality.sh

# Verify setup
ruff check .
ruff format --check .

# Test pre-commit hook
pre-commit run --all-files

# Fix issues automatically
ruff check --fix .
ruff format .

# Test pre-commit integration
git add .
git commit -m "test: verify hooks"
```

## Configuration Files

### ruff.toml

Standalone Ruff configuration with sensible defaults:

- Line length: 100 characters
- Target Python version: 3.10+
- Enabled rules: F (pyflakes), E/W (errors/warnings), I (imports)
- Ignore: E501 (line too long - handled by formatter)

### pyproject-quality.toml

Configuration snippet for projects using `pyproject.toml`:

```toml
[tool.ruff]
line-length = 100
target-version = "py310"
```

### .pre-commit-config.yaml

Hooks configuration for:

- Ruff linting: `ruff check --fix`
- Ruff formatting: `ruff format`

## Resources

- **Ruff**: https://docs.astral.sh/ruff/
- **pre-commit**: https://pre-commit.com/
- **Ruff vs Black**: https://docs.astral.sh/ruff/formatter/
