#!/bin/bash

# Journal OCTO Explore Script
# Returns available OCTO folders for a given project

set -e

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Parse arguments
PROJECT="${1:-}"

# Validate input
if [ -z "$PROJECT" ]; then
    echo "ERROR: Project name is required"
    exit 1
fi

# Construct paths
VAULT_PATH="$OBSIDIAN_VAULT_PATH"
PROJECTS_PATH="$VAULT_PATH/$JOURNAL_PROJECTS_FOLDER"
PROJECT_PATH="$PROJECTS_PATH/$PROJECT"

# Check if project directory exists
if [ ! -d "$PROJECT_PATH" ]; then
    echo "ERROR: Project directory not found: $PROJECT_PATH"
    exit 1
fi

# List OCTO folders sorted by modification date (newest first)
# Only directories starting with "OCTO-"
ls -1t "$PROJECT_PATH" | grep "^OCTO-" || echo "NO_OCTO_FOLDERS"