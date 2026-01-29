---
name: project-bootstrap
description: >
  Scaffolds project directories, AGENTS.md files, and configuration.
  Trigger: When creating new project, scaffolding directories, setting up project structure.
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'Creating new project structure'
    - 'Scaffolding project directories'
    - 'Setting up empty project'
    - 'Initializing project with AI agents'
allowed-tools: [Write, Read, Glob, Bash]
---

## Purpose

Scaffolds project structure based on specifications. **Only executes, does not decide.**
Expects decisions to already be made (by user or architecture-advisor skill).

## When to Use

- Creating structure for a new project
- Adding components to existing project
- After architecture decisions are made
- When user says "create the project structure"

## When NOT to Use

- If user hasn't decided on project type yet (use architecture-advisor)
- If user wants recommendations (use architecture-advisor)
- For analyzing existing projects (use project-analyzer)

---

## Required Input

Before scaffolding, you MUST gather these decisions:

### 1. Project Type (required)

- `single-app` - Simple application with src/ at root
- `multi-component` - Multiple components (api, ui, cli, sdk)
- `monorepo` - Workspace with packages/, services/, apps/

### 2. Components (if multi-component or monorepo)

For multi-component:

- api, ui, cli, sdk, or custom names

For monorepo:

- services/ (api, worker, etc.)
- packages/ (sdk, shared, utils)
- apps/ (web, mobile, desktop)

### 3. Project Name (optional)

Defaults to current directory name.

### 4. Tech Stack (optional)

For README documentation only.

---

## Scaffolding Rules

### CRITICAL: Never Overwrite

```
BEFORE writing ANY file:
1. Check if file already exists
2. If exists → ASK user: "File X exists. Overwrite? (y/n)"
3. If user says no → Skip that file
4. If user says yes → Backup to .bak then write
```

### Directory Creation

Create directories with `.gitkeep` if empty:

```bash
mkdir -p component/src
touch component/src/.gitkeep
```

---

## Structure Templates

### Single-App Structure

```
project/
├── AGENTS.md           # Root routing guide
├── src/                # Application source
│   └── .gitkeep
├── README.md           # Project documentation
└── .agentic-boost.yml  # Project metadata
```

### Multi-Component Structure

```
project/
├── AGENTS.md           # Root routing guide
├── {component}/        # For each component
│   ├── AGENTS.md       # Component-specific guide
│   └── src/
│       └── .gitkeep
├── README.md
└── .agentic-boost.yml
```

**Example with api, ui:**

```
project/
├── AGENTS.md
├── api/
│   ├── AGENTS.md
│   └── src/
├── ui/
│   ├── AGENTS.md
│   └── src/
├── README.md
└── .agentic-boost.yml
```

### Monorepo Structure

```
workspace/
├── AGENTS.md           # Root routing guide
├── services/           # Backend services
│   └── {service}/
│       ├── AGENTS.md
│       └── src/
├── packages/           # Shared packages/libraries
│   └── {package}/
│       ├── AGENTS.md
│       └── src/
├── apps/               # Frontend applications
│   └── {app}/
│       ├── AGENTS.md
│       └── src/
├── README.md
└── .agentic-boost.yml
```

**Example with services/api, packages/sdk, apps/web:**

```
workspace/
├── AGENTS.md
├── services/
│   └── api/
│       ├── AGENTS.md
│       └── src/
├── packages/
│   └── sdk/
│       ├── AGENTS.md
│       └── src/
├── apps/
│   └── web/
│       ├── AGENTS.md
│       └── src/
├── README.md
└── .agentic-boost.yml
```

---

## File Templates

### Root AGENTS.md

```markdown
# Repository Guidelines

## How to Use This Guide

- Start here for cross-project norms and routing
- Skills provide on-demand detailed patterns
- Component AGENTS.md files provide domain-specific guidance

## Available Skills

Skills are located in `skills/` directory.

(Run skill-sync to populate this section)

## Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
| ------ | ----- |

(Run skill-sync to populate this table)

---

## Structure

{STRUCTURE_DESCRIPTION}
```

**Structure descriptions:**

For single-app:

```
Single application:
- All code in root-level `src/` directory
- Shared skills in `skills/`
- One AGENTS.md (this file)
```

For multi-component:

```
Multiple components:
- Each component has its own AGENTS.md
- Components: {COMPONENT_LIST}
- Shared skills in root-level `skills/`
```

For monorepo:

```
Monorepo workspace:
- Services: {SERVICES_LIST}
- Packages: {PACKAGES_LIST}
- Apps: {APPS_LIST}
- Shared skills in root-level `skills/`
```

