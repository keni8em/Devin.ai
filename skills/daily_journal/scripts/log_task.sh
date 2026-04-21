#!/bin/bash
# log_task.sh - Log a daily task to the daily journal
# Usage: log_task.sh <date> <task_description> [project] [target_date]

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

# Check if required parameters are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "ERROR: Date and task description are required" >&2
    echo "Usage: log_task.sh <date> <task_description> [project] [target_date]" >&2
    exit 1
fi

DATE="$1"
TASK="$2"
PROJECT="${3:-}"
TARGET_DATE="${4:-}"

# Get the journal directory
JOURNAL_DIR="$OBSIDIAN_VAULT_PATH/$JOURNAL_FOLDER"
ENTRY_FILE="$JOURNAL_DIR/$DATE.md"

# Check if entry file exists
if [ ! -f "$ENTRY_FILE" ]; then
    echo "ERROR: Entry file not found: $ENTRY_FILE" >&2
    exit 1
fi

# Build the task line
if [ -n "$PROJECT" ]; then
    if [ -n "$TARGET_DATE" ]; then
        TASK_LINE="- [ ] $PROJECT: $TASK (for $TARGET_DATE)"
    else
        TASK_LINE="- [ ] $PROJECT: $TASK"
    fi
else
    if [ -n "$TARGET_DATE" ]; then
        TASK_LINE="- [ ] $TASK (for $TARGET_DATE)"
    else
        TASK_LINE="- [ ] $TASK"
    fi
fi

# If project is specified, we need to group tasks by project
if [ -n "$PROJECT" ]; then
    # Check if there are existing tasks for this project
    if grep -q "\\[ \\] $PROJECT:" "$ENTRY_FILE"; then
        # Find the last task for this project and insert after it
        sed -i "/\\[ \\] $PROJECT:/a\\$TASK_LINE" "$ENTRY_FILE"
    else
        # Check if there are tasks with other projects
        if grep -q "^- \\[ \\].*:" "$ENTRY_FILE"; then
            # Find the last task with any project and insert after it
            sed -i "/^- \\[ \\].*:/a\\$TASK_LINE" "$ENTRY_FILE"
        else
            # Insert at the beginning of the Tasks section (after header)
            sed -i "/^## Tasks$/a\\$TASK_LINE" "$ENTRY_FILE"
        fi
    fi
else
    # No project - add to the bottom of the task list
    # Find the last task line and insert after it
    if grep -q "^- \\[ \\]" "$ENTRY_FILE"; then
        sed -i "/^- \\[ \\]/a\\$TASK_LINE" "$ENTRY_FILE"
    else
        # Insert at the beginning of the Tasks section (after header)
        sed -i "/^## Tasks$/a\\$TASK_LINE" "$ENTRY_FILE"
    fi
fi

echo "LOGGED:$ENTRY_FILE"
