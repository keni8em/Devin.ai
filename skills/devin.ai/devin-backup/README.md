# Devin Configuration Backup Skill

Automatically sync your Devin configuration with a GitHub repository.

## Quick Start

Get started immediately with these simple commands:

**Default backup with timestamp:**
```bash
skill devin-backup
```

**Custom commit message:**
```bash
skill devin-backup "Updated skills configuration"
```

## Why Use This Skill?

- **No manual git operations**: Skip the complexity of git commands
- **One-command backup**: Execute a single command to sync your entire configuration
- **Accurate change detection**: Only commits when there are actual changes
- **Automatic configuration**: Handles git setup and user identity automatically
- **Error resilience**: Graceful handling of network issues, authentication, and conflicts
- **No approval prompts**: All operations run in a single script execution

## Overview

This skill provides a simple way to backup your Devin configuration to GitHub without needing to manually run git commands. It uses a layered architecture to avoid approval prompts while maintaining intelligent decision-making.

## Architecture

The skill uses a **layered approach** to solve the approval prompt problem:

- **SKILL.md Layer**: Intelligent interface that:
  - Understands user intent and natural language requests
  - Prepares parameters (commit messages, context)
  - Makes decisions about when to execute backup
  - Executes the script with appropriate parameters

- **backup.sh Layer**: Technical execution that:
  - Handles all git operations (add, commit, push)
  - Performs change detection (answers "is backup needed?")
  - Manages file system operations
  - Provides progress feedback and error handling
  - **Never asks for approval** - all operations batched together

- **config.sh Layer**: Configuration that:
  - Stores user-configurable settings (config path, git identity)
  - Separates configuration from implementation
  - Easy to customize without touching code

**Why this approach?**
When the SKILL does everything directly, you get asked to approve each git command. By batching all technical operations in the backup.sh script, you get intelligent decision-making from the SKILL but no approval prompts for the technical work.

## Requirements

- Git installed on your system
- ~/.config/devin/ initialized as a git repository
- GitHub remote configured (optional but recommended for full functionality)
- Devin AI with access to the skills system

## Installation & Configuration

### Installation

The skill is located in your Devin configuration:
```
/home/moorek8/.config/devin/skills/devin.ai/devin-backup/
```

No additional installation is required - it's part of your Devin configuration.

### Configuration

#### Default Config Path

The backup script uses the config path from its configuration file:
```
/home/moorek8/.config/devin
```

To change this, edit the `DEVIN_CONFIG_PATH` variable in the skill's configuration file:
```bash
/home/moorek8/.config/devin/skills/devin.ai/devin-backup/config.sh
```

#### GitHub Remote Setup

If your config directory doesn't have a GitHub remote configured, the script will:
- Initialize a local git repository if needed
- Configure git user identity if not set
- Commit changes locally
- Skip the push step and prompt you to add a remote manually

To add a remote:
```bash
cd ~/.config/devin
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
skill devin-backup
```

### Custom Commit Message

Run with a custom commit message:
```
skill devin-backup "Updated skills configuration"
```

## How It Works

The skill follows this streamlined process with clear separation of concerns:

1. **User invokes skill**: `skill devin-backup "custom message"`
2. **SKILL.md (Intent Assessment & Parameter Preparation)**:
   - Assesses user's intent and request context
   - Reads configuration file to get config path
   - Prepares commit message (user-provided or default timestamp)
   - Executes backup script with appropriate parameters
3. **backup.sh (Technical Execution)**:
   - Navigates to your ~/.config/devin/ directory
   - Checks if it's a git repository (initializes if needed)
   - Configures git user identity if not already set
   - Gets the current branch for proper tracking
   - Checks if GitHub remote is configured
   - Stages all modified files
   - **Detects changes** (determines if backup is needed)
   - Shows what will be committed
   - Creates a commit with your message or a timestamp (with error handling)
   - Pushes changes to GitHub (if remote configured)
   - Displays a summary of the backup operation
4. **Result**: Configuration is synced with GitHub without manual intervention

**Key Separation of Concerns:**
- **SKILL.md**: Understands user intent, prepares parameters, executes script
- **backup.sh**: Handles all git operations, change detection, file system operations
- **config.sh**: Stores user-configurable settings
- **No approval prompts**: All technical operations batched in script execution

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
=== Devin Config Backup Script ===
Config path: /home/moorek8/.config/devin
Commit message: Devin config backup: 2026-04-20 15:52:40

Remote configured: https://github.com/username/repo.git
Staging changes...
Checking for changes...

Changes to be committed:
 skills/devin.ai/backup.sh | 5 +----
 config.json              | 3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

Creating commit...
[main abc1234] Devin config backup: 2026-04-20 15:52:40
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

### Custom Config Path

To use a different config path, you can either:
1. Edit the `DEVIN_CONFIG_PATH` variable in `config.sh`, or
2. Create a copy of the skill with a different configuration

## Troubleshooting

### "No changes detected"
This means your configuration is already up to date with GitHub. No backup is needed. The script stages files first before checking for changes to ensure accurate detection.

### "Git user identity configured"
This is normal when the script automatically sets up git user identity for the first time. This ensures commits can be created even if git is not configured on your system.

### "Another git process seems to be running"
This happens when a previous git operation was interrupted. Remove the lock file:
```bash
rm ~/.config/devin/.git/index.lock
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
cd ~/.config/devin
git remote add origin https://github.com/your-username/your-repo.git
```

## Files

The skill folder structure:

```
devin.ai/
└── devin-backup/
    ├── SKILL.md          # Skill configuration and execution instructions
    ├── backup.sh         # Main backup script that handles git operations
    ├── config.sh         # Skill-specific configuration
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
  - Navigates to the ~/.config/devin/ directory
  - Initializes git repository if needed
  - Configures git user identity automatically
  - Stages all changes for accurate detection
  - Creates commits with custom or timestamp messages
  - Pushes to GitHub remote if configured
  - Provides detailed progress feedback and error handling

- **config.sh**: Skill-specific configuration file:
  - Config path and GitHub repository settings
  - Git user identity configuration
  - Backup preferences and commit message formats
  - File exclusion patterns

- **README.md**: Comprehensive documentation covering:
  - Quick start guide for immediate usage
  - Feature overview and capabilities
  - Installation and configuration instructions
  - Usage examples for basic and advanced scenarios
  - Detailed operation flow
  - Troubleshooting guide for common issues
  - Located at: /home/moorek8/.config/devin/skills/devin.ai/devin-backup/

## License

This skill is part of your personal Devin configuration.
