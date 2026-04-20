# Obsidian Backup

Simple backup script to sync your Obsidian vault with GitHub.

## What It Does

This skill backs up your Obsidian vault to a GitHub repository by:
- Checking for changes in your vault
- Staging and committing changes
- Pushing to GitHub

## Usage

```bash
# Backup with automatic timestamp message
skill obsidian-backup

# Backup with custom message
skill obsidian-backup "Updated daily notes"
```

## Configuration

The script uses this vault path:
```
/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian
```

To change it, edit the `VAULT_PATH` variable in `backup.sh`.

## Requirements

- Git installed
- GitHub repository configured as remote
- Obsidian vault initialized as git repository

## Files

- `SKILL.md` - Skill configuration
- `backup.sh` - Backup script
- `README.md` - This file