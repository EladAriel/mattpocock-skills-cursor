---
name: adversarial-review
description: "Adversarial code review in a fresh subagent context to refute an implementation against requirements, edge cases, and regression risks. Use when the user asks for \"adversarial review\", \"sanity check\", \"find gaps in my diff\", or to stress-test an implementation before merging."
---

# Adversarial Review

Review a git diff from an adversarial perspective. The goal is to discover real gaps in correctness, missing requirements, and unhandled edge cases before code merges.

Run this review in a fresh subagent context. A reviewer without the author's reasoning evaluates the diff strictly on its merits.

## Three Review Lenses

The adversarial reviewer evaluates the diff along three specific lenses:

1. **Requirement gaps**: Does the diff miss any requirement stated in the spec or ticket? Are parts of the acceptance criteria only partially implemented?
2. **Unhandled edge cases**: What happens on null or undefined inputs, empty collections, boundary values, network timeouts, or concurrent access? Do tests cover these cases?
3. **Scope creep and blast radius**: Did the diff modify files, functions, or dependencies that were not requested? Do unintended changes increase regression risk?

## Hard Rules for the Reviewer

- **Report gaps, not style preferences**: Do not comment on code formatting, variable naming preferences, or stylistic choices that linters already handle.
- **No speculative abstractions**: Do not suggest adding extra classes, factories, or indirection layers.
- **Cite evidence**: Every reported gap must cite the specific file, line number, or diff hunk, and explain the exact failure scenario.
- **Do not delegate**: Perform the review directly. Do not spawn recursive subagents.

## Process

### 1. Identify the diff and spec

Determine the fixed point to compare against:
- Use `git diff <fixed-point>...HEAD` (default to merge-base with `main`).
- Locate the spec or ticket: check the branch issue description, commit messages, or `.scratch/` tickets.
- If no spec is available, ask the user or review against stated intent and general correctness.

**Done when:** the git diff command and spec source are identified.

### 2. Run adversarial analysis

Examine the diff against the three lenses:

1. Map each requirement from the spec to the corresponding hunk in the diff.
2. Search for missing edge cases in modified functions:
   - Zero, negative, or overflow values
   - Missing error handling or unhandled rejections
   - Asynchronous race conditions or missing transaction rollbacks
3. Check test files:
   - Does a test exist for each modified behavior?
   - Do tests assert real outcomes, or are they tautological?
4. Inspect modified files outside the core domain logic for unnecessary changes.

**Done when:** all three lenses have been evaluated across all hunks in the diff.

### 3. Output format

Deliver a concise report with findings categorized by severity:

```markdown
## Adversarial Review Findings

### Critical Gaps (Correctness or Data Loss)
- `path/to/file.ts:42`: Description of missing requirement or unhandled failure scenario.

### Edge Case Gaps
- `path/to/file.ts:88`: Boundary or error condition that lacks handling or test coverage.

### Scope Creep
- `path/to/file.ts`: Unnecessary modification outside the task's scope.

### Verdict
[Ready to merge | Requires fixes before merge] - 1-2 sentence summary.
```

If no gaps are found, state clearly: "No critical gaps, edge case omissions, or scope creep identified."
