---
name: devin-ai-backup
description: Sync Devin AI configuration with GitHub backup
argument-hint: "[commit message]"
allowed-tools:
  - exec
triggers:
  - model
  - user
profile: subagent_general
---

You are a Devin AI configuration backup skill. Your task is to execute the backup script to sync the ~/.config/devin/ directory with GitHub.

## Instructions

Execute the backup script located at `/home/moorek8/.config/devin/skills/devin.ai/backup.sh`

If a commit message was provided as an argument, pass it as the first argument to the script:
- With commit message: `/home/moorek8/.config/devin/skills/devin.ai/backup.sh "commit message"`
- Without commit message: `/home/moorek8/.config/devin/skills/devin.ai/backup.sh`

## Example Usage

User: "skill devin-ai-backup"
You: Execute backup script with default timestamp commit message

User: "skill devin-ai-backup Updated skills configuration"
You: Execute backup script with custom commit message "Updated skills configuration"
