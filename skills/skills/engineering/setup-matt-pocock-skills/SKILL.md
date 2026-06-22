---
name: setup-matt-pocock-skills
description: Configure this repo for the engineering skills — set up its issue tracker, triage label vocabulary, domain doc layout, and optional Cursor coding-standard rules. Run once before first use of the other engineering skills.
disable-model-invocation: true
---

# Setup Matt Pocock's Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels** — the strings used for the five canonical triage roles
- **Domain docs** — where `CONTEXT.md` and ADRs live, and the consumer rules for reading them
- **Coding standards** — optional Cursor rules in `.cursor/rules/` (code quality, docstrings, license compliance, backend layers)
- **Stack profile** — optional `docs/agents/stack-profile.md` for fullstack repos (paths, test runners)
- **Fullstack LLM Wiki** — optional `fullstack-llm-wiki/` clone for local framework documentation

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config` — is this a GitHub repo? Which one?
- `AGENTS.md` at the repo root — does it exist? Is there already an `## Agent skills` section?
- `.cursor/rules/` — any existing Cursor rules?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/` — does this skill's prior output already exist?
- `.scratch/` — sign that a local-markdown issue tracker convention is already in use

### 2. Present findings and ask

Summarise what's present and what's missing. Then walk the user through the decisions **one at a time** — present a section, get the user's answer, then move to the next. Don't dump all sections at once.

Assume the user does not know what these terms mean. Each section starts with a short explainer (what it is, why these skills need it, what changes if they pick differently). Then show the choices and the default.

**Section A — Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `to-issues`, `triage`, `to-prd`, and `qa` read from and write to it — they need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: these skills were designed for GitHub. If a `git remote` points at GitHub, propose that. If a `git remote` points at GitLab (`gitlab.com` or a self-hosted host), propose GitLab. Otherwise (or if the user prefers), offer:

- **GitHub** — issues live in the repo's GitHub Issues (uses the `gh` CLI)
- **GitLab** — issues live in the repo's GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown** — issues live as files under `.scratch/<feature>/` in this repo (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.) — ask the user to describe the workflow in one paragraph; the skill will record it as freeform prose

**Section B — Triage label vocabulary.**

> Explainer: When the `triage` skill processes an incoming issue, it moves it through a state machine — needs evaluation, waiting on reporter, ready for an AFK agent to pick up, ready for a human, or won't fix. To do that, it needs to apply labels (or the equivalent in your issue tracker) that match strings *you've actually configured*. If your repo already uses different label names (e.g. `bug:triage` instead of `needs-triage`), map them here so the skill applies the right ones instead of creating duplicates.

The five canonical roles:

- `needs-triage` — maintainer needs to evaluate
- `needs-info` — waiting on reporter
- `ready-for-agent` — fully specified, AFK-ready (an agent can pick it up with no human context)
- `ready-for-human` — needs human implementation
- `wontfix` — will not be actioned

Default: each role's string equals its name. Ask the user if they want to override any. If their issue tracker has no existing labels, the defaults are fine.

**Section C — Domain docs.**

> Explainer: Some skills (`improve-codebase-architecture`, `diagnosing-bugs`, `tdd`) read a `CONTEXT.md` file to learn the project's domain language, and `docs/adr/` for past architectural decisions. They need to know whether the repo has one global context or multiple (e.g. a monorepo with separate frontend/backend contexts) so they look in the right place.

Confirm the layout:

- **Single-context** — one `CONTEXT.md` + `docs/adr/` at the repo root. Most repos are this.
- **Multi-context** — `CONTEXT-MAP.md` at the root pointing to per-context `CONTEXT.md` files (typically a monorepo).

**Section D — Coding standards (Cursor rules).**

> Explainer: Cursor rules are persistent coding standards the agent sees when editing matching files. Skills like `review` treat them as Standards sources alongside `CONTRIBUTING.md`. Seed templates ship with this skill — code quality thresholds, docstring/JSDoc conventions, and license compliance when adding dependencies. OrchestKit's visual-style rule is intentionally omitted (toolkit-specific emoji/ASCII vocabulary).

Default: **install seed rules** if `.cursor/rules/` is empty or missing. If rules already exist, list them and ask whether to add the seeds (skip filenames that already exist), replace nothing without explicit approval, or skip entirely.

Templates (in this skill's [rules/](./rules/) folder):

- `code-quality.mdc` — function length, nesting depth, cyclomatic complexity
- `docstring-standards.mdc` — Python docstrings and TypeScript/JSDoc for exported functions
- `license-compliance.mdc` — dependency license checks (`alwaysApply: true`)
- `backend-layers.mdc` — router → service → repository separation for Python (`alwaysApply: false`)

Offer to tune `globs` in the templates for the repo's primary languages before writing.

**Section E — Stack profile (optional).**

> Explainer: Fullstack skills (`implement`, `tdd`, `to-issues`) use generic conventions in `fullstack/references/`. A stack profile records *this repo's* paths and test runners so agents don't guess. Skip for libraries, CLIs, or backend-only repos.

Default: **skip** unless the repo is clearly fullstack (e.g. FastAPI + Next.js). If yes, propose writing `docs/agents/stack-profile.md` from the seed template — backend framework, ORM, directory paths, API prefix, frontend framework, test runners (pytest + Vitest by default).

**Section F — Fullstack LLM Wiki (optional).**

> Explainer: Framework API docs (FastAPI, SQLAlchemy, Next.js, etc.) live in a separate local wiki repo. The `fullstack-llm-wiki-navigator` skill reads it when you build. Clone it once per app repo. Only offer this when the user chose a stack profile in Section E.

Default: **clone** if the repo is clearly fullstack and `fullstack-llm-wiki/` does not already exist:

```bash
git clone https://github.com/EladAriel/fullstack-llm-wiki.git fullstack-llm-wiki
```

If `fullstack-llm-wiki/` already exists, note it and skip. If the user declines, skip — agents will prompt them to clone when framework docs are needed.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to `AGENTS.md` (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`, `docs/agents/domain.md`
- If installing a stack profile: the contents of `docs/agents/stack-profile.md`
- If cloning the wiki: confirm `fullstack-llm-wiki/` will be created (or already exists)
- If installing coding standards: the list of `.mdc` files to write under `.cursor/rules/`

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `AGENTS.md` exists, edit it.
- If it does not exist, create `AGENTS.md` at the repo root (default for Cursor).

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.

