#!/bin/bash

# Script to log a meeting to the daily journal
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Parse parameters
MEETING_TITLE="$1"
MEETING_TYPE="$2"
MEETING_DURATION="$3"
PROJECT="$4"
TIME="$5"

# Default to current time if not provided
if [ -z "$TIME" ]; then
    TIME=$(date +"$TIME_FORMAT")
fi

# Check if all required fields are provided
if [ -z "$MEETING_TITLE" ]; then
    echo "Error: Meeting title is required"
    exit 1
fi
if [ -z "$MEETING_TYPE" ]; then
    echo "Error: Meeting type is required"
    exit 1
fi
if [ -z "$MEETING_DURATION" ]; then
    echo "Error: Meeting duration is required"
    exit 1
fi

# Determine journal file path (use today's date)
JOURNAL_PATH="$OBSIDIAN_VAULT_PATH/$JOURNAL_FOLDER"
DATE=$(date +"$DATE_FORMAT")
JOURNAL_FILE="$JOURNAL_PATH/$DATE.md"

# Check if journal file exists
if [ ! -f "$JOURNAL_FILE" ]; then
    echo "Error: Journal file not found: $JOURNAL_FILE"
    exit 1
fi

# Format the meeting line
MEETING_LINE="- [$TIME] $MEETING_TITLE"
MEETING_LINE="$MEETING_LINE | type: $MEETING_TYPE"
MEETING_LINE="$MEETING_LINE | duration: $MEETING_DURATION"
if [ -n "$PROJECT" ]; then
    MEETING_LINE="$MEETING_LINE | project: $PROJECT"
fi

# Check if Meeting Log section exists
if ! grep -q "^## Meeting Log" "$JOURNAL_FILE"; then
    # Create Meeting Log section
    sed -i "/^## Notes/i ## Meeting Log\n\n---\n" "$JOURNAL_FILE"
fi

# Insert the meeting at the end of Meeting Log section
# Only search for lines within the Meeting Log section (between ## Meeting Log and ---)
MEETING_START=$(grep -n "^## Meeting Log" "$JOURNAL_FILE" | head -1 | cut -d: -f1)
MEETING_END=$(grep -n "^---" "$JOURNAL_FILE" | awk -F: '$1>'$MEETING_START' {print $1; exit}')

if [ -n "$MEETING_END" ]; then
    # Check if there are any lines starting with - in the Meeting Log section
    MEETING_LINES=$(sed -n "${MEETING_START},${MEETING_END}p" "$JOURNAL_FILE" | grep -n "^- " | tail -1 | cut -d: -f1)
    if [ -n "$MEETING_LINES" ]; then
        # Find the absolute line number of the last meeting
        LAST_LINE=$((MEETING_START + MEETING_LINES - 1))
        sed -i "${LAST_LINE}a\\$MEETING_LINE" "$JOURNAL_FILE"
    else
        # Insert at the beginning of the Meeting Log section (after header)
        sed -i "${MEETING_START}a\\\n$MEETING_LINE" "$JOURNAL_FILE"
    fi
else
    # No --- found, insert at the beginning of the Meeting Log section (after header)
    sed -i "${MEETING_START}a\\\n$MEETING_LINE" "$JOURNAL_FILE"
fi

echo "Meeting logged to $JOURNAL_FILE"

