#!/bin/bash
# log_activity.sh - Log an activity to the daily journal
# Usage: log_activity.sh [date] [time] <activity_description> [project] [jira_epic]
# If date is not provided, uses current date
# If time is not provided, uses current time

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

# Parse parameters - date and time are optional, activity description is required
if [ -z "$1" ]; then
    echo "ERROR: Activity description is required" >&2
    echo "Usage: log_activity.sh [date] [time] <activity_description> [project] [jira_epic]" >&2
    exit 1
fi

# Determine if first parameter is a date (YYYY-MM-DD format) or activity description
if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    DATE="$1"
    shift
    # Check if next parameter is a time (HH:MM format) or activity description
    if [[ $1 =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
        TIME="$1"
        shift
    else
        TIME=$(date +"$TIME_FORMAT")
    fi
else
    DATE=$(date +"$DATE_FORMAT")
    # Check if first parameter is a time (HH:MM format) or activity description
    if [[ $1 =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
        TIME="$1"
        shift
    else
        TIME=$(date +"$TIME_FORMAT")
    fi
fi

ACTIVITY="$1"
PROJECT="${2:-}"
JIRA_EPIC="${3:-}"

# Get the journal directory
JOURNAL_DIR="$OBSIDIAN_VAULT_PATH/$JOURNAL_FOLDER"
ENTRY_FILE="$JOURNAL_DIR/$DATE.md"

# Check if entry file exists
if [ ! -f "$ENTRY_FILE" ]; then
    echo "ERROR: Entry file not found: $ENTRY_FILE" >&2
    exit 1
fi

# Build the activity line
if [ -n "$PROJECT" ] && [ -n "$JIRA_EPIC" ]; then
    ACTIVITY_LINE="[$TIME] $ACTIVITY | project: ${PROJECT} | Jira Epic: $JIRA_EPIC"
elif [ -n "$PROJECT" ]; then
    ACTIVITY_LINE="[$TIME] $ACTIVITY | project: ${PROJECT}"
else
    ACTIVITY_LINE="[$TIME] $ACTIVITY"
fi

# Find the Activity Log section and insert in chronological order
# Get all existing activity times and their line numbers
ACTIVITY_TIMES=$(sed -n "/^## $SECTION_ACTIVITY/,/^---/p" "$ENTRY_FILE" | grep -n "^\[")

if [ -z "$ACTIVITY_TIMES" ]; then
    # No existing activities, insert after the header
    sed -i "/^## $SECTION_ACTIVITY$/a\\\n$ACTIVITY_LINE" "$ENTRY_FILE"
else
    # Find the correct position based on time
    SECTION_START=$(grep -n "^## $SECTION_ACTIVITY" "$ENTRY_FILE" | cut -d: -f1)
    INSERT_LINE=""  # Will hold the line to insert before
    
    while IFS=: read -r line_num content; do
        ACTUAL_LINE=$((SECTION_START + line_num - 1))
        EXISTING_TIME=$(echo "$content" | sed 's/\[//' | sed 's/\].*//')
        
        # Compare times (assuming HH:MM format)
        if [ "$TIME" \< "$EXISTING_TIME" ]; then
            INSERT_LINE=$ACTUAL_LINE
            break
        fi
    done <<< "$ACTIVITY_TIMES"
    
    if [ -n "$INSERT_LINE" ]; then
        # Insert before the activity that's later
        sed -i "${INSERT_LINE}i\\$ACTIVITY_LINE" "$ENTRY_FILE"
    else
        # Insert at the end (before ---)
        LAST_ACTIVITY_LINE=$(echo "$ACTIVITY_TIMES" | tail -1 | cut -d: -f1)
        ACTUAL_LAST_LINE=$((SECTION_START + LAST_ACTIVITY_LINE -1))
        sed -i "${ACTUAL_LAST_LINE}a\\$ACTIVITY_LINE" "$ENTRY_FILE"
    fi
fi

echo "LOGGED:$ENTRY_FILE"
