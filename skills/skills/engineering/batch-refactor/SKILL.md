---
name: batch-refactor
description: "Orchestrate large-scale repetitive codebase migrations or refactors across multiple files using a staged fan-out pattern with pilot testing and verification gates."
disable-model-invocation: true
---

# Batch Refactor

Orchestrate wide migrations and repetitive refactors across many files. When a change affects dozens or hundreds of call sites, jumping straight into a bulk edit produces compiler errors and broken tests.

This skill applies the **fan-out pattern**: generate a file list, validate on a small pilot batch, execute in bounded chunks, and gate each chunk with automated verification.

## Core Rules

1. **Pilot before bulk**: Always test the migration on 2–3 files first. Refine the pattern on real diffs before touching the rest of the codebase.
2. **Measurable target**: Define the exact transformation and success criterion up front (for example, "zero remaining usages of deprecated API X, typecheck passes with exit code 0").
3. **Point to a reference**: Name an existing file or pattern that exemplifies the desired end state.
4. **Bounded batches**: Edit files in chunks of 5–10 files. Verify after every chunk so regressions are isolated to a handful of files.
5. **Expand–contract sequence**: If a change alters a shared interface, add the new interface first without deleting the old one. Migrate callers batch by batch. Delete the old interface only when zero callers remain.

## Process

### 1. Scope and target definition

Clarify three essential inputs:
- **Source pattern**: The deprecated syntax, old library call, or target structure to replace.
- **Reference target**: A file in the repository that already demonstrates the new pattern.
- **Verification command**: The command to run after each batch (for example, `npm run typecheck` or `pytest`).

**Done when:** the transformation pattern, reference file, and verification command are agreed upon.

### 2. Generate candidate list

Scan the codebase and record all files needing modification:

```bash
# Example: find all files containing the target pattern
rg -l "deprecatedMethod\(" src/ > .scratch/migration-candidates.txt
```

Save the file list to `.scratch/` so progress can be tracked across batches. Count the total candidate files.

**Done when:** a complete list of matching file paths is written to disk.

### 3. Run pilot transformation

Select 2 or 3 representative files from the list:
1. Apply the transformation manually or with targeted editing.
2. Run the verification command.
3. Review the diff to verify that no unintended changes occurred.
4. Confirm with the user if the transformation matches expectations.

Remove the pilot files from the candidate list.

**Done when:** pilot files pass verification and the pattern is proven viable.

### 4. Execute fan-out batches

Iterate through the candidate file list in batches of 5 to 10 files:

1. Pick the next batch of files.
2. Apply the refactoring pattern to each file.
3. Run the verification command immediately.
   - If verification succeeds: mark batch complete and remove files from the candidate list.
   - If verification fails: fix the issue immediately within the current batch before touching additional files.
4. Commit the batch with a concise commit message (for example, `refactor: migrate auth callers batch 3/8`).

**Done when:** zero files remain in the candidate list.

### 5. Final verification and contract cleanup

Once all call sites are migrated:
1. If using the expand-contract pattern, remove the deprecated function or alias.
2. Run the full test suite and linter across the entire repository.
3. Verify that search for the original deprecated pattern returns zero matches.
4. Clean up any temporary files in `.scratch/`.

**Done when:** full test suite passes, zero old usages remain, and temporary artifacts are removed.
