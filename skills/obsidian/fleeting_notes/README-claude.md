# Fleeting Notes Skill

A Devin skill for creating and managing fleeting notes in Obsidian as part of a Zettelkasten workflow. The skill captures everything relevant to a specific task or activity — steps, commands, references, observations, decisions, and open questions — into a structured temporary note that later becomes the source material for permanent notes and formal deliverables.

---

## Purpose

A fleeting note is a workbench, not a filing cabinet. It is the raw, honest record of how work actually happened — written in the moment, intentionally unpolished, and temporary by design. The fleeting note captures at engineering scale what the daily journal captures at human scale.

The collection of fleeting notes across a project becomes the project's memory. When it comes time to write formal procedures, research findings, architecture decisions, or post-mortems, the user synthesises from these receipts rather than working from memory.

Fleeting notes are distinct from the daily journal:

| | Daily Journal | Fleeting Note |
|---|---|---|
| **Scope** | The whole day | A single task or activity |
| **Granularity** | 2-3 sentences per activity | Every step, command, URL, error, observation |
| **Author** | Devin, autonomously | Devin routing user narration |
| **Lifecycle** | Permanent daily log | Temporary — processed and archived |

---

## Directory Structure

```
~/.config/devin/skills/obsidian/fleeting_notes/
├── SKILL.md
├── config.sh
└── scripts/
    ├── init_fleeting_note.sh
    ├── log_section.sh
    ├── close_fleeting_note.sh
    └── get_active_note.sh
```

---

## Obsidian Vault Structure

Fleeting notes are created inside the project/epic structure of the vault:

```
OIL Notebook/
└── OIL R&D Journal/
    └── [Project]/
        ├── Fleeting Notes/               ← notes without a Jira epic
        │   └── YYYY-MM-DD - [Title] - Fleeting.md
        └── [JIRA Epic]/
            └── Fleeting Notes/           ← notes associated with an epic
                └── YYYY-MM-DD - [Title] - Fleeting.md
```

---

## Note Structure

Every fleeting note is created from the `Fleeting Note Template.md` with the following frontmatter and sections:

```markdown
---
title:
project:
jira:
type:
status: active
created: YYYY-MM-DD HH:MM
modified: YYYY-MM-DD HH:MM
tags: []
---

## Goal
## Steps & Commands
## Hypothesis & Tests
## Design Decisions
## Sources & References
## Observations & Comments
## Blockers & Open Questions
## Follow-up
```

Not every section is used in every note. They exist as prompts — fill what is relevant, ignore what is not.

---

## Note Types

| Type | Description |
|---|---|
| `technical-execution` | Procedures, commands, errors, URLs — sequential and timestamped |
| `research` | Sources, findings, evaluation of relevance to current work |
| `debugging` | Hypothesis → test → result loops, dead ends included |
| `design` | Decisions, options considered and rejected, reasoning |
| `meeting` | Decisions made, actions assigned, context heard |
| `literature` | References, commentary, connections to current work |
| `ideation` | Loose half-formed ideas captured fast before they disappear |

---

## Note Lifecycle

```
[User starts task]
       ↓
  Note created (status: active)
  Activity logged to daily journal
       ↓
  Content captured throughout the task
  Sections updated as work progresses
       ↓
  [User finishes task]
       ↓
  Note closed (status: needs-processing)
  Activity logged to daily journal with wikilink
       ↓
  [Processing pass — later]
       ↓
  Synthesised into permanent notes / procedures / deliverables
  Note archived or deleted
```

---

## Section Routing

The skill automatically routes captured content to the correct section based on content type:

| Content Type | Target Section |
|---|---|
| Step, command, procedure, error message | Steps & Commands |
| URL, document, source, reference | Sources & References |
| Possible explanation, working theory | Hypothesis & Tests |
| Architecture choice, approach selected, option rejected | Design Decisions |
| Unknown, open question, "not sure" | Blockers & Open Questions |
| Future action, follow-up item | Follow-up |
| Observation, surprise, noteworthy behaviour, general comment | Observations & Comments |

---

## Configuration

