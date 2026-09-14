## What it does

`verify-work` runs an automated check before an agent considers a task complete. It requires real terminal output evidence from a test runner, a typechecker, a linter, or a compiler.

The defining constraint is that an agent must execute a dual check: prove that the intended change works, and prove that existing tests still pass. The agent must never declare work complete based only on inspection or unverified code edits.

## When to reach for it

Type `/verify-work`, or the agent reaches for it automatically when completing an implementation, fixing a bug, or checking for regressions.

| Your situation | Reach for |
| --- | --- |
| You made changes and want proof they work without regressions | `verify-work` |
| You want to build code test-first, one slice at a time | [tdd](https://aihero.dev/skills-tdd) |
| A bug is intermittent or hard to reproduce | [diagnosing-bugs](https://aihero.dev/skills-diagnosing-bugs) |
| You want a two-axis review of standards and spec compliance | [code-review](https://aihero.dev/skills-code-review) |
| You want an adversarial check hunting for missing requirements | [adversarial-review](https://aihero.dev/skills-adversarial-review) |

## The dual-check loop

A complete verification requires two separate checks:

| Check | Target | Purpose |
| --- | --- | --- |
| Target check | The modified function or endpoint | Proves the new feature or bug fix actually works |
| Regression check | The existing test suite and typechecker | Proves untouched code was not accidentally broken |

Running only the target check leaves regressions undetected. Running only the general test suite can miss bugs if the new behavior lacks an explicit test. Both checks are required.

## Evidence over assertion

An agent must show the command it executed and the resulting output. An assertion without terminal output is treated as unverified.

The skill forbids suppressing errors. If a typechecker or test fails, the root cause must be corrected. Adding `@ts-ignore`, `# type: ignore`, empty catch blocks, or dummy return values violates the verification standard.

## Common questions

**Does this replace writing unit tests?**
No. It executes the tests that exist and requires writing a targeted check if one is missing.

**What if the repository has no test suite?**
The skill falls back to running a linter, a typechecker (`tsc --noEmit`, `mypy`), a build command (`npm run build`), or an executable CLI script that tests the modified code path.

**When should this run?**
Run it at the end of every ticket or implementation task, right before committing changes or opening a pull request.

## It's working if

- The agent shows the exact terminal command it executed.
- The output displays test counts, exit codes, or compilation status.
- Existing tests continue to pass alongside the new verification test.
- No error-suppression comments were added to bypass failing checks.

## Where it fits

`verify-work` is the verification gate that closes the build loop:

- [tdd](https://aihero.dev/skills-tdd) drives test-first implementation of individual behaviors.
- [implement](https://aihero.dev/skills-implement) builds features across vertical slices.
- `verify-work` runs the dual check before changes are committed.
- [code-review](https://aihero.dev/skills-code-review) and [adversarial-review](https://aihero.dev/skills-adversarial-review) inspect the resulting diff.
