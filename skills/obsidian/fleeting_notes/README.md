# Fleeting Notes Skill

A skill for managing fleeting notes in Obsidian as part of a Zettelkasten workflow. Fleeting notes are temporary, in-the-moment captures of everything relevant to a specific task or activity.

## What It Is

A fleeting note is a technical scratchpad — a raw, honest record of how work actually happened. It is not a finished document, a daily log, or a summary. It captures everything relevant to a task while you're working on it, which is later synthesised into permanent notes, procedures, or formal deliverables.

### What a Fleeting Note Contains

- **Goal**: What you're trying to achieve
- **Steps & Commands**: Everything procedural, including failures and errors (timestamped)
- **Hypothesis & Tests**: Proposed explanations and test approaches (confirmed or not)
- **Design Decisions**: Architectural choices, options considered/rejected, reasoning
- **Sources & References**: Every URL, document, or source referenced
- **Observations & Comments**: In-the-moment thinking, surprises, things worth noting
- **Blockers & Open Questions**: Anything unresolved that needs follow-up
- **Follow-up**: Seeds for permanent notes, procedures, or future tasks

### What It Does Not Contain

- Daily journal entries or end-of-day reflections (that's the daily journal skill)
- Finished procedures or formal documents (those come from processing)
- Duplicate content from the daily journal

## Operational Modes

The skill operates in three modes, all active by default:

### User Directive Mode
You provide explicit instructions and the skill executes them:
- "Start a fleeting note for [task name]"
- "Note that [observation]"
- "Add a reference [URL]"
- "Close the fleeting note"

### Smart Proofreading Mode
Applies technical proofreading to descriptive content before logging:
- Objective tone, active voice, precise terminology, clarity, conciseness
- Never alters commands, error messages, URLs, or code
- Presents corrected version for visibility

### Autonomous Mode
Monitors conversation and routes content automatically:
- Creates new fleeting notes when a distinct new task is detected
- Closes active note when task completion is detected
- Routes content to correct section based on content type

## Note Types

| Type | Description |
|---|---|
| **technical-execution** | Procedures, commands, errors, URLs — sequential and timestamped |
| **research** | Sources, findings, evaluation of relevance to current work |
| **debugging** | Hypothesis → test → result loops, dead ends included |
| **design** | Decisions, options considered and rejected, reasoning |
| **meeting** | Decisions made, actions assigned, context heard |
| **literature** | References, commentary, connections to current work |
| **ideation** | Loose half-formed ideas captured fast |

## Usage

### Initialisation
Invoke the skill without parameters to set up project and Jira Epic context:
```
/fleeting_notes
```

### Create a Note
```
Start a fleeting note for [task name]
```

The skill will:
- Determine note type from context (or ask if ambiguous)
- Determine project and Jira Epic from context
- Create the note with structured sections
- Log an opening activity to the daily journal

### Capture Content
Use trigger phrases to route content to the correct section:
- "Note that [observation]" → Observations & Comments
- "Add a reference [URL]" → Sources & References
- "Open question [question]" → Blockers & Open Questions
- "Hypothesis [theory]" → Hypothesis & Tests
- "Decision made [choice]" → Design Decisions
- "Follow-up [action]" → Follow-up

### Close a Note
```
Close the fleeting note
```

The skill will:
- Mark the note as needs-processing
- Clear it from active session context
- Inform you it's ready for processing

## Section Routing

Content is automatically routed to the correct section based on type:

| Content Type | Target Section |
|---|---|
| Step, command, procedure, error message | Steps & Commands |
| URL, document, source, reference | Sources & References |
| Possible explanation, "might be", "could be" | Hypothesis & Tests |
| Architecture choice, approach selected, option rejected | Design Decisions |
| Unknown, "need to find out", "not sure", open question | Blockers & Open Questions |
| Future action, "follow up", "to do after this" | Follow-up |
| Observation, surprise, noteworthy behaviour, general comment | Observations & Comments |

## Integration with Daily Journal

The fleeting notes skill integrates with the daily journal skill:
- When a fleeting note is created, an activity is logged to the daily journal
- The daily journal links to fleeting notes for detailed technical context
- Daily journal captures high-level narrative; fleeting notes capture technical detail

## Philosophy

**Capture ugly, fix later.**

The fleeting note is written in the moment — raw, incomplete, and unpolished. Quality comes at the processing stage, not the capture stage. Don't edit while you work. The collective value of fleeting notes across a project shows the real shape of the work — where it was harder than expected, how thinking evolved, where decisions were made, and what dead ends were explored.

## Processing Pass

This step is manual and happens later:
- Read across fleeting notes
- Synthesize into permanent notes
- Turn procedures into formal documents
- Turn decisions into ADRs
- Send actions to task list
- Discard noise
- Archive/delete processed notes

## Scripts

- `init_fleeting_note.sh`: Create a new fleeting note with structured sections
- `log_section.sh`: Append content to a specific section
- `close_fleeting_note.sh`: Close a note and mark it for processing
- `get_active_note.sh`: Retrieve the currently active fleeting note
