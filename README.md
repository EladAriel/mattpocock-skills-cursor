# Matt Pocock Skills (Cursor)

A Cursor-only fork of [mattpocock/skills](https://github.com/mattpocock/skills).

**Created:** 2026-06-18 09:34 +0300 · **Updated:** 2026-06-18 13:35 +0300 · **Upstream:** [mattpocock/skills](https://github.com/mattpocock/skills)

The skill library lives in [`skills/`](skills/). See [`skills/README.md`](skills/README.md) for the quickstart:

```bash
git clone https://github.com/EladAriel/mattpocock-skills-cursor.git
cd mattpocock-skills-cursor/skills && ./scripts/link-skills-cursor.sh
```

Then reload Cursor and run **setup-matt-pocock-skills** in your project.

## Workflow

End-to-end flow for building a feature with these skills (see also [`WORKFLOW.md`](WORKFLOW.md)):

1. **Align** — If you have a codebase, use **grill-with-docs**; otherwise use **grill-me** to build shared language with the agent.
2. **PRD** — In the same conversation, invoke **to-prd** to turn the discussion into a PRD.
3. **Issues** — Invoke **to-issues** to break the plan into independently grabbable vertical slices.
4. **Build** — Copy the `Suggested pickup order` from step 3, then invoke **tdd** for test-driven development on each slice.
5. **Refactor** — If the code needs structural work, invoke **improve-codebase-architecture**.

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

To pull new skills from [mattpocock/skills](https://github.com/mattpocock/skills) into this fork:

1. Open this repo in Cursor.
2. Invoke **sync-matt-pocock-skills-cursor** (`@sync-matt-pocock-skills-cursor`).
3. Review the upstream changelog summary, confirm the merge, then reload Cursor.

Fork tracking: [`skills/FORK.md`](skills/FORK.md) · Cursor deltas: [`skills/FORK-DELTA.md`](skills/FORK-DELTA.md)
