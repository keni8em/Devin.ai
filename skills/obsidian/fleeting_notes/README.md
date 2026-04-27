# Fleeting Notes Skill

Create and manage fleeting notes as project memory - one note per task with structured capture and processing workflow.

## Quick Start

**Invoke without parameters:**
```
/fleeting_notes
```

The skill will:
1. Inform you what it can do (create fleeting notes, add content, close notes)
2. Query the system for project and Jira Epic context using get_projects.sh
3. Set project and Jira Epic context (mandatory)
4. Tell you how to use the skill
5. Finish (ready for you to start creating notes)

**Start a fleeting note:**
```
/fleeting_notes Start a fleeting note for GPU benchmark optimization
```

**Add content while working:**
```
Note that the TensorRT optimization is showing 40% improvement
Hypothesis: The memory issue is related to batch size
Decision made: We'll proceed with the current configuration
```

**Close the note:**
```
/fleeting_notes Close the fleeting note
```

## Why Use This Skill?

- **Project memory**: One note per task creates an honest record of how work actually happened
- **Workbench philosophy**: Capture ugly, fix later - don't edit while you work
- **Structured capture**: Trigger phrases route content to appropriate sections automatically
- **Session context**: Uses project/Jira context from session for efficiency
- **Processing workflow**: Close notes mark them for synthesis into permanent documentation
- **Automatic proofreading**: Technical writing style applied to task names and content (objective, active voice, precise, concise)

## Overview

This skill implements a sophisticated project memory system where fleeting notes serve as a workbench for capturing work as it happens. Unlike daily journal entries, these notes are purely technical and focus on the honest record of task execution, research, debugging, design decisions, and meetings. Each note spans a single task or activity and gets processed later into permanent documentation.

## Core Principles

**One note per task**: Not per day - one note follows a task from start to finish

**Workbench, not filing cabinet**: Capture ugly, fix it later during processing pass

**Purely technical**: No journaling or daily reflection - that's for the daily journal skill

**Don't edit while working**: Capture first, quality comes at the processing stage

**Project memory**: Collective notes show where work was hard, how thinking evolved, what dead ends were explored

**Atomicity later**: Breaking content into atomic notes happens during processing, not capture

## Note Types

Each fleeting note has a type that determines its structure and eventual processing destination:

- **Technical Execution**: Procedures, commands, errors, URLs - sequential and timestamped
- **Research & Investigation**: Sources, findings, your evaluation of relevance
- **Problem Solving & Debugging**: Hypothesis → test → result loops, dead ends included
- **Design & Architecture**: Decisions, options considered and rejected, reasoning
- **Meetings & Conversations**: Decisions made, actions assigned, context heard
- **Literature & Source Review**: References, your commentary, connections to current work
- **Ideation & Speculation**: Loose half-formed ideas captured fast before they disappear

## Workflow

### Step 1: Open the Note

When you start a new task or activity:
```
Start a fleeting note for [task name]
```

Devin queries the system for context (mandatory):
- Uses get_projects.sh script to get available projects and their Jira Epics
- Presents project options for selection
- Presents Jira Epic options for selected project
- Context selection is not optional for fleeting notes

Then creates the note with:
- Naming convention: `YYYY-MM-DD - [Task Name] - Fleeting.md`
- Stored in `OIL R&D Journal/[Project]/[Jira Epic]/fleeting-notes/` folder
- Note type tagged in YAML frontmatter
- Project and Jira in YAML frontmatter
- Status set to "active"

**Automatic Proofreading:** Task name is automatically proofread for technical writing style (objective, active voice, precise, concise) before creating the note.

### Step 2: Capture While You Work

Talk to Devin the way you already do - narrate everything. Devin routes content to the right section:

- "Note that..." → Observations & Comments
- "Add a reference..." → Sources & References
- "Open question..." → Blockers & Open Questions
- "Follow-up on..." → Follow-up
- "Hypothesis..." → Hypothesis & Tests
- "Decision made..." → Design Decisions

Don't stop to edit, structure, or second-guess. Capture ugly.

**Automatic Proofreading:** Devin automatically applies technical writing style proofreading to task names and appended content:
- Objective tone and active voice
- Precise terminology and elimination of ambiguity
- Removal of redundancy and focus on clarity
- Simplification of complex descriptions for conciseness

