# Obsidian Skills Configuration

This file contains shared configuration variables used across all Obsidian-related skills in this directory.

## Usage

This configuration file is automatically sourced by Obsidian skill scripts. To use it in a script:

```bash
# Get the script directory and source the config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

# Use the configuration variables
echo "Vault path: $OBSIDIAN_VAULT_PATH"
echo "Git user: $GIT_USER_NAME"
```

## Configuration Variables

### Vault Configuration

- **OBSIDIAN_VAULT_PATH**: Path to your main Obsidian vault directory
  - Default: `/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian`
  - Used by: All vault-related operations

### GitHub Configuration

- **OBSIDIAN_GITHUB_REPO**: GitHub repository URL for vault backup
  - Default: `https://github.com/keni8em/Obsidian.git`
  - Used by: Backup and sync operations

### Git Configuration

- **GIT_USER_NAME**: Default git user name for automatic commits
  - Default: `Devin Backup`
  - Used by: Automatic git operations

- **GIT_USER_EMAIL**: Default git email for automatic commits
  - Default: `devin@backup.local`
  - Used by: Automatic git operations

### Daily Journal Configuration

- **DAILY_JOURNAL_PATH**: Subdirectory for daily journal entries
  - Default: `Daily Journal`
  - Used by: Daily journal creation skill

- **DAILY_JOURNAL_DATE_FORMAT**: Date format for journal entries
  - Default: `%Y-%m-%d`
  - Used by: Daily journal creation skill

### Backup Configuration

- **BACKUP_COMMIT_PREFIX**: Prefix for automatic backup commit messages
  - Default: `Obsidian vault backup`
  - Used by: Backup operations

- **BACKUP_EXCLUDE_PATTERNS**: File patterns to exclude from backups
  - Default: `.obsidian/workspace .obsidian/workspace-mobile`
  - Used by: Backup filtering (if implemented)

## Modifying Configuration

To modify any configuration variable:

1. Edit this file (`config.sh`)
2. Change the desired variable value
3. Save the file
4. Changes will be automatically picked up by all Obsidian skills

## Example Customization

```bash
# Change vault path
OBSIDIAN_VAULT_PATH="/custom/path/to/your/vault"

# Change git user for commits
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your.email@example.com"

# Customize daily journal location
DAILY_JOURNAL_PATH="Journal/Daily"

# Change date format
DAILY_JOURNAL_DATE_FORMAT="%d-%m-%Y"
```

## Adding New Variables

To add a new configuration variable:

1. Add the variable to this file with a descriptive comment
2. Update the relevant skill scripts to use the new variable
3. Document the variable in this README
4. Update the main obsidian folder README if needed

## Security Considerations

- This file may contain sensitive information (repository URLs, email addresses)
- Ensure appropriate file permissions are set
- Consider using environment variables for sensitive data
- Do not commit secrets or API keys to this file

## File Permissions

Ensure the configuration file has appropriate permissions:
```bash
chmod 644 config.sh  # Read/write for owner, read for others
```

## Related Files

- Individual skill scripts in subdirectories
- Main obsidian folder README
- Skill-specific README files
