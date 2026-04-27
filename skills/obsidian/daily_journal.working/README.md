# Daily Journal Skill

Create and manage daily journal entries in your Obsidian vault with project and Jira Epic context tracking.

## Quick Start

**Log an activity:**
```
/daily_journal log activity Completed code review for authentication module
```

**Log a meeting:**
```
/daily_journal log meeting Team standup meeting
```

**Add a note:**
```
/daily_journal log note Note about challenges faced today
```

**Add a task:**
```
/daily_journal log task Add task to deploy new server
```

## Why Use This Skill?

- **Natural language parsing**: Extracts information from natural language requests (e.g., "log meeting OIL and Development Team meeting at 15:30 for 30 minutes no project") to minimize prompts
- **Autonomous activity logging**: Automatically evaluates conversation progress on each interaction and logs significant work achievements without explicit instruction
- **Intelligent context management**: Priority system for context selection (request context, remembered choices)
- **Automatic quality control**: Technical writing style proofreading for all journal entries, including spelling, grammar, sentence simplification, objective tone, active voice, and precise terminology
- **Chronological ordering**: Activities and meetings are automatically sorted by timestamp, supporting backdating
- **Project organization**: Associate entries with projects from your Obsidian vault
- **Jira Epic tracking**: Link entries to Jira Epics for better project organization
- **Template-based**: Creates journal entries from customizable templates
- **Multiple entry types**: Support for activities, meetings, notes, and tasks
- **No manual file editing**: Skip the complexity of manually editing markdown files

## Overview

This skill provides a streamlined way to create and manage daily journal entries in your Obsidian vault. It operates in two modes: user-initiated logging for explicit requests, and autonomous logging that automatically captures work progress by evaluating conversation progress on each interaction. It uses a separation of concerns architecture with intelligent decision-making in the skill layer and technical operations in the script layer.

## Prerequisites

- **Devin AI**: Access to the Devin AI skills system
- **Obsidian vault**: Configured with the following structure:
  - Daily Journal folder for journal entries
  - OIL R&D Journal folder for project organization
  - Templates folder with journal templates
- **Bash shell environment**: For script execution
- **Daily Journal Template**: Template file in your Templates folder

## Architecture

The skill uses a **separation of concerns** approach:

- **Intelligence Layer (Skill)**: Handles decision making, user interaction, context selection, and orchestrates the workflow
  - Date/time capture and parsing
  - User interaction and context selection
  - Decision logic for project/Jira Epic selection using priority system
  - Autonomous activity logging during work sessions based on conversation progress evaluation
  - Technical writing style proofreading for all entries, including spelling, grammar, sentence simplification, objective tone, active voice, and precise terminology
  - Orchestrates the workflow and calling appropriate scripts

- **System Operations Layer (Scripts)**: Handles file system queries and file writing operations
  - Querying the file system for projects and Jira Epics
  - Checking if journal entries exist
  - Creating new journal entries with templates
  - Writing specific entry types (activity, meeting, note, task) to journal files
  - Automatic date/time capture when not provided

**Why this approach?**
By separating intelligence from system operations, the skill can make smart decisions about context and user interaction while the scripts handle the technical file operations efficiently.

## Installation & Configuration

### Installation

The skill is located in your Devin configuration:
```
/home/moorek8/.config/devin/skills/obsidian/daily_journal/
```

No additional installation is required - it's part of your Devin configuration.

### Configuration

Edit `config.sh` to customize paths and settings:

```bash
# Vault Configuration
OBSIDIAN_VAULT_PATH="/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian/OIL Notebook"

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
SECTION_MEETINGS="Meeting Log"
SECTION_NOTES="Notes"
SECTION_TASKS="Tasks"
```

### Project Organization

Projects should be organized in the `OIL R&D Journal` folder with the following structure:

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

## Usage

### Basic Usage

**Invoke skill without parameters:**
```
/daily_journal
```

