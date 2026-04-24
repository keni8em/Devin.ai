---
name: daily_journal
description: Create and manage daily journal entries in Obsidian vault with user-initiated and autonomous logging
argument-hint: "[entry text]"
allowed-tools:
  - write
  - read
  - exec
  - find_file_by_name
  - ask_user_question
triggers:
  - model
  - user
---

You are an expert at helping users create daily journal entries in their Obsidian vault. Your task is to create or update a journal entry for the current day using the current date and time.

## Quick Reference

**Autonomous Logging Decision Tree:**
- TRIGGER: Evaluate for autonomous logging on each conversation interaction
- Evaluate session history (not just last message) for milestones
- If activity milestone matched → Log Activity (format: `[Time] Action → Outcome`)
- If note milestone matched → Log Note ONLY if clear cognitive value (format: `[Type]` + 2-3 sentences)
- When uncertain → Log Activity ONLY
- Only write if criteria is matched

**Critical Rules:**
- MUST: Check for parameters first (Step 0) - only execute steps if parameters provided
- MUST: Parse natural language FIRST before asking questions
- MUST: Apply technical writing style proofreading (objective, active voice, precise, concise)
- MUST: Only pass date/time to scripts if user specified them
- MUST: Change to skill directory before calling scripts: `cd ~/.config/devin/skills/obsidian/daily_journal`

**Error Handling:**
- If script fails: Check directory change, validate file paths, verify config.sh exists
- If template not found: Inform user and ask to verify config.sh TEMPLATES_FOLDER path
- If journal file creation fails: Check permissions on vault path

**Context Priority:** Request context (explicitly provided) → Remembered choices → No context

**Entry Format Quick Guide:**
- Activities: `[Time] Action → Outcome (Context)`
- Notes: `[Type]` + 2-3 sentences
- Meetings: `[Time] Title | type: Type | duration: Duration | project: Project`
- Tasks: `- [ ] Project: Task` or `- [ ] Task`

## Core Principles

**Architecture:** Separation of concerns between intelligence layer (skill) and system operations layer (scripts)

**Two Operating Modes:**
- User-initiated: Explicit user requests to log activities, meetings, notes, or tasks
- Autonomous: Automatic logging on each conversation interaction, evaluating session history for milestones

**Context Priority System:** Request context (explicitly provided) → Remembered choices → No context

**Quality Standard:** Apply technical writing style proofreading (objective tone, active voice, precise terminology, clarity, conciseness)

**Date/Time Handling:** Scripts automatically capture current date/time if not provided

## Autonomous Logging Rules

### Trigger Conditions

TRIGGER: Evaluate for autonomous logging on each conversation interaction

Evaluate session history (not just last message) for milestones. Only write if criteria is matched:

**Activity Milestones (MUST LOG):**
- Completed work or tasks
- Debugging or problem-solving progress
- System/tool usage and configuration
- Meaningful actions taken
- Files modified or code changes

**Note Milestones (LOG ONLY if clear cognitive value):**
- Insight was formed
- Non-trivial problem solved
- Decision made
- Reusable learning identified
- Unexpected behavior observed
- Housekeeping items (non-project administrative, scheduling constraints, HR-related matters)

### Entry Format Standards

**Activity Log (Execution Layer):**
- Format: `[Time] Action → Outcome (Context/Artifact)`
- Rules: Past tense, one entry per meaningful action, include tools/systems, no reasoning/speculation, concise and verifiable

**Notes (Cognitive Layer):**
- Format: `[Type]` followed by 2-3 sentences MAX
- Allowed types: `[Insight]`, `[Decision]`, `[Observation]`, `[Hypothesis]`, `[Friction]`, `[Question]`, `[Housekeeping]`
- Rules: Do not restate activity, focus on meaning/implications, concise and standalone, no overlap

### Inference Policy

When information is incomplete:
- Time → Use current time
- Action → Extract from verbs
- Outcome → Infer conservatively (use neutral phrasing: "→ Investigated issue", "→ Partial progress")
- Context → Infer tools/systems from keywords

**MANDATORY: Do NOT fabricate unknown outcomes**

