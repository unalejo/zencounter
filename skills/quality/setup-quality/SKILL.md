---
name: setup-quality
description: >
  Orchestrates quality assurance setup for projects. Detects project type, configures linters,
  and optionally integrates AI code review via GGA.
  Trigger: When setting up code quality gates, configuring linters, initializing quality standards.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Setting up code quality gates'
    - 'Configuring linters and formatters'
    - 'Initializing quality standards'
allowed-tools: [Bash, Read, Glob, Grep]
---

## When to Use

Use this skill when:

- Setting up code quality for a new project
- Adding linting and formatting to existing projects
- Configuring quality gates and standards
- Enabling AI code review with GGA
- Researching modern quality tools for your stack

## How It Works

The orchestrator automates the entire quality setup workflow:

1. **Detect Project Type** - Identifies JavaScript, TypeScript, Python, Go, Rust, or monorepo
2. **Interactive Interview** - Asks about preferences:
   - Research modern tools using WebSearch?
   - Enable AI code review with GGA?
   - Proceed with setup?
3. **Delegate to Stack Skill** - Runs appropriate installer:
   - JavaScript/TypeScript → `quality-javascript`
   - Python → `quality-python`
4. **Optional Enhancements** - Applies selected options:
   - Quality Evolution research → `quality-evolution`
   - GGA integration → `setup-gga`

## Critical Patterns

### Pattern 1: Multi-Stack Detection

Automatically detects project type with priority order:

1. TypeScript (package.json + tsconfig.json)
2. JavaScript (package.json only)
3. Python modern (pyproject.toml)
4. Python classic (requirements.txt)
5. Go (go.mod)
6. Rust (Cargo.toml)
7. Multiple/Monorepo detection

### Pattern 2: Interactive Workflow

Presents user choices for optional features:

- Modern tools research (uses WebSearch)
- AI code review integration (GGA)
- Confirmation before installation

### Pattern 3: Delegated Installation

Invokes specific stack skills rather than implementing all logic itself. Enables:

- Modular design
- Stack-specific best practices
- Independent skill testing

## Commands

```bash
# Interactive setup with all defaults
./skills/quality/setup-quality/assets/quality-interview.sh

# Detect project type only
./skills/quality/setup-quality/assets/detect-project.sh

# Run complete orchestration
# (Normally invoked by the AI agent based on auto_invoke triggers)
```

## Project Type Detection

The detect-project.sh script identifies:

- **typescript** - package.json + tsconfig.json
- **javascript** - package.json only
- **python** - pyproject.toml or requirements.txt
- **go** - go.mod
- **rust** - Cargo.toml
- **monorepo** - Multiple project types detected
- **unknown** - No recognized project files

## Optional Features

### Modern Tools Research

Uses WebSearch to find state-of-the-art tools:

- ESLint alternatives for JavaScript
- Ruff alternatives for Python
- Tool performance comparisons
- Community adoption metrics

Integration: Calls `quality-evolution` skill if enabled

### AI Code Review

Installs Gentleman Guardian Angel (GGA) for automated architectural review:

- Integrates with existing hooks (husky, pre-commit, git-native)
- Runs on staged files before commit
- Skippable with `git commit --no-verify`

Integration: Calls `setup-gga` skill if enabled

## Stack Skills Invoked

| Stack      | Skill                | Location                          |
| ---------- | -------------------- | --------------------------------- |
| JavaScript | `quality-javascript` | skills/quality/stacks/javascript/ |
| TypeScript | `quality-javascript` | skills/quality/stacks/javascript/ |
| Python     | `quality-python`     | skills/quality/stacks/python/     |

## Resources

- **Project Detection**: Follows agentskills.io standards
- **Stack Skills**: Modular, reusable quality configurations
- **GGA Integration**: https://github.com/Gentleman-Programming/gentleman-guardian-angel
- **WebSearch Evolution**: Modern tools research with safety gates
