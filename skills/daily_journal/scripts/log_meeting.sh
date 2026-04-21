#!/bin/bash
# log_meeting.sh - Log a meeting to the daily journal
# Usage: log_meeting.sh <date> <time> <title> <type> <duration> [project]

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

# Check if all required parameters are provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
    echo "ERROR: Date, time, title, type, and duration are required" >&2
    echo "Usage: log_meeting.sh <date> <time> <title> <type> <duration> [project]" >&2
    exit 1
fi

DATE="$1"
TIME="$2"
TITLE="$3"
TYPE="$4"
DURATION="$5"
PROJECT="${6:-}"

# Get the journal directory
JOURNAL_DIR="$OBSIDIAN_VAULT_PATH/$JOURNAL_FOLDER"
ENTRY_FILE="$JOURNAL_DIR/$DATE.md"

# Check if entry file exists
if [ ! -f "$ENTRY_FILE" ]; then
    echo "ERROR: Entry file not found: $ENTRY_FILE" >&2
    exit 1
fi

# Build the meeting line
if [ -n "$PROJECT" ]; then
    MEETING_LINE="[$TIME] $TITLE | type: $TYPE | duration: $DURATION | project: $PROJECT"
else
    MEETING_LINE="[$TIME] $TITLE | type: $TYPE | duration: $DURATION"
fi

# Find the Meetings Log section and insert in chronological order
# Get all existing meeting times and their line numbers
MEETING_TIMES=$(sed -n '/^## Meetings Log/,/^---/p' "$ENTRY_FILE" | grep -n "^\[")

if [ -z "$MEETING_TIMES" ]; then
    # No existing meetings, insert after the header
    sed -i "/^## Meetings Log$/a\\\n$MEETING_LINE" "$ENTRY_FILE"
else
    # Find the correct position based on time
    SECTION_START=$(grep -n "^## Meetings Log" "$ENTRY_FILE" | cut -d: -f1)
    INSERT_LINE=""  # Will hold the line to insert before
    
    while IFS=: read -r line_num content; do
        ACTUAL_LINE=$((SECTION_START + line_num - 1))
        EXISTING_TIME=$(echo "$content" | sed 's/\[//' | sed 's/\].*//')
        
        # Compare times (assuming HH:MM format)
        if [ "$TIME" \< "$EXISTING_TIME" ]; then
            INSERT_LINE=$ACTUAL_LINE
            break
        fi
    done <<< "$MEETING_TIMES"
    
    if [ -n "$INSERT_LINE" ]; then
        # Insert before the meeting that's later
        sed -i "${INSERT_LINE}i\\$MEETING_LINE" "$ENTRY_FILE"
    else
        # Insert at the end (before ---)
        LAST_MEETING_LINE=$(echo "$MEETING_TIMES" | tail -1 | cut -d: -f1)
        ACTUAL_LAST_LINE=$((SECTION_START + LAST_MEETING_LINE -1))
        sed -i "${ACTUAL_LAST_LINE}a\\$MEETING_LINE" "$ENTRY_FILE"
    fi
fi

echo "LOGGED:$ENTRY_FILE"
