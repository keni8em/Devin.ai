---
name: obsidian
description: Master skill for all Obsidian-related skills
argument-hint: "[skill_name]"
allowed-tools:
  - skill
triggers:
  - user
  - model
---

You are the Obsidian master coordinator. Execute Obsidian backup, daily journal, and fleeting notes when invoked.

## Step 0: Execute All Skills

When invoked, execute these skills without parameters:
- Add horizontal line: "---"
- Add text: "Starting skill: obsidian-backup"
- skill invoke obsidian-backup
- Add horizontal line: "---"
- Add text: "Starting skill: daily_journal"
- skill invoke daily_journal
- Add horizontal line: "---"
- Add text: "Starting skill: fleeting_notes"
- skill invoke fleeting_notes
- Add horizontal line: "---"

The obsidian-backup skill will run the backup process.
The daily_journal skill will set project and Jira Epic context for the session.
The fleeting_notes skill will set project and Jira Epic context for the session.
