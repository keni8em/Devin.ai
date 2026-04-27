#!/bin/bash

# Script to close a fleeting note
# Updates status to needs-processing, updates modified timestamp,
# and logs a closing activity to the daily journal
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Parse parameters
NOTE_PATH="$1"

# Validate required parameters
if [ -z "$NOTE_PATH" ]; then
    echo "Error: Note path is required"
    exit 1
fi

# Check note file exists
if [ ! -f "$NOTE_PATH" ]; then
    echo "Error: Note file not found: $NOTE_PATH"
    exit 1
fi

# Check note is currently active
NOTE_STATUS=$(grep "^status: " "$NOTE_PATH" | sed 's/^status: //')
if [ "$NOTE_STATUS" != "$STATUS_ACTIVE" ]; then
    echo "Warning: Note status is '$NOTE_STATUS' — expected '$STATUS_ACTIVE'"
    echo "Note may already be closed"
fi

# Get current datetime
DATETIME=$(date +"$DATETIME_FORMAT")

# Extract metadata from note frontmatter
NOTE_TITLE=$(grep "^title: " "$NOTE_PATH" | sed 's/^title: //')
NOTE_PROJECT=$(grep "^project: " "$NOTE_PATH" | sed 's/^project: //')
NOTE_JIRA=$(grep "^jira: " "$NOTE_PATH" | sed 's/^jira: //')
NOTE_TYPE=$(grep "^type: " "$NOTE_PATH" | sed 's/^type: //')

# Get the note filename without extension for Obsidian wikilink
NOTE_NAME=$(basename "$NOTE_PATH" .md)

# Update status to needs-processing
sed -i "s/^status: $STATUS_ACTIVE$/status: $STATUS_NEEDS_PROCESSING/" "$NOTE_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to update note status"
    exit 1
fi

# Update modified timestamp
sed -i "s/^modified: .*/modified: $DATETIME/" "$NOTE_PATH"

echo "Fleeting note closed: $NOTE_PATH"
echo "Status updated to: $STATUS_NEEDS_PROCESSING"

# Log the closing activity to the daily journal
DAILY_JOURNAL_LOG_ACTIVITY="$DAILY_JOURNAL_SKILL_PATH/scripts/log_activity.sh"

if [ -f "$DAILY_JOURNAL_LOG_ACTIVITY" ]; then
    # Build the activity description with Obsidian wikilink
    ACTIVITY_DESC="Closed fleeting note: $NOTE_TITLE [[$NOTE_NAME]]"

    # Change to daily journal skill directory as required by log_activity.sh
    cd "$DAILY_JOURNAL_SKILL_PATH"

    bash "$DAILY_JOURNAL_LOG_ACTIVITY" "$ACTIVITY_DESC" "$NOTE_PROJECT" "$NOTE_JIRA"

    if [ $? -eq 0 ]; then
        echo "Activity logged to daily journal"
    else
        echo "Warning: Failed to log activity to daily journal — note was still closed successfully"
    fi
else
    echo "Warning: Daily journal log_activity.sh not found at $DAILY_JOURNAL_LOG_ACTIVITY"
    echo "Note was closed successfully but activity was not logged to daily journal"
fi

# Output structured result for skill to parse
echo ""
echo "NOTE_CLOSED=$NOTE_PATH"
echo "NOTE_TITLE=$NOTE_TITLE"
echo "NOTE_PROJECT=$NOTE_PROJECT"
echo "NOTE_JIRA=$NOTE_JIRA"
echo "NOTE_TYPE=$NOTE_TYPE"
