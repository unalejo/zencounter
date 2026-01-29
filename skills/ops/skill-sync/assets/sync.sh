#!/usr/bin/env bash
# Sync skill metadata to AGENTS.md Auto-invoke sections
# Usage: ./sync.sh [--dry-run] [--scope <scope>]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Options
DRY_RUN=false
FILTER_SCOPE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --scope)
            FILTER_SCOPE="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--dry-run] [--scope <scope>]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Show what would change without modifying files"
            echo "  --scope      Only sync specific scope (auto-discovered from directory structure)"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Auto-discover AGENTS.md files and build scope mapping
declare -A SCOPE_TO_PATH

find_and_map_agents() {
    local agents_files
    agents_files=$(find "$REPO_ROOT" -name "AGENTS.md" \
        -not -path "*/node_modules/*" \
        -not -path "*/.git/*" \
        -not -path "*/skills/*" \
        -print | sort)

    while IFS= read -r agents_file; do
        [ -f "$agents_file" ] || continue

        local agents_dir=$(dirname "$agents_file")
        local scope

        # Root AGENTS.md → scope: "root"
        if [ "$agents_dir" = "$REPO_ROOT" ]; then
            scope="root"
        else
            # Component AGENTS.md → derive scope from path
            # Example: /repo/api/AGENTS.md → scope: "api"
            # Example: /repo/packages/sdk/AGENTS.md → scope: "packages_sdk"
            local relative_path="${agents_dir#$REPO_ROOT/}"
            scope=$(echo "$relative_path" | tr '/' '_')
        fi

        SCOPE_TO_PATH[$scope]="$agents_file"
    done <<< "$agents_files"
}

# Call discovery on startup
find_and_map_agents

# Get AGENTS.md path for a scope
get_agents_path() {
    local scope="$1"
    echo "${SCOPE_TO_PATH[$scope]}"
}

# Extract YAML frontmatter field using awk
extract_field() {
    local file="$1"
    local field="$2"
    awk -v field="$field" '
        /^---$/ { in_frontmatter = !in_frontmatter; next }
        in_frontmatter && $1 == field":" {
            # Handle single line value
            sub(/^[^:]+:[[:space:]]*/, "")
            if ($0 != "" && $0 != ">") {
                gsub(/^["'\'']|["'\'']$/, "")  # Remove quotes
                print
                exit
            }
            # Handle multi-line value
            getline
            while (/^[[:space:]]/ && !/^---$/) {
                sub(/^[[:space:]]+/, "")
                printf "%s ", $0
                if (!getline) break
            }
            print ""
            exit
        }
    ' "$file" | sed 's/[[:space:]]*$//'
}

# Extract nested metadata field
#
# Supports either:
#   auto_invoke: "Single Action"
# or:
#   auto_invoke:
#     - "Action A"
#     - "Action B"
#
# For list values, this returns a pipe-delimited string: "Action A|Action B"
extract_metadata() {
    local file="$1"
    local field="$2"

    awk -v field="$field" '
        function trim(s) {
            sub(/^[[:space:]]+/, "", s)
            sub(/[[:space:]]+$/, "", s)
            return s
        }

        /^---$/ { in_frontmatter = !in_frontmatter; next }

        in_frontmatter && /^metadata:/ { in_metadata = 1; next }
        in_frontmatter && in_metadata && /^[a-z]/ && !/^[[:space:]]/ { in_metadata = 0 }

        in_frontmatter && in_metadata && $1 == field":" {
            # Remove "field:" prefix
            sub(/^[^:]+:[[:space:]]*/, "")

            # Single-line scalar: auto_invoke: "Action"
            if ($0 != "") {
                v = $0
                gsub(/^["'\'']|["'\'']$/, "", v)
                gsub(/^\[|\]$/, "", v)  # legacy: allow inline [a, b]
                print trim(v)
                exit
            }

            # Multi-line list:
            # auto_invoke:
            #   - "Action A"
            #   - "Action B"
            out = ""
            while (getline) {
                # Stop when leaving metadata block
                if (!in_frontmatter) break
                if (!in_metadata) break
                if ($0 ~ /^[a-z]/ && $0 !~ /^[[:space:]]/) break

                # On multi-line list, only accept "- item" lines. Anything else ends the list.
                line = $0
                # Stop at frontmatter delimiter (getline bypasses pattern matching)
                if (line ~ /^---$/) break
                if (line ~ /^[[:space:]]*-[[:space:]]*/) {
                    sub(/^[[:space:]]*-[[:space:]]*/, "", line)
                    line = trim(line)
                    gsub(/^["'\'']|["'\'']$/, "", line)
                    if (line != "") {
                        if (out == "") out = line
                        else out = out "|" line
                    }
                } else {
                    break
                }
            }

            if (out != "") print out
            exit
        }
    ' "$file"
}

echo -e "${BLUE}Skill Sync - Updating AGENTS.md Auto-invoke sections${NC}"
echo "========================================================"
echo ""

# Collect skills by scope
declare -A SCOPE_SKILLS  # scope -> "skill1:action1|skill2:action2|..."

