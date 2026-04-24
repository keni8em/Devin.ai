---
name: daily_journal
description: Create a daily journal entry in Obsidian vault
argument-hint: "[entry text]"
allowed-tools:
  - write
  - read
  - exec
  - find_file_by_name
  - ask_user_question
triggers:
  - user
---

You are an expert at helping users create daily journal entries in their Obsidian vault. Your task is to create or update a journal entry for the current day using the current date and time.

## Architecture

This skill uses a separation of concerns:
- **Intelligence Layer (Skill)**: Handles decision making, user interaction, context selection, and orchestrates the workflow
- **System Operations Layer (Scripts)**: Handles file system queries and file writing operations

The skill is responsible for:
- Date/time capture and parsing
- User interaction and context selection
- Decision logic for project/Jira Epic selection
- Orchestrating the workflow and calling appropriate scripts

The scripts are responsible for:
- Querying the file system for projects and Jira Epics
- Checking if journal entries exist
- Creating new journal entries with templates
- Writing specific entry types (activity, meeting, note, task) to journal files

## Available Scripts

All scripts are located in the `scripts/` directory within the skill and are sourced from `config.sh` for configuration.

### Query & Setup Scripts

- **validate_journal.sh**: Validates and prepares the daily journal file, then returns context data
  - Usage: `scripts/validate_journal.sh [target_date]` (execute from skill directory)
  - If target_date is provided in YYYY-MM-DD format, uses that date
  - Otherwise, captures current date and time
  - Combines multiple operations in one call:
    1. Captures current date and time (or uses provided date)
    2. Checks if daily journal file exists for the target date
    3. Creates file from template if it doesn't exist (reads template from Obsidian vault)
    4. Gets all projects and their associated OCTO epics
  - Returns structured output:
    ```
    STATUS:CREATED or STATUS:EXISTS
    FILE:/path/to/journal/file.md
    DATE:YYYY-MM-DD
    TIME:HH:MM
    DISPLAY_DATE:Mon 20 April 2026
    CONTEXT_START
    ProjectName|Epic1|Epic2|Epic3...
    CONTEXT_END
    ```
  - The skill parses this output to get file status, path, date/time, and project/epic context
  - Template is read from: `$OBSIDIAN_VAULT_PATH/$TEMPLATES_FOLDER/$DAILY_JOURNAL_TEMPLATE.md`

### Logging Scripts

- **log_activity.sh**: Logs an activity to the Activity Log section
  - Usage: `log_activity.sh [date] [time] <activity_description> [project] [jira_epic]`
  - If date/time not provided, script automatically captures current date/time
  - Returns: "LOGGED:<file_path>"

- **log_meeting.sh**: Logs a meeting to the Meetings Log section
  - Usage: `log_meeting.sh [date] [time] <title> <type> <duration> [project]`
  - If date/time not provided, script automatically captures current date/time
  - Returns: "LOGGED:<file_path>"

- **log_note.sh**: Logs a daily note to the Notes section
  - Usage: `log_note.sh [date] [time] [project] [jira_epic] <summary>`
  - If date/time not provided, script automatically captures current date/time
  - Returns: "LOGGED:<file_path>"

- **log_task.sh**: Logs a task to the Tasks section
  - Usage: `log_task.sh [date] <task_description> [project] [target_date]`
  - If date not provided, script automatically captures current date
  - Returns: "LOGGED:<file_path>"
  - Note: Automatically groups tasks by project

## Instructions

This skill operates in one mode:
- **User-initiated logging**: When explicitly asked to log activities, meetings, notes, or tasks

1. **Determine target date**:
   - Check if a specific date was mentioned in the user's request (e.g., "Monday", "tomorrow", "2026-04-20")
   - If a specific date is mentioned: convert it to YYYY-MM-DD format
   - If no date is specified: call scripts/validate_journal.sh without parameters (it will capture current date)
   - For tasks with dates, add the target date information in the task description
   - Note: The log scripts handle timestamp capture automatically if no date/time is provided

