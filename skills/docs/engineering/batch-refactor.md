## What it does

`batch-refactor` organizes code migrations across dozens or hundreds of files. It replaces wide, unguided edits with a structured loop: identify all candidate files, test on a pilot of two or three files, and process remaining files in verified batches of five to ten.

The defining constraint is that every batch must pass an automated verification check before the next batch begins. This isolates errors to the current small batch instead of breaking the entire build simultaneously.

## When to reach for it

You invoke this by typing `/batch-refactor`; the agent will not run it on its own.

| Your situation | Reach for |
| --- | --- |
| You have a repetitive change affecting many files across the repository | `batch-refactor` |
| You want to find places where modules are shallow and deepen them | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) |
| You are implementing a single feature or bug fix | [implement](https://aihero.dev/skills-implement) |
| You want to build code test-first | [tdd](https://aihero.dev/skills-tdd) |
| You want to write a throwaway experiment to test a design | [prototype](https://aihero.dev/skills-prototype) |

## The pilot and batch pattern

Running a massive refactor across an entire repository without testing the transformation causes compounding failures. `batch-refactor` breaks the work into three phases:

1. **Candidate listing**: The agent searches for all matching files and saves them to `.scratch/` as a checklist.
2. **Pilot transformation**: The agent modifies two or three files first. You review the diff and run tests to ensure the pattern works cleanly.
3. **Batch execution**: The agent edits files in small chunks of five to ten files. It runs your test or typecheck command after each chunk. If something breaks, the problem is inside those few files, making it simple to fix.

## Expand-contract migration

When changing a function signature or database schema used across many files, apply the expand-contract pattern:

1. **Expand**: Add the new function or parameter next to the old one. Do not delete the old version yet.
2. **Migrate**: Use `batch-refactor` to update callers in batches to use the new version.
3. **Contract**: Once search proves zero files call the old version, delete the old version.

This keeps the codebase buildable and testable at every intermediate commit.

## Common questions

**How large should a batch be?**
Between five and ten files. Batches larger than ten make compiler errors harder to trace. Batches smaller than three create unnecessary overhead.

**What happens if verification fails on a batch?**
The agent stops immediately. It must resolve the failure in the current batch before taking on new files.

**Can subagents run these batches in parallel?**
Yes. In git worktrees or isolated subagent runs, different batches can proceed in parallel, provided they do not edit the same files.

## It's working if

- A candidate list file exists on disk with an accurate count of files to modify.
- A pilot run of two or three files was executed and verified before bulk editing.
- Each batch of edits is followed immediately by a test or typecheck command.
- Commits are made incrementally as batches pass verification.

## Where it fits

`batch-refactor` manages wide codebase updates:

- [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) discovers architectural improvements.
- `batch-refactor` executes the changes across all affected files.
- [verify-work](https://aihero.dev/skills-verify-work) verifies the finished system.
- [code-review](https://aihero.dev/skills-code-review) reviews the resulting pull request.