# Deterministic iteration order (stable diffs)
# Note: macOS ships BSD find; avoid GNU-only flags.
while IFS= read -r skill_file; do
    [ -f "$skill_file" ] || continue

    skill_name=$(extract_field "$skill_file" "name")
    scope_raw=$(extract_metadata "$skill_file" "scope")

    auto_invoke_raw=$(extract_metadata "$skill_file" "auto_invoke")
    # extract_metadata() returns:
    # - single action: "Action"
    # - multiple actions: "Action A|Action B" (pipe-delimited)
    # But SCOPE_SKILLS also uses '|' to separate entries, so we protect it.
    auto_invoke=${auto_invoke_raw//|/;;}

    # Skip if no scope or auto_invoke defined
    [ -z "$scope_raw" ] || [ -z "$auto_invoke" ] && continue

    # Parse scope (can be comma-separated or space-separated)
    IFS=', ' read -ra scopes <<< "$scope_raw"

    for scope in "${scopes[@]}"; do
        scope=$(echo "$scope" | tr -d '[:space:]')
        [ -z "$scope" ] && continue

        # Filter by scope if specified
        [ -n "$FILTER_SCOPE" ] && [ "$scope" != "$FILTER_SCOPE" ] && continue

        # Append to scope's skill list
        if [ -z "${SCOPE_SKILLS[$scope]}" ]; then
            SCOPE_SKILLS[$scope]="$skill_name:$auto_invoke"
        else
            SCOPE_SKILLS[$scope]="${SCOPE_SKILLS[$scope]}|$skill_name:$auto_invoke"
        fi
    done
done < <(find "$SKILLS_DIR" -name SKILL.md -not -path "*/assets/*" -print | sort)

# Generate Auto-invoke section for each scope
# Deterministic scope order (stable diffs)
scopes_sorted=()
while IFS= read -r scope; do
    scopes_sorted+=("$scope")
done < <(printf "%s\n" "${!SCOPE_SKILLS[@]}" | sort)

for scope in "${scopes_sorted[@]}"; do
    # Skip empty scopes
    [ -z "$scope" ] && continue

    agents_path=$(get_agents_path "$scope")

    if [ -z "$agents_path" ] || [ ! -f "$agents_path" ]; then
        echo -e "${YELLOW}Warning: No AGENTS.md found for scope '$scope'${NC}"
        continue
    fi

    echo -e "${BLUE}Processing: $scope -> $(basename "$(dirname "$agents_path")")/AGENTS.md${NC}"

    # Build the Auto-invoke table
    auto_invoke_section="### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|"

    # Expand into sortable rows: "action<TAB>skill"
    rows=()

    IFS='|' read -ra skill_entries <<< "${SCOPE_SKILLS[$scope]}"
    for entry in "${skill_entries[@]}"; do
        skill_name="${entry%%:*}"
        actions_raw="${entry#*:}"

        actions_raw=${actions_raw//;;/|}
        IFS='|' read -ra actions <<< "$actions_raw"
        for action in "${actions[@]}"; do
            action="$(echo "$action" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
            [ -z "$action" ] && continue
            rows+=("$action	$skill_name")
        done
    done

    # Deterministic row order: Action then Skill
    while IFS=$'\t' read -r action skill_name; do
        [ -z "$action" ] && continue
        auto_invoke_section="$auto_invoke_section
| $action | \`$skill_name\` |"
    done < <(printf "%s\n" "${rows[@]}" | LC_ALL=C sort -t $'\t' -k1,1 -k2,2)

    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY RUN] Would update $agents_path with:${NC}"
        echo "$auto_invoke_section"
        echo ""
    else
        # Write new section to temp file (avoids awk multi-line string issues on macOS)
        section_file=$(mktemp)
        echo "$auto_invoke_section" > "$section_file"

        # Check if Auto-invoke section exists
        if grep -q "### Auto-invoke Skills" "$agents_path"; then
            # Replace existing section (up to next --- or ## heading)
            awk '
                /^### Auto-invoke Skills/ {
                    while ((getline line < "'"$section_file"'") > 0) print line
                    close("'"$section_file"'")
                    skip = 1
                    next
                }
                skip && /^(---|## )/ {
                    skip = 0
                    print ""
                }
                !skip { print }
            ' "$agents_path" > "$agents_path.tmp"
            mv "$agents_path.tmp" "$agents_path"
            echo -e "${GREEN}  ✓ Updated Auto-invoke section${NC}"
        else
            # Insert after Skills Reference blockquote
            awk '
                /^>.*SKILL\.md\)$/ && !inserted {
                    print
                    getline
                    if (/^$/) {
                        print ""
                        while ((getline line < "'"$section_file"'") > 0) print line
                        close("'"$section_file"'")
                        print ""
                        inserted = 1
                        next
                    }
                }
                { print }
            ' "$agents_path" > "$agents_path.tmp"
            mv "$agents_path.tmp" "$agents_path"
            echo -e "${GREEN}  ✓ Inserted Auto-invoke section${NC}"
        fi

        rm -f "$section_file"
    fi
done

echo ""
echo -e "${GREEN}Done!${NC}"

# Show skills without metadata
echo ""
echo -e "${BLUE}Skills missing sync metadata:${NC}"
missing=0
while IFS= read -r skill_file; do
    [ -f "$skill_file" ] || continue
    skill_name=$(extract_field "$skill_file" "name")
    scope_raw=$(extract_metadata "$skill_file" "scope")
    auto_invoke_raw=$(extract_metadata "$skill_file" "auto_invoke")
    auto_invoke=${auto_invoke_raw//|/;;}

    if [ -z "$scope_raw" ] || [ -z "$auto_invoke" ]; then
        echo -e "  ${YELLOW}$skill_name${NC} - missing: ${scope_raw:+}${scope_raw:-scope} ${auto_invoke:+}${auto_invoke:-auto_invoke}"
        missing=$((missing + 1))
    fi
done < <(find "$SKILLS_DIR" -name SKILL.md -not -path "*/assets/*" -print | sort)

if [ $missing -eq 0 ]; then
    echo -e "  ${GREEN}All skills have sync metadata${NC}"
fi

# Generate skills/README.md
generate_skills_readme() {
    local readme_file="$SKILLS_DIR/README.md"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo ""
    echo -e "${BLUE}Generating skills/README.md${NC}"

    # Collect skills by category
    declare -A CATEGORY_SKILLS
    local total_skills=0

    while IFS= read -r skill_file; do
        [ -f "$skill_file" ] || continue

        local skill_name=$(extract_field "$skill_file" "name")
        local description=$(extract_field "$skill_file" "description")
        # Clean description: first line only, remove "Trigger:" part
        description=$(echo "$description" | sed 's/Trigger:.*//; s/[[:space:]]*$//')

        # Extract category from path: skills/{category}/...
        local relative_path="${skill_file#$SKILLS_DIR/}"
        local category=$(echo "$relative_path" | cut -d'/' -f1)

        # Append to category (use newline as separator)
        if [ -z "${CATEGORY_SKILLS[$category]}" ]; then
            CATEGORY_SKILLS[$category]="$skill_name|$description"
        else
            CATEGORY_SKILLS[$category]="${CATEGORY_SKILLS[$category]}"$'\n'"$skill_name|$description"
        fi

        total_skills=$((total_skills + 1))
    done < <(find "$SKILLS_DIR" -name SKILL.md -not -path "*/assets/*" -print | sort)

    if $DRY_RUN; then
        echo -e "${YELLOW}[DRY RUN] Would generate skills/README.md with $total_skills skills${NC}"
        return
    fi

    # Generate README header
    cat > "$readme_file" << EOF
# Skills Directory

> Auto-generated by sync.sh. Do not edit manually.

This directory contains **$total_skills AI agent skills** organized by category.

## Available Skills

EOF

    # Output categories in specific order
    for category in generic ops setup quality; do
        [ -z "${CATEGORY_SKILLS[$category]}" ] && continue

        # Count skills in category
        local count=$(echo "${CATEGORY_SKILLS[$category]}" | grep -c '|')

        # Category header with capitalized name
        local category_title
        case $category in
            generic) category_title="Generic" ;;
            ops) category_title="Operational" ;;
            setup) category_title="Setup" ;;
            quality) category_title="Quality" ;;
            *) category_title="$category" ;;
        esac

        echo "### $category_title ($count)" >> "$readme_file"
        echo "" >> "$readme_file"
        echo "| Skill | Description |" >> "$readme_file"
        echo "|-------|-------------|" >> "$readme_file"

        # Output skills sorted by name
        while IFS='|' read -r skill_name description; do
            [ -z "$skill_name" ] && continue
            echo "| \`$skill_name\` | $description |" >> "$readme_file"
        done <<< "$(echo "${CATEGORY_SKILLS[$category]}" | sort)"

        echo "" >> "$readme_file"
    done

    # Add structure and footer
    cat >> "$readme_file" << 'EOF'
## Structure

```
skills/
├── generic/
│   └── git-conventional/
├── ops/
│   ├── skill-creator/
│   └── skill-sync/
├── quality/
│   ├── setup-quality/
│   ├── quality-evolution/
│   ├── stacks/
│   │   ├── javascript/
│   │   └── python/
│   └── tools/
│       └── setup-gga/
└── setup/
    ├── project-analyzer/
    ├── project-bootstrap/
    ├── architecture-advisor/
    └── best-practices-auditor/
```

## Creating New Skills

See [skill-creator](ops/skill-creator/SKILL.md) for instructions.

After creating or modifying a skill:
```bash
./skills/ops/skill-sync/assets/sync.sh
```
EOF

    echo "" >> "$readme_file"
    echo "---" >> "$readme_file"
    echo "" >> "$readme_file"
    echo "*Last updated: $timestamp*" >> "$readme_file"

    echo -e "${GREEN}  ✓ Generated skills/README.md ($total_skills skills)${NC}"
}

# Call the function
generate_skills_readme
