#!/bin/bash

# Script to log content to a specific section of the active fleeting note
# Source the configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
source "$CONFIG_DIR/config.sh"

# Parse parameters
NOTE_PATH="$1"
SECTION="$2"
CONTENT="$3"
TIMESTAMP="${4:-$(date +"$TIME_FORMAT")}"

# Validate required parameters
if [ -z "$NOTE_PATH" ]; then
    echo "Error: Note path is required"
    exit 1
fi
if [ -z "$SECTION" ]; then
    echo "Error: Section name is required"
    exit 1
fi
if [ -z "$CONTENT" ]; then
    echo "Error: Content is required"
    exit 1
fi

# Check note file exists
if [ ! -f "$NOTE_PATH" ]; then
    echo "Error: Note file not found: $NOTE_PATH"
    exit 1
fi

# Check note is still active
NOTE_STATUS=$(grep "^status: " "$NOTE_PATH" | sed 's/^status: //')
if [ "$NOTE_STATUS" != "$STATUS_ACTIVE" ]; then
    echo "Error: Note is not active (status: $NOTE_STATUS). Cannot append to a closed note."
    exit 1
fi

# Update modified timestamp in frontmatter
DATETIME=$(date +"$DATETIME_FORMAT")
sed -i "s/^modified: .*/modified: $DATETIME/" "$NOTE_PATH"

# Use Python3 to insert content into the correct section
python3 << PYEOF
import sys

note_path = '$NOTE_PATH'
section_name = '$SECTION'
timestamp = '$TIMESTAMP'
raw_content = '''$CONTENT'''

# Format the entry line
entry_line = f'- [{timestamp}] {raw_content}'

with open(note_path, 'r') as f:
    lines = f.readlines()

# Strip trailing newlines for processing
lines = [l.rstrip('\n') for l in lines]

# Find the target section header
section_header = f'## {section_name}'
section_start = None
next_section = None

for i, line in enumerate(lines):
    if line.strip() == section_header:
        section_start = i
    elif section_start is not None and line.startswith('## '):
        next_section = i
        break

if section_start is None:
    print(f'Error: Section "{section_name}" not found in note')
    sys.exit(1)

# Determine insertion point
# Insert at the end of the section content, before the next section header
if next_section is not None:
    insert_at = next_section
    # Step back over trailing blank lines to keep spacing clean
    while insert_at > section_start + 1 and lines[insert_at - 1].strip() == '':
        insert_at -= 1
    lines.insert(insert_at, entry_line)
else:
    # Last section in the file — find end of file content
    insert_at = len(lines)
    while insert_at > section_start + 1 and lines[insert_at - 1].strip() == '':
        insert_at -= 1
    lines.insert(insert_at, entry_line)

# Write back to file
with open(note_path, 'w') as f:
    f.write('\n'.join(lines) + '\n')

print(f'Logged to section: {section_name}')
PYEOF

if [ $? -ne 0 ]; then
    echo "Error: Failed to write content to note"
    exit 1
fi

echo "Content logged to '$SECTION' in: $NOTE_PATH"
