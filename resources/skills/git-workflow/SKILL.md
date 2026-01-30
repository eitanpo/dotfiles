---
name: git-workflow
description: Git workflow patterns for AI agents. Use when committing changes, creating branches, or pushing to remote repositories.
---

# Git Workflow

## Reminders

- After PR creation: print the URL, run `git status` to confirm clean state
- Before rebase or pull: commit (or stash) uncommitted changes first

## Sandbox Permissions

| Operation | Permission |
|-----------|------------|
| `push`, `pull`, `fetch` | network |
| `add`, `commit`, `checkout` | git_write |
| HTTPS with credentials | all |
