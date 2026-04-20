# Obsidian Skills

This directory hosts custom skills specifically designed for interacting with Obsidian vaults and enhancing Obsidian workflow automation.

## Overview

The Obsidian skills folder contains specialized skills that integrate with Obsidian, the powerful knowledge base application. These skills automate vault operations, streamline note-taking workflows, and enhance productivity when working with Obsidian.

## Available Skills

### obsidian-backup
Automatically sync your Obsidian vault with a GitHub repository.

- **Purpose**: Backup and version control for Obsidian vaults
- **Location**: `obsidian-backup/`
- **Usage**: `skill obsidian-backup [commit message]`
- **Documentation**: See `obsidian-backup/README.md`
- **Features**:
  - Automatic git operations
  - Accurate change detection
  - Custom commit messages
  - Error handling and authentication

### daily-journal
Create daily journal entries in your Obsidian vault.

- **Purpose**: Automated daily journal creation
- **Location**: `daily-journal/`
- **Usage**: `skill daily-journal`
- **Documentation**: See `daily-journal/SKILL.md`
- **Features**:
  - Daily note creation
  - Template support
  - Date-based organization

## Structure

```
obsidian/
├── README.md              # This file - overview of Obsidian skills
├── CONFIG.md              # Configuration file documentation
├── config.sh              # Shared configuration variables
├── daily-journal/          # Daily journal automation skill
│   └── SKILL.md          # Skill configuration
└── obsidian-backup/       # Vault backup skill
    ├── SKILL.md          # Skill configuration
    ├── backup.sh         # Backup script
    └── README.md         # Skill documentation
```

## Usage

All skills in this directory can be invoked using the standard Devin.ai skill syntax:

```bash
# List available skills
skill list

# Invoke a specific skill
skill <skill-name> [arguments]

# Example: Backup Obsidian vault
skill obsidian-backup "Updated daily notes"

# Example: Create daily journal entry
skill daily-journal
```

## Configuration

Obsidian skills use a centralized configuration system to manage shared settings across all skills.

### Configuration File

The `config.sh` file contains shared variables used by all Obsidian skills:

- **Vault path**: Centralized Obsidian vault location
- **GitHub repository**: Repository URL for backup operations
- **Git settings**: Default user identity for commits
- **Journal settings**: Daily journal configuration
- **Backup preferences**: Commit message formats and exclusions

### Benefits

- **Single source of truth**: Update settings in one place
- **Consistency**: All skills use the same configuration
- **Maintainability**: Easy to update paths and settings
- **Flexibility**: Simple to customize for different environments

### Customization

To modify configuration:

1. Edit `config.sh` in the obsidian folder
2. Change the desired variable values
3. All skills automatically use the updated configuration

See `CONFIG.md` for detailed configuration documentation.

## Purpose

These skills focus on:

- **Vault Management**: Backup, sync, and version control for Obsidian vaults
- **Note Automation**: Automated note creation and organization
- **Workflow Enhancement**: Streamlining repetitive Obsidian tasks
- **Integration**: Connecting Obsidian with external tools and services
- **Productivity**: Reducing manual overhead in knowledge management

## Typical Use Cases

### Knowledge Management
- Automatic vault backups to prevent data loss
- Version control for tracking note changes
- Sync across multiple devices

### Daily Workflow
- Automated daily journal creation
- Template-based note generation
- Consistent note organization

### Research & Writing
- Backup research notes
- Track changes in Zettelkasten
- Maintain version history of important documents

## Configuration

Skills in this directory may require:

- Obsidian vault path configuration
- Git repository setup (for backup operations)
- GitHub CLI authentication (for remote backup)
- Template files (for journal creation)
- Plugin dependencies (depending on skill functionality)

## Default Vault Path

Most Obsidian skills use this default vault path:
```
/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian
```

To customize this for your setup, edit the respective skill configuration files.

## Adding New Skills

To add a new Obsidian-specific skill:

1. Create a new subfolder: `mkdir obsidian/your-skill-name/`
2. Add the required files:
   - `SKILL.md` - Skill configuration and instructions
   - Implementation files (scripts, templates, etc.)
   - `README.md` - Documentation (recommended)
3. Follow the existing structure and naming conventions
4. Update this README to include the new skill
5. Test thoroughly with your Obsidian setup

## Requirements

- Obsidian installed and configured
- Appropriate vault access permissions
- Git installed (for backup operations)
- GitHub account (for remote backup operations)
- Devin AI with access to the skills system

## Best Practices

### Backup Strategy
- Use obsidian-backup regularly, especially after significant changes
- Consider automated scheduled backups
- Test backup restoration process periodically

### Journal Workflow
- Use daily-journal as part of a consistent daily routine
- Customize templates to match your workflow
- Integrate with other productivity tools

### Vault Organization
- Maintain consistent folder structure
- Use meaningful file naming conventions
- Leverage Obsidian plugins for enhanced functionality

## Integration with Obsidian Plugins

These skills work well with popular Obsidian plugins:

- **Obsidian Git**: Alternative git integration within Obsidian
- **Templater**: Advanced template functionality
- **Daily Notes**: Built-in daily note creation
- **Calendar**: Calendar-based note navigation

## Related Directories

- `devin.ai/` - Skills for Devin.ai CLI system operations
- Other skill directories for different domains

## Troubleshooting

### Common Issues

**Vault path not found**
- Ensure the vault path is correctly configured
- Check that the vault is accessible from your current environment
- Update the path in skill configuration files

**Git authentication failures**
- Verify GitHub CLI is authenticated: `gh auth status`
- Check repository permissions
- Ensure remote URL is correct

**Plugin conflicts**
- Some Obsidian plugins may conflict with external git operations
- Consider disabling automatic git operations in Obsidian when using backup skills
- Test skill functionality with plugins disabled

## Support

For issues or questions about specific skills, refer to the individual skill's README documentation in the respective subfolder.

## Contributing

When adding new skills to this directory:

1. Ensure the skill is specifically related to Obsidian operations
2. Follow the established structure and documentation patterns
3. Include comprehensive README documentation
4. Test thoroughly with various Obsidian setups
5. Consider different vault configurations and use cases
6. Update this main README to document the new skill

## Future Enhancements

Potential areas for skill development:

- Advanced search and query operations
- Note linking and relationship mapping
- Content analysis and summarization
- Cross-vault operations
- Integration with other PKM tools
- Automated tagging and categorization

## License

These skills are part of your personal Devin AI configuration.