The skill will:
1. Inform you what it can do (log activities, meetings, notes, tasks, review journal, autonomous logging)
2. Set project and Jira Epic context for the current session
3. Tell you how to log to the journal and finish

**Log an activity with automatic context:**
```
/daily_journal log activity Completed code review
```

The skill will:
1. Prompt for project selection
2. Prompt for Jira Epic selection (if project selected)
3. Insert the activity in chronological order

**Log a meeting with natural language parsing:**
```
/daily_journal log meeting OIL and Development Team meeting at 15:30 for 30 minutes no project
```

The skill will:
1. Parse the request to extract: entry type (meeting), title, time (15:30), duration (30 minutes), project (no project)
2. Skip project/Jira Epic selection (user specified "no project")
3. Only ask for meeting type (not provided in request)
4. Insert the meeting at the correct chronological position

**Add a diary-style note:**
```
/daily_journal log note Note about challenges faced today
```

The skill will generate a summary based on your request context.

**Add a task to your task list:**
```
/daily_journal log task Add task to deploy new server
```

The skill will prompt for project context and organize tasks by project.

### Example Output

When you log an activity, the skill confirms creation:

```
**Journal entry**: updated
**File**: /mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian/OIL Notebook/Daily Journal/2026-04-22.md
**Date**: Wed 22 April 2026

The activity "Completed code review" has been logged to your daily journal.
```

The journal entry is automatically added to your Obsidian vault in the appropriate section with proper formatting.

### Chronological Ordering

Activities and meetings support backdating with specific timestamps:

```
/daily_journal log activity at 14:30 Code review completed this morning
```

The skill will insert the entry at the correct chronological position based on the timestamp.

### Context Reuse

The skill uses a priority system for context determination:
1. **Request context**: Uses project/epic explicitly provided in the natural language request
2. **Remembered choices**: Reuses project/epic choices from previous selections during the same session

This makes it efficient to log multiple entries without repeatedly selecting the same context.

## How It Works

The skill follows this streamlined process with clear separation of concerns:

1. **User invokes skill**: `/daily_journal log activity <description>` or `/daily_journal` (no parameters) or autonomous logging (evaluates conversation progress on each interaction)
2. **Skill (Parameter Check)**:
   - If parameters provided: Proceed to intent assessment
   - If NO parameters: Inform user what skill can do, set project/Jira Epic context for session, tell user how to log to journal, finish
3. **Skill (Intent Assessment & Context Selection)**:
   - Determines target date (current date or specified date)
   - Applies context priority system (request context → remembered choices → no context)
   - Changes to skill directory for script execution
   - Calls `validate_journal.sh` to initialize journal and get project/epic context
   - Displays available projects and prompts for selection (if no context from priority system)
   - Displays available Jira Epics for selected project and prompts for selection (if no context from priority system)
   - Gets entry content (from command argument or prompts user)
   - Applies technical writing style proofreading, including spelling, grammar, sentence simplification, objective tone, active voice, precise terminology, and clarity
4. **Script Execution (Technical Operations)**:
   - Calls appropriate logging script (`log_activity.sh`, `log_meeting.sh`, `log_note.sh`, or `log_task.sh`)
   - Scripts handle automatic date/time capture if not provided
   - Scripts handle file operations and content insertion
   - Chronological ordering handled for activities and meetings
   - Tasks grouped by project automatically
5. **Result**: Journal entry created or updated in Obsidian vault

**Key Separation of Concerns:**
- **Skill**: User interaction, context selection, decision making, workflow orchestration, quality validation
- **Scripts**: File system queries, file writing operations, content formatting, automatic timestamp handling
- **Config**: Configuration settings and paths

### Key Features

