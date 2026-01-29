---
name: skill-sync
description: >
  Syncs skill metadata to AGENTS.md Auto-invoke sections.
  Trigger: When updating skill metadata (metadata.scope/metadata.auto_invoke), regenerating Auto-invoke tables, or running ./skills/ops/skill-sync/assets/sync.sh (including --dry-run/--scope).
license: Apache-2.0
metadata:
  author: agentic-boost
  version: '1.0'
  scope: [root]
  auto_invoke:
    - 'After creating/modifying a skill'
    - 'Regenerate AGENTS.md Auto-invoke tables (sync.sh)'
    - 'Troubleshoot why a skill is missing from AGENTS.md auto-invoke'
allowed-tools: [Read, Edit, Write, Glob, Grep, Bash]
---

## Purpose

Keeps AGENTS.md Auto-invoke sections in sync with skill metadata. When you create or modify a skill, run the sync script to automatically update all affected AGENTS.md files.

## How Scopes Are Discovered

Scopes are automatically derived from directory structure:

- **Root AGENTS.md**: `scope: [root]`
- **Component AGENTS.md**: `scope: [{directory_name}]`
- **Nested directories**: Slashes become underscores

### Auto-Discovery Examples

| AGENTS.md Location                 | Discovered Scope |
| ---------------------------------- | ---------------- |
| `/project/AGENTS.md`               | `root`           |
| `/project/api/AGENTS.md`           | `api`            |
| `/project/ui/AGENTS.md`            | `ui`             |
| `/project/packages/sdk/AGENTS.md`  | `packages_sdk`   |
| `/project/services/auth/AGENTS.md` | `services_auth`  |

The sync script automatically finds all AGENTS.md files (except those in `node_modules/`, `.git/`, and `skills/` directories) and creates the scope mapping.

## Required Skill Metadata

Each skill that should appear in Auto-invoke sections needs these fields in `metadata`.

`auto_invoke` can be either a single string **or** a list of actions:

```yaml
metadata:
  author: your-name-or-org
  version: '1.0'
  scope: [api] # Which AGENTS.md files to update

  # Option A: single action
  auto_invoke: 'Creating API endpoints'

  # Option B: multiple actions
  # auto_invoke:
  #   - "Creating API endpoints"
  #   - "Refactoring API routes"
```

### Scope Values

Skills declare which AGENTS.md files they apply to. The scope name must match the directory name:

| Example Scope  | Updates                   |
| -------------- | ------------------------- |
| `root`         | `/AGENTS.md` (repo root)  |
| `api`          | `/api/AGENTS.md`          |
| `ui`           | `/ui/AGENTS.md`           |
| `packages_sdk` | `/packages/sdk/AGENTS.md` |

Skills can have multiple scopes: `scope: [api, ui, root]`

---

## Usage

### After Creating/Modifying a Skill

```bash
./skills/ops/skill-sync/assets/sync.sh
```

### What It Does

1. Auto-discovers all AGENTS.md files in the repository
2. Reads all `skills/*/SKILL.md` files
3. Extracts `metadata.scope` and `metadata.auto_invoke`
4. Generates Auto-invoke tables for each AGENTS.md
5. Updates the `### Auto-invoke Skills` section in each file

---

## Example

Given this skill metadata in `/skills/api-endpoints/SKILL.md`:

```yaml
metadata:
  author: myteam
  version: '1.0'
  scope: [api]
  auto_invoke: 'Creating API endpoints'
```

The sync script generates in `/api/AGENTS.md`:

```markdown
### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action                 | Skill           |
| ---------------------- | --------------- |
| Creating API endpoints | `api-endpoints` |
```

---

## Commands

```bash
# Sync all AGENTS.md files
./skills/ops/skill-sync/assets/sync.sh

# Dry run (show what would change)
./skills/ops/skill-sync/assets/sync.sh --dry-run

# Sync specific scope only
./skills/ops/skill-sync/assets/sync.sh --scope api
```

---

## Troubleshooting

### Skill not appearing in Auto-invoke table

**Cause:** Missing `metadata.scope` or `metadata.auto_invoke`

**Fix:** Add these to your skill's frontmatter:

```yaml
metadata:
  scope: [root]
  auto_invoke: 'When to use this skill'
```

### Wrong scope name

**Cause:** Scope doesn't match AGENTS.md location

**Fix:** Check the auto-discovery table above to match your AGENTS.md location

### Auto-discovery not finding your AGENTS.md

**Cause:** File is in `node_modules/`, `.git/`, or `skills/` directory

**Fix:** Move AGENTS.md to a component directory (e.g., `/api/AGENTS.md`)

---

## Checklist After Modifying Skills

- [ ] Added `metadata.scope` to new/modified skill
- [ ] Added `metadata.auto_invoke` with action description
- [ ] Ran `./skills/ops/skill-sync/assets/sync.sh`
- [ ] Verified AGENTS.md files updated correctly
