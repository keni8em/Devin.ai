#!/bin/bash

# Script to find the most recently modified active fleeting note
# Searches within the given project/epic scope, or across all projects if not specified
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Parse parameters
PROJECT="$1"
JIRA_EPIC="$2"

# Check vault path exists
if [ ! -d "$OBSIDIAN_VAULT_PATH" ]; then
    echo "Error: Obsidian vault path not found: $OBSIDIAN_VAULT_PATH"
    exit 1
fi

PROJECTS_PATH="$OBSIDIAN_VAULT_PATH/$JOURNAL_PROJECTS_FOLDER"

# Determine search scope
if [ -n "$PROJECT" ] && [ -n "$JIRA_EPIC" ]; then
    # Narrow scope: specific project and epic
    SEARCH_PATH="$PROJECTS_PATH/$PROJECT/$JIRA_EPIC/$FLEETING_NOTES_FOLDER"
elif [ -n "$PROJECT" ]; then
    # Mid scope: entire project
    SEARCH_PATH="$PROJECTS_PATH/$PROJECT"
else
    # Broad scope: all projects
    SEARCH_PATH="$PROJECTS_PATH"
fi

# Handle case where the scoped path doesn't exist — fall back to broad search
if [ ! -d "$SEARCH_PATH" ]; then
    if [ -n "$PROJECT" ] || [ -n "$JIRA_EPIC" ]; then
        echo "Warning: Scoped path not found, falling back to broad search: $SEARCH_PATH"
        SEARCH_PATH="$PROJECTS_PATH"
    else
        echo "Error: Projects path not found: $SEARCH_PATH"
        exit 1
    fi
fi

# Find all fleeting notes matching the naming convention
# Pattern: YYYY-MM-DD - * - Fleeting.md
ALL_FLEETING=$(find "$SEARCH_PATH" -type f -name "*- $NOTE_FILE_SUFFIX.md" 2>/dev/null)

if [ -z "$ALL_FLEETING" ]; then
    echo "No fleeting notes found in search path: $SEARCH_PATH"
    exit 1
fi

# Filter for notes with active status, sorted by modification time (newest first)
ACTIVE_NOTE=""
while IFS= read -r NOTE_FILE; do
    STATUS=$(grep "^status: " "$NOTE_FILE" 2>/dev/null | sed 's/^status: //')
    if [ "$STATUS" = "$STATUS_ACTIVE" ]; then
        ACTIVE_NOTE="$NOTE_FILE"
        break
    fi
done < <(echo "$ALL_FLEETING" | xargs ls -t 2>/dev/null)

if [ -z "$ACTIVE_NOTE" ]; then
    echo "No active fleeting note found in search path: $SEARCH_PATH"
    exit 1
fi

# Extract metadata from the active note
NOTE_NAME=$(basename "$ACTIVE_NOTE" .md)
NOTE_TITLE=$(grep "^title: " "$ACTIVE_NOTE" | sed 's/^title: //')
NOTE_PROJECT=$(grep "^project: " "$ACTIVE_NOTE" | sed 's/^project: //')
NOTE_JIRA=$(grep "^jira: " "$ACTIVE_NOTE" | sed 's/^jira: //')
NOTE_TYPE=$(grep "^type: " "$ACTIVE_NOTE" | sed 's/^type: //')
NOTE_MODIFIED=$(grep "^modified: " "$ACTIVE_NOTE" | sed 's/^modified: //')

echo "Active fleeting note found:"
echo "  Title:    $NOTE_TITLE"
echo "  Type:     $NOTE_TYPE"
echo "  Project:  $NOTE_PROJECT"
echo "  Jira:     $NOTE_JIRA"
echo "  Modified: $NOTE_MODIFIED"
echo ""
echo "NOTE_PATH=$ACTIVE_NOTE"
echo "NOTE_NAME=$NOTE_NAME"
echo "NOTE_TITLE=$NOTE_TITLE"
echo "NOTE_PROJECT=$NOTE_PROJECT"
echo "NOTE_JIRA=$NOTE_JIRA"
echo "NOTE_TYPE=$NOTE_TYPE"
echo "NOTE_MODIFIED=$NOTE_MODIFIED"
