# Devin.ai Custom Skills

This directory hosts custom skills specifically designed for interacting with the Devin.ai CLI system.

## Overview

The Devin.ai CLI skills folder contains specialized skills that extend and enhance the functionality of the Devin.ai command-line interface. These skills are tailored for system-level operations, configuration management, and CLI-specific tasks.

## Available Skills

### devin-backup
Automatically syncs your Devin AI configuration with a GitHub repository.

- **Purpose**: Backup and version control for Devin AI configuration
- **Location**: `devin-backup/`
- **Usage**: `skill devin-ai-backup [commit message]`
- **Documentation**: See `devin-backup/README.md`

## Structure

```
devin.ai/
├── README.md              # This file - overview of Devin.ai CLI skills
└── devin-backup/          # Configuration backup skill
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

# Example: Backup Devin AI configuration
skill devin-ai-backup "Updated configuration"
```

## Purpose

These skills focus on:

- **Configuration Management**: Backing up and syncing Devin AI configurations
- **CLI Integration**: Enhancing CLI-specific workflows
- **System Operations**: Tasks that interact with the Devin.ai system itself
- **Automation**: Streamlining repetitive CLI operations

## Difference from Other Skills

Unlike general-purpose skills (like the Obsidian backup in the `obsidian/` folder), skills in this directory are specifically designed for:

- Devin.ai CLI system interaction
- Configuration and setup automation
- System-level administrative tasks
- CLI workflow optimization

## Adding New Skills

To add a new Devin.ai CLI-specific skill:

1. Create a new subfolder: `mkdir devin.ai/your-skill-name/`
2. Add the required files:
   - `SKILL.md` - Skill configuration and instructions
   - `backup.sh` (or equivalent script) - Implementation
   - `README.md` - Documentation
3. Follow the existing structure and naming conventions
4. Update this README to include the new skill

## Requirements

- Devin AI CLI installed and configured
- Appropriate permissions for system operations
- Git installed (for backup operations)
- GitHub account (for remote backup operations)

## Configuration

Skills in this directory may require:

- GitHub CLI authentication (for backup operations)
- System-level permissions
- Configuration file paths
- API keys or tokens (depending on skill functionality)

## Contributing

When adding new skills to this directory:

1. Ensure the skill is specifically related to Devin.ai CLI operations
2. Follow the established structure and documentation patterns
3. Include comprehensive README documentation
4. Test thoroughly before deployment
5. Update this main README to document the new skill

## Related Directories

- `obsidian/` - Skills for Obsidian vault operations
- Other skill directories for different domains

## Support

For issues or questions about specific skills, refer to the individual skill's README documentation in the respective subfolder.

## License

These skills are part of your personal Devin AI configuration.
