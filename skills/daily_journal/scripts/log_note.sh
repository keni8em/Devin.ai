#!/bin/bash
# log_note.sh - Log a daily note to the daily journal
# Usage: log_note.sh <date> <time> <project> <jira_epic> <summary>

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

# Check if all parameters are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$5" ]; then
    echo "ERROR: Date, time, and summary are required" >&2
    echo "Usage: log_note.sh <date> <time> [project] [jira_epic] <summary>" >&2
    exit 1
fi

DATE="$1"
TIME="$2"
PROJECT="${3:-}"
JIRA_EPIC="${4:-}"
SUMMARY="$5"

# Get the journal directory
JOURNAL_DIR="$OBSIDIAN_VAULT_PATH/$JOURNAL_FOLDER"
ENTRY_FILE="$JOURNAL_DIR/$DATE.md"

# Check if entry file exists
if [ ! -f "$ENTRY_FILE" ]; then
    echo "ERROR: Entry file not found: $ENTRY_FILE" >&2
    exit 1
fi

# Build the note header
if [ -n "$PROJECT" ] && [ -n "$JIRA_EPIC" ]; then
    NOTE_HEADER="[$TIME] project: $PROJECT | Jira Epic: $JIRA_EPIC"
elif [ -n "$PROJECT" ]; then
    NOTE_HEADER="[$TIME] project: $PROJECT"
else
    NOTE_HEADER="[$TIME]"
fi

# Find the Notes section and insert the note
# Check for existing entries
if sed -n '/^## Notes/,/^---/p' "$ENTRY_FILE" | grep -q "^\["; then
    # Has existing entries, find the last one and insert after it
    LAST_LINE=$(sed -n '/^## Notes/,/^---/p' "$ENTRY_FILE" | grep -n "^\[" | tail -1 | cut -d: -f1)
    SECTION_START=$(grep -n "^## Notes" "$ENTRY_FILE" | cut -d: -f1)
    ACTUAL_LINE=$((SECTION_START + LAST_LINE))  # Insert after the summary line
    sed -i "${ACTUAL_LINE}a\\\n$NOTE_HEADER\n$SUMMARY" "$ENTRY_FILE"
else
    # No existing entries, insert after the header
    sed -i "/^## Notes$/a\\\n$NOTE_HEADER\n$SUMMARY" "$ENTRY_FILE"
fi

echo "LOGGED:$ENTRY_FILE"
