# Daily Journal Skill

A Devin skill for maintaining a high-level narrative log of your working day in Obsidian.

## Overview

The daily journal is a logbook used for recording accountability of what you're working on. It captures the story of your day — what happened, in what order, how it went, and what was achieved. Unlike project notes that capture technical detail, the daily journal provides a high-level narrative that remains readable months later.

## What the Daily Journal Contains

- **Activity Log**: A chronological record of what you did throughout the day. Each entry is timestamped and captures what the activity was, the outcome, and significant observations. It does not capture how — that level of detail belongs in project notes.
- **Meetings & Conversations**: A brief record of any meetings attended during the day
- **Todo & Task Management**: Tasks added, completed, deferred, or cancelled throughout the day
- **Insights & Reflections**: Observations that sit above the task level — something learned, a pattern noticed, a question worth carrying forward
- **Achievements**: Things completed or progressed that are worth noting

## What the Daily Journal Does Not Contain

- Step by step procedures or commands
- URLs, error messages, or technical detail
- Raw unprocessed observations specific to a task

## Tone & Voice

Written in plain, professional first-person prose. Concise but complete enough that you could read back an entry three months later and immediately understand what was happening in your work at that point in time.

## Features

### Operational Modes

The skill operates in three modes, all active by default:

1. **User Directive Mode**: Evaluates and fulfills explicit user requests to log tasks, activities, meetings, or notes
2. **Smart Proofreading Mode**: Applies technical proofreading to improve clarity, conciseness, and precision while preserving meaning
3. **Autonomous Logging Mode**: Uses intuitive reasoning to recognize when updates, decisions, or observations have value for the daily journal and logs them automatically

### Autonomous Logging with Intuitive Reasoning

The skill monitors conversations and automatically logs entries when it recognizes value:

**What Constitutes "Value":**
- Completion statements — "that's done", "finished", "deployed", "merged"
- Decision statements — "we've decided", "going with", "agreed to"
- Meeting references — "just spoke to", "call with", "meeting with"
- Named outcomes — specific things produced, delivered, or resolved
- Significant blockers or discoveries — "turns out", "found out", "realised"
- Explicit instructions to log

### Session Progression Awareness

The skill reviews conversation history to identify progression milestones:

**Pattern Detection:**
- **Task completion**: Task mentioned → work appeared → resolution signal
- **Debugging resolved**: Problem described → investigation → fix stated
- **Decision reached**: Options discussed → conclusion appeared
- **Meeting occurred**: Meeting referenced → outcomes appeared
- **Insight formed**: Understanding emerged across multiple messages

### Pattern Recognition by Note Type

The skill evaluates the entire conversation to determine if something new has been created:

| Note Type | Opening State | Closing State | Ready When |
|---|---|---|---|
| **Insight** | Not knowing | Knowing | User has moved past the knowing |
| **Decision** | Open choice | Closed choice | Choice has disappeared from conversation |
| **Observation** | Active work | Noteworthy behaviour described | Conversation has moved past it |
| **Hypothesis** | Unknown or problem | Working theory formed | Theory is being carried unconfirmed |
| **Friction** | Resistance encountered | Past the friction point | Difficulty is behind the user |
| **Question** | Gap identified | Gap remains open | Conversation has moved forward carrying it |

## Note Types

| Type | Description |
|---|---|
| **Insight** | Understanding that wasn't present at the start of the conversation |
| **Decision** | A commitment that closes an open choice |
| **Observation** | Something noteworthy about how a system, tool, or situation behaves |
| **Hypothesis** | A proposed explanation being carried forward untested |
| **Friction** | Something that created unnecessary difficulty |
| **Question** | An open question being carried forward unanswered |
| **Housekeeping** | Administrative or organizational notes |

## Usage

### Starting the Daily Journal

Invoke the skill without parameters to initialise the session:

```
skill daily_journal
```

The skill will:
1. Create today's daily journal file (if it doesn't exist)
2. Discover available projects from your Obsidian vault
3. Prompt you to select a project
4. Prompt you to select a Jira Epic (optional)
5. Set session context for subsequent logging operations

### Logging Tasks

Add tasks to your daily journal:

```
"Log a task: Fix the authentication bug in the login service"
```

The skill will:
- Apply smart proofreading to the task description
- Determine project context from session or prompt if needed
- Add the task to the Tasks section with project association
- Organize tasks by project for easy tracking

### Logging Activities

Record activities throughout your day:

```
"Log activity: Deployed the new feature to staging environment"
```