- **Natural language parsing**: Extracts information from natural language requests to minimize prompts
- **Autonomous activity logging**: Evaluates conversation progress on each interaction and automatically logs significant work achievements
- **Context priority system**: Request context and remembered choices
- **Automatic quality control**: Technical writing style proofreading for all entries, including spelling, grammar, sentence simplification, objective tone, active voice, and precise terminology
- **Audit tracking**: Source indication in Devin output (user, autonomous, intuition) for all journal entries
- **Chronological ordering**: Activities and meetings automatically sorted by timestamp
- **Context reuse**: Intelligent context management reduces repetitive selections
- **Project grouping**: Tasks automatically organized by project
- **Template-based**: Creates entries from customizable templates
- **Backdating support**: Log entries for specific times in the past
- **Multiple entry types**: Activities, meetings, notes, and tasks
- **Intelligent summary generation**: Generates note summaries from request context
- **Automatic timestamp handling**: Scripts capture current date/time when not provided

## Advanced Usage

### Audit Tracking

For audit purposes, the skill indicates the source of each journal entry in the Devin output before writing to the file:

- **user**: Entry created due to explicit user direction (user-initiated logging)
- **autonomous**: Entry created by the autonomous logging system based on conversation evaluation
- **intuition**: Entry created when Devin decides to write to the log file on its own, not because of user direction or autonomous logging success

The source is indicated in the Devin output (e.g., "Writing to journal [source: user]...") but is not written to the actual journal files, keeping the log entries clean while providing audit trail visibility.

### Autonomous Activity Logging

In addition to user-initiated logging, the skill supports autonomous activity logging during work sessions. The skill evaluates conversation progress on each interaction for key milestones and automatically logs activities and notes to create a record of the work day and achievements.

**Two-layer structure:**
- **Activity Log (Execution Layer)**: Objective actions and outcomes in format `- [Time] Action → Outcome (Context)`
- **Notes (Cognitive Layer)**: Insights, decisions, reasoning in format `[Type]` followed by 2-3 sentences

**Autonomous logging triggers:**
- Completed work or tasks
- Debugging or problem-solving progress
- System/tool usage and configuration
- Meaningful actions taken
- Files modified or code changes
- Insights formed (for notes)
- Non-trivial problems solved (for notes)
- Decisions made (for notes)

**Autonomous logging characteristics:**
- Evaluates on each conversation interaction with session history evaluation (not just last message)
- Only writes if criteria is matched
- Uses current date/time automatically
- Applies the same context priority system as user-initiated logging
- Includes technical writing style proofreading
- Does not interrupt workflow or require confirmation
- Conservative bias: Activity ONLY when uncertain, Notes only for clear cognitive value
- Applies inference policy for missing details without fabricating outcomes

### Detailed Entry Process

When you invoke the skill, it follows this detailed process:

```
/daily_journal log activity Fixed authentication bug
```

**Step 1: Date/Time Capture**
- Captures current date and time
- Or uses provided date if specified

**Step 2: Journal Validation**
- Changes to skill directory for script execution
- Checks if journal file exists for the target date
- Creates file from template if it doesn't exist
- Gets all projects and their associated OCTO epics
- Returns structured context data

**Step 3: Context Selection**
- Parses project context and displays available projects
- Presents 4 options for project selection
- If project selected, presents Jira Epic options for that project

**Step 4: Content Creation**
- Uses provided entry text or prompts for content
- Generates summary for notes based on request context
- Formats entry according to type (activity, meeting, note, task)

**Step 5: File Operations**
- Inserts entry at appropriate chronological position
- Handles project grouping for tasks
- Ensures proper formatting and placement

### Entry Types

**User-initiated logging format** (used by scripts):

**Activities**: Log work and accomplishments with project/epic context
```
[HH:MM] Activity description | project: Project | Jira Epic: OCTO-12345
```

**Meetings**: Record meetings with type, duration (with units), and project context
```
[HH:MM] Meeting title | type: Type | duration: 1 hour | project: Project
```

**Notes**: Add diary-style thoughts, observations, and insights
```
[HH:MM] project: Project | Jira Epic: OCTO-12345
Summary text here
```

