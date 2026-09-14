---
name: verify-work
description: Run an executable verification check (test suite, linter, typechecker, or build) to prove a change works and causes no regressions before declaring completion. Use when verifying code changes, running tests, checking for regressions, or when the user says "verify", "check your work", "run the tests", or "confirm it works".
---

# Verify Work

Prove that changes work before considering work complete. An implementation is only finished when an executable check passes and outputs evidence.

## Principles

1. **Evidence over assertion**: Never tell the user that code works without running the command and showing the output.
2. **Dual check**: Every change requires two verifications:
   - Target check: the new feature works or the bug is resolved.
   - Regression check: existing automated tests and typechecks continue to pass without errors.
3. **Root cause resolution**: Fix the root cause of an issue. Never suppress type errors, warnings, or test failures using ignore comments (`@ts-ignore`, `# type: ignore`), dummy mocks, or empty error handlers.

## Process

### 1. Identify the verification command

Detect the project's verification tools from configuration files and scripts:

- **Test runner**: `npm test`, `pnpm test`, `pytest`, `cargo test`, `go test ./...`
- **Typechecker**: `npm run typecheck`, `tsc --noEmit`, `mypy`, `pyright`
- **Linter**: `npm run lint`, `eslint`, `ruff check`
- **Build tool**: `npm run build`, `cargo build`

If multiple tools exist, pick the most specific test for immediate feedback first, followed by the broader suite for regression safety.

### 2. Execute target check

Run the command that specifically exercises the changed code:

- Run the targeted test file or test case.
- For UI or API changes without automated tests, run a curl request, integration script, or CLI command that exercises the endpoint.
- Capture the command invocation and stdout/stderr.

**Done when:** the target command runs to completion and exits with code 0.

### 3. Execute regression check

Run the existing test suite and typechecker across the affected modules:

- Confirm no existing tests were broken by the change.
- Confirm types remain sound and no new type errors were introduced.

If tests fail, stop and fix the failure. Do not modify the test assertions to make failing tests pass unless the specification explicitly changed expected behavior.

**Done when:** the regression command runs and passes completely.

### 4. Present evidence

Present the verification results clearly:

- State the exact command executed.
- Show the terminal output, including test counts and execution time.
- If any warnings or edge cases remain, state them explicitly.

**Done when:** verification evidence is shown and confirmed clean.
