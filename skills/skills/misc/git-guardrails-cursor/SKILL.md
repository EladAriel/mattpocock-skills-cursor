---
name: git-guardrails-cursor
description: Set up Cursor hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) and optional destructive database commands before they execute. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Cursor.
---

# Setup Git Guardrails

Sets up `beforeShellExecution` hooks that intercept dangerous shell commands before the agent runs them.

## What Gets Blocked

**Git** ([scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)):

- `git push` (all variants including `--force`)
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

**Database (optional)** ([scripts/block-dangerous-db.sh](scripts/block-dangerous-db.sh)):

- `drop database` / `DROP DATABASE`
- `truncate table` / `TRUNCATE TABLE`
- `DROP TABLE`

When blocked, the agent sees a message telling it that it does not have authority to run these commands.

## Steps

### 1. Ask scope

Ask the user: install for **this project only** (`.cursor/hooks.json`) or **all projects** (`~/.cursor/hooks.json`)?

### 2. Copy the hook scripts

Bundled scripts:

- [scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh) — always install
- [scripts/block-dangerous-db.sh](scripts/block-dangerous-db.sh) — ask if the user wants DB protection (recommended for repos with a database)

Copy to the target location based on scope:

- **Project**: `.cursor/hooks/block-dangerous-git.sh` (and `.cursor/hooks/block-dangerous-db.sh` if opted in)
- **Global**: `~/.cursor/hooks/block-dangerous-git.sh` (and `~/.cursor/hooks/block-dangerous-db.sh` if opted in)

Make each copied script executable with `chmod +x`.

### 3. Add hook to hooks.json

Create or merge into the appropriate hooks file:

**Project** (`.cursor/hooks.json`):

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      {
        "command": ".cursor/hooks/block-dangerous-git.sh",
        "failClosed": true
      },
      {
        "command": ".cursor/hooks/block-dangerous-db.sh",
        "failClosed": true
      }
    ]
  }
}
```

Omit the `block-dangerous-db.sh` entry if the user skipped DB protection.

**Global** (`~/.cursor/hooks.json`):

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [
      {
        "command": "./hooks/block-dangerous-git.sh",
        "failClosed": true
      },
      {
        "command": "./hooks/block-dangerous-db.sh",
        "failClosed": true
      }
    ]
  }
}
```

If the hooks file already exists, merge the hook into the existing `beforeShellExecution` array — don't overwrite other settings.

### 4. Ask about customization

Ask if user wants to add or remove any patterns from the blocked list. Edit the copied script accordingly.

### 5. Verify

Run a quick test:

```bash
echo '{"command":"git push origin main"}' | <path-to-script>
```

Should print a JSON deny response with `"permission": "deny"`.
