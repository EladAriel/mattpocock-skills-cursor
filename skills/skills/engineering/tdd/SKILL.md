---
name: tdd
description: Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests. Always branches from main, commits only session-touched files, and opens a PR when the cycle completes.
---

# Test-Driven Development

TDD is the red → green loop. This skill is the reference that makes that loop produce tests worth keeping: what a good test is, where tests go, the anti-patterns, and the rules of the loop. Every section applies on every cycle — consult them before and during the loop, not after.

## Default for feature work

`/tdd` is the required build loop whenever `/implement` (or any feature issue) changes observable behavior. Use red → green for each acceptance criterion — do not implement behavior first and add tests later.

Standalone `/tdd` uses the same cycle end-to-end, including branch setup and ship.

When exploring the codebase, read `CONTEXT.md` (if it exists) so test names and interface vocabulary match the project's domain language, and respect ADRs in the area you're touching.

## What a good test is

Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification — "user can checkout with valid cart" tells you exactly what capability exists — and survives refactors because it doesn't care about internal structure.

See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.

## Seams — where tests go

A **seam** is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

**Test only at pre-agreed seams.** Before writing any test, write down the seams under test and confirm them with the user. No test is written at an unconfirmed seam. You can't test everything — agreeing the seams up front is how testing effort lands on the critical paths and complex logic instead of every edge case.

Ask: "What's the public interface, and which seams should we test?"

## Anti-patterns

- **Implementation-coupled** — mocks internal collaborators, tests private methods, or verifies through a side channel (querying the database instead of using the interface). The tell: the test breaks when you refactor but behavior hasn't changed.
- **Tautological** — the assertion recomputes the expected value the way the code does (`expect(add(a, b)).toBe(a + b)`, a snapshot derived by hand the same way, a constant asserted equal to itself), so it passes by construction and can never disagree with the code. Expected values must come from an independent source of truth — a known-good literal, a worked example, the spec.
- **Horizontal slicing** — writing all tests first, then all implementation. Bulk tests verify _imagined_ behavior: you test the _shape_ of things rather than user-facing behavior, the tests go insensitive to real changes, and you commit to test structure before understanding the implementation. Work in **vertical slices** instead — one test → one implementation → repeat, each test a **tracer bullet** that responds to what the last cycle taught you.

## Rules of the loop

- **Red before green.** Write the failing test first, then only enough code to pass it. Don't anticipate future tests or add speculative features.
- **One slice at a time.** One seam, one test, one minimal implementation per cycle.
- **Structural refactoring belongs in review.** Deep structural refactoring belongs to the `/code-review` stage, not the red → green implementation cycle. This fork optionally applies the `/ponytail` ladder after green (see section 5).

## Workflow

**Session file tracking**: From the first edit onward, keep a running list of every file created or modified during this TDD session. At ship time, stage **only** those files — never `git add .` or unrelated dirty files.

### 1. Planning

**Fullstack repos:** if `docs/agents/stack-profile.md` exists, read it. Then read [fullstack/references/testing.md](../fullstack/references/testing.md) for within-slice test order (service before route before UI). Matt's anti-pattern — horizontal test batches — still applies; this only orders layers inside one vertical slice. For framework or library API questions, follow **Framework documentation fallback** below.

#### Framework documentation fallback

When a framework or library API question arises, follow this chain **sequentially** — do not query wiki and Context7 in parallel for the same question.

1. **Wiki** — Run `/fullstack-llm-wiki-navigator` using [fullstack/references/wiki-map.md](../fullstack/references/wiki-map.md). Navigate entry index → directory index → most specific page. **Done when** the question is answered, or after confirming the wiki is missing or the topic is not covered in the relevant indexes.
2. **Context7** — Only if step 1 did not answer. Check session MCP availability: look for a Context7 server (`user-context7` or `context7`) exposing `resolve-library-id` and `query-docs`. Read tool descriptors under `mcps/<server>/tools/` before calling. Call `resolve-library-id` then `query-docs` (respect per-tool call limits). **Done when** the question is answered, or Context7 is unavailable or has no relevant library.
3. **Other documentation MCPs** — Only if steps 1–2 did not answer. Scan other **enabled documentation MCP servers** in the session (e.g. `user-docs-langchain` for LangChain/LangGraph). Read each server's tool descriptors; pick the best-matching server for the topic. **Done when** the question is answered, or no doc MCP is available or relevant.
4. **Model knowledge** — Last resort. Explicitly state that the wiki, Context7, and other doc MCPs did not cover the question; answer from general knowledge and mark it as unverified against project docs.

Always cite the source used (wiki file path, Context7 library ID, or MCP server name). When wiki metadata shows staleness, mention it.

Before writing any code:

- [ ] Confirm with user what interface changes are needed
- [ ] Confirm with user which behaviors to test (prioritize)
- [ ] Identify opportunities for deep modules (small interface, deep implementation) — run the `/codebase-design` skill for the vocabulary and the testability checks
- [ ] List the behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Ask: "What should the public interface look like? Which behaviors are most important to test?"

**You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

### 2. Branch Setup

> **When invoked via `/implement`, skip this section.** `/implement` runs pre-flight and branch creation before calling `/tdd`.

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

### 5. Refactor (ponytail pass)

After all tests pass, apply the `/ponytail` ladder before moving on:

- [ ] Apply the `/ponytail` ladder — reuse / stdlib / native before new code; delete over add
- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

### 6. Ship

> **When invoked via `/implement`, skip this section.** `/implement` runs `/simplify`, HITL verification, and `/commit-push-pr` after `/code-review`.

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
