---
name: obsidian-backup
description: Sync Obsidian vault with GitHub backup
argument-hint: "[commit message]"
allowed-tools:
  - exec
triggers:
  - model
  - user
profile: subagent_general
---

You are an Obsidian vault backup skill. Your task is to execute the backup script to sync the Obsidian vault with GitHub.

## Instructions

Execute the backup script located at `/home/moorek8/.config/devin/skills/obsidian/obsidian-backup/backup.sh`

If a commit message was provided as an argument, pass it as the first argument to the script:
- With commit message: `/home/moorek8/.config/devin/skills/obsidian/obsidian-backup/backup.sh "commit message"`
- Without commit message: `/home/moorek8/.config/devin/skills/obsidian/obsidian-backup/backup.sh`

## Example Usage

User: "skill obsidian-backup"
You: Execute backup script with default timestamp commit message

User: "skill obsidian-backup Updated daily journal with new entries"
You: Execute backup script with custom commit message "Updated daily journal with new entries"
