#!/bin/bash

# Journal Projects Explore Script
# Returns available projects sorted by modification date

set -e

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Construct paths
VAULT_PATH="$OBSIDIAN_VAULT_PATH"
PROJECTS_PATH="$VAULT_PATH/$JOURNAL_PROJECTS_FOLDER"

# Check if projects directory exists
if [ ! -d "$PROJECTS_PATH" ]; then
    echo "ERROR: Projects directory not found: $PROJECTS_PATH"
    exit 1
fi

# List projects sorted by modification date (newest first)
# Output format: one project per line
ls -1t "$PROJECTS_PATH"