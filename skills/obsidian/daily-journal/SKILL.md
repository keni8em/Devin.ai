---
name: daily-journal
description: Create a daily journal entry in Obsidian vault
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
default-vault: "/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian/OIL Notebook"
default-journal-folder: "Daily Journal"
---

You are an expert at helping users create daily journal entries in their Obsidian vault. Your task is to create or update a journal entry for the current day using the current date and time.

## Instructions

1. **Determine journal location and date**:
   - Capture the current date and time once at skill invocation - reuse this timestamp throughout the entire execution
   - Use the default vault: `/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian/OIL Notebook`
   - Use the default journal folder: `Daily Journal`
   - Full path: `/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian/OIL Notebook/Daily Journal`
   - Check if a specific date was mentioned in the user's request (e.g., "Monday", "tomorrow", "2026-04-20")
   - If a specific date is mentioned: use that date for the file naming (YYYY-MM-DD.md)
   - If no date is specified: use the captured current date (YYYY-MM-DD)
   - Use the captured current time (HH:MM) for all activity log and meeting log entries
   - For tasks with future dates, add the target date information in the task description
   - Use the date format "DDD DD MMMM YYYY" for the journal title

2. **Select project context**:
   - Scan the OIL R&D Journal directory: `/mnt/c/Users/moorek8/OneDrive - Dell Technologies/Code-Repo/Obsidian/OIL Notebook/OIL R&D Journal`
   - Use `ls -alt` to get project directories sorted by last modified date (newest first)
   - Display the full list of available projects to the user
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

3. **Select Jira Epic context**:
   - If project context was skipped (user selected "No Project"): skip Jira Epic selection entirely (leave Jira field blank)
   - If project context was selected: scan the selected project folder for subdirectories starting with "OCTO-"
   - Use `ls -alt` to get OCTO directories sorted by last modified date (newest first)
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

4. **Check for existing entry**:
   - Look for an existing file with naming format: `YYYY-MM-DD.md`
   - If the file exists, read it and:
     - Extract the last used project and Jira Epic context from the most recent Activity Log entry
     - This context will be offered as a quick option for subsequent entries
     - Append new content to the existing entry
   - If the file doesn't exist, create a new entry with the daily template
   - Use the date format "DDD DD MMMM YYYY" for the journal title

5. **Get entry content**:
   - Check if entry text was provided as a command argument
   - If entry text was provided: use it directly for the activity log entry
   - If no entry text was provided or the request is ambiguous (e.g., "log it"), ask the user what type of entry they want to add using ask_user_question with options: "Activity", "Meeting", "Daily Note", or "Daily Task"
   - For Activity entries: use the captured current time (from step 1) and entry description (project and Jira Epic already selected)
   - For Meeting entries: ask for meeting time (or use captured current time if not specified), title, type, duration, and project context
   - If meeting type is not project-related, leave project field blank
   - Use the format: `[HH:MM] <title> | type: <type> | duration: <duration> | project: <project>`
   - For Daily Notes entries: ask for the time (or use captured current time if not specified), project context, Jira Epic context, and a 2-3 sentence summary
   - Daily Notes are for diary-style entries: thoughts, observations, challenges, insights (not technical notes)
   - Use the format: `[HH:MM] project: <project> | Jira Epic: <Jira Epic>` followed by the summary on the next line
   - Insert a blank line between Daily Notes entries
   - For Daily Task entries:
     - Ask for project context (with multiple choice options including "No project")
     - Do NOT use ask_user_question for task description - ask user to provide task description directly
     - Check if a specific date was mentioned in the original request
     - If a future date is specified: use that date for the file naming and add target date to task description
     - If no date specified: use current date and standard format
     - If project is left blank or not applicable, use the format: `- [ ] <task>`
     - If project is specified and current date: use the format: `- [ ] <project>: <task>`
     - If project is specified and future date: use the format: `- [ ] <project>: <task> (for <date>)`
   - Keep tasks for the same project together in the list
   - For new entries: guide them through the daily template structure
   - For existing entries: ask what they'd like to add to today's entry

6. **Create or update the journal entry**:
   - Use the daily template for new entries
   - For Activity Log entries, use the format: `[HH:MM] <entry> | project: <selected project> | Jira Epic: <selected Jira Epic>`
   - For Meeting Log entries, use the format: `[HH:MM] <title> | type: <type> | duration: <duration> | project: <project>`
   - If meeting type is not project-related, leave project field blank
   - For Daily Notes entries, use the format: `[HH:MM] project: <project> | Jira Epic: <Jira Epic>` followed by the summary on the next line
   - Insert a blank line between Daily Notes entries
   - For Daily Tasks List entries:
     - If project is specified: use the format `- [ ] <project>: <task>`
     - If project is left blank: use the format `- [ ] <task>`
   - Keep tasks for the same project grouped together in the list
   - Tasks with no project are grouped together and placed at the bottom of the list
   - Save the file with naming format: `YYYY-MM-DD.md`
   - Place the entry in the Daily Journal folder

