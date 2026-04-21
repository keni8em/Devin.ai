#!/bin/bash

# Journal Activity Script
# Adds activity log entry to journal file

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

# Format the activity entry
if [ -n "$PROJECT" ] && [ -n "$EPIC" ]; then
    ACTIVITY_ENTRY="[$TIME] $CONTENT | project: $PROJECT | Jira Epic: $EPIC"
elif [ -n "$PROJECT" ]; then
    ACTIVITY_ENTRY="[$TIME] $CONTENT | project: $PROJECT"
else
    ACTIVITY_ENTRY="[$TIME] $CONTENT"
fi

# Find Activity Log section and add entry
# Use awk to insert after "## Activity Log" and before the next "---"
awk -v entry="$ACTIVITY_ENTRY" '
    /^## Activity Log$/ { in_section = 1; print; next }
    in_section && /^---$/ { 
        print entry
        print
        in_section = 0
        next
    }
    { print }
' "$JOURNAL_FILE" > "${JOURNAL_FILE}.tmp" && mv "${JOURNAL_FILE}.tmp" "$JOURNAL_FILE"

echo "SUCCESS: Activity entry added to $JOURNAL_FILE"