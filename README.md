# Matt Pocock Skills (Cursor)

A Cursor-only fork of [mattpocock/skills](https://github.com/mattpocock/skills).

**Created:** 2026-06-18 09:34 +0300 · **Updated:** 2026-07-08 15:22 +0300 · **Upstream:** [mattpocock/skills](https://github.com/mattpocock/skills)

The skill library lives in [`skills/`](skills/). See [`skills/README.md`](skills/README.md) for the quickstart:

```bash
git clone https://github.com/EladAriel/mattpocock-skills-cursor.git
cd mattpocock-skills-cursor/skills && ./scripts/link-skills-cursor.sh
```

Then reload Cursor and run **setup-matt-pocock-skills** in your project.

## Workflow

End-to-end flow for building a feature with these skills (see also [`WORKFLOW.md`](WORKFLOW.md)):

1. **Align** — If you have a codebase, use **grill-with-docs**; otherwise use **grill-me** to build shared language with the agent.
2. **Spec** — In the same conversation, invoke **to-spec** to turn the discussion into a spec.
3. **Tickets** — Invoke **to-tickets** to break the plan into tracer-bullet tickets with blocking edges.
4. **Build** — Work tickets in pickup order, invoking **implement** for each (it uses **tdd** inside and **verify-work** for regression checks).
5. **Review** — Run **code-review** and **adversarial-review** on the resulting diff.
6. **Refactor** — If the code needs structural work, invoke **improve-codebase-architecture** (or **batch-refactor** for wide migrations).

## Keeping up to date

### Already have a local clone

If you linked skills once with `link-skills-cursor.sh`, symlinks point into this repo — a pull updates skill files in place.

```bash
cd mattpocock-skills-cursor   # your clone path
git pull
```

Then reload Cursor (`Cmd/Ctrl+Shift+P` → **Developer: Reload Window**).

If the update **added new skills**, re-run the link script so they appear in Cursor:

```bash
cd mattpocock-skills-cursor/skills
./scripts/link-skills-cursor.sh            # global → ~/.cursor/skills/
# or
./scripts/link-skills-cursor.sh --project   # project → .cursor/skills/ in cwd
```

Reload Cursor again.

**App projects:** `git pull` updates skill templates in this repo (e.g. setup seed rules). It does not change files already written in your app (`.cursor/rules/`, `docs/agents/`). Re-run **setup-matt-pocock-skills** in the app repo if you want new templates copied there.

### Syncing upstream (fork maintainers)

Upstream [mattpocock/skills](https://github.com/mattpocock/skills) is merged into this fork under the `skills/` subtree. Do **not** run a bare `git pull` on `main` — that skips Cursor-specific fixes documented in [`skills/FORK-DELTA.md`](skills/FORK-DELTA.md).

To pull new upstream changes:

1. **Open this repo in Cursor** — the workspace root must be this fork (the folder with this `README.md` and the `skills/` subdirectory), not an app project that only links skills.
2. **Invoke the sync skill** — in chat, type `@sync-matt-pocock-skills-cursor` (or `/sync-matt-pocock-skills-cursor` if you use slash commands). The agent runs preflight checks (clean tree, `main` branch, `upstream` remote), fetches upstream, and shows commits on `upstream/main` that are not yet in this fork.
3. **Review before merging** — read the upstream commit summary the agent presents. Confirm only when you are ready to merge. The agent then runs `git subtree pull --prefix=skills upstream main`, re-applies Cursor fork invariants from FORK-DELTA, and updates the last-synced SHA in [`skills/FORK.md`](skills/FORK.md).
4. **Reload Cursor** (`Cmd/Ctrl+Shift+P` → **Developer: Reload Window**). If new skills were added, re-run `./scripts/link-skills-cursor.sh` from `skills/` (see above).

The sync skill does not commit or push unless you explicitly ask.

Fork tracking: [`skills/FORK.md`](skills/FORK.md) · Cursor deltas: [`skills/FORK-DELTA.md`](skills/FORK-DELTA.md)
