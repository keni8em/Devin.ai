#!/bin/bash
# Obsidian Skills Configuration
# Shared configuration variables for all Obsidian-related skills

# Obsidian Vault Path
# The main directory containing your Obsidian vault
OBSIDIAN_VAULT_PATH="/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian"

# GitHub Repository Configuration
# GitHub repository URL for vault backup (if applicable)
OBSIDIAN_GITHUB_REPO="https://github.com/keni8em/Obsidian.git"

# Default Git Configuration
# Used for automatic git identity setup
GIT_USER_NAME="Devin Backup"
GIT_USER_EMAIL="devin@backup.local"

# Daily Journal Configuration
# Subdirectory within vault for daily journal entries
DAILY_JOURNAL_PATH="Daily Journal"

# Date format for daily journal entries
DAILY_JOURNAL_DATE_FORMAT="%Y-%m-%d"

# Backup Configuration
# Commit message prefix for automatic backups
BACKUP_COMMIT_PREFIX="Obsidian vault backup"

# File patterns to exclude from backups
# Space-separated list of glob patterns
BACKUP_EXCLUDE_PATTERNS=".obsidian/workspace .obsidian/workspace-mobile"

# Skill-specific settings can be added below
# Format: SKILL_NAME_VARIABLE="value"
