# Daily Journal Skill

A skill for creating and managing daily journal entries in an Obsidian vault with project and Jira Epic context tracking.

## Features

- **Multiple Entry Types**: Support for activities, meetings, notes, and tasks
- **Project Context**: Associate entries with projects from your Obsidian vault
- **Jira Epic Tracking**: Link entries to Jira Epics for better project organization
- **Chronological Ordering**: Activities and meetings are automatically sorted by timestamp
- **Context Reuse**: Remembers your last used project and Jira Epic for efficient logging
- **Template-based**: Creates journal entries from customizable templates

## Requirements

- Obsidian vault with the following structure:
  - Daily Journal folder for journal entries
  - OIL R&D Journal folder for project organization
  - Templates folder with journal templates
- Bash shell environment
- Daily Journal Template file in your Templates folder

## Configuration

Edit `config.sh` to customize paths and settings:

```bash
# Vault Configuration
OBSIDIAN_VAULT_PATH="/path/to/your/obsidian/vault"

# Journal Configuration
JOURNAL_FOLDER="Daily Journal"
JOURNAL_PROJECTS_FOLDER="OIL R&D Journal"
TEMPLATES_FOLDER="Templates"
DAILY_JOURNAL_TEMPLATE="Daily Journal Template"

# Date/Time Configuration
DATE_FORMAT="%Y-%m-%d"
DATE_DISPLAY_FORMAT="%a %d %B %Y"
TIME_FORMAT="%H:%M"

# Section Headers
SECTION_ACTIVITY="Activity Log"
SECTION_MEETINGS="Meetings Log"
SECTION_NOTES="Notes"
SECTION_TASKS="Tasks"
```

## Usage

### Basic Usage

Invoke the skill and follow the prompts:

```
skill journal [entry text]
```

Example:
```
skill journal Completed code review for authentication module
```

### Entry Types

The skill supports four types of entries:

1. **Activities**: Log work and accomplishments
2. **Meetings**: Record meetings with type, duration, and project context
3. **Notes**: Add diary-style thoughts, observations, and insights
4. **Tasks**: Create and manage task lists with project grouping

### Activity Logging

Log activities with optional project and Jira Epic context:

```
skill journal Fixed authentication bug in login module
```

The skill will:
1. Prompt for project selection
2. Prompt for Jira Epic selection (if project selected)
3. Insert the activity in chronological order

### Meeting Logging

Log meetings with details:

```
skill journal Add meeting
```

The skill will prompt for:
- Meeting time (or use current time)
- Title
- Type (e.g., Training, Planning, Review)
- Duration
- Project context (optional)

Meetings are automatically sorted chronologically.

### Note Taking

Add diary-style notes:

```
skill journal Note about challenges faced today
```

The skill will:
- Prompt for project context (optional)
- Prompt for Jira Epic context (optional)
- Generate a summary based on your request context
- Insert the note in chronological order

### Task Management

Create and manage tasks:

```
skill journal Add task to deploy new server
```

Tasks can be:
- Associated with projects for grouping
- Given target dates for future planning
- Automatically grouped by project

### Chronological Ordering

Activities and meetings support backdating. For example:

```
skill journal Log activity at [14:30] for code review completed this morning
```

The skill will insert the entry at the correct chronological position based on the timestamp.

## Journal Structure

The daily journal follows this structure:

```markdown
# Daily Journal - DDD DD MMMM YYYY

## Daily Tasks List

---

## Activity Log

[HH:MM] Activity description | project: Project | Jira Epic: OCTO-12345

---

## Meetings Log

[HH:MM] Meeting title | type: Type | duration: 1 hour | project: Project

---

## Daily Notes

[HH:MM] project: Project | Jira Epic: OCTO-12345
Summary text here

---

## Day's Events
- What happened today?
- What were the highlights?
- What challenges did you face?

---

## Evening Reflection
- What went well today?
- What could have been better?
- What are you grateful for?

---

## Tomorrow
- What are your plans for tomorrow?
```

## Project Organization

Projects are organized in the `OIL R&D Journal` folder with the following structure:

```
OIL R&D Journal/
├── Project1/
│   ├── OCTO-12345 Epic 1/
│   └── OCTO-12346 Epic 2/
├── Project2/
│   └── OCTO-12347 Epic 3/
└── Project3/
```

Each project can contain multiple OCTO (Jira Epic) folders for context tracking.

## Scripts

The skill uses several bash scripts in the `scripts/` directory:

- **validate_journal.sh**: Validates and prepares journal files, returns context data
- **log_activity.sh**: Logs activities with project/epic context
- **log_meeting.sh**: Logs meetings with chronological ordering
- **log_note.sh**: Adds diary-style notes
- **log_task.sh**: Manages tasks with project grouping

## Troubleshooting

### Journal file not found
Ensure the journal directory exists and the template file is available in your Templates folder.

### Projects not appearing
Verify that your projects are organized in the `OIL R&D Journal` folder as specified in the configuration.

### Chronological ordering not working
Make sure your time format matches the configured `TIME_FORMAT` (default: HH:MM in 24-hour format).

## Development

The skill uses a separation of concerns:
- **Intelligence Layer (Skill)**: Handles decision making, user interaction, and workflow orchestration
- **System Operations Layer (Scripts)**: Handles file system queries and file writing operations

## License

This skill is part of the daily journal system for personal productivity and project tracking.
