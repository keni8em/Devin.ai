#!/bin/bash
# log_note.sh - Log a daily note to the daily journal
# Usage: log_note.sh [date] [time] [project] [jira_epic] <summary>
# If date is not provided, uses current date
# If time is not provided, uses current time
# Summary is required

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

# Parse parameters - date, time, project, and jira_epic are optional, summary is required
if [ -z "$1" ]; then
    echo "ERROR: Summary is required" >&2
    echo "Usage: log_note.sh [date] [time] [project] [jira_epic] <summary>" >&2
    exit 1
fi

# Initialize variables
DATE=""
TIME=""
PROJECT=""
JIRA_EPIC=""

# Determine if first parameter is a date (YYYY-MM-DD format) or not
if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    DATE="$1"
    shift
    # Check if next parameter is a time (HH:MM format) or not
    if [[ $1 =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
        TIME="$1"
        shift
    else
        TIME=$(date +"$TIME_FORMAT")
    fi
else
    DATE=$(date +"$DATE_FORMAT")
    # Check if first parameter is a time (HH:MM format) or not
    if [[ $1 =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
        TIME="$1"
        shift
    else
        TIME=$(date +"$TIME_FORMAT")
    fi
fi

# Now we have date and time set, remaining parameters are project, jira_epic, summary
# We need to determine which are which
# If we have 3+ parameters left, the last one is summary, first two could be project/jira_epic
# If we have 2 parameters left, the last one is summary, first could be project
# If we have 1 parameter left, it's the summary

PARAM_COUNT=$#
if [ $PARAM_COUNT -eq 1 ]; then
    SUMMARY="$1"
elif [ $PARAM_COUNT -eq 2 ]; then
    PROJECT="$1"
    SUMMARY="$2"
elif [ $PARAM_COUNT -ge 3 ]; then
    PROJECT="$1"
    JIRA_EPIC="$2"
    # All remaining parameters are part of the summary
    shift 2
    SUMMARY="$*"
fi

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