All configuration is managed in `config.sh`. Update the following before first use:

| Variable | Description |
|---|---|
| `OBSIDIAN_VAULT_PATH` | Full path to your Obsidian vault |
| `JOURNAL_PROJECTS_FOLDER` | Folder containing project directories |
| `FLEETING_NOTES_FOLDER` | Name of the fleeting notes subfolder within projects |
| `TEMPLATES_FOLDER` | Folder containing Obsidian templates |
| `FLEETING_NOTE_TEMPLATE` | Name of the fleeting note template file (without .md) |
| `JIRA_EPIC_IDENTIFIER` | Prefix used to identify Jira epics (e.g. OCTO-) |
| `DAILY_JOURNAL_SKILL_PATH` | Full path to the daily_journal skill directory |

---

## Scripts

### `init_fleeting_note.sh`
Creates a new fleeting note from the template, populates the frontmatter, and writes the goal into the Goal section. Outputs structured data for the skill to parse.

```bash
# Usage
./scripts/init_fleeting_note.sh "title" "type" "goal" [project] [jira_epic]

# Output
NOTE_PATH=/full/path/to/note.md
NOTE_FILE=YYYY-MM-DD - Title - Fleeting.md
NOTE_TITLE=Title
NOTE_TYPE=technical-execution
NOTE_PROJECT=ProjectX
NOTE_JIRA=OCTO-12345 ProjectX deployment
```

### `log_section.sh`
Appends a timestamped entry to a named section of the active fleeting note. Updates the modified frontmatter on every write. Uses Python3 for reliable mid-file section insertion.

```bash
# Usage
./scripts/log_section.sh "note_path" "section_name" "content" [HH:MM]
```

### `close_fleeting_note.sh`
Updates the note status to `needs-processing`, updates the modified timestamp, and logs a closing activity to the daily journal with an embedded Obsidian wikilink.

```bash
# Usage
./scripts/close_fleeting_note.sh "note_path"

# Output
NOTE_CLOSED=/full/path/to/note.md
NOTE_TITLE=Title
NOTE_PROJECT=ProjectX
NOTE_JIRA=OCTO-12345
NOTE_TYPE=technical-execution
```

### `get_active_note.sh`
Searches for the most recently modified fleeting note with `status: active`. Scoped by project and epic if provided, falls back to vault-wide search. Used by the skill to restore session context.

```bash
# Usage
./scripts/get_active_note.sh [project] [jira_epic]

# Output
NOTE_PATH=/full/path/to/note.md
NOTE_NAME=YYYY-MM-DD - Title - Fleeting
NOTE_TITLE=Title
NOTE_PROJECT=ProjectX
NOTE_JIRA=OCTO-12345
NOTE_TYPE=technical-execution
NOTE_MODIFIED=2026-04-27 14:32
```

---

## Operational Modes

The skill operates in three modes simultaneously:

**User Directive** — The user explicitly asks the skill to create, capture to, or close a fleeting note. The skill applies the ask_user_question priority to determine all required fields from context before asking the user anything. If multiple fields cannot be determined, they are consolidated into a single question interaction.

**Smart Proofreading** — Applied to all descriptive content before logging. Commands, code, URLs, and error messages are never altered. The corrected version is shown to the user for visibility.

**Autonomous Mode** — The skill monitors the conversation and manages the fleeting note lifecycle without being asked:
- Routes content to the correct section based on content type
- Creates a new note when a distinct new task is detected
- Closes the active note when task completion is detected

---

## Setup

1. Copy the skill directory to `~/.config/devin/skills/obsidian/fleeting_notes/`
2. Update `config.sh` with your vault path, folder names, and daily journal skill path
3. Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```
4. Create `Fleeting Note Template.md` in your Obsidian Templates folder
5. Ensure the `daily_journal` skill is installed — the fleeting notes skill depends on it for activity logging

---

## Dependencies

- **daily_journal skill** — required for activity logging on note open and close
- **Python3** — required by `log_section.sh` for reliable section insertion
- **Obsidian vault** — must exist at the configured path with the expected folder structure