This ensures notes are clear and professional while maintaining the workbench philosophy of capturing first, refining later during the processing pass.

### Step 3: Close the Note

When you finish the task:
```
Close the fleeting note
```

Devin:
- Updates note status to "needs-processing"
- Clears the active note tracking

### Step 4: Processing Pass (Later)

This is NOT automated. You do this later - end of day, end of sprint, whenever work concludes:
- Synthesize into permanent notes
- Turn procedural steps into formal procedure documents
- Turn design decisions into ADRs
- Send actions from meetings to your task list
- Discard anything that was pure noise
- Archive or delete the fleeting note once processed

This is an authoring activity, not a tidying activity. You're reading receipts and writing something new from them.

## Note Structure

Each fleeting note has this structure:

```markdown
---
title: Task Name
project: Project Name
jira: Jira Epic (optional)
type: [technical-execution | research | debugging | design | meeting | literature | ideation]
status: active
created: YYYY-MM-DD HH:MM
modified: YYYY-MM-DD HH:MM
tags: [Universal, OCTO-13032]
---

Additional tags can be manually added to the tags array as needed (e.g., `[Universal, OCTO-13032, NVAIE]`).

## Goal

## Steps & Commands

## Hypothesis & Tests

## Design Decisions

## Sources & References

## Observations & Comments

## Blockers & Open Questions

## Follow-up
```

Not every section is used in every note. They sit there as prompts - fill what's relevant, ignore what isn't.

## Storage Structure

Notes are stored in your Obsidian vault as:
```
OIL Notebook/
├── OIL R&D Journal/
│   ├── Universal/
│   │   ├── OCTO-13032/
│   │   │   └── fleeting-notes/
│   │   │       ├── 2026-04-24 - GPU benchmark optimization - Fleeting.md
│   │   │       └── 2026-04-24 - Anthos deployment issues - Fleeting.md
│   │   └── OCTO-5460/
│   │       └── fleeting-notes/
│   │           └── 2026-04-25 - Team followup - Fleeting.md
```

## The Collective as Project Memory

A single fleeting note shows you did a thing. A collection of fleeting notes across a project shows you:
- Where the work was harder than expected
- How your thinking evolved
- Where decisions were actually made and why
- What dead ends were explored

When writing formal project outcomes, research findings, or post-mortems, you're synthesizing from receipts, not working from memory.

## Installation & Configuration

### Installation

The skill is located in your Devin configuration:
```
/home/moorek8/.config/devin/skills/obsidian/fleeting_notes/
```

### Configuration

Edit `config.sh` to customize paths and settings:

```bash
# Vault Configuration
OBSIDIAN_VAULT_PATH="/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian/OIL Notebook"

# Storage Configuration
FLEETING_NOTES_FOLDER="fleeting-notes"
JOURNAL_PROJECTS_FOLDER="OIL R&D Journal"

# Date/Time Configuration
DATE_FORMAT="%Y-%m-%d"
TIME_FORMAT="%H:%M"
DATETIME_FORMAT="%Y-%m-%d %H:%M"
```

## Files

The skill folder structure:
```
obsidian/fleeting_notes/
├── SKILL.md          # Skill configuration and execution instructions
├── config.sh         # Skill-specific configuration
├── scripts/          # System operations scripts
│   ├── create_note.sh       # Create fleeting note with YAML frontmatter
│   ├── append_to_note.sh    # Append content to specific section
│   ├── close_note.sh        # Close note, update status
│   ├── get_projects.sh      # Get available projects and their Jira Epics
└── README.md         # This documentation file
```

## Splitting Rules

Open a second fleeting note only if:
- The task genuinely forks into an independent problem with its own context
- A new note type emerges mid-session that has no dependency on the original task

Otherwise stay on one note. Resist the urge to fragment while working.

## Processing Destinations

By note type, fleeting notes typically process into:

- **Technical Execution**: Formal procedure document
- **Research & Investigation**: Permanent reference note
- **Problem Solving & Debugging**: Permanent note on solution or pattern
- **Design & Architecture**: ADR, HLD, or design document
- **Meetings & Conversations**: Actions to todo list, decisions to permanent notes
- **Literature & Source Review**: Permanent reference note, bibliography
- **Ideation & Speculation**: Permanent note if it develops, discarded if it doesn't

## License

This skill is part of your personal Devin configuration.
