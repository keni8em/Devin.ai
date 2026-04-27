#!/bin/bash

# Script to log a note to the daily journal
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Parse parameters
NOTE_TYPE="$1"
NOTE_DETAIL="$2"
PROJECT="$3"
JIRA_EPIC="$4"
TIME="$5"

# Default to current time if not provided
if [ -z "$TIME" ]; then
    TIME=$(date +"$TIME_FORMAT")
fi

# Validate note type
if [ -z "$NOTE_TYPE" ]; then
    echo "Error: Note type is required"
    exit 1
fi
VALID_TYPE=false
for TYPE in "${NOTE_TYPES[@]}"; do
    if [ "$NOTE_TYPE" = "$TYPE" ]; then
        VALID_TYPE=true
        break
    fi
done
if [ "$VALID_TYPE" = false ]; then
    echo "Error: Invalid note type. Valid types are: ${NOTE_TYPES[*]}"
    exit 1
fi

# Check if note detail is provided
if [ -z "$NOTE_DETAIL" ]; then
    echo "Error: Note detail is required"
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

# Format the note
NOTE_HEADER="[$TIME] $NOTE_TYPE\n"
if [ -n "$PROJECT" ] || [ -n "$JIRA_EPIC" ]; then
    NOTE_CONTEXT=""
    if [ -n "$PROJECT" ]; then
        NOTE_CONTEXT="$PROJECT"
    fi
    if [ -n "$JIRA_EPIC" ]; then
        if [ -n "$NOTE_CONTEXT" ]; then
            NOTE_CONTEXT="$NOTE_CONTEXT | $JIRA_EPIC"
        else
            NOTE_CONTEXT="$JIRA_EPIC"
        fi
    fi
    NOTE_HEADER="$NOTE_HEADER$NOTE_CONTEXT\n"
fi
NOTE_HEADER="$NOTE_HEADER$NOTE_DETAIL\n"

# Check if Notes section exists
if ! grep -q "^## Notes" "$JOURNAL_FILE"; then
    # Create Notes section at the end of the file
    echo -e "\n## Notes\n\n---\n" >> "$JOURNAL_FILE"
fi

# Insert the note at the end of Notes section
# Only search within the Notes section (between ## Notes and ---)
NOTES_START=$(grep -n "^## Notes" "$JOURNAL_FILE" | head -1 | cut -d: -f1)
NOTES_END=$(grep -n "^---" "$JOURNAL_FILE" | awk -F: '$1>'$NOTES_START' {print $1; exit}')

if [ -n "$NOTES_END" ]; then
    # Insert before the --- in the Notes section
    sed -i "${NOTES_END}i\\$NOTE_HEADER" "$JOURNAL_FILE"
else
    # No --- found after Notes, append to end of file
    echo -e "$NOTE_HEADER" >> "$JOURNAL_FILE"
fi

echo "Note logged to $JOURNAL_FILE"

