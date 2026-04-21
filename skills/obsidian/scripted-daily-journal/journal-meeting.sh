#!/bin/bash

# Journal Meeting Script
# Adds meeting log entry to journal file

set -e

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Parse arguments
DATE="${1:-$(date +"$DATE_FORMAT")}"
TIME="${2:-$(date +"$TIME_FORMAT")}"
TITLE="${3:-}"
TYPE="${4:-}"
DURATION="${5:-}"
PROJECT="${6:-}"

# Construct paths
VAULT_PATH="$OBSIDIAN_VAULT_PATH"
JOURNAL_PATH="$VAULT_PATH/$JOURNAL_FOLDER"
JOURNAL_FILE="$JOURNAL_PATH/$DATE.md"

# Validate inputs
if [ -z "$TITLE" ]; then
    echo "ERROR: Title is required"
    exit 1
fi

if [ ! -f "$JOURNAL_FILE" ]; then
    echo "ERROR: Journal file not found: $JOURNAL_FILE"
    exit 1
fi

# Format the meeting entry
if [ -n "$PROJECT" ]; then
    MEETING_ENTRY="[$TIME] $TITLE | type: $TYPE | duration: $DURATION | project: $PROJECT"
else
    MEETING_ENTRY="[$TIME] $TITLE | type: $TYPE | duration: $DURATION"
fi

# Find Meetings Log section and add entry
awk -v entry="$MEETING_ENTRY" '
    /^## Meetings Log$/ { in_section = 1; print; next }
    in_section && /^---$/ { 
        print entry
        print
        in_section = 0
        next
    }
    { print }
' "$JOURNAL_FILE" > "${JOURNAL_FILE}.tmp" && mv "${JOURNAL_FILE}.tmp" "$JOURNAL_FILE"

echo "SUCCESS: Meeting entry added to $JOURNAL_FILE"