**Tasks**: Create and manage task lists with project grouping
```
- [ ] Project: Task description
- [ ] Project: Another task
- [ ] Task without project
```

**Autonomous logging format** (ChatGPT.md framework):

**Activities**: Objective actions and outcomes
```
[Time] Action → Outcome (Context/Artifact)
```

**Notes**: Insights, decisions, reasoning with type tags
```
[Type]
2-3 sentence note
```

## Files

The skill folder structure:

```
obsidian/daily_journal/
├── SKILL.md          # Skill configuration and execution instructions
├── config.sh         # Skill-specific configuration
├── scripts/          # System operations scripts
│   ├── validate_journal.sh   # Journal validation and context retrieval
│   ├── log_activity.sh        # Activity logging
│   ├── log_meeting.sh         # Meeting logging
│   ├── log_note.sh            # Note logging
│   └── log_task.sh             # Task logging
└── README.md         # This documentation file
```

### File Descriptions

- **SKILL.md**: Contains the skill configuration, including:
  - Skill name and description
  - Allowed tools (write, read, exec, find_file_by_name, ask_user_question)
  - Triggers (model and user initiated)
  - Quick Reference for immediate decision support
  - Core Principles (architecture, operating modes, context priority)
  - Autonomous Logging Rules (ChatGPT.md framework with trigger conditions)
  - User-Initiated Logging Procedures (Steps 1-7 with detailed natural language parsing)
  - Script Reference
  - Example Workflows

- **config.sh**: Skill-specific configuration file:
  - Vault path and journal folder settings
  - Date/time format configuration
  - Section header names
  - File naming conventions

- **validate_journal.sh**: Journal validation and context retrieval script:
  - Validates and prepares daily journal files
  - Creates files from templates if needed
  - Retrieves project and Jira Epic context
  - Returns structured context data for the skill

- **log_activity.sh**: Activity logging script:
  - Inserts activities in chronological order
  - Handles project and Jira Epic context
  - Manages time-based ordering
  - Accepts optional date/time parameters (captures current automatically if not provided)

- **log_meeting.sh**: Meeting logging script:
  - Inserts meetings in chronological order
  - Handles meeting metadata (type, duration with units, project)
  - Automatically adds "minutes" to duration if no units provided
  - Manages time-based ordering
  - Accepts optional date/time parameters (captures current automatically if not provided)

- **log_note.sh**: Note logging script:
  - Inserts notes with project/epic context
  - Generates summaries from request context
  - Handles multi-line note format
  - Accepts optional date/time parameters (captures current automatically if not provided)

- **log_task.sh**: Task logging script:
  - Inserts tasks with project grouping
  - Manages task organization by project
  - Handles target dates for future tasks
  - Accepts optional date parameter (captures current automatically if not provided)

- **README.md**: Comprehensive documentation covering:
  - Quick start guide for immediate usage
  - Feature overview and capabilities
  - Installation and configuration instructions
  - Usage examples for basic and advanced scenarios
  - Detailed operation flow
  - Project organization structure

## Troubleshooting

### "Project not found"
Ensure your projects are organized in the `OIL R&D Journal` folder as specified in the configuration. Check that the project folder exists and is named correctly.

### "Journal file not found"
Ensure the journal directory exists and the template file is available in your Templates folder. The skill will create the journal file from the template if it doesn't exist.

### "Template file not found"
Verify that the `DAILY_JOURNAL_TEMPLATE` file exists in your Templates folder as specified in the configuration. The skill reads this file to create new journal entries.

### "Chronological ordering not working"
Make sure your time format matches the configured `TIME_FORMAT` (default: HH:MM in 24-hour format). The skill compares timestamps as strings for ordering.

### "Context not being reused"
The skill uses a priority system for context: request context → remembered choices. If context isn't being reused as expected, check that project/epic was either explicitly provided in the request or selected in the current session.

## License

This skill is part of your personal Devin configuration.