#!/usr/bin/env bash
# Project type detection for quality setup
# Returns: javascript, typescript, python, go, rust, monorepo, unknown

set -e

PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT"

declare -a DETECTED_TYPES=()

# TypeScript detection (must check both package.json and tsconfig.json)
if [[ -f "tsconfig.json" ]] && [[ -f "package.json" ]]; then
  DETECTED_TYPES+=("typescript")
fi

# JavaScript detection (if not TypeScript)
if [[ -f "package.json" ]] && [[ ! " ${DETECTED_TYPES[@]} " =~ "typescript" ]]; then
  DETECTED_TYPES+=("javascript")
fi

# Python detection (pyproject.toml is modern, requirements.txt is classic)
if [[ -f "pyproject.toml" ]]; then
  DETECTED_TYPES+=("python")
elif [[ -f "requirements.txt" ]]; then
  DETECTED_TYPES+=("python")
fi

# Go detection
if [[ -f "go.mod" ]]; then
  DETECTED_TYPES+=("go")
fi

# Rust detection
if [[ -f "Cargo.toml" ]]; then
  DETECTED_TYPES+=("rust")
fi

# Determine output based on number of detected types
case ${#DETECTED_TYPES[@]} in
  0)
    # No recognized project files
    echo "unknown"
    exit 0
    ;;
  1)
    # Single project type detected
    echo "${DETECTED_TYPES[0]}"
    exit 0
    ;;
  *)
    # Multiple types detected - likely monorepo
    echo "monorepo"
    >&2 echo "Multiple types detected: ${DETECTED_TYPES[*]}"
    exit 0
    ;;
esac