2. **Initialize journal and get context**:
   - **CRITICAL**: First change directory to the skill location using: `cd ~/.config/devin/skills/obsidian/daily_journal`
   - Then call the `scripts/validate_journal.sh [target_date]` script to:
     - Capture current date and time (or use provided target date)
     - Check if the daily journal file exists for the target date
     - Create the file from template if it doesn't exist
     - Get all projects and their associated OCTO epics
   - Parse the script output to extract:
     - File status (CREATED or EXISTS)
     - File path
     - Date (YYYY-MM-DD format)
     - Time (HH:MM format)
     - Display date (DDD DD MMMM YYYY format, e.g., "Mon 20 April 2026")
     - Project/epic context data (between CONTEXT_START and CONTEXT_END)
   - Store the date and time for use in log entries
   - If file status is EXISTS, read the existing file to extract the last used project and Jira Epic context from the most recent Activity Log entry
   - Store the context data for later use in project and epic selection

3. **Select project context**:
   - **Remembered choices check**: Check if project/epic choices were made in a previous ask_user_question instance during this session. If yes, use the most recent project choice and skip to Jira Epic selection (or skip if epic was also chosen).
   - If no context from remembered choices, proceed with user selection:
   - Parse the stored context output to extract project names (first field of each pipe-delimited line)
   - Display the full list of available project names to the user (only project names, not epic details)
   - Determine the 4 options to present:
     - **Option 1**: If working with existing daily entry with previous context: "Use same project as last entry: <project name>"
                If working with new entry or no previous context: Top project from the list
     - **Option 2**: If Option 1 was "Use same project...": Top project from the list
                If Option 1 was top project: Second project from the list
     - **Option 3**: "No Project" - if selected, project context will not be used in the rest of the task
     - **Option 4**: "New Project" - if selected, ask user for new project name and create the project folder
   - Present these 4 options using ask_user_question tool (tool automatically provides "Other" option)
   - Handle user selection:
     - If user selects an existing project: use that as the project context
     - If user selects "No Project": skip project context in the rest of the task (leave project field blank)
     - If user selects "New Project": ask user for the new project name, then create the project folder in the OIL R&D Journal directory
     - If user selects "Other": try to match the entered name to an existing project; if found, use it; if not found, use the entered name but do NOT create a new project folder

4. **Select Jira Epic context**:
   - If project context was skipped (user selected "No Project"): skip Jira Epic selection entirely (leave Jira field blank)
   - **Remembered choices check**: If project context was selected, check if project/epic choices were made in a previous ask_user_question instance during this session. If yes, use the most recent epic choice and skip user selection.
   - If no context from remembered choices, proceed with user selection:
   - Parse the stored context output from step 2 to extract epics for the selected project
     - Find the line matching the selected project name
     - Extract fields after the first (split by pipe) to get the list of epics
     - If the line has no pipe delimiters, the project has no epics
   - Display the full list of available OCTO folders to the user
   - Determine the 4 options to present:
     - **Option 1**: If working with existing daily entry with previous context: "Use same Jira Epic as last entry: <epic name>"
                If working with new entry or no previous context: Top OCTO folder from the list
                If no OCTO folders exist: "No Jira Epic"
     - **Option 2**: If Option 1 was "Use same Jira Epic...": Top OCTO folder from the list
                If Option 1 was top OCTO folder: Second OCTO folder from the list
                If Option 1 was "No Jira Epic" (no OCTO folders): "New Jira Epic"
                If OCTO folders exist but Option 1 was not "Use same...": Second OCTO folder from the list
     - **Option 3**: "No Jira Epic" - if selected, Jira Epic context will not be used in the rest of the task (only present if OCTO folders exist)
     - **Option 4**: "New Jira Epic" - if selected, ask user for new Jira Epic reference and create the folder under the project directory
   - Special case for no OCTO folders: Present only 2 options - "No Jira Epic" and "New Jira Epic" (satisfies 2-4 option requirement)
   - Present these options using ask_user_question tool (tool automatically provides "Other" option)
   - Handle user selection:
     - If user selects an existing OCTO folder: use that as the Jira Epic context
     - If user selects "No Jira Epic": skip Jira Epic context in the rest of the task (leave Jira field blank)
     - If user selects "New Jira Epic": ask user for the new Jira Epic reference, create the folder under the project directory, and use it in the entry
     - If user selects "Other": try to match the entered name to an existing OCTO folder; if found, use it; if not found, use the entered reference but do NOT create a new folder