The skill will:
- Apply smart proofreading to the activity description
- Add timestamp to the entry
- Insert chronologically in the Activity Log section
- Include project and Jira Epic context if available

### Logging Meetings

Record meetings you attend:

```
"Log meeting: Weekly standup with the team, type: standup, duration: 30 minutes"
```

The skill will:
- Apply smart proofreading to the meeting title
- Add timestamp, type, and duration
- Include project context if available
- Insert in the Meeting Log section

### Logging Notes

Capture insights, decisions, observations, etc.:

```
"Log note: Insight - The performance issue was caused by database connection pool exhaustion"
```

The skill will:
- Validate the note type against allowed types
- Apply smart proofreading to ensure 2-3 sentence summary
- Add timestamp and context (project, Jira Epic)
- Insert in the Notes section

## Configuration

The skill uses configuration from `config.sh`:

- **Vault Path**: Your Obsidian vault location
- **Folder Structure**: Defines where daily journals are stored
- **Template Support**: Uses Obsidian templates if available
- **Date/Time Formats**: Formatting for timestamps and filenames
- **Note Types**: Valid note types for validation
- **Jira Integration**: Jira Epic identifier pattern matching

## File Structure

```
daily_journal/
├── SKILL.md                  # Main skill definition
├── config.sh                 # Configuration settings
├── README.md                 # This file
└── scripts/
    ├── init_journal.sh       # Create daily journal and discover projects
    ├── log_task.sh           # Log tasks to journal
    ├── log_activity.sh       # Log activities chronologically
    ├── log_meeting.sh        # Log meetings to journal
    └── log_note.sh           # Log notes to journal
```

## Smart Proofreading

The skill applies technical proofreading principles to all logged content:

- **Objective tone**: Removes emotional language and subjective statements
- **Active voice**: Converts passive constructions to active voice
- **Remove ambiguity**: Clarifies vague references and unclear pronouns
- **Precise terminology**: Uses accurate technical terms
- **Eliminate redundancy**: Removes unnecessary repetition
- **Clarity and conciseness**: Simplifies complex descriptions
- **Grammar and spelling**: Automatically corrects minor issues

**Example:**
```
Before: "I was trying to fix the thing but it didnt work and was really frustrating"
After:  "Attempted to fix authentication bug — failed due to missing environment variables"
```

## Integration with Projects

The skill integrates with your project structure:
- Discovers projects from your Obsidian vault's project folder
- Identifies Jira Epics within each project
- Associates journal entries with project and epic context
- Supports hierarchical organization (Project → Epic → Entries)

## Error Handling

The skill includes comprehensive error handling for:
- Missing journal files (creates automatically if template exists)
- Invalid note types (validates against allowed types)
- Missing required parameters (prompts user for missing information)
- Context unavailability (re-runs initialisation to discover projects)
- Template not found (creates basic structure as fallback)

## Examples

### Task Logging
```
User: "Log a task: Review and merge the pull request for the user authentication feature"
Skill: "Task logged: Review and merge the pull request for the user authentication feature"
```

### Activity Logging
```
User: "Log activity: Completed the code review for the authentication module"
Skill: "[14:32] Completed code review for authentication module | project: Universal"
```

### Meeting Logging
```
User: "Log meeting: Architecture review meeting, type: review, duration: 1 hour"
Skill: "[15:00] Architecture review meeting | type: review | duration: 1 hour | project: Universal"
```

### Note Logging
```
User: "Log note: Decision - We will use JWT tokens for authentication instead of session-based auth"
Skill: "[15:45] Decision | Universal
We will use JWT tokens for authentication instead of session-based auth. This approach provides better scalability and simplifies state management across services."
```

### Autonomous Logging Example
```
User: "That's done — the deployment to staging is complete"
Skill: (Autonomously logs) "[16:15] Deployment to staging completed successfully | project: Universal"
```

## Requirements

- Obsidian vault configured in `config.sh`
- Project folder structure in vault (optional but recommended)
- Daily journal template in Templates folder (optional)
- Bash shell for script execution
- Date command with `-d` option for date formatting

## The Value of Daily Journaling

A daily journal provides:
- **Accountability**: Clear record of what you worked on each day
- **Pattern recognition**: Identify recurring themes, blockers, and achievements
- **Context preservation**: Understand what was happening when reading back months later
- **Progress tracking**: See how work and understanding evolved over time
- **Communication foundation**: Provide basis for status updates and performance discussions

Unlike project notes that capture technical detail, the daily journal captures the narrative arc of your work — the story of what happened, why it mattered, and what you learned.
