---
name: best-practices-auditor
description: >
  Audits projects against best practices and recommends improvements.
  Trigger: When auditing project, checking best practices, reviewing project health.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Auditing project health'
    - 'What can I improve in this project'
allowed-tools: [Read, Glob, Grep, Bash]
---

## Purpose

Audits existing projects against best practices and suggests improvements.
Identifies gaps in configuration, missing quality gates, and recommends skills to adopt.

**Key principle**: This skill analyzes and recommends. It does NOT make changes directly.
It tells you what skills to invoke to fix issues.

## When to Use

- After cloning or inheriting an existing project
- Periodic project health checks
- When user asks "what can I improve?"
- Before major releases or handoffs
- When onboarding to a new codebase

## When NOT to Use

- For technology recommendations → use `architecture-advisor`
- For creating new projects → use `project-bootstrap`
- For just analyzing stack → use `project-analyzer`

---

## Audit Workflow

```
1. INVOKE project-analyzer
   └─ Get baseline: stack, structure, existing tools

2. RUN CHECKLIST
   ├─ Agentic-Boost completeness
   ├─ Quality gates
   ├─ Best practices
   └─ Stack-specific checks

3. SCORE FINDINGS
   ├─ Critical (must fix)
   ├─ Recommended (should fix)
   └─ Optional (nice to have)

4. GENERATE REPORT
   ├─ Overall score
   ├─ Findings by category
   └─ Recommended skills to invoke

5. PRESENT TO USER
   └─ Ask which issues to address
```

---

## Audit Checklist

### 1. Agentic-Boost Completeness

| Check               | Description                    | Severity    |
| ------------------- | ------------------------------ | ----------- |
| `skills/` exists    | Skills directory present       | Critical    |
| Root AGENTS.md      | Has routing document           | Critical    |
| Component AGENTS.md | Each component has AGENTS.md   | Recommended |
| Auto-invoke tables  | Tables populated (not empty)   | Recommended |
| IDE configured      | .claude/, .gemini/, etc. exist | Optional    |
| skill-sync run      | Tables match current skills    | Recommended |

**Detection:**

```bash
# Check skills directory
[ -d "skills" ] && [ -n "$(find skills -name 'SKILL.md')" ]

# Check AGENTS.md files
find . -name "AGENTS.md" -not -path "*/node_modules/*" -not -path "*/.git/*"

# Check if auto-invoke tables are populated
grep -q "| Action | Skill |" AGENTS.md && \
  ! grep -q "(Run skill-sync to populate" AGENTS.md
```

### 2. Quality Gates

| Check                 | Description                       | Severity    |
| --------------------- | --------------------------------- | ----------- |
| Linting configured    | ESLint, Ruff, golangci-lint, etc. | Critical    |
| Formatting configured | Prettier, Black, gofmt, etc.      | Recommended |
| Pre-commit hooks      | husky, pre-commit, etc.           | Recommended |
| Type checking         | TypeScript, mypy, etc.            | Recommended |
| Test framework        | Jest, pytest, go test, etc.       | Critical    |
| CI/CD pipeline        | GitHub Actions, GitLab CI, etc.   | Recommended |

**Detection by stack:**

**JavaScript/TypeScript:**

```bash
# Linting
[ -f "eslint.config.js" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ]

# Formatting
[ -f "prettier.config.js" ] || [ -f ".prettierrc" ]

# Hooks
[ -d ".husky" ]

# Tests
grep -q '"test":' package.json
```

**Python:**

```bash
# Linting
[ -f "ruff.toml" ] || grep -q "\[tool.ruff\]" pyproject.toml

# Formatting
[ -f "ruff.toml" ] || [ -f ".black.toml" ]

# Hooks
[ -f ".pre-commit-config.yaml" ]

# Tests
[ -d "tests" ] || [ -d "test" ]
```

**Go:**

```bash
# Linting
[ -f ".golangci.yml" ]

# Tests
find . -name "*_test.go" | head -1
```

### 3. Project Best Practices

| Check           | Description               | Severity    |
| --------------- | ------------------------- | ----------- |
| README.md       | Project has documentation | Critical    |
| LICENSE         | License file present      | Recommended |
| .gitignore      | Git ignore configured     | Critical    |
| .editorconfig   | Editor settings shared    | Optional    |
| CHANGELOG.md    | Version history tracked   | Optional    |
| CONTRIBUTING.md | Contribution guidelines   | Optional    |

**Detection:**

```bash
[ -f "README.md" ]
[ -f "LICENSE" ] || [ -f "LICENSE.md" ] || [ -f "LICENSE.txt" ]
[ -f ".gitignore" ]
[ -f ".editorconfig" ]
```

### 4. Security Best Practices

| Check              | Description             | Severity    |
| ------------------ | ----------------------- | ----------- |
| No secrets in code | .env not committed      | Critical    |
| Dependency audit   | npm audit, safety, etc. | Recommended |
| Security headers   | If web app              | Recommended |
| HTTPS enforced     | If web app              | Critical    |

**Detection:**

```bash
# Check for committed secrets
! git log --all --full-history -- "*.env" | grep -q commit

# Check .gitignore has .env
grep -q "\.env" .gitignore
```

### 5. Stack-Specific Checks

**TypeScript:**
| Check | Description | Severity |
|-------|-------------|----------|
| strict mode | tsconfig strict: true | Recommended |
| noImplicitAny | No implicit any | Recommended |
| Path aliases | Clean imports | Optional |

