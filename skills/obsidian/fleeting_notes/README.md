# Fleeting Notes Skill

A Devin skill for capturing and managing fleeting notes in Obsidian as part of a Zettelkasten workflow.

## Overview

The fleeting notes skill creates, manages, and captures content into temporary work notes throughout your working session. It operates as a technical scratchpad that captures raw, in-the-moment work which later gets synthesised into permanent notes, procedures, or formal deliverables.

## What is a Fleeting Note?

A fleeting note is a temporary, in-the-moment capture of everything relevant to a specific task or activity. It is your workbench — a raw, honest record of how work actually happened.

### What a Fleeting Note Contains

- **Goal**: What you're trying to achieve — set once at creation
- **Steps & Commands**: Everything procedural, including failures and errors, timestamped
- **Hypothesis & Tests**: Proposed explanations and test approaches, confirmed or not
- **Design Decisions**: Architectural choices, options considered and rejected, reasoning
- **Sources & References**: Every URL, document, or source referenced during the task
- **Observations & Comments**: In-the-moment thinking, surprises, things worth noting
- **Blockers & Open Questions**: Anything unresolved that needs follow-up
- **Follow-up**: Seeds for permanent notes, procedures, or future tasks

### What a Fleeting Note Does Not Contain

- Daily journal entries or end-of-day reflections (use the daily journal skill)
- Finished procedures or formal documents (those come from the processing stage)
- Duplicate content from the daily journal

## Note Types

| Type | Description |
|---|---|
| **technical-execution** | Procedures, commands, errors, URLs — sequential and timestamped |
| **research** | Sources, findings, evaluation of relevance to current work |
| **debugging** | Hypothesis → test → result loops, dead ends included |
| **design** | Decisions, options considered and rejected, reasoning |
| **meeting** | Decisions made, actions assigned, context heard |
| **literature** | References, commentary, connections to current work |
| **ideation** | Loose half-formed ideas captured fast before they disappear |

## Features

### Operational Modes

The skill operates in three modes, all active by default:

1. **User Directive Mode**: Evaluates and fulfills explicit user requests to create, capture to, or close fleeting notes
2. **Smart Proofreading Mode**: Applies technical proofreading to descriptive content before logging while preserving commands, URLs, code, and error messages
3. **Autonomous Mode**: Monitors conversation and routes content to the active fleeting note without explicit instruction, creates new notes when new tasks are detected, and closes notes when tasks complete

### Autonomous Capture

The skill automatically captures content that belongs in the active fleeting note, including:
- Procedural steps, commands, or technical actions
- URLs or references being consulted
- Errors, unexpected results, or surprising behaviour
- Working theories or proposed explanations
- Architectural or design choices
- Open questions or unknowns
- Follow-up actions being noted

### Smart Section Routing

Content is automatically routed to the correct section based on type:

| Content Type | Target Section |
|---|---|
| Step, command, procedure, error message | Steps & Commands |
| URL, document, source, reference | Sources & References |
| Possible explanation, "might be", "could be" | Hypothesis & Tests |
| Architecture choice, approach selected, option rejected | Design Decisions |
| Unknown, "need to find out", open question | Blockers & Open Questions |
| Future action, "follow up", "to do after this" | Follow-up |
| Observation, surprise, noteworthy behaviour | Observations & Comments |

## Usage

### Starting a New Fleeting Note

Invoke the skill without parameters to initialise the session:

```
skill fleeting_notes
```

The skill will:
1. Prompt you to select a project from your available projects
2. Prompt you to select a Jira Epic (optional)
3. Check for any existing active fleeting notes
4. Be ready to create a new note or capture to an existing one

### Creating a Note

When you start working on a new task, the skill can automatically create a note, or you can explicitly request one:

```
"Start a fleeting note for deploying kafka-connect"
```

The skill will:
- Deduce the note type from context (e.g., technical-execution for deployment)
- Infer the goal from conversation context
- Determine project and epic from session context
- Create the note with proper frontmatter and structure
- Log the opening activity to your daily journal

### Capturing Content

You can explicitly request content capture, or the skill will autonomously capture relevant content:

```
"Note that the healthcheck interval is too aggressive for slower disks"
```

The skill will:
- Apply smart proofreading to descriptive content
- Route to the appropriate section
- Add timestamp to the entry
- Preserve commands, URLs, and code exactly as written

### Closing a Note

When a task is complete:

```
"Close the fleeting note"
```

The skill will:
- Update note status to "needs-processing"
- Update modified timestamp
- Log the closing activity to your daily journal
- Clear the active note from session context

## Configuration

The skill uses configuration from `config.sh`:

- **Vault Path**: Your Obsidian vault location
- **Folder Structure**: Defines where fleeting notes are stored within your vault
- **Note Types**: Valid note types for validation
- **Date/Time Formats**: Formatting for timestamps and filenames
- **Template Support**: Uses Obsidian templates if available

## File Structure

```
fleeting_notes/
├── SKILL.md                    # Main skill definition
├── config.sh                   # Configuration settings
├── README.md                   # This file
└── scripts/
    ├── init_fleeting_note.sh   # Create new fleeting notes
    ├── get_active_note.sh      # Find active fleeting note
    ├── log_section.sh          # Log content to sections
    └── close_fleeting_note.sh  # Close fleeting notes
```

## Integration with Daily Journal

The fleeting notes skill integrates with the daily journal skill:
- Opening a fleeting note logs an activity to your daily journal
- Closing a fleeting note logs an activity to your daily journal
- Daily journal entries link to fleeting notes using Obsidian wikilinks

## The Collective Value

A single fleeting note shows you completed a task. A collection of fleeting notes across a project shows the real shape of the work — where it was harder than expected, how thinking evolved, where decisions were made, and what dead ends were explored.

When it comes time to write formal deliverables, you synthesise from these receipts rather than working from memory.

## Tone & Voice

Capture ugly. Do not edit while working. The fleeting note is written in the moment — raw, incomplete, and unpolished. Quality comes at the processing stage, not the capture stage.

## Error Handling

The skill includes comprehensive error handling for:
- Missing active notes (prompts to create one)
- Script execution failures (displays error messages)
- Note file not found (attempts to find alternative active note)
- Missing templates (creates basic structure)
- Context unavailability (re-runs initialisation)

## Examples

### Technical Execution
```
User: "Start a fleeting note for the kafka-connect deployment"
Skill: Creates note with type technical-execution, infers goal from context
```

### Debugging
```
User: "Hypothesis — the auth failures might be a token expiry race condition under load"
Skill: Routes to Hypothesis & Tests section, applies proofreading
```

### Research
```
User: "Add a reference https://docs.confluent.io/kafka-connect"
Skill: Routes to Sources & References, preserves URL exactly
```

### Smart Proofreading
```
Before: "ran the docker compose thing and it didnt work because of missing env var"
After:  "Ran docker-compose up — failed due to missing CONNECT_BOOTSTRAP_SERVERS env var"
```

## Requirements

- Obsidian vault configured in `config.sh`
- Daily journal skill for activity logging (optional but recommended)
- Python3 for section content insertion
- Bash shell for script execution
