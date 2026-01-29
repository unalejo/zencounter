---
name: quality-evolution
description: >
  Researches modern quality tools using WebSearch and updates stack skill files with SOTA tools.
  Trigger: When researching modern linting/formatting tools, updating quality standards, finding better alternatives.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Researching modern quality tools'
    - 'Updating quality standards'
    - 'Finding better linting alternatives'
allowed-tools: [WebSearch, Read, Write, Edit, Bash]
---

## When to Use

Use this skill when:

- Researching state-of-the-art linting and formatting tools
- Evaluating alternatives to existing tools
- Keeping quality standards current with industry best practices
- Finding tools with better performance or features
- Comparing tools based on community adoption

## How It Works

The quality evolution skill conducts research and safely proposes improvements:

1. **Research Phase** - Uses WebSearch to find modern tools:
   - ESLint alternatives with performance comparisons
   - Ruff alternatives for Python linting
   - Formatting tool innovations
   - Community adoption metrics

2. **Evaluation Phase** - Validates candidates against criteria:
   - 2x+ performance improvement over current tool
   - Active development (commits within 90 days)
   - Community adoption (10k+ GitHub stars or 500k+ weekly downloads)
   - Maturity check (tools <6 months old excluded)

3. **Proposal Phase** - If better tool found:
   - Backs up original: `SKILL.md.bak` (preserves original)
   - Generates proposed new SKILL.md with new tool
   - **Shows unified diff** of changes to user
   - **Requests explicit confirmation** before applying
   - Generates detailed evolution report with reasoning

4. **Implementation Phase** - If user approves:
   - Writes new SKILL.md with updated tool
   - Preserves `.bak` file for rollback
   - Creates evolution report in assets/

## Critical Patterns

### Pattern 1: Web-Based Research

Uses WebSearch to find current industry standards:

- Queries include year (2026) for current information
- Searches for performance comparisons
- Tracks community adoption metrics

### Pattern 2: Safety Gates

**Never rewrites without explicit user approval:**

- Always show diff before applying changes
- Require user confirmation (never auto-apply)
- Backup original to `.bak` file
- Provide rollback instructions

### Pattern 3: Detailed Decision Making

Documents all research and reasoning:

- Tool comparison metrics
- Performance improvements
- Community adoption data
- Maturity assessment
- Risk evaluation

## Decision Criteria

Tools are evaluated against these metrics:

| Criterion   | Threshold                            | Reason                 |
| ----------- | ------------------------------------ | ---------------------- |
| Performance | 2x faster                            | Meaningful improvement |
| Maturity    | >6 months old                        | Proven stability       |
| Community   | 10k+ stars OR 500k+ weekly downloads | Adoption signal        |
| Activity    | Commits within 90 days               | Active development     |

## Output Files

### evolution-report.md

Detailed report generated in `skills/quality/quality-evolution/assets/`:

- Research queries used
- Tools evaluated
- Performance comparisons
- Adoption metrics
- Decision reasoning
- Rollback instructions

## Safety Features

- **Backup Preservation**: `.bak` files never deleted
- **Diff Review**: Unified diff shown before applying
- **Explicit Confirmation**: Required before any file writes
- **Rollback Support**: One-command restoration: `mv SKILL.md.bak SKILL.md`
- **Maturity Checking**: Tools <6 months old excluded
- **Change Tracking**: Full changelog in evolution report

## Commands

```bash
# Research is typically invoked by setup-quality orchestrator
# with user consent during interactive interview

# Manual research (if needed)
# The AI agent would run appropriate WebSearch queries and
# generate proposals with diff comparison
```

## Example Evolution Report

Evolution reports document:

- Date of research
- Tools evaluated
- Performance data
- Community metrics
- Final recommendation
- Implementation date
- Rollback timestamp

This enables:

- Audit trail of quality tool decisions
- Historical tool evolution tracking
- Informed rollback if needed

## Resources

- **ESLint**: https://eslint.org/
- **Ruff**: https://docs.astral.sh/ruff/
- **Prettier**: https://prettier.io/
- **pre-commit**: https://pre-commit.com/
- **GitHub Trending**: https://github.com/trending
- **npmjs.com Statistics**: Package adoption metrics