**Python:**
| Check | Description | Severity |
|-------|-------------|----------|
| Type hints | Functions have types | Recommended |
| pyproject.toml | Modern config | Recommended |
| Virtual env | .venv or poetry.lock | Critical |

**Go:**
| Check | Description | Severity |
|-------|-------------|----------|
| go.sum | Dependencies locked | Critical |
| Module name | Proper module path | Recommended |

---

## Scoring System

### Calculation

```
Score = (Passed / Total) * 100

Weighted by severity:
- Critical: 3 points
- Recommended: 2 points
- Optional: 1 point
```

### Score Interpretation

| Score  | Grade | Status          |
| ------ | ----- | --------------- |
| 90-100 | A     | Excellent       |
| 80-89  | B     | Good            |
| 70-79  | C     | Acceptable      |
| 60-69  | D     | Needs work      |
| < 60   | F     | Critical issues |

---

## Output Format

### Audit Report

```markdown
## Project Health Audit

**Date**: 2026-01-25
**Project**: my-project
**Score**: 72/100 (Grade: C)

---

### Summary

| Category       | Score | Status             |
| -------------- | ----- | ------------------ |
| Agentic-Boost  | 4/6   | ⚠️ Needs attention |
| Quality Gates  | 3/6   | ⚠️ Needs attention |
| Best Practices | 5/6   | ✅ Good            |
| Security       | 2/4   | ⚠️ Needs attention |
| Stack-Specific | 3/4   | ✅ Good            |

---

### Critical Issues (Must Fix)

| Issue                   | Location     | Fix                                    |
| ----------------------- | ------------ | -------------------------------------- |
| No linting configured   | project root | Invoke `setup-quality`                 |
| Missing tests directory | project root | Create tests/                          |
| .env committed to git   | .env         | Remove from history, add to .gitignore |

### Recommended Improvements

| Issue                      | Location      | Fix                        |
| -------------------------- | ------------- | -------------------------- |
| AGENTS.md in api/ missing  | api/          | Invoke `project-bootstrap` |
| Auto-invoke tables empty   | AGENTS.md     | Invoke `skill-sync`        |
| No pre-commit hooks        | project root  | Invoke `setup-quality`     |
| TypeScript strict disabled | tsconfig.json | Enable strict: true        |

### Optional Enhancements

| Issue             | Location     | Fix                 |
| ----------------- | ------------ | ------------------- |
| No CHANGELOG.md   | project root | Create CHANGELOG.md |
| No .editorconfig  | project root | Add .editorconfig   |
| No GGA configured | project root | Invoke `setup-gga`  |

---

### Recommended Actions

Based on this audit, I recommend:

1. **First** (Critical):
   - Invoke `setup-quality` to configure linting and formatting
   - Create tests directory and add initial tests

2. **Then** (Recommended):
   - Invoke `skill-sync` to update auto-invoke tables
   - Enable TypeScript strict mode

3. **Optional**:
   - Invoke `setup-gga` for AI code review
   - Add CHANGELOG.md for version tracking

Would you like me to address any of these issues?
```

---

## Integration with Other Skills

### Workflow

```
[best-practices-auditor]
    │
    ├─ INVOKES: project-analyzer (get baseline)
    │
    ├─ ANALYZES: against checklist
    │
    └─ RECOMMENDS skills to invoke:
        ├─ setup-quality (for linting/formatting)
        ├─ setup-gga (for AI code review)
        ├─ skill-sync (for AGENTS.md updates)
        ├─ project-bootstrap (for missing AGENTS.md)
        └─ git-conventional (for commit standards)
```

### Example Interaction

```
User: "What can I improve in this project?"

Agent:
[Invokes project-analyzer first]

"I've completed a best practices audit of your project.

**Score: 72/100 (Grade: C)**

**Critical Issues Found:**
1. No linting configured
2. Pre-commit hooks missing

**Recommended Improvements:**
1. AGENTS.md in api/ component is missing
2. Auto-invoke tables are empty

Would you like me to:
1. Set up quality gates (linting + hooks)?
2. Add missing AGENTS.md files?
3. Update auto-invoke tables?
4. All of the above?
"

User: "All of the above"

Agent:
[Invokes setup-quality]
[Invokes project-bootstrap for api/AGENTS.md]
[Invokes skill-sync]

"Done! Your project score is now 94/100 (Grade: A)"
```

---

## Customizing the Audit

### Focus Areas

User can request focused audits:

```
"Audit only quality gates"
→ Run only Quality Gates checklist

"Check security best practices"
→ Run only Security checklist

"Check TypeScript configuration"
→ Run only Stack-Specific (TypeScript) checklist
```

### Ignoring Checks

For legitimate exceptions:

```
# In .agentic-boost.yml
audit:
  ignore:
    - "LICENSE"           # Proprietary project
    - "CHANGELOG.md"      # Using GitHub releases instead
    - "editorconfig"      # Team uses IDE-specific settings
```

---

## Exit Codes (for CI)

If running in CI mode:

| Exit Code | Meaning                  |
| --------- | ------------------------ |
| 0         | All checks passed        |
| 1         | Critical issues found    |
| 2         | Recommended issues found |
| 3         | Analysis error           |

```bash
# CI usage example
npx agentic-boost audit --ci --fail-on=critical
```
