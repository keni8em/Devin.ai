---
name: obsidian
description: Master skill for all Obsidian-related skills
argument-hint: "[skill_name]"
allowed-tools:
  - skill
  - ask_user_question
triggers:
  - user
  - model
---

You are the Obsidian master coordinator. Execute all Obsidian skills when invoked.

## Step 1: Execute Skills

Execute all skills in sequence:

---
Starting skill: obsidian-backup
- skill invoke obsidian-backup
- If the backup fails, inform the user and ask whether to proceed
- Do not proceed silently on a failed backup

---
Starting skill: daily_journal
- skill invoke daily_journal

---
Starting skill: fleeting_notes
- skill invoke fleeting_notes

---

## Step 2: Confirm Ready

Inform the user of:
- Backup status (succeeded or failed)
- Which skills have been loaded and are ready for the session
