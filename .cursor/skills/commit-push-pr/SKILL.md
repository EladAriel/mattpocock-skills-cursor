---
name: commit-push-pr
description: Commit changes, push branch, and open a GitHub pull request with business context. Use when the user asks to commit, push, create a PR, open a pull request, or ship changes — including phrases like "commit and push", "create PR", or "ready for review".
---

# Commit, Push, and Create PR

End-to-end workflow: stage and commit locally, push the branch, open a PR with business logic, acceptance criteria, and outcomes.

## Prerequisites

- User explicitly asked to commit, push, and/or create a PR (never commit unprompted).
- GitHub MCP server (`user-github`) enabled and authenticated — use it for all GitHub API tasks (PR creation, PR lookup, etc.). Do **not** use the `gh` CLI.
- No secrets in staged files (`.env`, credentials, tokens). Warn before committing if present.

## MCP usage rules

1. Read the tool schema under `mcps/user-github/tools/` before calling any GitHub MCP tool.
2. Use `CallMcpTool` with `server: "user-github"`.
3. Prefer local `git` commands for working-tree inspection, commit, and push. Use GitHub MCP only for GitHub-hosted operations.

## Phase 1 — Inspect changes

Run in parallel:

```bash
git status
git diff
git diff --staged
git log -5 --oneline
```

Also run when preparing a PR:

```bash
git branch -vv
git branch --show-current
git remote get-url origin
git log main...HEAD --oneline
git diff main...HEAD
```

Use `main` or the repo's default base branch if different.

### Resolve GitHub coordinates

From `git remote get-url origin`, parse `owner` and `repo`:

- `https://github.com/owner/repo.git`
- `git@github.com:owner/repo.git`

Set:

- `head` — current branch from `git branch --show-current`
- `base` — default branch (`main`, `master`, or from `git symbolic-ref refs/remotes/origin/HEAD`)

If the branch was pushed from a fork, `head` may need `forkOwner:branchName` (same-repo pushes use the branch name only).

## Phase 2 — Commit

### Safety (never violate)

- Do not update git config.
- Do not use destructive git commands (`push --force`, `reset --hard`) unless explicitly requested.
- Do not skip hooks (`--no-verify`, `--no-gpg-sign`) unless explicitly requested.
- Do not force-push to `main`/`master`; warn if requested.
- Avoid `git commit --amend` unless ALL are true: user requested amend, HEAD commit is yours this session, commit not pushed.
- If a hook fails, fix and create a **new** commit — never amend a failed commit.
- Do not push unless the user asked.

### Message style

1–2 sentences focused on **why**, not a file list. Match recent commit tone from `git log`.

### Commit sequence

```bash
git add <relevant-files>
git commit -m "$(cat <<'EOF'
Concise message explaining why.

EOF
)"
git status
```

Stage only relevant files; exclude secrets and unrelated changes.

## Phase 3 — Push

Only when the user asked to push:

```bash
git push -u origin HEAD
```

Use `-u` when the branch has no upstream. Request `all` permissions if sandbox blocks network/git writes.

## Phase 4 — Create PR

Use the GitHub MCP server for all PR tasks — never `gh pr create` or other `gh` commands.

### Before creating

1. Branch pushed (push first if user asked for PR + push).
2. Full diff reviewed: `git diff main...HEAD` (all commits on branch, not just latest).
3. Draft PR title: imperative, scoped (e.g. `feat(api): add stress tool validation`).
4. Check for an existing open PR on the same branch (optional but recommended):

```
CallMcpTool:
  server: user-github
  toolName: search_pull_requests
  arguments:
    owner: <owner>
    repo: <repo>
    query: "head:<branch> is:open"
```

If one exists, return its URL instead of creating a duplicate.

### PR body template

Fill every section from the actual diff and conversation context. Be specific — no generic placeholders.

```markdown
## Summary

[1–3 bullets: what changed at a high level]

## Business logic

[Explain the problem, domain rules, and how the change behaves for users/systems. Why this approach? What invariants or calculations apply?]

## Acceptance criteria

- [ ] [Testable criterion — observable behavior or outcome]
- [ ] [Edge case or error path covered]
- [ ] [Regression / compatibility expectation]

## What we achieve

[Outcomes after merge: user value, reliability, performance, maintainability, or unblocked work. Tie to the original goal.]

## Test plan

- [ ] [Command or manual step to verify]
- [ ] [Additional check if needed]
```

### Create PR via MCP

Read `mcps/user-github/tools/create_pull_request.json`, then call:

```
CallMcpTool:
  server: user-github
  toolName: create_pull_request
  arguments:
    owner: <owner>
    repo: <repo>
    title: "the pr title"
    head: "<branch>"            # or "forkOwner:branch" for forks
    base: "<default-branch>"
    body: |
      ## Summary
      - ...

      ## Business logic
      ...

      ## Acceptance criteria
      - [ ] ...

      ## What we achieve
      ...

      ## Test plan
      - [ ] ...
    draft: false                 # set true only if user asked for a draft PR
```

Return the PR URL from the MCP response to the user. If creation fails, report the error and suggest fixes (e.g. branch not pushed, wrong base branch, auth failure).

### Other GitHub tasks during this workflow

Use matching MCP tools instead of `gh`:

| Task | MCP tool |
|------|----------|
| Create PR | `create_pull_request` |
| Find existing PR | `search_pull_requests` or `list_pull_requests` |
| Read PR details / diff / checks | `pull_request_read` |
| Update PR title or body | `update_pull_request` |
| List branches | `list_branches` |

## Writing guidance

| Section | Purpose |
|---------|---------|
| **Business logic** | Domain "why" and behavior — not a file changelog |
| **Acceptance criteria** | Checkboxes reviewers can verify before merge |
| **What we achieve** | Success metrics and delivered value after merge |

**Good acceptance criterion:** "API returns 422 when `thickness_mm` is missing from tool payload."

**Bad:** "Code looks good."

## Quick checklist

```
- [ ] User asked for commit / push / PR
- [ ] git status + diff reviewed
- [ ] No secrets staged
- [ ] Commit message explains why
- [ ] Branch pushed (if PR requested)
- [ ] owner, repo, head, base resolved from git remote + branch
- [ ] PR covers all branch commits
- [ ] Business logic, acceptance criteria, and outcomes filled in
- [ ] PR created via user-github MCP (not gh CLI)
- [ ] PR URL returned
```
