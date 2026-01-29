---
name: setup-gga
description: >
  Installs and configures GGA AI code review tool, intelligently integrating with existing hook systems (husky, pre-commit, or native git hooks).
  Trigger: When enabling AI code review, installing GGA, setting up automated review gates.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Installing GGA'
    - 'Enabling AI code review'
    - 'Setting up automated review gates'
allowed-tools: [Bash, Read, Edit, Write, Grep, Glob]
---

## When to Use

Use this skill when:

- Setting up AI-powered code review for a project
- Installing Gentleman Guardian Angel (GGA) tool
- Enabling automated architectural review gates
- Integrating AI review with existing hook systems

## Critical Patterns

### Pattern 1: Intelligent Hook Detection

Automatically detects the project's hook system (husky for npm, pre-commit for Python, or git-native) and integrates GGA appropriately.

### Pattern 2: Safe Integration

Always backs up existing hooks before modification. Checks for duplicate "gga run" entries to prevent conflicts. Tests integration after setup.

### Pattern 3: Multi-System Support

Works seamlessly with:

- **husky** (Node.js projects) - Integrates into .husky/pre-commit
- **pre-commit** (Python/multi-language) - Adds to .pre-commit-config.yaml
- **git-native** (raw .git/hooks) - Creates or appends to .git/hooks/pre-commit
- **None** (fresh setup) - Creates git hook infrastructure

## Installation Requirements

This skill will install:

- **GGA (Gentleman Guardian Angel)**: AI-powered code review tool
  - Via Homebrew: `brew tap gentleman-programming/tap && brew install gga` (recommended)
  - Manual fallback: Clone from GitHub and run local install script

## How It Works

1. **Installation** - Detects OS/environment and installs GGA via Homebrew or manual clone
2. **Detection** - Identifies existing hook system in project
3. **Integration** - Intelligently adds GGA to appropriate hook system
4. **Testing** - Validates integration with `gga run --dry-run`
5. **Backup** - Preserves original hook files with `.backup.TIMESTAMP` suffix

## Commands

```bash
# Interactive setup (detects and integrates automatically)
./skills/quality/tools/setup-gga/assets/install-gga.sh
./skills/quality/tools/setup-gga/assets/detect-hooks.sh
./skills/quality/tools/setup-gga/assets/integrate-hooks.sh

# Test integration
gga run --dry-run

# View GGA configuration
gga config

# Run review on staged changes
gga run --staged

# Bypass GGA on commit
git commit --no-verify
```

## Integration Points

### With husky (Node.js)

Appends to `.husky/pre-commit`:

```bash
gga run --staged || exit 1
```

### With pre-commit (Python)

Adds to `.pre-commit-config.yaml`:

```yaml
- repo: local
  hooks:
    - id: gga-review
      name: GGA AI Code Review
      entry: gga run
      language: system
      stages: [commit]
```

### With git-native

Creates `.git/hooks/pre-commit`:

```bash
#!/bin/bash
gga run --staged || exit 1
```

## Safety Features

- **Backup Creation**: Original hooks saved as `.backup.TIMESTAMP`
- **Duplicate Prevention**: Checks for existing "gga run" entries
- **Dry Run Testing**: Validates integration with `gga run --dry-run`
- **Rollback Instructions**: Provides commands to restore original state
- **Skip Support**: `git commit --no-verify` to bypass hooks

## Resources

- **GGA (Gentleman Guardian Angel)**: https://github.com/Gentleman-Programming/gentleman-guardian-angel
- **Homebrew Tap**: `brew tap gentleman-programming/tap`
- **husky Documentation**: https://typicode.github.io/husky/
- **pre-commit Documentation**: https://pre-commit.com/