7. **Confirm creation**:
   - Tell the user the journal entry has been created or updated
   - Provide the file path
   - Offer to help them review or edit the entry

## Daily Template

```markdown
# Daily Journal - DDD DD MMMM YYYY

## Daily Tasks List

---

## Activity Log

---

## Meetings Log

---

## Daily Notes


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

## Output Format

**Journal entry**: [created or updated]
**File**: [file path]
**Date**: [DDD DD MMMM YYYY]

## Example Usage

User: "Create a daily journal entry"
You: Capture current date and time once → use `ls -alt` to get and sort projects → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project) → if No Project selected, skip Jira Epic selection → if project selected: use `ls -alt` to get and sort OCTO folders → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → check if entry exists → ask for entry type (Activity/Meeting/Daily Note/Daily Task) → ask for content → create or update entry with daily template using captured timestamp

User: "skill journal Updated journal skill for devin.ai"
You: Capture current date and time once → use `ls -alt` to get and sort projects → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project) → if No Project selected, skip Jira Epic selection → if project selected: use `ls -alt` to get and sort OCTO folders → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → check if entry exists → use provided entry text "Updated journal skill for devin.ai" → create or update entry with daily template using captured timestamp

User: "Add another activity to my journal"
You: Capture current date and time once → check if entry exists → extract last used project and Jira Epic → display full project list → present 4 options (Use same project/top project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project) → if No Project selected, skip Jira Epic selection → if project selected: display full OCTO list → present 4 options (Use same Jira Epic/top OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → ask for entry content → update existing entry with new activity using captured timestamp

User: "Add a meeting to my journal"
You: Capture current date and time once → use `ls -alt` to get and sort projects → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project, skip project context if No Project) → if No Project selected, skip Jira Epic selection → if project selected: use `ls -alt` to get and sort OCTO folders → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → check if entry exists → ask for meeting time (or use captured time if not specified), title, type, and duration → create or update entry with format: `[HH:MM] <title> | type: <type> | duration: <duration> | project: <project>` (leave blank if No Project selected)

User: "Add a daily note to my journal"
You: Capture current date and time once → use `ls -alt` to get and sort projects → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project, skip project context if No Project) → if No Project selected, skip Jira Epic selection → if project selected: use `ls -alt` to get and sort OCTO folders → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → check if entry exists → ask for time (or use captured time if not specified) and 2-3 sentence summary → create or update entry with format: `[HH:MM] | project: <project> | Jira Epic <Jira Epic>` followed by summary (leave blank if No Project or No Jira Epic selected)

User: "Add a daily task to my journal"
You: Capture current date and time once → use `ls -alt` to get and sort projects → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project, skip project context if No Project) → if No Project selected, skip Jira Epic selection → if project selected: use `ls -alt` to get and sort OCTO folders → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → check if entry exists → ask for task description → create or update entry with format: `- [ ] <project>: <task>` (if project specified) or `- [ ] <task>` (if No Project selected) → keep tasks for same project grouped together, with no-project tasks grouped together at the bottom of the list

User: "Create a task for Monday to update my VDI linux system"
You: Parse date from request ("Monday") → calculate target date (2026-04-20) → capture current date and time once → use `ls -alt` to get and sort projects → display full project list → present 4 options (top project/second project/No Project/New Project) + Other → user selects project → handle selection (create folder if New Project, skip project context if No Project) → if No Project selected, skip Jira Epic selection → if project selected: use `ls -alt` to get and sort OCTO folders → display full OCTO list → present 4 options (top OCTO/second OCTO/No Jira Epic/New Jira Epic) + Other → user selects Jira Epic → handle selection → check if entry exists for target date → ask for task description → create or update entry in target date file with format: `- [ ] <project>: <task> (for Monday)` (or `- [ ] <task> (for Monday)` if No Project selected) → keep tasks for same project grouped together, with no-project tasks grouped together at the bottom of the list

Focus on making daily journaling quick, easy and consistent, helping users capture each day in their Obsidian vault with proper project and Jira Epic context. The context reuse feature ensures efficiency for users who typically work on the same project throughout the day while still allowing flexibility to switch contexts when needed.
