#!/bin/bash

# Obsidian Vault Backup Script
# Syncs the Obsidian vault with GitHub repository

set -e  # Exit on error

# Source the skill-specific configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

VAULT_PATH="$OBSIDIAN_VAULT_PATH"
COMMIT_MESSAGE="${1:-$BACKUP_COMMIT_PREFIX: $(date '+%Y-%m-%d %H:%M:%S')}"

echo "=== Obsidian Vault Backup Script ==="
echo "Vault path: $VAULT_PATH"
echo "Commit message: $COMMIT_MESSAGE"
echo ""

# Navigate to vault directory
cd "$VAULT_PATH" || {
    echo "Error: Cannot navigate to vault directory: $VAULT_PATH"
    exit 1
}

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed"
    exit 1
fi

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    echo "Git repository initialized"
fi

# Ensure git user identity is configured
if [ -z "$(git config user.name)" ]; then
    git config user.name "$GIT_USER_NAME"
    git config user.email "$GIT_USER_EMAIL"
    echo "Git user identity configured"
fi

# Get current branch (needed for summary regardless of remote status)
CURRENT_BRANCH=$(git branch --show-current || echo "main")

# Check if remote is configured
if ! git remote get-url origin &> /dev/null; then
    echo "Warning: No remote configured. Please add a remote with:"
    echo "  git remote add origin <repository-url>"
    echo ""
    echo "Skipping push step. Repository is initialized locally only."
    HAS_REMOTE=false
else
    HAS_REMOTE=true
    REMOTE_URL=$(git remote get-url origin)
    echo "Remote configured: $REMOTE_URL"
fi

# Stage all changes first
echo "Staging changes..."
git add .

# Check for changes after staging (more accurate)
echo "Checking for changes..."
if git diff --cached --quiet; then
    echo "No changes detected. Vault is already up to date."
    exit 0
fi

# Show what will be committed
echo ""
echo "Changes to be committed:"
git diff --cached --stat

# Create commit
echo ""
echo "Creating commit..."
if git commit -m "$COMMIT_MESSAGE"; then
    COMMIT_HASH=$(git rev-parse --short HEAD)
    echo "Commit created: $COMMIT_HASH"
else
    echo "Error: Failed to create commit"
    exit 1
fi

# Push to remote if configured
if [ "$HAS_REMOTE" = true ]; then
    echo ""
    echo "Pushing to remote..."
    echo "Current branch: $CURRENT_BRANCH"

    # Attempt to push
    if git push origin "$CURRENT_BRANCH"; then
        echo "Push successful"
    else
        echo "Warning: Push failed. Possible reasons:"
        echo "  - Network connectivity issues"
        echo "  - Authentication required"
        echo "  - Remote repository not accessible"
        echo ""
        echo "Changes are committed locally. Please push manually when ready:"
        echo "  cd \"$VAULT_PATH\""
        echo "  git push origin $CURRENT_BRANCH"
        exit 1
    fi
fi

# Display summary
echo ""
echo "=== Backup Summary ==="
echo "Status: Success"
echo "Commit: $COMMIT_HASH"
echo "Branch: $CURRENT_BRANCH"
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"

if [ "$HAS_REMOTE" = true ]; then
    echo "Remote: $REMOTE_URL"
else
    echo "Remote: Not configured"
fi

echo ""
echo "Backup completed successfully!"