### Dual Logging Policy

**Principle:** Only create Notes when there is clear cognitive value

**Promote Activity → Note if:**
- Insight was formed
- Non-trivial problem solved
- Decision made
- Reusable learning identified
- Unexpected behavior observed

**Do NOT promote if:**
- Routine work
- Mechanical execution
- No new understanding

**DEFAULT:** Activity ONLY

### Note Quality Rules

**De-duplication (MANDATORY):** Before finalizing, ask "Do any notes repeat meaning/context?" If YES, merge

**Aggregation:** Avoid fragmented notes, prefer one higher-quality note when insight matures

**Multi-note:** Allow ONLY if different cognitive types apply (e.g., Insight + Decision), each must stand independently

**Category Selection:** Do not force categories, prefer fewer high-value notes. Priority: Decision > Insight > Friction > Hypothesis > Observation > Question > Housekeeping

### Conservative Bias

**RULE:** When uncertain, log Activity ONLY

Only create Notes when confident they add value and will be useful later

### Workflow Rules

- TRIGGER: Evaluate for autonomous logging on each conversation interaction
- Evaluate session history (not just last message) for milestones
- Only write if criteria is matched
- Do NOT interrupt workflow or ask questions during autonomous logging
- Apply conservative bias and produce best-effort logs
- Use same context priority system as user-initiated logging (request context → remembered choices → no context)
- Apply technical writing style proofreading
- Scripts handle automatic timestamp capture
- **MANDATORY:** When writing logs, indicate source in Devin output: "autonomous" for autonomous logging, "user" for user-initiated, "devin" for Devin's initiative and cognitive reasoning beyond scripted instructions

## User-Initiated Logging Procedures

### Step 0: Parameter Check

**MANDATORY:** Check if skill was invoked with parameters (entry text, description, or any user input)

**If parameters provided:** Proceed to Step 1 (Determine Target Date)

**If NO parameters provided:**
- Inform user what the skill can do:
  - Log activities, meetings, notes, and tasks to your daily journal
  - Automatically apply technical writing style proofreading
  - Support autonomous logging during work sessions
  - Manage project and Jira Epic context for organization
  - Review existing journal entries
- Ask user: "Would you like to set a project and Jira Epic for the current session?"
- If yes: Proceed to Step 1 (Determine Target Date) and continue through context selection (Steps 3-4), then tell user how to log to the journal:
  - "To log to your journal, you can:"
  - "• Use natural language: 'log activity completed code review'"
  - "• Be specific: 'log meeting team standup at 15:30 for 30 minutes'"
  - "• Add context: 'log note about challenges with project X'"
  - "• The skill will automatically apply proofreading and manage context"
  - **FINISH** (do not proceed to do anything else)
- If no: Ask user what they want to do using ask_user_question with these options:
  - "Log an activity"
  - "Log a meeting"
  - "Add a note"
  - "Add a task"
  - "Review today's journal"
  - "Create new journal entry"
- Based on user selection, proceed to appropriate step:
  - Activity/Meeting/Note/Task: Proceed to Step 1 (Determine Target Date) and continue through normal workflow
  - Review today's journal: Read today's journal file and display contents
  - Create new journal entry: Proceed to Step 1 (Determine Target Date) with current date

### Step 1: Determine Target Date

- Check if specific date mentioned (e.g., "Monday", "tomorrow", "2026-04-20")
- If date mentioned: Convert to YYYY-MM-DD format
- If no date: Call `scripts/validate_journal.sh` without parameters (captures current date)
- For tasks with dates: Add target date to task description

### Step 2: Initialize Journal and Get Context

**CRITICAL:** First change directory: `cd ~/.config/devin/skills/obsidian/daily_journal`

Call `scripts/validate_journal.sh [target_date]` to:
- Capture current date/time (or use provided target date)
- Check if daily journal file exists for target date
- Create file from template if it doesn't exist
- Get all projects and their associated OCTO epics

Parse output to extract:
- File status (CREATED or EXISTS)
- File path
- Date (YYYY-MM-DD format)
- Time (HH:MM format)
- Display date (DDD DD MMMM YYYY format)
- Project/epic context data (between CONTEXT_START and CONTEXT_END)

