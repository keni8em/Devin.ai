# Obsidian Backup Skill

Automatically sync your Obsidian vault with a GitHub repository.

## Quick Start

Get started immediately with these simple commands:

**Default backup with timestamp:**
```bash
skill obsidian-backup
```

**Custom commit message:**
```bash
skill obsidian-backup "Updated daily journal with new entries"
```

## Why Use This Skill?

- **No manual git operations**: Skip the complexity of git commands
- **One-command backup**: Execute a single command to sync your entire vault
- **Accurate change detection**: Only commits when there are actual changes
- **Automatic configuration**: Handles git setup and user identity automatically
- **Error resilience**: Graceful handling of network issues, authentication, and conflicts
- **No approval prompts**: All operations run in a single script execution

## Overview

This skill provides a simple way to backup your Obsidian vault to GitHub without needing to manually run git commands. It handles all the git operations automatically: checking for changes, staging files, creating commits, and pushing to your remote repository.

## Requirements

- Git installed on your system
- Obsidian vault initialized as a git repository
- GitHub remote configured (optional but recommended for full functionality)
- Devin AI with access to the skills system

## Installation & Configuration

### Installation

The skill is located in your Devin configuration:
```
/home/moorek8/.config/devin/skills/obsidian/obsidian-backup/
```

No additional installation is required - it's part of your Devin configuration.

### Configuration

#### Default Vault Path

The backup script uses this default vault path:
```
/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian
```

To change this, edit the `VAULT_PATH` variable in `backup.sh`.

#### GitHub Remote Setup

If your vault doesn't have a GitHub remote configured, the script will:
- Initialize a local git repository if needed
- Configure git user identity if not set
- Commit changes locally
- Skip the push step and prompt you to add a remote manually

To add a remote:
```bash
cd /path/to/your/vault
git remote add origin https://github.com/your-username/your-repo.git
```

#### Git User Identity

The script automatically configures git user identity if not set:
- **User name**: "Devin Backup"
- **Email**: "devin@backup.local"

This ensures commits can be created even if git is not configured on your system.

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

## How It Works

The skill follows this streamlined process:

1. **User invokes skill**: `skill obsidian-backup "custom message"`
2. **SKILL.md instructions**: Directs execution of backup script
3. **backup.sh execution**:
   - Navigates to your Obsidian vault directory
   - Checks if it's a git repository (initializes if needed)
   - Configures git user identity if not already set
   - Gets the current branch for proper tracking
   - Checks if GitHub remote is configured
   - Stages all modified files (for accurate change detection)
   - Checks for changes after staging (more accurate detection)
   - Shows what will be committed
   - Creates a commit with your message or a timestamp (with error handling)
   - Pushes changes to GitHub (if remote is configured)
   - Displays a summary of the backup operation
4. **Result**: Vault is synced with GitHub without manual intervention

### Key Features

- **Accurate change detection**: Stages files first, then checks for changes
- **Custom commit messages**: Optional commit message support
- **Automatic timestamps**: Generates timestamp-based commit messages by default
- **Git identity configuration**: Automatically sets git user if not configured
- **Error handling**: Handles common git issues gracefully with clear error messages
- **No approval prompts**: All operations run in a single script execution

## Advanced Usage

### Detailed Output Example

The script provides clear feedback at each step:

```
=== Obsidian Vault Backup Script ===
Vault path: /path/to/vault
Commit message: Obsidian vault backup: 2026-04-20 15:52:40

Remote configured: https://github.com/username/repo.git
Staging changes...
Checking for changes...

Changes to be committed:
 file1.md | 5 +----
 file2.md | 3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

Creating commit...
[main abc1234] Obsidian vault backup: 2026-04-20 15:52:40
 2 files changed, 5 insertions(+), 3 deletions(-)
Commit created: abc1234

Pushing to remote...
Current branch: main
To https://github.com/username/repo.git
   def5678..abc1234  main -> main
Push successful

=== Backup Summary ===
Status: Success
Commit: abc1234
Branch: main
Timestamp: 2026-04-20 15:52:40
Remote: https://github.com/username/repo.git

Backup completed successfully!
```

### Custom Vault Path

To use a different vault path, you can either:
1. Edit the `VAULT_PATH` variable in `backup.sh`, or
2. Create a copy of the skill with a different configuration

## Troubleshooting

### "No changes detected"
This means your vault is already up to date with GitHub. No backup is needed. The script stages files first before checking for changes to ensure accurate detection.

### "Git user identity configured"
This is normal when the script automatically sets up git user identity for the first time. This ensures commits can be created even if git is not configured on your system.

### "Another git process seems to be running"
This happens when a previous git operation was interrupted. Remove the lock file:
```bash
rm /path/to/vault/.git/index.lock
```

### "Error: Failed to create commit"
This can happen if there's an issue with the git operation. The script provides better error handling and will exit with a clear error message instead of continuing with undefined variables.

### "Push failed"
This can happen due to:
- Network connectivity issues
- Authentication problems
- Remote repository not accessible

The script commits changes locally and displays instructions for manual push with the exact commands needed.

### "No remote configured"
You need to add a GitHub remote:
```bash
cd /path/to/vault
git remote add origin https://github.com/your-username/your-repo.git
```

## Files

The skill folder structure:

```
obsidian-backup/
├── SKILL.md          # Skill configuration and execution instructions
├── backup.sh         # Main backup script that handles git operations
└── README.md         # This documentation file
```

### File Descriptions

- **SKILL.md**: Contains the skill configuration, including:
  - Skill name and description
  - Allowed tools (exec for running scripts)
  - Triggers (model and user initiated)
  - Instructions for executing the backup script
  - Example usage patterns

- **backup.sh**: The bash script that performs the actual backup:
  - Navigates to the Obsidian vault directory
  - Initializes git repository if needed
  - Configures git user identity automatically
  - Stages all changes for accurate detection
  - Creates commits with custom or timestamp messages
  - Pushes to GitHub remote if configured
  - Provides detailed progress feedback and error handling

- **README.md**: Comprehensive documentation covering:
  - Quick start guide for immediate usage
  - Feature overview and capabilities
  - Installation and configuration instructions
  - Usage examples for basic and advanced scenarios
  - Detailed operation flow
  - Troubleshooting guide for common issues

## License

This skill is part of your personal Devin configuration.
