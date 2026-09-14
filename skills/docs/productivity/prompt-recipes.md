## What it does

`prompt-recipes` documents repeatable prompt patterns for coding agents. It adapts the prompt engineering principles from Anthropic's Claude Code prompt library into practical templates for day-to-day software engineering in Cursor.

The defining constraint is that effective prompts describe desired outcomes, provide explicit verification commands, point to existing reference files, and avoid micromanaging intermediate implementation steps.

## When to reach for it

Read this guide when you want to write clearer instructions for coding agents, reduce iteration loops, or understand how to pair prompts with skills in this repository.

| Your goal | Section to consult |
| --- | --- |
| Learn the fundamental patterns of agent prompting | The six core prompt patterns |
| Prompt recipes for common workflows (bugs, features, refactoring) | Prompt recipes by task |
| Connect prompting patterns to Matt Pocock skills | Mapping prompt patterns to skills |

## The six core prompt patterns

Every high-leverage prompt in modern coding environments follows one or more of these six patterns:

### 1. Describe the outcome, not the steps
Tell the agent the end state you want and let it discover the files to edit. Avoid listing file paths or mechanical edits unless necessary.

- **Vague prompt**: "Add rate limiting."
- **Procedural prompt**: "Open `src/middleware/rateLimit.ts` and write a Redis check on line 25."
- **Outcome prompt**: "Add rate limiting to all public endpoints under `/api/v1/`. Ensure existing API tests pass."

### 2. Give an automated self-check
Tell the agent how to verify its work in the initial prompt so it iterates autonomously until the check passes, rather than stopping on first guess.

- **Unverified prompt**: "Fix the null pointer exception in customer checkout."
- **Self-checking prompt**: "Fix the null pointer in customer checkout. Run `npm test tests/checkout.test.ts` to confirm the fix and prove no regressions."

### 3. Point to a reference pattern
Anchor new code to an existing implementation in the codebase. This ensures consistent naming, error handling, and architecture.

- **Without reference**: "Create a user notification banner."
- **Referenced prompt**: "Add a system maintenance banner on the dashboard. Follow the layout, styling, and dismiss logic used in `src/components/AlertBanner.tsx`."

### 4. State measurable targets
When optimizing performance or refactoring code, give concrete numerical thresholds.

- **Ambiguous prompt**: "Make the search query faster."
- **Targeted prompt**: "Optimize the full-text search query in `src/services/search.ts` so response time stays under 100 milliseconds for 50,000 documents. Show the query plan before and after."

### 5. Provide raw artifacts directly
Paste error logs, stack traces, compiler output, or reference files directly into the prompt using `@` mentions.

- **Descriptive prompt**: "The build failed with a TypeScript error about missing properties."
- **Artifact prompt**: "The build failed: `@build.log`. Fix the root cause in `src/types/auth.ts` without suppressing compiler checks."

### 6. Specify output format and audience constraints
Constrain the length, format, or audience of the agent's explanation.

- **Default prompt**: "Explain how payment webhooks work."
- **Constrained prompt**: "Explain how payment webhooks work. Format the answer as a sequence diagram followed by a comparison table of retry policies. Follow ELI12 rules: short sentences, plain words, no metaphors."

## Prompt recipes by task

### Understand a new codebase

```text
Give me a high-level overview of this codebase. Trace the request lifecycle from HTTP routing down to database persistence, and list the 3 main domain models.
```

### Reproduce and fix a bug

```text
The login endpoint fails when a session token expires. Here is the reproduction command: `curl -v http://localhost:3000/api/auth/refresh`. Diagnose the root cause, write a failing regression test, and fix it. Ensure existing test suite passes.
```

### Feature implementation with TDD

```text
Implement user password reset via email. Follow our existing service patterns in `src/services/auth.ts`. Write a failing unit test first, make it pass, and run the test suite to verify zero regressions.
```

### Large-scale migration

```text
Migrate all usages of the deprecated `oldLogger.log()` to `structuredLogger.info()`. Test on 2 pilot files first, show the diff, and wait for confirmation before migrating remaining files in batches.
```

### Pre-merge adversarial review

```text
Review the current diff against `main`. Identify missing acceptance criteria, unhandled edge cases (null inputs, timeouts, concurrency), and scope creep. Report concrete gaps with line numbers; do not comment on formatting or style.
```

## Mapping prompt patterns to skills

| Prompt Pattern | Complementary Skill |
| --- | --- |
| Socratic alignment & clarifying requirements | [grill-with-docs](https://aihero.dev/skills-grill-with-docs), [grill-me](https://aihero.dev/skills-grill-me) |
| Outcome-based test-driven implementation | [tdd](https://aihero.dev/skills-tdd), [implement](https://aihero.dev/skills-implement) |
| Hard bugs with automated reproduction loop | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |
| Automated self-check and zero regressions | [verify-work](https://aihero.dev/skills-verify-work) |
| Adversarial gap finding before merge | [adversarial-review](https://aihero.dev/skills-adversarial-review) |
| Large-scale repetitive batch refactoring | [batch-refactor](https://aihero.dev/skills-batch-refactor) |
| Architectural deepening | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) |
| Format & tone constraint | [eli12](https://aihero.dev/skills-eli12), [brief-me](https://aihero.dev/skills-brief-me) |

## Common questions

**Do I need to memorize these prompts?**
No. Remember the core formula: **Outcome + Reference + Self-check**. When you give the agent the desired outcome, an example to follow, and a command to verify its work, output quality improves significantly.

**Can I combine prompt recipes with Cursor skills?**
Yes. You can invoke a skill (such as `@tdd` or `@diagnosing-bugs`) and supply a prompt that follows these recipes. The prompt provides task-specific constraints while the skill provides the engineering process.

## It's working if

- The agent reaches working solutions with fewer correction cycles.
- The agent runs tests and builds automatically instead of stopping after editing.
- New code matches existing codebase conventions without manual cleanup.

## Where it fits

`prompt-recipes` is the reference guide for structuring input to agents across all other skills:

- Use during initial planning with [grill-with-docs](https://aihero.dev/skills-grill-with-docs).
- Use during implementation with [tdd](https://aihero.dev/skills-tdd) and [implement](https://aihero.dev/skills-implement).
- Use during review with [adversarial-review](https://aihero.dev/skills-adversarial-review) and [verify-work](https://aihero.dev/skills-verify-work).