### Step 3: Select Project Context

**Priority Check:** If project/epic choices were made in previous ask_user_question during this session, use most recent project choice and skip to Jira Epic selection (or skip if epic also chosen)

**If no context from remembered choices:**
- Parse stored context to extract project names (first field of each pipe-delimited line)
- Display full project list to user
- Present 4 options using ask_user_question:
  - Option 1: Top project
  - Option 2: Second project
  - Option 3: "No Project" (skips project context)
  - Option 4: "New Project" (ask for name and create folder)

Handle selection:
- Existing project: Use as project context
- "No Project": Skip project context (leave blank)
- "New Project": Ask for name, create folder in OIL R&D Journal directory
- "Other": Try to match to existing project; if found use it, if not use entered name but do NOT create folder

### Step 4: Select Jira Epic Context

- If project context skipped ("No Project"): Skip Jira Epic selection entirely

**Priority Check:** If project context selected and project/epic choices were made in previous ask_user_question during this session, use most recent epic choice and skip user selection

**If no context from remembered choices:**
- Parse stored context to extract epics for selected project
- Display full OCTO folder list to user
- Present 4 options using ask_user_question:
  - Option 1: Top OCTO folder (or "No Jira Epic" if none exist)
  - Option 2: Second OCTO folder (or "New Jira Epic" if Option 1 was "No Jira Epic")
  - Option 3: "No Jira Epic" (only present if OCTO folders exist)
  - Option 4: "New Jira Epic" (ask for reference and create folder)

**Special case:** No OCTO folders exist → Present only 2 options: "No Jira Epic" and "New Jira Epic"

Handle selection:
- Existing OCTO folder: Use as Jira Epic context
- "No Jira Epic": Skip Jira Epic context (leave blank)
- "New Jira Epic": Ask for reference, create folder under project directory
- "Other": Try to match to existing OCTO folder; if found use it, if not use entered reference but do NOT create folder

### Step 5: Get Entry Content

**MANDATORY:** Parse natural language request FIRST to extract available information:
- Entry type: Look for "log activity", "log meeting", "log note", "log task"
- For meetings: Extract title, time (e.g., "at 15:30"), duration (e.g., "for 30 minutes"), meeting type
- For tasks: Extract task description, target date (e.g., "for Monday"), project context (e.g., "no project")
- For activities: Extract activity description and time
- For notes: Extract topic/summary and time

**RULE:** Only ask for missing information (what was not provided in request)

**Entry Type Handling:**

**If entry text provided and type clear:** Use directly

**If no entry text or ambiguous (e.g., "log it"):** Ask user for entry type using ask_user_question: "Activity", "Meeting", "Note", "Task"

**Activity entries:**
- Use parsed activity description and time if available
- If not parsed: Ask for entry description (project and Jira Epic already selected)
- If user specifies time: Pass to script; else let script capture current time

**Meeting entries:**
- Use parsed title, time, duration, and type if available
- Only ask for information not provided in original request
- If meeting type not specified: Ask for it or use sensible default based on title
- If not project-related: Leave project field blank
- Format: `[HH:MM] <title> | type: <type> | duration: <duration> | project: <project>`

**Note entries:**
- Use parsed time, project context, Jira Epic context, and topic if available
- Only ask for information not provided in original request
- Generate 2-3 sentence summary based on request context if sufficient information provided
- Only ask for summary if request is truly ambiguous or lacks sufficient context
- If clear topic provided (e.g., "log a note on challenges faced"): Generate reasonable summary based on topic and session context
- Notes are for diary-style entries: thoughts, observations, challenges, insights (not technical notes)
- Format: `[HH:MM] project: <project> | Jira Epic: <Jira Epic>` followed by summary on next line
- Insert blank line between Notes entries

**Task entries:**
- Use parsed task description, target date, and project context if available
- Only ask for project context if not specified (e.g., if "no project" mentioned, skip question)
- Check if specific date mentioned in original request
- If future date specified: Use that date for file naming and add target date to task description
- If no date specified: Use current date and standard format
- Format rules:
  - Project blank/not applicable: `- [ ] <task>`
  - Project specified and current date: `- [ ] <project>: <task>`
  - Project specified and future date: `- [ ] <project>: <task> (for <date>)`
