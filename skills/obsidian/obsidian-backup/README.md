# Obsidian Backup Skill

Automatically sync your Obsidian vault with a GitHub repository.

## Overview

This skill provides a simple way to backup your Obsidian vault to GitHub without needing to manually run git commands. It handles all the git operations automatically: checking for changes, staging files, creating commits, and pushing to your remote repository.

## Features

- **Automatic git operations**: No manual git commands needed
- **Change detection**: Only commits when there are actual changes
- **Custom commit messages**: Optional commit message support
- **Automatic timestamps**: Generates timestamp-based commit messages by default
- **Error handling**: Handles common git issues gracefully
- **No approval prompts**: All operations run in a single script execution

## Requirements

- Git installed on your system
- Obsidian vault initialized as a git repository
- GitHub remote configured (optional but recommended for full functionality)

## Installation

The skill is located at:
```
/home/moorek8/.config/devin/skills/obsidian/obsidian-backup/
```

## Configuration

### Default Vault Path

The backup script uses this default vault path:
```
/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian
```

To change this, edit the `VAULT_PATH` variable in `backup.sh`.

### GitHub Remote

If your vault doesn't have a GitHub remote configured, the script will:
- Initialize a local git repository if needed
- Commit changes locally
- Skip the push step and prompt you to add a remote manually

To add a remote:
```bash
cd /path/to/your/vault
git remote add origin https://github.com/your-username/your-repo.git
```

## Usage

### Basic Usage

Run the skill with default timestamp commit message:
```
skill obsidian-backup
```

### Custom Commit Message

Run with a custom commit message:
```
skill obsidian-backup "Updated daily journal with new entries"
```

## What It Does

When you run the skill, the backup script:

1. **Navigates** to your Obsidian vault directory
2. **Checks** if it's a git repository (initializes if needed)
3. **Detects** any changes since the last backup
4. **Stages** all modified files
5. **Creates** a commit with your message or a timestamp
6. **Pushes** changes to GitHub (if remote is configured)
7. **Displays** a summary of the backup operation

## Output

The script provides clear feedback at each step:

```
=== Obsidian Vault Backup Script ===
Vault path: /path/to/vault
Commit message: Obsidian vault backup: 2026-04-20 15:52:40

Remote configured: https://github.com/username/repo.git
Checking for changes...

Changes to be committed:
 M "file1.md"
 M "file2.md"

Staging changes...
Creating commit...
[main abc1234] Obsidian vault backup: 2026-04-20 15:52:40
 2 files changed, 5 insertions(+), 3 deletions(-)

Pushing to remote...
Current branch: main
To https://github.com/username/repo.git
   def5678..abc1234  main -> main

=== Backup Summary ===
Status: Success
Commit: abc1234
Branch: main
Timestamp: 2026-04-20 15:52:40
Remote: https://github.com/username/repo.git
```

## Troubleshooting

### "No changes detected"
This means your vault is already up to date with GitHub. No backup is needed.

### "Another git process seems to be running"
This happens when a previous git operation was interrupted. Remove the lock file:
```bash
rm /path/to/vault/.git/index.lock
```

### "Push failed"
This can happen due to:
- Network connectivity issues
- Authentication problems
- Remote repository not accessible

The script will commit changes locally and display instructions for manual push.

### "No remote configured"
You need to add a GitHub remote:
```bash
cd /path/to/vault
git remote add origin https://github.com/your-username/your-repo.git
```

## Files

- `SKILL.md` - Skill configuration and instructions
- `backup.sh` - The backup script that handles all git operations
- `README.md` - This file

## License

This skill is part of your personal Devin configuration.
