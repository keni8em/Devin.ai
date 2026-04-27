#!/bin/bash

# Fleeting Notes Configuration
# Configuration specific to the fleeting-notes skill

# Skill Paths
DEVIN_SKILL_PATH="$HOME/.config/devin/skills/obsidian/fleeting_notes"
DAILY_JOURNAL_SKILL_PATH="$HOME/.config/devin/skills/obsidian/daily_journal"

# Vault Configuration
OBSIDIAN_VAULT_PATH="/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian/OIL Notebook"

# Obsidian Structure
JOURNAL_PROJECTS_FOLDER="OIL R&D Journal"
FLEETING_NOTES_FOLDER="Fleeting Notes"
TEMPLATES_FOLDER="Templates"
FLEETING_NOTE_TEMPLATE="Fleeting Note Template"

# File Naming
NOTE_FILE_SUFFIX="Fleeting"

# Date/Time Configuration
DATE_FORMAT="%Y-%m-%d"
DATETIME_FORMAT="%Y-%m-%d %H:%M"
TIME_FORMAT="%H:%M"

# Jira Epic Identifier
JIRA_EPIC_IDENTIFIER="OCTO-"

# Note Types
NOTE_TYPES=("technical-execution" "research" "debugging" "design" "meeting" "literature" "ideation")

# Frontmatter Status Values
STATUS_ACTIVE="active"
STATUS_NEEDS_PROCESSING="needs-processing"

# Section Names (must match template exactly)
SECTION_GOAL="Goal"
SECTION_STEPS="Steps & Commands"
SECTION_HYPOTHESIS="Hypothesis & Tests"
SECTION_DECISIONS="Design Decisions"
SECTION_REFERENCES="Sources & References"
SECTION_OBSERVATIONS="Observations & Comments"
SECTION_BLOCKERS="Blockers & Open Questions"
SECTION_FOLLOWUP="Follow-up"