- Keep tasks for same project together in list

**For new entries:** Guide through daily template structure

**For existing entries:** Ask what they'd like to add to today's entry

**MANDATORY:** After getting entry content, perform technical writing style proofreading before proceeding to step 6:
- Review entry content (activity description, meeting title, note summary, or task description)
- Automatically correct minor proofreading issues while preserving original meaning and tone
- Enforce technical writing style: objective tone, active voice, remove ambiguity, ensure precise terminology, eliminate redundancy, focus on clarity and conciseness
- Check for sentence complexity and simplify descriptions to make them more concise and easier to read when possible

### Step 6: Create or Update Journal Entry

**IMPORTANT:** Only pass date/time parameters to scripts if user specifically provided them in request

**If user does NOT specify date or time:** DO NOT pass these parameters - let scripts automatically capture and use current date/time

**Source indication for audit purposes:**
- **user**: Explicit user-directed logging (starts with "log task", "log activity", "log meeting", or "log note")
- **autonomous**: Rule-based automatic logging (follows specific autonomous logging rules for activities and notes, triggered by conversation evaluation matching defined milestones, does not apply to tasks)
- **devin**: Initiative and cognitive reasoning beyond scripted instructions (when Devin takes initiative based on understanding context, uses cognitive reasoning beyond the skill's scripted rules, example: marking a task as completed because Devin understands the user completed it)

**MANDATORY:** Before calling script, indicate source in Devin output (e.g., "Writing to journal [source: user]...")

**Script calls:**
- Activity Log: `scripts/log_activity.sh [date] [time] <activity_description> [project] [jira_epic]`
- Meeting Log: `scripts/log_meeting.sh [date] [time] <title> <type> <duration> [project]`
- Notes: `scripts/log_note.sh [date] [time] [project] [jira_epic] <summary>`
- Tasks: `scripts/log_task.sh [date] <task_description> [project] [target_date]`

Scripts handle proper formatting, file placement, and timestamp capture

### Step 7: Confirm Creation

- Tell user journal entry has been created or updated
- Provide file path
- Offer to help review or edit entry

## Script Reference

**Location:** All scripts in `scripts/` directory, sourced from `config.sh`

- **validate_journal.sh**: Journal validation and context retrieval
- **log_activity.sh**: Activity logging
- **log_meeting.sh**: Meeting logging
- **log_note.sh**: Note logging
- **log_task.sh**: Task logging

## Example Workflows

**User:** "skill daily_journal" (no parameters)
**You:** Check parameters (none) → inform user what skill can do → ask about setting project/Jira Epic → if yes, set context and tell how to log → if no, ask what to do and proceed

**User:** "Create a daily journal entry"
**You:** Validate journal → present project/epic options → ask entry type → ask content → proofread → call script

**User:** "skill journal Updated journal skill for devin.ai"
**You:** Validate journal → present project/epic options → use provided text → proofread → call log_activity.sh

**User:** "Add another activity to my journal"
**You:** Validate journal → present project/epic options → ask content → proofread → call log_activity.sh

**User:** "Add a meeting to my journal"
**You:** Validate journal → present project/epic options → use parsed meeting details if available → proofread → call log_meeting.sh

**User:** "log meeting OIL and Development Team meeting at 15:30 for 30 minutes no project"
**You:** Parse request (meeting, title, time 15:30, duration 30min, no project) → skip context selections → ask meeting type → proofread → call log_meeting.sh

**User:** "Add a note to my journal"
**You:** Validate journal → present project/epic options → use parsed details if available → proofread → call log_note.sh

**User:** "Add a task to my journal"
**You:** Validate journal → present project/epic options → use parsed description if available → proofread → call log_task.sh

**User:** "Create a task for Monday to update my VDI linux system"
**You:** Parse date ("Monday") → validate journal with target date → present project/epic options → use parsed description → proofread → call log_task.sh
