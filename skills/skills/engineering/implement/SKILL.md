---
name: implement
description: "Implement a piece of work based on a PRD or set of issues."
disable-model-invocation: true
---

# Implement

Orchestrate a single issue from branch to merge. The user passes a PRD and one issue (from `/to-issues` pickup order, triage, or ad hoc).

Issue tracker conventions live in `docs/agents/issue-tracker.md` — run `/setup-matt-pocock-skills` if that file is missing.

## Phase 0 — Pre-flight

Before reading code or writing tests, ask explicitly:

> Have you pushed and merged the latest PR to `main`?

- **No** — stop. Tell the user to finish and merge the prior PR, then confirm before continuing.
- **Yes** — sync the default branch and create a new feature branch. Never start implementation on `main`.

1. Resolve the default branch (`main`, or the repo default from `git symbolic-ref refs/remotes/origin/HEAD`).
2. Sync and branch:

```bash
git fetch origin <default-branch>
git checkout <default-branch>
git pull --ff-only origin <default-branch>
git checkout -b <branch-name>
```

3. Pick a descriptive branch name (e.g. `feat/cart-checkout`, `fix/validate-thickness`). Include the issue number when one exists.

If the working tree has unrelated uncommitted changes, stash or leave them behind — do not carry them onto the new branch.

## Phase 1 — Build

Read the PRD and the single issue the user passed in.

**All production behavior changes use `/tdd`.** For every acceptance criterion in the issue:

1. Write a failing test (red).
2. Implement the minimum code to pass (green).
3. Refactor while tests stay green.

Do not implement behavior first and add tests later. If code is modified to deliver feature behavior, tests must be added or updated in the same TDD cycle.

When invoking `/tdd` from this skill, **skip TDD's branch setup (section 2) and ship (section 6)** — this skill owns those phases.

### Exceptions (rare; document in the PR if used)

Skip new tests only when the change is:

- docs-only, formatting, or dependency bumps with no behavior change
- pure styling with no logic branch

Everything else — APIs, domain logic, validation, jobs, state, integrations — **must** go through `/tdd`.

**Fullstack repos** (FastAPI + TypeScript, etc.): if `docs/agents/stack-profile.md` exists, read it first. Then read [fullstack/references/layer-order.md](../fullstack/references/layer-order.md) once per issue, and the layer-specific reference for what you're building now (`backend.md`, `api.md`, `jobs.md`, `frontend.md`). For framework API questions during build, follow the **Framework documentation fallback** chain in `/tdd` Planning (wiki → Context7 → other doc MCPs → model knowledge).

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Keep a running list of every file created or modified during this session (same rule as `/tdd`).

## Phase 2 — Review

Run `/review` against the branch diff. Use the default branch as the fixed point.

Before accepting the review, verify: **every acceptance criterion has a corresponding test added or updated in this branch.** Missing tests are **blocking** — return to Phase 1 and add them via `/tdd`.

Address any other blocking findings before continuing. Judgement calls can wait for the simplify gate if the user prefers.

## Phase 3 — Simplify gate (HITL #1)

Run the **`/simplify`** Cursor command scoped to the session diff (unstaged + staged).

**STOP.** Summarize what `/simplify` changed. Ask the user to verify the diff.

- Do **not** commit, push, or open a PR until the user explicitly accepts.
- If the user requests changes, address them and re-run `/simplify` before asking again.

## Phase 4 — Ship

Follow `/commit-push-pr` end-to-end:

1. Stage **session files only** — never `git add .` or unrelated dirty files.
2. Commit with a message focused on **why** (behavior delivered).
3. Push the branch.
4. Create the PR via GitHub MCP.

Return the PR URL to the user. PR title and body should reflect the issue's acceptance criteria.

## Phase 5 — Merge gate (HITL #2)

Tell the user to review and merge the PR on GitHub.

**STOP.** Wait for explicit confirmation that the PR is merged before continuing.

## Phase 6 — Wrap-up

### Mark issue completed

Read `docs/agents/issue-tracker.md` and follow the tracker-specific workflow:

- **GitHub** — `gh issue close <number> --comment "..."` with the PR link
- **Local markdown** — set `Status: completed` at the top of the issue file; check acceptance-criteria boxes; append the PR link under `## Comments`
- **GitLab** — close the issue per the GitLab workflow in setup

### Return to main

```bash
git checkout <default-branch>
git pull --ff-only origin <default-branch>
```

### Ask next steps

Ask the user what to do next — e.g. pick up the next issue from the pickup order, run `/improve-codebase-architecture`, or stop.
