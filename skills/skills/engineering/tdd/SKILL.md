---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests. Always branches from main, commits only session-touched files, and opens a PR when the cycle completes.
---

# Test-Driven Development

## Philosophy

**Core principle**: Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_ it does it. A good test reads like a specification - "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors because they don't care about internal structure.

**Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means (like querying a database directly instead of using the interface). The warning sign: your test breaks when you refactor, but behavior hasn't changed. If you rename an internal function and tests fail, those tests were testing implementation, not behavior.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** This is "horizontal slicing" - treating RED as "write all tests" and GREEN as "write all code."

This produces **crap tests**:

- Tests written in bulk test _imagined_ behavior, not _actual_ behavior
- You end up testing the _shape_ of things (data structures, function signatures) rather than user-facing behavior
- Tests become insensitive to real changes - they pass when behavior breaks, fail when behavior is fine
- You outrun your headlights, committing to test structure before understanding the implementation

**Correct approach**: Vertical slices via tracer bullets. One test → one implementation → repeat. Each test responds to what you learned from the previous cycle. Because you just wrote the code, you know exactly what behavior matters and how to verify it.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## Workflow

**Session file tracking**: From the first edit onward, keep a running list of every file created or modified during this TDD session. At ship time, stage **only** those files — never `git add .` or unrelated dirty files.

### 1. Planning

When exploring the codebase, read `CONTEXT.md` (if it exists) so that test names and interface vocabulary match the project's domain language, and respect ADRs in the area you're touching.

Before writing any code:

- [ ] Confirm with user what interface changes are needed
- [ ] Confirm with user which behaviors to test (prioritize)
- [ ] Identify opportunities for deep modules (small interface, deep implementation) — run the `/codebase-design` skill for the vocabulary and the testability checks
- [ ] List the behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Ask: "What should the public interface look like? Which behaviors are most important to test?"

**You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

### 2. Branch Setup

After the plan is approved and **before** writing any test or implementation code:

1. Resolve the default branch (`main`, or the repo default from `git symbolic-ref refs/remotes/origin/HEAD`).
2. Create a new branch from that branch — never commit TDD work on `main`:

```bash
git fetch origin <default-branch>
git checkout <default-branch>
git pull --ff-only origin <default-branch>
git checkout -b <branch-name>
```

3. Pick a descriptive branch name (e.g. `feat/cart-checkout`, `fix/validate-thickness`). Use an issue number when one exists.

If the working tree has unrelated uncommitted changes, stash or leave them behind — do not carry them onto the new branch.

### 3. Tracer Bullet

Write ONE test that confirms ONE thing about the system:

```
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

This is your tracer bullet - proves the path works end-to-end.

### 4. Incremental Loop

For each remaining behavior:

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules:

- One test at a time
- Only enough code to pass current test
- Don't anticipate future tests
- Keep tests focused on observable behavior

### 5. Refactor

After all tests pass, look for [refactor candidates](refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

### 6. Ship

Mandatory when the TDD cycle is complete (all tests green, refactor done). Skip only if the user explicitly says not to commit or open a PR.

1. **Confirm session files** — review the tracked list; add any file touched during refactor if missing.
2. **Inspect** — run `git status` and `git diff` in parallel. Verify no secrets (`.env`, credentials) are in session files.
3. **Stage session files only**:

```bash
git add <session-file-1> <session-file-2> ...
```

Do not stage unrelated changes. Do not use `git add .` or `git add -A`.

4. **Commit** — 1–2 sentences focused on **why** (behavior delivered), matching repo tone from `git log`:

```bash
git commit -m "$(cat <<'EOF'
Concise message explaining why.

EOF
)"
```

5. **Push and open PR** — follow the `/commit-push-pr` skill end-to-end: push the branch, then create the PR via GitHub MCP. Return the PR URL to the user.

PR title and body should reflect the behaviors tested and delivered in this session — use the TDD plan and acceptance criteria from planning.

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
