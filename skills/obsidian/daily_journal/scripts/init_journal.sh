#!/bin/bash

# Script to create daily journal file and discover projects and Jira Epics from the Obsidian vault
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Function to format date
format_date() {
    date +"$1"
}

# Default to today's date
TARGET_DATE=$(format_date "$DATE_FORMAT")
TARGET_DATE_DISPLAY=$(format_date "$DATE_DISPLAY_FORMAT")

# Check if date parameter is provided
if [ -n "$1" ]; then
    TARGET_DATE="$1"
    # Try to convert to display format
    TARGET_DATE_DISPLAY=$(date -d "$TARGET_DATE" +"$DATE_DISPLAY_FORMAT" 2>/dev/null || echo "$TARGET_DATE")
fi

# Check if vault path exists
if [ ! -d "$OBSIDIAN_VAULT_PATH" ]; then
    echo "Error: Obsidian vault path not found: $OBSIDIAN_VAULT_PATH"
    exit 1
fi

# Create journal folder if it doesn't exist
JOURNAL_PATH="$OBSIDIAN_VAULT_PATH/$JOURNAL_FOLDER"
if [ ! -d "$JOURNAL_PATH" ]; then
    mkdir -p "$JOURNAL_PATH"
fi

# Create daily journal file
JOURNAL_FILE="$JOURNAL_PATH/$TARGET_DATE.md"

if [ ! -f "$JOURNAL_FILE" ]; then
    # Check if template exists
    TEMPLATE_PATH="$OBSIDIAN_VAULT_PATH/$TEMPLATES_FOLDER/$DAILY_JOURNAL_TEMPLATE.md"
    if [ -f "$TEMPLATE_PATH" ]; then
        cp "$TEMPLATE_PATH" "$JOURNAL_FILE"
        # Extract date components
        DAY_OF_WEEK=$(date -d "$TARGET_DATE" +"%A")
        DAY=$(date -d "$TARGET_DATE" +"%d")
        MONTH=$(date -d "$TARGET_DATE" +"%B")
        YEAR=$(date -d "$TARGET_DATE" +"%Y")
        # Replace date placeholders
        sed -i "s/{{DAY_OF_WEEK}}/$DAY_OF_WEEK/g" "$JOURNAL_FILE"
        sed -i "s/{{DAY}}/$DAY/g" "$JOURNAL_FILE"
        sed -i "s/{{MONTH}}/$MONTH/g" "$JOURNAL_FILE"
        sed -i "s/{{YEAR}}/$YEAR/g" "$JOURNAL_FILE"
        echo "Created daily journal file: $JOURNAL_FILE from template"
    else
        # Create basic file without template
        echo "# Daily Journal - $TARGET_DATE_DISPLAY" > "$JOURNAL_FILE"
        echo "" >> "$JOURNAL_FILE"
        echo "## Activity Log" >> "$JOURNAL_FILE"
        echo "" >> "$JOURNAL_FILE"
        echo "## Meeting Log" >> "$JOURNAL_FILE"
        echo "" >> "$JOURNAL_FILE"
        echo "## Notes" >> "$JOURNAL_FILE"
        echo "" >> "$JOURNAL_FILE"
        echo "## Tasks" >> "$JOURNAL_FILE"
        echo "Created daily journal file: $JOURNAL_FILE (basic structure)"
    fi
else
    echo "Daily journal file already exists: $JOURNAL_FILE"
fi

# Discover projects from the projects folder
PROJECTS_PATH="$OBSIDIAN_VAULT_PATH/$JOURNAL_PROJECTS_FOLDER"
if [ -d "$PROJECTS_PATH" ]; then
    echo ""
    echo "Projects found in $JOURNAL_PROJECTS_FOLDER (sorted newest first):"
    ls -t "$PROJECTS_PATH" | while read -r project; do
        echo "  - $project"
    done
else
    echo ""
    echo "Warning: Projects folder not found: $PROJECTS_PATH"
fi

# Output structured context data for skill to parse
echo ""
echo "CONTEXT_START"

# For each project, get its epics
if [ -d "$PROJECTS_PATH" ]; then
    ls -t "$PROJECTS_PATH" | while read -r PROJECT; do
        PROJECT_DIR="$PROJECTS_PATH/$PROJECT"

        # Get epics for this project (directories matching JIRA_EPIC_IDENTIFIER pattern)
        EPICS=$(find "$PROJECT_DIR" -maxdepth 1 -type d -name "${JIRA_EPIC_IDENTIFIER}*" -printf "%T@ %p\n" | sort -rn | cut -d' ' -f2- | xargs -I {} basename {})

        # Build the output line
        if [ -n "$EPICS" ]; then
            # Join epics with pipes
            EPIC_LINE=$(echo "$EPICS" | paste -sd '|' -)
            echo "$PROJECT|$EPIC_LINE"
        else
            # No epics, just output project name
            echo "$PROJECT"
        fi
    done
fi

echo "CONTEXT_END"