5. **Get entry content**:
   - **Parse natural language request first**: Before asking questions, parse the user's original request to extract available information:
     - Entry type: Look for "log activity", "log meeting", "log note", "log task", or similar phrases
     - For meetings: Extract title, time (e.g., "at 15:30", "at 3:30 PM"), duration (e.g., "for 30 minutes", "1 hour"), and meeting type if specified
     - For tasks: Extract task description, target date (e.g., "for Monday", "tomorrow"), and project context if specified (e.g., "no project")
     - For activities: Extract activity description and time if specified
     - For notes: Extract topic/summary and time if specified
   - **Only ask for missing information**: After parsing, only ask the user for information that was not provided in the request
   - Check if entry text was provided as a command argument
   - If entry text was provided and entry type is clear: use it directly for the entry
   - If no entry text was provided or the request is ambiguous (e.g., "log it"), ask the user what type of entry they want to add using ask_user_question with options: "Activity", "Meeting", "Note", or "Task"
   - For Activity entries:
     - Use the parsed activity description and time if available
     - If not parsed, ask for the entry description (project and Jira Epic already selected)
     - If user specifies a time, pass it to the script; otherwise let the script capture current time
   - For Meeting entries:
     - Use the parsed title, time, duration, and type if available
     - Only ask for information that was not provided in the original request
     - If meeting type is not specified, ask for it or use a sensible default based on the title
     - If meeting type is not project-related, leave project field blank
     - Use the format: `[HH:MM] <title> | type: <type> | duration: <duration> | project: <project>`
   - For Daily Notes entries:
     - Use the parsed time, project context, Jira Epic context, and topic if available
     - Only ask for information that was not provided in the original request
     - Generate a 2-3 sentence summary based on the user's request context if sufficient information is provided
     - Only ask for a summary if the request is truly ambiguous or lacks sufficient context
     - If the user provides a clear topic (e.g., "log a note on the challenges faced completing this skill"), generate a reasonable summary based on that topic and the session context
     - Daily Notes are for diary-style entries: thoughts, observations, challenges, insights (not technical notes)
     - Use the format: `[HH:MM] project: <project> | Jira Epic: <Jira Epic>` followed by the summary on the next line
     - Insert a blank line between Notes entries
   - For Task entries:
     - Use the parsed task description, target date, and project context if available
     - Only ask for project context if not specified in the request (e.g., if "no project" was mentioned, skip the question)
     - Check if a specific date was mentioned in the original request
     - If a future date is specified: use that date for the file naming and add target date to task description
     - If no date specified: use current date and standard format
     - If project is left blank or not applicable, use the format: `- [ ] <task>`
     - If project is specified and current date: use the format: `- [ ] <project>: <task>`
     - If project is specified and future date: use the format: `- [ ] <project>: <task> (for <date>)`
   - Keep tasks for the same project together in the list
   - For new entries: guide them through the daily template structure
   - For existing entries: ask what they'd like to add to today's entry
   - **MANDATORY**: After getting the entry content, perform proofreading before proceeding to step 6. Review the entry content (activity description, meeting title, note summary, or task description) and automatically correct minor proofreading issues while preserving the original meaning and tone. Additionally, check for sentence complexity and simplify descriptions to make them more concise and easier to read when possible.

6. **Create or update the journal entry**:
   - **IMPORTANT**: Only pass date/time parameters to scripts if the user specifically provided them in their request
   - If the user does NOT specify a date or time, DO NOT pass these parameters - let the scripts automatically capture and use the current date/time
   - The scripts have built-in date/time capture logic and will use current date/time if not provided
   - For Activity Log entries: call `scripts/log_activity.sh <activity_description> [project] [jira_epic]` (only add [date] [time] if user specified them)
   - For Meeting Log entries: call `scripts/log_meeting.sh <title> <type> <duration> [project]` (only add [date] [time] if user specified them, leave project blank if not project-related)
   - For Daily Notes entries: call `scripts/log_note.sh [project] [jira_epic] <summary>` (only add [date] [time] if user specified them, leave project/jira_epic blank if not selected)
   - For Tasks entries: call `scripts/log_task.sh <task_description> [project] [target_date]` (only add [date] if user specified a specific date, leave project blank if not selected, leave target_date blank if current date)
   - The scripts handle proper formatting, file placement, and timestamp capture

7. **Confirm creation**:
   - Tell the user the journal entry has been created or updated
   - Provide the file path
   - Offer to help them review or edit the entry

## Example Usage

