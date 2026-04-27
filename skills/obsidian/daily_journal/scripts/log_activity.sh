#!/bin/bash

# Script to log an action to the daily journal
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Parse parameters
DESCRIPTION="$1"
PROJECT="$2"
JIRA_EPIC="$3"
TIME="$4"

# Default to current time if not provided
if [ -z "$TIME" ]; then
    TIME=$(date +"$TIME_FORMAT")
fi

# Check if description is provided
if [ -z "$DESCRIPTION" ]; then
    echo "Error: Description is required"
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

# Format the activity line
ACTIVITY_LINE="- [$TIME] $DESCRIPTION"
if [ -n "$PROJECT" ]; then
    ACTIVITY_LINE="$ACTIVITY_LINE | project: $PROJECT"
fi
if [ -n "$JIRA_EPIC" ]; then
    ACTIVITY_LINE="$ACTIVITY_LINE | jira: $JIRA_EPIC"
fi
ACTIVITY_LINE="$ACTIVITY_LINE\n"

# Check if Activity Log section exists
if ! grep -q "^## Activity Log" "$JOURNAL_FILE"; then
    # Create Activity Log section
    sed -i "/^## Meeting Log/i ## Activity Log\n\n---\n" "$JOURNAL_FILE"
fi

# Insert the activity chronologically
# Find the Activity Log section and insert activities in chronological order
# Get all existing activity timestamps
EXISTING_TIMES=$(grep "^- \[" "$JOURNAL_FILE" | sed 's/- \[\([^]]*\)\].*/\1/' | sort)

# Find the correct insertion point
INSERT_LINE=""
for EXISTING_TIME in $EXISTING_TIMES; do
    if [ "$TIME" \< "$EXISTING_TIME" ]; then
        INSERT_LINE=$(grep -n "^- \[$EXISTING_TIME\]" "$JOURNAL_FILE" | head -1 | cut -d: -f1)
        break
    fi
done

if [ -n "$INSERT_LINE" ]; then
    # Insert before the line with the later time
    sed -i "${INSERT_LINE}i\\$ACTIVITY_LINE" "$JOURNAL_FILE"
else
    # Insert at the end of Activity Log section (before ---)
    sed -i "/^## Activity Log/,/^---/s/^---/$ACTIVITY_LINE\n---/" "$JOURNAL_FILE"
fi

echo "Activity logged to $JOURNAL_FILE"

