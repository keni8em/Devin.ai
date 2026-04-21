#!/bin/bash

# Journal Task Script
# Adds daily task entry to journal file with project grouping

set -e

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Parse arguments
DATE="${1:-$(date +"$DATE_FORMAT")}"
TASK="${2:-}"
PROJECT="${3:-}"
TARGET_DATE="${4:-}"  # Optional: for future tasks

# Construct paths
VAULT_PATH="$OBSIDIAN_VAULT_PATH"
JOURNAL_PATH="$VAULT_PATH/$JOURNAL_FOLDER"
JOURNAL_FILE="$JOURNAL_PATH/$DATE.md"

# Validate inputs
if [ -z "$TASK" ]; then
    echo "ERROR: Task description is required"
    exit 1
fi

if [ ! -f "$JOURNAL_FILE" ]; then
    echo "ERROR: Journal file not found: $JOURNAL_FILE"
    exit 1
fi

# Format the task entry
if [ -n "$PROJECT" ]; then
    if [ -n "$TARGET_DATE" ]; then
        TASK_ENTRY="- [ ] $PROJECT: $TASK (for $TARGET_DATE)"
    else
        TASK_ENTRY="- [ ] $PROJECT: $TASK"
    fi
else
    if [ -n "$TARGET_DATE" ]; then
        TASK_ENTRY="- [ ] $TASK (for $TARGET_DATE)"
    else
        TASK_ENTRY="- [ ] $TASK"
    fi
fi

# Add task to Tasks section with project grouping
# This is more complex - need to find the right place to insert based on project
awk -v task="$TASK_ENTRY" -v project="$PROJECT" '
    BEGIN { in_tasks = 0; found = 0 }
    
    /^## Tasks$/ { 
        in_tasks = 1
        print
        next
    }
    
    in_tasks && /^---$/ {
        # End of tasks section, add task here if not found
        if (!found) {
            print task
        }
        in_tasks = 0
        print
        next
    }
    
    in_tasks && /^- \[ \]/ {
        # Check if this is a task for our project
        if (project != "" && index($0, project ":") > 0) {
            # Found a task for our project, insert after it
            print task
            found = 1
        }
        # If no project and this is a no-project task, insert after
        if (project == "" && index($0, ": ") == 0) {
            print task
            found = 1
        }
    }
    
    { print }
' "$JOURNAL_FILE" > "${JOURNAL_FILE}.tmp" && mv "${JOURNAL_FILE}.tmp" "$JOURNAL_FILE"

echo "SUCCESS: Task added to $JOURNAL_FILE"