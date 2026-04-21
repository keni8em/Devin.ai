#!/bin/bash

# Journal Note Script
# Adds daily note entry to journal file

set -e

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Parse arguments
DATE="${1:-$(date +"$DATE_FORMAT")}"
TIME="${2:-$(date +"$TIME_FORMAT")}"
CONTENT="${3:-}"
PROJECT="${4:-}"
EPIC="${5:-}"

# Construct paths
VAULT_PATH="$OBSIDIAN_VAULT_PATH"
JOURNAL_PATH="$VAULT_PATH/$JOURNAL_FOLDER"
JOURNAL_FILE="$JOURNAL_PATH/$DATE.md"

# Validate inputs
if [ -z "$CONTENT" ]; then
    echo "ERROR: Content is required"
    exit 1
fi

if [ ! -f "$JOURNAL_FILE" ]; then
    echo "ERROR: Journal file not found: $JOURNAL_FILE"
    exit 1
fi

# Format the note entry
if [ -n "$PROJECT" ] && [ -n "$EPIC" ]; then
    NOTE_HEADER="[$TIME] project: $PROJECT | Jira Epic: $EPIC"
elif [ -n "$PROJECT" ]; then
    NOTE_HEADER="[$TIME] project: $PROJECT"
else
    NOTE_HEADER="[$TIME]"
fi

# Find Notes section and add entry with blank line before
awk -v header="$NOTE_HEADER" -v content="$CONTENT" '
    /^## Notes$/ { in_section = 1; print; next }
    in_section && /^---$/ { 
        print ""
        print header
        print content
        print
        in_section = 0
        next
    }
    { print }
' "$JOURNAL_FILE" > "${JOURNAL_FILE}.tmp" && mv "${JOURNAL_FILE}.tmp" "$JOURNAL_FILE"

echo "SUCCESS: Daily note added to $JOURNAL_FILE"