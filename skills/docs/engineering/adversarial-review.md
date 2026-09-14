## What it does

`adversarial-review` inspects a git diff to find missing requirements, unhandled edge cases, and unintended changes before code merges. It runs in a fresh subagent context so it evaluates the changes without the author's assumptions.

The defining constraint is that it flags only gaps affecting correctness, missing acceptance criteria, or safety risks. It ignores code formatting, personal style preferences, and requests for extra abstraction layers.

## When to reach for it

Type `/adversarial-review`, or the agent reaches for it automatically when you ask for an adversarial review, a stress-test of your changes, or a gap analysis before submitting a pull request.

| Your situation | Reach for |
| --- | --- |
| You want to stress-test your diff for missing edge cases and spec gaps | `adversarial-review` |
| You want a two-axis review checking repo coding standards and Fowler smells | [code-review](https://aihero.dev/skills-code-review) |
| You need to run tests and confirm zero regressions | [verify-work](https://aihero.dev/skills-verify-work) |
| You want to build code test-first | [tdd](https://aihero.dev/skills-tdd) |
| You want to refactor architecture across an entire codebase | [improve-codebase-architecture](https://aihero.dev/skills-improve-codebase-architecture) |

## Prerequisites

The skill needs a git diff against a base commit or branch (defaults to `main`). Having a specification file or ticket helps the reviewer verify requirement completeness.

## The three lenses

The review inspects code through three focused categories:

| Lens | What it checks | Example finding |
| --- | --- | --- |
| Requirement gaps | Compares the diff to the task acceptance criteria | An API parameter was added but not passed to the database service |
| Edge cases | Tests boundary inputs, null values, and error flows | Missing timeout handling on an external HTTP request |
| Scope creep | Detects modified files unrelated to the task | Formatting changes in five unrelated configuration files |

## Avoiding review fatigue

Standard code reviews often get bogged down in stylistic debates. This skill enforces strict boundaries:

- **No style debates**: Linters and formatters handle code style. The reviewer never comments on indentation or syntax preferences.
- **No speculative generality**: The reviewer never asks the author to add factories, generic interfaces, or future-proofing abstractions.
- **Concrete evidence**: Every report must cite the exact file and line number with a realistic failure scenario.

## Common questions

**How is this different from `/code-review`?**
`code-review` evaluates two distinct axes: Standards (adherence to repository coding guidelines and code smells) and Spec (whether the diff fulfills the originating issue). `adversarial-review` acts as a refutation check: it searches for omitted requirements, boundary failures, and scope creep.

**Should I run this in the same session that wrote the code?**
No. It is designed to run in a fresh subagent or separate session. An agent that just wrote the code carries confirmation bias and may overlook its own omissions.

**What if the reviewer finds no problems?**
The reviewer explicitly reports that no critical gaps or scope creep were detected. It does not invent minor nitpicks to justify its execution.

## It's working if

- Findings cite specific file paths and line numbers with concrete failure conditions.
- No findings complain about whitespace, formatting, or personal aesthetic preferences.
- Missing acceptance criteria from the spec are caught before merging.
- Unrelated file edits outside the feature's scope are flagged.

## Where it fits

`adversarial-review` runs near the end of the development lifecycle:

- [implement](https://aihero.dev/skills-implement) produces the feature changes.
- [verify-work](https://aihero.dev/skills-verify-work) proves the tests and builds pass.
- `adversarial-review` tests the diff for missed requirements and unhandled edge cases.
- [commit-push-pr](https://aihero.dev/skills-commit-push-pr) ships the verified changes.
