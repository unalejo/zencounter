---
name: project-analyzer
description: >
  Analyzes project state, stack, dependencies, and agentic-boost configuration.
  Trigger: When analyzing a project, detecting tech stack, understanding project structure.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Analyzing project structure'
    - 'Detecting technology stack'
    - 'Understanding what this project has'
allowed-tools: [Read, Glob, Grep, Bash]
---

## Purpose

Foundation skill that detects project state before any modifications.
Other skills invoke this first to understand what exists.

## When to Use

- Starting work on any existing project
- Before suggesting improvements or changes
- As first step in any project-related workflow
- When user asks "what is this project?" or "analyze my project"

---

## STEP 0: Framework Source Detection (ALWAYS CHECK FIRST)

Before analyzing as a normal project, check if this IS the agentic-boost framework source repository:

### Detection Indicators

| Indicator                         | Check                                                      | Reliability           |
| --------------------------------- | ---------------------------------------------------------- | --------------------- |
| Framework signature in install.sh | `grep -q "AGENTIC_BOOST_FRAMEWORK_SOURCE=true" install.sh` | 100%                  |
| Git remote URL                    | Contains "agentic-boost"                                   | 99% - Standard naming |

### Detection Logic

```bash
# Check 1: Framework signature in install.sh (definitive)
if [ -f "install.sh" ] && grep -q "AGENTIC_BOOST_FRAMEWORK_SOURCE=true" install.sh; then
    echo "This IS the agentic-boost framework source"
fi

# Check 2: Git remote (backup check)
if git remote get-url origin 2>/dev/null | grep -q "agentic-boost"; then
    echo "This IS the agentic-boost framework source"
fi
```

### If Framework Source Detected

**DO NOT** offer project configuration. Instead report:

```
## Project Analysis

**Type**: Agentic-Boost Framework Source Repository

This IS the agentic-boost framework itself, not an application project.

**Framework Info**:
- Skills available: {count from skills/**/SKILL.md}
- Categories: generic, ops, setup, quality

**What you can do here**:
1. Develop and test new skills
2. Run `./skills/ops/skill-sync/assets/sync.sh` to update metadata
3. Run `./install.sh` from ANOTHER project to install agentic-boost there

**Note**: This repository doesn't need "project configuration" - it IS the configuration framework.
```

**IMPORTANT**: After detecting framework source, STOP analysis. Do not continue to "project state" detection.

---

## What It Detects (for application projects)

### 1. Project State

- **empty**: No source files, no manifest files
- **initialized**: Has manifest files but minimal source
- **established**: Mature project with source, tests, configs

### 2. Technology Stack

- Languages: TypeScript, JavaScript, Python, Go, Rust
- Frameworks: React, Next.js, FastAPI, Django, Express, etc.
- Build tools: Vite, Webpack, Turbo, Poetry, Cargo
- Package managers: npm, yarn, pnpm, pip, poetry, uv

### 3. Agentic-Boost State

- `skills/` directory present and skill count
- AGENTS.md files (root and component locations)
- IDE configurations (.claude/, .gemini/, .codex/)
- Quality gates configured (eslint, ruff, pre-commit)

### 4. Project Structure

- **single-app**: src/ at root, one main application
- **multi-component**: Multiple top-level dirs (api/, ui/, cli/)
- **monorepo**: Workspace with packages/, services/, apps/

---

## Detection Patterns

### Stack Detection Files

| Language   | Indicator Files                                      |
| ---------- | ---------------------------------------------------- |
| TypeScript | `tsconfig.json` + `package.json`                     |
| JavaScript | `package.json` (no tsconfig)                         |
| Python     | `pyproject.toml` or `requirements.txt` or `setup.py` |
| Go         | `go.mod`                                             |
| Rust       | `Cargo.toml`                                         |

### Framework Detection

| Framework | Indicator                                   |
| --------- | ------------------------------------------- |
| Next.js   | `next.config.*` or `"next"` in package.json |
| React     | `"react"` in package.json dependencies      |
| Vue       | `"vue"` in package.json or `vue.config.js`  |
| FastAPI   | `"fastapi"` in pyproject.toml/requirements  |
| Django    | `manage.py` or `"django"` in requirements   |
| Express   | `"express"` in package.json                 |
| Gin       | `"github.com/gin-gonic/gin"` in go.mod      |
| Axum      | `"axum"` in Cargo.toml                      |

### Structure Detection

| Type            | Indicators                                                                 |
| --------------- | -------------------------------------------------------------------------- |
| Monorepo        | `pnpm-workspace.yaml`, `lerna.json`, `turbo.json`, multiple `package.json` |
| Multi-component | Multiple top-level dirs with `src/` or `AGENTS.md`                         |
| Single-app      | `src/` at root, single manifest file                                       |