### Component AGENTS.md

```markdown
# {COMPONENT_NAME}

## Purpose

Guidelines for {COMPONENT_NAME} development.

## Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
| ------ | ----- |

(Run skill-sync to populate this table)

---

## Component Structure
```

{COMPONENT_NAME}/
├── AGENTS.md
├── src/
└── README.md

```

```

### README.md

````markdown
# {PROJECT_NAME}

AI-agent-enabled project with Agentic-Boost.

## Getting Started

1. **Configure IDE** (if not done):
   ```bash
   ./skills/setup/setup.sh
   ```
````

2. **Available Skills**: See [AGENTS.md](AGENTS.md) for available skills

3. **Create new skills**: Ask your AI agent to invoke `skill-creator`

## Structure

{STRUCTURE_TREE}

## Technologies

{TECH_STACK}

## Documentation

See [AGENTS.md](AGENTS.md) for AI agent patterns and conventions.

````

### .agentic-boost.yml

```yaml
# Agentic-Boost Configuration
project_name: "{PROJECT_NAME}"
project_type: "{PROJECT_TYPE}"
created_at: "{TIMESTAMP}"
tech_stack: "{TECH_STACK}"
components:
  {COMPONENTS_LIST_YAML}
````

---

## Execution Workflow

```
1. GATHER INPUT
   ├─ Project type: single-app | multi-component | monorepo
   ├─ Components (if applicable)
   ├─ Project name (default: directory name)
   └─ Tech stack (optional, for docs)

2. CHECK FOR CONFLICTS
   ├─ Does AGENTS.md exist?
   ├─ Do component directories exist?
   └─ Ask user about conflicts

3. CREATE STRUCTURE
   ├─ Create component directories
   ├─ Create src/ subdirectories
   └─ Add .gitkeep to empty dirs

4. CREATE FILES
   ├─ Write root AGENTS.md (or update Structure section)
   ├─ Write component AGENTS.md files
   ├─ Write README.md (if not exists)
   └─ Write .agentic-boost.yml

5. POST-SCAFFOLDING
   ├─ Invoke `skill-sync` to populate auto-invoke tables
   └─ Suggest next steps to user
```

---

## Post-Scaffolding Actions

After creating the structure:

### 1. ALWAYS Invoke skill-sync

```
The auto-invoke tables in AGENTS.md files are empty placeholders.
You MUST invoke the `skill-sync` skill to populate them.
```

### 2. Suggest Next Steps to User

```markdown
## Project Scaffolded Successfully!

**Created:**

- Root AGENTS.md with structure section
- Component AGENTS.md files: api/, ui/
- README.md with getting started guide
- .agentic-boost.yml configuration

**Next Steps:**

1. **Configure IDE** (recommended):
   Ask me to "configure IDE" or run `./skills/setup/setup.sh`

2. **Set up quality gates** (optional):
   Ask me to "set up quality gates" to configure linting and formatting

3. **Start coding!**
   Your project is ready for development.
```

---

## Example Interaction

**User**: "Create a multi-component project with api and ui components"

**Agent Response**:

```
I'll create a multi-component project structure.

**Configuration:**
- Type: multi-component
- Components: api, ui
- Project name: {current directory name}

Creating structure...

✓ Created api/AGENTS.md
✓ Created api/src/
✓ Created ui/AGENTS.md
✓ Created ui/src/
✓ Updated AGENTS.md (added Structure section)
✓ Created README.md
✓ Created .agentic-boost.yml

Now invoking skill-sync to populate auto-invoke tables...

✓ Auto-invoke tables updated

**Your project is ready!**

Next steps:
1. Configure your IDE: ask me to "configure IDE"
2. Optional: Set up quality gates for linting/formatting
```

---

## Error Handling

### File Already Exists

```
⚠️ File already exists: AGENTS.md

Options:
1. Skip this file (keep existing)
2. Merge Structure section only
3. Overwrite (backup created)

What would you like to do?
```

### Directory Already Has Content

```
⚠️ Directory api/ already exists with content.

Options:
1. Add AGENTS.md only (keep existing files)
2. Skip this component entirely
3. Overwrite (backup created)

What would you like to do?
```

### Skills Directory Missing

```
⚠️ skills/ directory not found.

This project doesn't have agentic-boost installed.
Please run the installer first:

curl -sSL https://raw.githubusercontent.com/unalejo/agentic-boost/main/install.sh | bash

Then try again.
```
