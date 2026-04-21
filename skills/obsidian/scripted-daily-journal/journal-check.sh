#!/bin/bash

# Journal Check Script
# Checks if journal entry exists for given date, creates with template if needed

set -e

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Parse arguments
DATE="${1:-$(date +"$DATE_FORMAT")}"
FORCE_CREATE="${2:-false}"

# Construct paths
VAULT_PATH="$OBSIDIAN_VAULT_PATH"
JOURNAL_PATH="$VAULT_PATH/$JOURNAL_FOLDER"
JOURNAL_FILE="$JOURNAL_PATH/$DATE.md"
TEMPLATE_PATH="$VAULT_PATH/$TEMPLATE_FOLDER/$TEMPLATE_FILE"

# Check if vault exists
if [ ! -d "$VAULT_PATH" ]; then
    echo "ERROR: Vault path not found: $VAULT_PATH"
    exit 1
fi

# Check if journal folder exists, create if needed
if [ ! -d "$JOURNAL_PATH" ]; then
    echo "Creating journal folder: $JOURNAL_PATH"
    mkdir -p "$JOURNAL_PATH"
fi

# Check if journal file exists
if [ -f "$JOURNAL_FILE" ] && [ "$FORCE_CREATE" != "true" ]; then
    echo "EXISTS:$JOURNAL_FILE"
    
    # Extract last used context from file
    LAST_PROJECT=$(grep -oP 'project: \K[^|]+' "$JOURNAL_FILE" | tail -1 | xargs || echo "")
    LAST_EPIC=$(grep -oP 'Jira Epic: \K[^\s]+' "$JOURNAL_FILE" | tail -1 | xargs || echo "")
    
    echo "CONTEXT:$LAST_PROJECT|$LAST_EPIC"
    exit 0
fi

# File doesn't exist or force create - check template
if [ ! -f "$TEMPLATE_PATH" ]; then
    echo "WARNING: Template not found at $TEMPLATE_PATH, using built-in template"
    # Built-in template
    TEMPLATE="# Daily Journal - $(date +"$DATE_DISPLAY_FORMAT")

## Tasks

---

## Activity Log

---

## Meetings Log

---

## Notes"
else
    # Read template from file and replace placeholders
    TEMPLATE=$(cat "$TEMPLATE_PATH")
    # Replace date placeholders
    DAY_OF_WEEK=$(date +"%A")
    DAY=$(date +"%d")
    MONTH=$(date +"%B")
    YEAR=$(date +"%Y")
    
    TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{DAY_OF_WEEK}}/$DAY_OF_WEEK/g")
    TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{DAY}}/$DAY/g")
    TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{MONTH}}/$MONTH/g")
    TEMPLATE=$(echo "$TEMPLATE" | sed "s/{{YEAR}}/$YEAR/g")
fi

# Create journal file with template
echo "$TEMPLATE" > "$JOURNAL_FILE"

echo "CREATED:$JOURNAL_FILE"
echo "CONTEXT:|"