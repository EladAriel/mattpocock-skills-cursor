---
name: implement
description: "Implement a piece of work based on a spec or set of tickets. In Plan mode, lead with a unified HLD (architecture + sequence) of the tickets."
disable-model-invocation: true
---

# Implement

Implement the work described by the user in the spec or tickets.

Branch on mode first.

## Plan mode

When Plan mode is active (read-only / CreatePlan required; no edits):

1. **Gather scope.** Load the ticket(s) the user named, or the feature slice under `.scratch/<feature>/issues/` plus parent SPEC/STATUS when present. Use `CONTEXT.md` glossary terms; respect ADRs in the area.
2. **Unified HLD.** Build **one** design picture for **all tickets in the feature slice** — not one mini-HLD per ticket. Call out which ticket(s) this `/implement` run will build. Follow [PLAN-MODE-HLD.md](PLAN-MODE-HLD.md) for required sections, Mermaid rules, and ticket annotations.
3. **CreatePlan.** The plan body **must** start with the Unified HLD (overview → architecture diagram → sequence diagram → ticket map), then build todos only for the ticket(s) in this run. Do not edit files or write code in Plan mode.
4. **Stop.** Submit the plan and wait for user confirmation / Agent mode before building.

**Done when:** CreatePlan has been submitted with a complete Unified HLD and build todos for the in-scope ticket(s).

## Agent mode

If this session already has an approved plan-mode HLD for these tickets, follow it. Regenerate only if the user asks or the tickets changed.

Use /tdd where possible, at pre-agreed seams.

The `/ponytail` ladder governs *what* gets built — reuse before rewrite, stdlib and native before new code, no unrequested abstractions.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

**Manual QA.** Write a manual QA markdown file for this ticket. Follow [MANUAL-QA.md](MANUAL-QA.md). Derive cases from the ticket acceptance criteria and what you actually built. Output path:

- Feature slice known: `.scratch/<feature-slug>/qa/<NN>-<slug>-manual-qa.md`
- Fallback (GitHub-only tracker, no slice dir): `.scratch/qa/<ticket-id>-manual-qa.md`

Commit the file with the implementation.

Once done, use /code-review to review the work.

Commit your work to the current branch.

**Done when (Agent mode):** code committed **and** manual QA file exists covering every in-scope acceptance criterion.
