# Daily Journal Skill

A Devin skill for managing a daily journal in Obsidian. The skill maintains a high-level narrative log of the working day — what happened, in what order, how it went, and what was achieved. It operates continuously throughout the day, logging activities, meetings, tasks, and notes from the user's narration without requiring the user to write anything directly.

---

## Purpose

The daily journal is the story of the day. It is not a task manager, a technical record, or a project document. It is a professional logbook written at human scale — concise enough to write in real time, complete enough to read back three months later and immediately understand what was happening.

The skill operates alongside the fleeting notes skill. Where the daily journal captures what happened and how it went in 2-3 sentences, the fleeting note captures the full technical detail of how it was done. The daily journal links to the fleeting note — it never duplicates it.

---

## Directory Structure

```
~/.config/devin/skills/obsidian/daily_journal/
├── SKILL.md
├── config.sh
└── scripts/
    ├── init_journal.sh
    ├── log_activity.sh
    ├── log_meeting.sh
    ├── log_note.sh
    └── log_task.sh
```

---

## Obsidian Vault Structure

```
OIL Notebook/
├── Daily Journal/
│   └── YYYY-MM-DD.md         ← one file per day
├── Templates/
│   └── Daily Journal Template.md
└── OIL R&D Journal/
    └── [Project]/
        └── [JIRA Epic]/
```

---

## Configuration

All configuration is managed in `config.sh`. Update the following before first use:

| Variable | Description |
|---|---|
| `OBSIDIAN_VAULT_PATH` | Full path to your Obsidian vault |
| `JOURNAL_PROJECTS_FOLDER` | Folder containing project directories |
| `JOURNAL_FOLDER` | Folder where daily journal files are created |
| `TEMPLATES_FOLDER` | Folder containing Obsidian templates |
| `DAILY_JOURNAL_TEMPLATE` | Name of the daily journal template file (without .md) |
| `JIRA_EPIC_IDENTIFIER` | Prefix used to identify Jira epics (e.g. OCTO-) |

---

## Journal Structure

Each daily journal file contains four sections:

| Section | Content |
|---|---|
| **Tasks** | Todo items added, completed, deferred, or cancelled throughout the day |
| **Activity Log** | Chronological record of activities, timestamped, with 2-3 sentence outcomes |
| **Meeting Log** | Record of meetings attended — who, what type, duration, outcome |
| **Notes** | Insights, decisions, observations, hypotheses, friction points, and open questions |

### Note Types

| Type | Description |
|---|---|
| `Insight` | Something learned or understood that wasn't known before |
| `Decision` | A choice made, an approach committed to |
| `Observation` | Something noteworthy about how a system or situation behaved |
| `Hypothesis` | A proposed explanation that has not yet been confirmed |
| `Friction` | Something that created unnecessary difficulty or wasted time |
| `Question` | An open question being carried forward unanswered |
| `Housekeeping` | Administrative or organisational actions taken |

---

## Operational Modes

The skill operates in three modes simultaneously:

**User Directive** — The user explicitly asks the skill to log something. The skill evaluates the request, applies Smart Proofreading, and writes to the journal.

**Smart Proofreading** — All entries are automatically improved for clarity, conciseness, and professional tone before being written. The corrected version is shown to the user for visibility. Original meaning is always preserved.

**Autonomous Logging** — The skill monitors the conversation and logs entries without being asked. Two mechanisms operate in parallel:
- *Intuitive Reasoning*: Evaluates the most recent message for signals that an outcome, decision, or event has occurred
- *Session Progression Awareness*: Evaluates the full conversation history on every interaction, looking for completed arcs that warrant a journal entry

---

## Scripts

### `init_journal.sh`
Creates the daily journal file for today (or a specified date) from the Obsidian template. Discovers all projects and Jira epics from the vault and outputs structured context data for the skill to parse.

```bash
# Usage
./scripts/init_journal.sh [YYYY-MM-DD]
```

### `log_activity.sh`
Logs a timestamped activity entry to the Activity Log section, inserted in chronological order.

```bash
# Usage
./scripts/log_activity.sh "description" [project] [jira_epic] [HH:MM]
```

### `log_meeting.sh`
Logs a meeting entry to the Meeting Log section.

```bash
# Usage
./scripts/log_meeting.sh "title" "type" "duration" [project] [HH:MM]
```

### `log_note.sh`
Logs a typed note to the Notes section.

```bash
# Usage
./scripts/log_note.sh "type" "detail" [project] [jira_epic] [HH:MM]
```

### `log_task.sh`
Logs a task to the Tasks section, grouped by project.

```bash
# Usage
./scripts/log_task.sh "description" [project] [YYYY-MM-DD]
```

---

## Setup

1. Copy the skill directory to `~/.config/devin/skills/obsidian/daily_journal/`
2. Update `config.sh` with your vault path and folder names
3. Make scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```
4. Create the `Daily Journal Template.md` in your Obsidian Templates folder
5. Invoke the skill in Devin to initialise today's journal

---

## Relationship to Fleeting Notes

The daily journal and fleeting notes are two distinct layers that reference each other:

- The daily journal entry tells you **what happened and how it went**
- The fleeting note tells you **exactly how it was done**

When an activity has a corresponding fleeting note, the daily journal entry carries an embedded Obsidian wikilink:

```
Deployed kafka-connect to staging. Bootstrap env var issue resolved 
quickly. Schema registry auth remains an open question.
[[2026-04-27 - Deploy kafka-connect to staging - Fleeting]]
```

The fleeting notes skill writes this link automatically when a fleeting note is closed.
