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

### daily-journal
Create daily journal entries in your Obsidian vault.

- **Purpose**: Automated daily journal creation
- **Location**: `daily-journal/`
- **Usage**: `skill daily-journal`
- **Documentation**: See `daily-journal/SKILL.md`

## Structure

```
obsidian/
├── README.md              # This file - overview of Obsidian skills
├── daily-journal/         # Daily journal automation skill
│   ├── SKILL.md          # Skill configuration
│   └── config.sh         # Journal-specific configuration
└── obsidian-backup/      # Vault backup skill
    ├── SKILL.md          # Skill configuration
    ├── backup.sh         # Backup script
    ├── config.sh         # Backup-specific configuration
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

## Purpose

These skills focus on:

- **Vault Management**: Backup, sync, and version control for Obsidian vaults
- **Note Automation**: Automated note creation and organization
- **Workflow Enhancement**: Streamlining repetitive Obsidian tasks
- **Integration**: Connecting Obsidian with external tools and services
- **Productivity**: Reducing manual overhead in knowledge management

## Difference from Other Skills

Unlike general-purpose skills (like the devin-backup in the `devin.ai/` folder), skills in this directory are specifically designed for:

- Obsidian vault operations
- Note-taking and knowledge management workflows
- Content creation and organization
- PKM (Personal Knowledge Management) tasks

## Adding New Skills

To add a new Obsidian-specific skill:

1. Create a new subfolder: `mkdir obsidian/your-skill-name/`
2. Add the required files:
   - `SKILL.md` - Skill configuration and instructions
   - Implementation files (scripts, templates, etc.)
   - `config.sh` - Skill-specific configuration
   - `README.md` - Documentation
3. Follow the existing structure and naming conventions
4. Update this README to include the new skill

## Requirements

- Obsidian installed and configured
- Appropriate vault access permissions
- Git installed (for backup operations)
- GitHub account (for remote backup operations)
- Devin AI with access to the skills system

## Configuration

Skills in this directory may require:

- Obsidian vault path configuration
- Git repository setup (for backup operations)
- GitHub CLI authentication (for remote backup)
- Template files (for journal creation)
- Plugin dependencies (depending on skill functionality)

### Skill-Specific Configuration

- **obsidian-backup**: Uses `obsidian-backup/config.sh`
  - Vault path, GitHub settings, backup preferences
- **daily-journal**: Uses `daily-journal/config.sh`
  - Vault path, journal folder, date/time formats

### Benefits

- **Independence**: Each skill is self-contained
- **Simplicity**: Easy to understand and modify
- **Isolation**: Changes to one skill don't affect others
- **Clarity**: Configuration is close to the code that uses it

### Customization

To modify a skill's configuration:

1. Edit the `config.sh` file in the skill's directory
2. Change the desired variable values
3. The skill automatically uses the updated configuration

## Contributing

When adding new skills to this directory:

1. Ensure the skill is specifically related to Obsidian operations
2. Follow the established structure and documentation patterns
3. Include comprehensive README documentation
4. Test thoroughly with various Obsidian setups
5. Consider different vault configurations and use cases
6. Update this main README to document the new skill

## Related Directories

- `devin.ai/` - Skills for Devin.ai CLI system operations
- Other skill directories for different domains

## Support

For issues or questions about specific skills, refer to the individual skill's README documentation in the respective subfolder.

## License

These skills are part of your personal Devin AI configuration.
