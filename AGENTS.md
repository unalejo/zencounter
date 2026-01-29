# Repository Guidelines

## How to Use This Guide

- Start here for cross-project norms and routing
- Skills provide on-demand detailed patterns
- Component AGENTS.md files provide domain-specific guidance

## Available Skills

Skills are located in `skills/` directory.

### Generic Skills

| Skill              | Description                 | URL                                                  |
| ------------------ | --------------------------- | ---------------------------------------------------- |
| `git-conventional` | Conventional commits format | [SKILL.md](skills/generic/git-conventional/SKILL.md) |

### Operational Skills

| Skill           | Description                      | URL                                           |
| --------------- | -------------------------------- | --------------------------------------------- |
| `skill-creator` | Create new AI agent skills       | [SKILL.md](skills/ops/skill-creator/SKILL.md) |
| `skill-sync`    | Sync skill metadata to AGENTS.md | [SKILL.md](skills/ops/skill-sync/SKILL.md)    |

### Setup Skills

| Skill                    | Description                                      | URL                                                      |
| ------------------------ | ------------------------------------------------ | -------------------------------------------------------- |
| `project-analyzer`       | Detect project state, stack, and structure       | [SKILL.md](skills/setup/project-analyzer/SKILL.md)       |
| `project-bootstrap`      | Scaffold project directories and AGENTS.md files | [SKILL.md](skills/setup/project-bootstrap/SKILL.md)      |
| `architecture-advisor`   | Recommend tech stacks based on requirements      | [SKILL.md](skills/setup/architecture-advisor/SKILL.md)   |
| `best-practices-auditor` | Audit projects against best practices            | [SKILL.md](skills/setup/best-practices-auditor/SKILL.md) |

### Quality & Standards Skills

| Skill                | Description                                    | URL                                                   |
| -------------------- | ---------------------------------------------- | ----------------------------------------------------- |
| `setup-quality`      | Orchestrates quality assurance setup           | [SKILL.md](skills/quality/setup-quality/SKILL.md)     |
| `quality-evolution`  | Researches modern quality tools with WebSearch | [SKILL.md](skills/quality/quality-evolution/SKILL.md) |
| `setup-gga`          | Installs and configures GGA AI code review     | [SKILL.md](skills/quality/tools/setup-gga/SKILL.md)   |
| `quality-javascript` | JavaScript/TypeScript linting & formatting     | [SKILL.md](skills/quality/stacks/javascript/SKILL.md) |
| `quality-python`     | Python linting & formatting with Ruff          | [SKILL.md](skills/quality/stacks/python/SKILL.md)     |

### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action                                                         | Skill                    |
| -------------------------------------------------------------- | ------------------------ |
| After creating/modifying a skill                               | `skill-sync`             |
| Analyzing project structure                                    | `project-analyzer`       |
| Auditing project health                                        | `best-practices-auditor` |
| Choosing technology stack                                      | `architecture-advisor`   |
| Configuring ESLint                                             | `quality-javascript`     |
| Configuring Ruff                                               | `quality-python`         |
| Configuring linters and formatters                             | `setup-quality`          |
| Creating git commits                                           | `git-conventional`       |
| Creating new project structure                                 | `project-bootstrap`      |
| Creating new skills                                            | `skill-creator`          |
| Detecting technology stack                                     | `project-analyzer`       |
| Enabling AI code review                                        | `setup-gga`              |
| Finding better linting alternatives                            | `quality-evolution`      |
| Initializing project with AI agents                            | `project-bootstrap`      |
| Initializing quality standards                                 | `setup-quality`          |
| Installing GGA                                                 | `setup-gga`              |
| Installing Prettier for JavaScript                             | `quality-javascript`     |
| Installing Python linters                                      | `quality-python`         |
| Planning project architecture                                  | `architecture-advisor`   |
| Processing requirements document                               | `architecture-advisor`   |
| Regenerate AGENTS.md Auto-invoke tables (sync.sh)              | `skill-sync`             |
| Researching modern quality tools                               | `quality-evolution`      |
| Scaffolding project directories                                | `project-bootstrap`      |
| Setting up JavaScript quality tools                            | `quality-javascript`     |
| Setting up Python quality tools                                | `quality-python`         |
| Setting up automated review gates                              | `setup-gga`              |
| Setting up code quality gates                                  | `setup-quality`          |
| Setting up empty project                                       | `project-bootstrap`      |
| Suggesting tech for new project                                | `architecture-advisor`   |
| Troubleshoot why a skill is missing from AGENTS.md auto-invoke | `skill-sync`             |
| Understanding what this project has                            | `project-analyzer`       |
| Updating quality standards                                     | `quality-evolution`      |
| What can I improve in this project                             | `best-practices-auditor` |
| What tech should I use                                         | `architecture-advisor`   |

---

## Philosophy

**Context is expensive. Use Filesystem-based Agents.**

Traditional documentation is passive. Agentic-Boost is active—AI agents automatically load relevant knowledge when performing tasks.

1. **Skills** = Focused knowledge modules (SKILL.md files)
2. **AGENTS.md** = Routing documents with auto-invoke tables
3. **Auto-discovery** = Works with any project structure
4. **Multi-IDE** = Claude Code, Gemini CLI, Codex, GitHub Copilot

---

## Conventional Commits

Follow conventional-commit style (see `git-conventional` skill):

```
type(scope): concise description

- Key change 1
- Key change 2
```

**Types:** feat, fix, docs, chore, refactor, test, perf

---

## Project Structure

Single application - cognitive training for Hi-Lo card counting:

```
zencounter/
├── src/
│   ├── components/    # React components (Card, Deck, Counter, Settings)
│   ├── hooks/         # Custom hooks (useGameState, useTimer)
│   ├── lib/           # Game logic (deck, Hi-Lo system)
│   ├── pages/         # Page components (Home, Training, About)
│   └── types/         # TypeScript type definitions
├── public/
│   └── cards/         # Card SVG assets
├── tests/             # Unit and integration tests
├── skills/            # Agentic-Boost skills
└── .github/workflows/ # CI/CD for GitHub Pages
```

## Tech Stack

| Category   | Technology    |
| ---------- | ------------- |
| Language   | TypeScript    |
| Framework  | React 18      |
| Build      | Vite          |
| Styling    | Tailwind CSS  |
| State      | Zustand       |
| Animations | Framer Motion |
| Testing    | Vitest        |
| Deploy     | GitHub Pages  |

## Development

```bash
yarn install     # Install dependencies
yarn dev         # Start dev server
yarn build       # Build for production
yarn test        # Run tests
yarn lint        # Check linting
```