### Quality Tools Detection

| Tool       | Indicator                                      |
| ---------- | ---------------------------------------------- |
| ESLint     | `eslint.config.*` or `.eslintrc.*`             |
| Prettier   | `prettier.config.*` or `.prettierrc.*`         |
| Ruff       | `ruff.toml` or `[tool.ruff]` in pyproject.toml |
| Pre-commit | `.pre-commit-config.yaml`                      |
| Husky      | `.husky/` directory                            |

---

## Analysis Workflow

```
0. CHECK IF FRAMEWORK SOURCE (ALWAYS FIRST)
   ├─ grep "AGENTIC_BOOST_FRAMEWORK_SOURCE=true" install.sh → IS framework source, STOP
   ├─ git remote contains "agentic-boost" → IS framework source, STOP
   └─ Continue to step 1 if NOT framework source

1. CHECK PROJECT STATE
   ├─ Look for manifest files (package.json, pyproject.toml, go.mod, Cargo.toml)
   ├─ Look for source directories (src/, lib/, app/)
   └─ Determine: empty | initialized | established

2. DETECT STACK
   ├─ Identify primary language from manifest
   ├─ Detect framework from configs and dependencies
   └─ Identify package manager

3. CHECK AGENTIC-BOOST STATE
   ├─ Look for skills/ directory
   ├─ Count SKILL.md files
   ├─ Find all AGENTS.md files
   └─ Check IDE configs (.claude/, .gemini/)

4. ANALYZE STRUCTURE
   ├─ Count top-level directories with source
   ├─ Check for workspace indicators
   └─ Classify: single-app | multi-component | monorepo

5. DETECT QUALITY TOOLS
   ├─ Check for linter configs
   ├─ Check for formatter configs
   └─ Check for git hooks
```

---

## Output Format

Report findings in this structured format:

```yaml
# Project Analysis Report
analysis_date: 2026-01-25

# FIRST: Identify project type
project_type: framework_source | application

# If framework_source, include this section instead of normal analysis:
framework_info:
  name: agentic-boost
  skills_count: 12
  categories: [generic, ops, setup, quality]

# If application, continue with normal analysis:
project_state: established | initialized | empty

detected_stacks:
  - language: typescript
    framework: nextjs
    package_manager: pnpm
    version: '14.0.0' # if detectable
  - language: python
    framework: fastapi
    package_manager: uv

agentic_boost:
  installed: true | false
  skills_count: 8
  skills_directory: skills/
  agents_md_files:
    - path: /AGENTS.md
      scope: root
    - path: /api/AGENTS.md
      scope: api
  ide_configured:
    - claude
    - gemini

structure:
  type: monorepo | multi-component | single-app
  components:
    - name: apps/web
      has_agents_md: true
    - name: packages/sdk
      has_agents_md: false

quality_tools:
  linting:
    - eslint (configured)
    - ruff (configured)
  formatting:
    - prettier (configured)
  hooks:
    - husky (installed)
    - pre-commit (not installed)

recommendations:
  - 'Missing AGENTS.md in packages/sdk'
  - 'Consider adding pre-commit hooks for Python'
```

---

## Usage Notes

### This Skill is Read-Only

- **NEVER** make changes to the project
- **NEVER** create or modify files
- Only analyze and report findings

### Invocation by Other Skills

Other skills should invoke `project-analyzer` first:

```markdown
## Workflow

1. **First**: Invoke `project-analyzer` to understand current state
2. **Then**: Make decisions based on analysis
3. **Finally**: Execute changes (if appropriate)
```

### Direct User Invocation

When user asks to analyze:

- "Analyze my project"
- "What tech stack does this project use?"
- "What's in this codebase?"

Respond with the structured analysis report, highlighting:

1. Project state and maturity
2. Detected technologies
3. Agentic-boost installation status
4. Recommendations for next steps

---

## Example Analysis

**User**: "Analyze this project"

**Response**:

```
## Project Analysis

**State**: Established TypeScript monorepo

**Stack**:
- Primary: TypeScript + Next.js (pnpm)
- Secondary: Python + FastAPI (uv)

**Structure**: Monorepo with 3 components
- apps/web (Next.js frontend)
- services/api (FastAPI backend)
- packages/sdk (TypeScript SDK)

**Agentic-Boost**: Installed
- 8 skills available
- AGENTS.md in root and api/
- Missing: AGENTS.md in apps/web, packages/sdk

**Quality Tools**:
- ESLint + Prettier (configured)
- Ruff (configured for Python)
- Pre-commit hooks (installed)

**Recommendations**:
1. Add AGENTS.md to apps/web and packages/sdk
2. Run `skill-sync` to update auto-invoke tables
```
