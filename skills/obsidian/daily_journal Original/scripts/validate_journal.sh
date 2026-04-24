#!/bin/bash
# validate_journal.sh - Validates and prepares the daily journal file, then returns context data
# Usage: validate_journal.sh [target_date]
# If target_date is provided in YYYY-MM-DD format, uses that date
# Otherwise, captures current date and time
# This script combines setup operations:
# 1. Captures current date and time (or uses provided date)
# 2. Checks if daily journal file exists for the target date
# 3. Creates file from template if it doesn't exist (reads template from Obsidian vault)
# 4. Gets projects and epics context
# Returns: STATUS|file_path|date|time|display_date followed by context data

# Source configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

# Capture date and time
if [ -n "$1" ]; then
    # Use provided date
    TARGET_DATE="$1"
    # Validate date format (YYYY-MM-DD)
    if [[ ! $TARGET_DATE =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "ERROR: Invalid date format. Use YYYY-MM-DD" >&2
        exit 1
    fi
else
    # Capture current date
    TARGET_DATE=$(date +"$DATE_FORMAT")
fi

# Capture current time
CURRENT_TIME=$(date +"$TIME_FORMAT")

# Generate display date (DDD DD MMMM YYYY)
if [ -n "$1" ]; then
    # If specific date provided, try to generate display date from it
    # This is a simplified version - in production you might want more robust date parsing
    DISPLAY_DATE=$(date -d "$TARGET_DATE" +"%a %d %B %Y" 2>/dev/null || echo "$TARGET_DATE")
else
    DISPLAY_DATE=$(date +"%a %d %B %Y")
fi

# Get the journal directory
JOURNAL_DIR="$OBSIDIAN_VAULT_PATH/$JOURNAL_FOLDER"
ENTRY_FILE="$JOURNAL_DIR/$TARGET_DATE.md"

# Get the template file path
TEMPLATE_FILE="$OBSIDIAN_VAULT_PATH/$TEMPLATES_FOLDER/$DAILY_JOURNAL_TEMPLATE.md"

# Check if journal directory exists
if [ ! -d "$JOURNAL_DIR" ]; then
    echo "ERROR: Journal directory not found: $JOURNAL_DIR" >&2
    exit 1
fi

# Check if entry file exists
if [ -f "$ENTRY_FILE" ]; then
    STATUS="EXISTS"
else
    # Check if template file exists
    if [ ! -f "$TEMPLATE_FILE" ]; then
        echo "ERROR: Template file not found: $TEMPLATE_FILE" >&2
        exit 1
    fi

    # Read the template and replace the date placeholder
    # The template uses {{DAY_OF_WEEK}} {{DAY}} {{MONTH}} {{YEAR}} format
    # We replace it with the provided display date
    sed "s/{{DAY_OF_WEEK}} {{DAY}} {{MONTH}} {{YEAR}}/$DISPLAY_DATE/g" "$TEMPLATE_FILE" > "$ENTRY_FILE"
    STATUS="CREATED"
fi

# Output status, file path, and captured date/time
echo "STATUS:$STATUS"
echo "FILE:$ENTRY_FILE"
echo "DATE:$TARGET_DATE"
echo "TIME:$CURRENT_TIME"
echo "DISPLAY_DATE:$DISPLAY_DATE"

# Get projects directory
PROJECTS_DIR="$OBSIDIAN_VAULT_PATH/$JOURNAL_PROJECTS_FOLDER"

# Check if projects directory exists
if [ ! -d "$PROJECTS_DIR" ]; then
    echo "ERROR: Projects directory not found: $PROJECTS_DIR" >&2
    exit 1
fi

# Get all projects sorted by last modified date (newest first)
PROJECTS=$(find "$PROJECTS_DIR" -maxdepth 1 -type d ! -name "$(basename "$PROJECTS_DIR")" -printf "%T@ %p\n" | sort -rn | cut -d' ' -f2- | xargs -I {} basename {})

# Output context header
echo "CONTEXT_START"

# For each project, get its epics and output in pipe-delimited format
while IFS= read -r PROJECT; do
    PROJECT_DIR="$PROJECTS_DIR/$PROJECT"

    # Check if project directory exists (it should, but just in case)
    if [ ! -d "$PROJECT_DIR" ]; then
        continue
    fi

    # Get epics for this project sorted by last modified date (newest first)
    EPICS=$(find "$PROJECT_DIR" -maxdepth 1 -type d -name "OCTO-*" -printf "%T@ %p\n" | sort -rn | cut -d' ' -f2- | xargs -I {} basename {})

    # Build the output line
    if [ -n "$EPICS" ]; then
        # Join epics with pipes
        EPIC_LINE=$(echo "$EPICS" | paste -sd '|' -)
        echo "$PROJECT|$EPIC_LINE"
    else
        # No epics, just output project name
        echo "$PROJECT"
    fi
done <<< "$PROJECTS"

echo "CONTEXT_END"
