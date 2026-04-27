#!/bin/bash

# Script to create a new fleeting note from template
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Parse parameters
TITLE="$1"
TYPE="$2"
GOAL="$3"
PROJECT="$4"
JIRA_EPIC="$5"

# Validate required parameters
if [ -z "$TITLE" ]; then
    echo "Error: Title is required"
    exit 1
fi
if [ -z "$TYPE" ]; then
    echo "Error: Type is required"
    exit 1
fi
if [ -z "$GOAL" ]; then
    echo "Error: Goal is required"
    exit 1
fi

# Validate note type
VALID_TYPE=false
for T in "${NOTE_TYPES[@]}"; do
    if [ "$TYPE" = "$T" ]; then
        VALID_TYPE=true
        break
    fi
done
if [ "$VALID_TYPE" = false ]; then
    echo "Error: Invalid note type '$TYPE'. Valid types are: ${NOTE_TYPES[*]}"
    exit 1
fi

# Check vault path exists
if [ ! -d "$OBSIDIAN_VAULT_PATH" ]; then
    echo "Error: Obsidian vault path not found: $OBSIDIAN_VAULT_PATH"
    exit 1
fi

# Determine folder path based on whether Jira Epic is provided
PROJECTS_PATH="$OBSIDIAN_VAULT_PATH/$JOURNAL_PROJECTS_FOLDER"

if [ -n "$PROJECT" ] && [ -n "$JIRA_EPIC" ]; then
    NOTES_PATH="$PROJECTS_PATH/$PROJECT/$JIRA_EPIC/$FLEETING_NOTES_FOLDER"
elif [ -n "$PROJECT" ]; then
    NOTES_PATH="$PROJECTS_PATH/$PROJECT/$FLEETING_NOTES_FOLDER"
else
    NOTES_PATH="$PROJECTS_PATH/$FLEETING_NOTES_FOLDER"
fi

# Create folder if it does not exist
mkdir -p "$NOTES_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create directory: $NOTES_PATH"
    exit 1
fi

# Generate timestamps
DATE=$(date +"$DATE_FORMAT")
DATETIME=$(date +"$DATETIME_FORMAT")

# Sanitize title for use in filename (replace characters not safe for filenames)
SAFE_TITLE=$(echo "$TITLE" | sed 's|[/:\\*?"<>|]|-|g' | sed 's/  */ /g' | sed 's/^ //;s/ $//')

# Generate note filename and path
NOTE_FILE="$DATE - $SAFE_TITLE - $NOTE_FILE_SUFFIX.md"
NOTE_PATH="$NOTES_PATH/$NOTE_FILE"

# Check if a note with this name already exists
if [ -f "$NOTE_PATH" ]; then
    echo "Error: Fleeting note already exists: $NOTE_PATH"
    echo "NOTE_PATH=$NOTE_PATH"
    echo "NOTE_FILE=$NOTE_FILE"
    exit 1
fi

# Build tags array
TAGS="[$NOTE_FILE_SUFFIX"
if [ -n "$PROJECT" ]; then
    TAGS="$TAGS, $PROJECT"
fi
if [ -n "$JIRA_EPIC" ]; then
    # Extract just the OCTO-XXXXX identifier from the epic string
    EPIC_TAG=$(echo "$JIRA_EPIC" | grep -oE "${JIRA_EPIC_IDENTIFIER}[0-9]+" | head -1)
    if [ -n "$EPIC_TAG" ]; then
        TAGS="$TAGS, $EPIC_TAG"
    fi
fi
TAGS="$TAGS]"

# Check if template exists
TEMPLATE_PATH="$OBSIDIAN_VAULT_PATH/$TEMPLATES_FOLDER/$FLEETING_NOTE_TEMPLATE.md"

if [ -f "$TEMPLATE_PATH" ]; then
    # Copy template to new note
    cp "$TEMPLATE_PATH" "$NOTE_PATH"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to copy template to: $NOTE_PATH"
        exit 1
    fi

    # Replace Obsidian Templater date placeholders with actual values
    sed -i "s/{{date:YYYY-MM-DD HH:mm}}/$DATETIME/g" "$NOTE_PATH"

    # Populate frontmatter fields
    sed -i "s|^title: $|title: $TITLE|" "$NOTE_PATH"
    sed -i "s|^project: $|project: $PROJECT|" "$NOTE_PATH"
    sed -i "s|^jira: $|jira: $JIRA_EPIC|" "$NOTE_PATH"
    sed -i "s|^type: $|type: $TYPE|" "$NOTE_PATH"
    sed -i "s|^tags: \[\]$|tags: $TAGS|" "$NOTE_PATH"

    echo "Created fleeting note from template: $NOTE_PATH"
else
    # Template not found — create note with basic structure
    echo "Warning: Template not found at $TEMPLATE_PATH — creating with basic structure"

    cat > "$NOTE_PATH" << EOF
---
title: $TITLE
project: $PROJECT
jira: $JIRA_EPIC
type: $TYPE
status: $STATUS_ACTIVE
created: $DATETIME
modified: $DATETIME
tags: $TAGS
---

## Goal
$GOAL

## Steps & Commands

## Hypothesis & Tests

## Design Decisions

## Sources & References

## Observations & Comments

## Blockers & Open Questions

## Follow-up
EOF

    echo "Created fleeting note with basic structure: $NOTE_PATH"
fi

# If template was used, write the goal into the Goal section
if [ -f "$TEMPLATE_PATH" ]; then
    python3 << PYEOF
with open('$NOTE_PATH', 'r') as f:
    content = f.read()

goal_header = '## Goal'
lines = content.split('\n')
goal_line = None

for i, line in enumerate(lines):
    if line.strip() == goal_header:
        goal_line = i
        break

if goal_line is not None:
    # Insert goal after the header line, preserving any blank line
    insert_at = goal_line + 1
    while insert_at < len(lines) and lines[insert_at].strip() == '':
        insert_at += 1
    lines.insert(insert_at, '$GOAL')

    with open('$NOTE_PATH', 'w') as f:
        f.write('\n'.join(lines))
PYEOF
fi

# Output structured result for skill to parse
echo ""
echo "NOTE_PATH=$NOTE_PATH"
echo "NOTE_FILE=$NOTE_FILE"
echo "NOTE_TITLE=$TITLE"
echo "NOTE_TYPE=$TYPE"
echo "NOTE_PROJECT=$PROJECT"
echo "NOTE_JIRA=$JIRA_EPIC"
