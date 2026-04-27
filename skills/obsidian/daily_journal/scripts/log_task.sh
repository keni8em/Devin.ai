#!/bin/bash

# Script to log a task to the daily journal
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Parse parameters
DESCRIPTION="$1"
PROJECT="$2"
DATE="$3"

# Default to today's date if not provided
if [ -z "$DATE" ]; then
    DATE=$(date +"$DATE_FORMAT")
fi

# Check if description is provided
if [ -z "$DESCRIPTION" ]; then
    echo "Error: Description is required"
    exit 1
fi

# Determine journal file path
JOURNAL_PATH="$OBSIDIAN_VAULT_PATH/$JOURNAL_FOLDER"
JOURNAL_FILE="$JOURNAL_PATH/$DATE.md"

# Check if journal file exists
if [ ! -f "$JOURNAL_FILE" ]; then
    echo "Error: Journal file not found: $JOURNAL_FILE"
    exit 1
fi

# Format the task
if [ -n "$PROJECT" ]; then
    TASK_LINE="- [ ] $PROJECT | $DESCRIPTION"
else
    TASK_LINE="- [ ] $DESCRIPTION"
fi

# Check if tasks section exists
if ! grep -q "^## Tasks" "$JOURNAL_FILE"; then
    # Create tasks section before Activity Log
    sed -i "/^## Activity Log/i ## Tasks\n\n---\n" "$JOURNAL_FILE"
fi

# Insert the task
if [ -n "$PROJECT" ]; then
    # Check if there are existing tasks for this project
    if grep -q "\\[ \\] $PROJECT |" "$JOURNAL_FILE"; then
        # Find the last task for this project and insert after it
        LAST_LINE=$(grep -n "\\[ \\] $PROJECT |" "$JOURNAL_FILE" | tail -1 | cut -d: -f1)
        sed -i "${LAST_LINE}a\\$TASK_LINE" "$JOURNAL_FILE"
    else
        # Check if there are tasks with other projects
        if grep -q "^- \\[ \\].*|" "$JOURNAL_FILE"; then
            # Find the last task with any project and insert after it
            LAST_LINE=$(grep -n "^- \\[ \\].*|" "$JOURNAL_FILE" | tail -1 | cut -d: -f1)
            sed -i "${LAST_LINE}a\\$TASK_LINE" "$JOURNAL_FILE"
        else
            # Insert at the beginning of the Tasks section (after header)
            sed -i "/^## Tasks$/a\\\n$TASK_LINE" "$JOURNAL_FILE"
        fi
    fi
else
    # No project - add to the bottom of the task list
    # Find the last task line and insert after it
    if grep -q "^- \\[ \\]" "$JOURNAL_FILE"; then
        LAST_LINE=$(grep -n "^- \\[ \\]" "$JOURNAL_FILE" | tail -1 | cut -d: -f1)
        sed -i "${LAST_LINE}a\\$TASK_LINE" "$JOURNAL_FILE"
    else
        # Insert at the beginning of the Tasks section (after header)
        sed -i "/^## Tasks$/a\\\n$TASK_LINE" "$JOURNAL_FILE"
    fi
fi

echo "Task logged to $JOURNAL_FILE"

