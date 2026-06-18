---
name: sync-matt-pocock-skills-cursor
description: Pull latest changes from mattpocock/skills into this Cursor fork, merge on main via the skills/ subtree, and re-apply Cursor-specific deltas. Use when syncing with upstream, updating the fork, or pulling new skills from the original repo.
disable-model-invocation: true
---

# Sync Matt Pocock Skills (Cursor fork)

Pull upstream [mattpocock/skills](https://github.com/mattpocock/skills) into this Cursor fork while preserving Cursor-specific changes.

Read [FORK.md](../../../FORK.md) and [FORK-DELTA.md](../../../FORK-DELTA.md) before starting.

## Preflight

1. `cd` to the **repository root** (the folder with the wrapper `README.md` and the `skills/` subdirectory).
2. Confirm `upstream` remote exists and points at `https://github.com/mattpocock/skills.git`.
3. Confirm current branch is `main`.
4. `git status` — working tree must be clean. Stash or commit first if not.
5. If preflight fails, stop and tell the user what to fix.

## Fetch and report

```bash
git fetch upstream
git log --oneline main..upstream/main
```

Present the commit summary to the user. If there are new commits, ask to proceed before merging. If already up to date, skip to validation and report.

## Merge

Pull upstream into the `skills/` subtree:

```bash
git subtree pull --prefix=skills upstream main
```

Prefer subtree merge over rebase to preserve fork history.

On conflicts, follow [resolving-merge-conflicts](../../engineering/resolving-merge-conflicts/SKILL.md):

- Prefer upstream for shared skills under `skills/skills/**`.
- Preserve Cursor fork files per FORK-DELTA.
- Never `--abort` unless the user explicitly asks.

## Re-apply invariants

Walk the checklist in [FORK-DELTA.md](../../../FORK-DELTA.md):

- [ ] Remove reintroduced Claude-only artifacts (`.claude-plugin/`, `CLAUDE.md`, `link-skills.sh`, `git-guardrails-claude-code/`)
- [ ] Ensure `CURSOR.md`, `link-skills-cursor.sh`, and `git-guardrails-cursor/` exist under `skills/`
- [ ] Patch README, CONTEXT, invocation docs, setup skill, misc README, and CHANGELOG if upstream overwrote Cursor edits
- [ ] Append notable upstream changes to CHANGELOG Unreleased if appropriate

## Validate

- Run `skills/scripts/list-skills.sh` if present, or verify each path listed in FORK-DELTA.
- Confirm `skills/scripts/link-skills-cursor.sh` exists and is executable.

## Record

Update **Last synced upstream commit** in [FORK.md](../../../FORK.md) to the current `upstream/main` SHA:

```bash
git rev-parse upstream/main
```

Do **not** commit or push unless the user explicitly asks.

## Finish

Report to the user:

- Upstream commits merged (or "already up to date")
- Any conflicts resolved and how
- Invariants re-applied
- New last-synced SHA
- Remind them to reload Cursor if skill files changed