### Coding standards

[one-line summary — installed seed rules or "none"]. See `.cursor/rules/`.

### Stack profile

[one-line summary — fullstack paths and test runners, or "not applicable"]. See `docs/agents/stack-profile.md`.

### Fullstack LLM Wiki

[one-line summary — cloned at `fullstack-llm-wiki/` or "not installed"]. See `docs/agents/wiki.md`.
```

Include the **Coding standards** subsection only when the user chose to install seed rules.

Include the **Stack profile** subsection only when the user chose to write `docs/agents/stack-profile.md`.

Include the **Fullstack LLM Wiki** subsection only when the user chose to clone the wiki or it already exists.

Then write the three docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md) — local-markdown issue tracker
- [triage-labels.md](./triage-labels.md) — label mapping
- [domain.md](./domain.md) — domain doc consumer rules + layout

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

If the user chose a stack profile, write `docs/agents/stack-profile.md` from [stack-profile.md](./stack-profile.md), filled in from exploration (actual paths in the repo).

If the user chose to clone the wiki (or it already exists), write `docs/agents/wiki.md` from [wiki.md](./wiki.md). If cloning, run:

```bash
git clone https://github.com/EladAriel/fullstack-llm-wiki.git fullstack-llm-wiki
```

If the user chose to install coding standards, create `.cursor/rules/` (if missing) and copy the agreed templates from [rules/](./rules/). Never overwrite an existing `.mdc` file unless the user explicitly asked to replace it.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` and `.cursor/rules/*.mdc` directly later — re-running this skill is only necessary if they want to switch issue trackers, update the stack profile, install the wiki, or restart from scratch.