User: "Create a daily journal entry"
You: Check if date mentioned → if not, call `scripts/validate_journal.sh` (captures current date/time) → if yes, convert date and call `scripts/validate_journal.sh` <target_date>` → parse output to extract file status, path, date, time, and project/epic data → if file exists, read it to extract last used context → parse context data to extract project names → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project) → if No Project selected, skip Jira Epic selection → if project selected: parse stored context to extract epics for selected project → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → ask for entry type (Activity/Meeting/Note/Task) → ask for content → validate and refine content for proofreading issues → call appropriate log script (scripts will capture current date/time if not provided)

User: "skill journal Updated journal skill for devin.ai"
You: Call `scripts/validate_journal.sh` (captures current date/time) → parse output to extract file status, path, date, time, and project/epic data → parse context data to extract project names → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project) → if No Project selected, skip Jira Epic selection → if project selected: parse stored context to extract epics for selected project → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → use provided entry text "Updated journal skill for devin.ai" → validate and refine content for proofreading issues → call `scripts/log_activity.sh` (script will capture current date/time if not provided)

User: "Add another activity to my journal"
You: Call `scripts/validate_journal.sh` (captures current date/time) → parse output to extract file status, path, date, time, and project/epic data → if file exists, read it to extract last used context → parse context data to extract project names → display full project list → present 4 options (Use same project/top project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project) → if No Project selected, skip Jira Epic selection → if project selected: parse stored context to extract epics for selected project → display full OCTO list → present 4 options (Use same Jira Epic/top OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → ask for entry content → validate and refine content for proofreading issues → call `scripts/log_activity.sh` (script will capture current date/time if not provided)

User: "Add a meeting to my journal"
You: Call `scripts/validate_journal.sh` (captures current date/time) → parse output to extract file status, path, date, time, and project/epic data → parse context data to extract project names → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project, skip project context if No Project) → if No Project selected, skip Jira Epic selection → if project selected: parse stored context to extract epics for selected project → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → use parsed meeting time/title/duration if available, only ask for missing information → validate and refine content for proofreading issues → call `scripts/log_meeting.sh` with appropriate parameters (leave project blank if No Project selected, script will capture current date/time if not provided)

User: "log meeting OIL and Development Team meeting at 15:30 for 30 minutes no project"
You: Parse request to extract: entry type (meeting), title (OIL and Development Team meeting), time (15:30), duration (30 minutes), project (no project) → Call `scripts/validate_journal.sh` (captures current date/time) → parse output to extract file status, path, date, time, and project/epic data → skip project selection (user specified "no project") → skip Jira Epic selection (no project) → only ask for meeting type (not provided in request) → validate and refine content for proofreading issues → call `scripts/log_meeting.sh` with extracted parameters (leave project blank, script will capture current date/time if not provided)

User: "Add a note to my journal"
You: Call `scripts/validate_journal.sh` (captures current date/time) → parse output to extract file status, path, date, time, and project/epic data → parse context data to extract project names → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project, skip project context if No Project) → if No Project selected, skip Jira Epic selection → if project selected: parse stored context to extract epics for selected project → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → use parsed time/topic if available, only ask for missing information → validate and refine content for proofreading issues → call `scripts/log_note.sh` with appropriate parameters (leave project/jira_epic blank if No Project or No Jira Epic selected, script will capture current date/time if not provided)

User: "Add a task to my journal"
You: Call `scripts/validate_journal.sh` (captures current date/time) → parse output to extract file status, path, date, time, and project/epic data → parse context data to extract project names → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project, skip project context if No Project) → if No Project selected, skip Jira Epic selection → if project selected: parse stored context to extract epics for selected project → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → use parsed task description if available, only ask if not parsed → validate and refine content for proofreading issues → call `scripts/log_task.sh` with appropriate parameters (leave project blank if No Project selected, script will capture current date if not provided)

User: "Create a task for Monday to update my VDI linux system"
You: Parse date from request ("Monday") → calculate target date (2026-04-20) → call `scripts/validate_journal.sh 2026-04-20` → parse output to extract file status, path, date, time, and project/epic data → parse context data to extract project names → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project, skip project context if No Project) → if No Project selected, skip Jira Epic selection → if project selected: parse stored context to extract epics for selected project → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → use parsed task description if available, only ask if not parsed → validate and refine content for proofreading issues → call `scripts/log_task.sh` with target date parameter (script handles task formatting and grouping, will capture current date if not provided)
