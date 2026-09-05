---
name: brief-me
description: Four-section brief for a concept or an overloaded action list so you can decide the next move.
argument-hint: "Concept or action pile to brief?"
disable-model-invocation: true
---

The user needs a **brief**: one fixed four-section explanation of a topic so they can keep deciding while the agent produces a lot of plan or build output.

A topic is either a **concept** (term, pattern, mechanism) or an **action pile** (ticket list, decision map, implement steps, QA checklist). Infer which from the argument and the conversation. If neither is clear, ask once what to brief, then produce the brief.

## Output contract

Reply with **exactly these four sections**, in this order, with these headings. No preamble before section 1. No fifth section. No files unless the user asked to save one.

### 1. Understand it

Core idea, the theory behind it, and why it exists. Keep it short. Define each unfamiliar technical term in plain words on first use. Say what happens, why, and the main trade-off.

### 2. See it

One visual that makes the structure graspable. Prefer, in this order:

1. A **comparison table** (2–5 rows), or
2. A **Mermaid diagram** (3–7 nodes), or
3. A short **conceptual diagram description** (boxes and arrows in prose)

Stay **eli12-safe**: no metaphors, analogies, or story comparisons. Tables and diagrams only.

For an **action pile**, the visual must show structure you can act on: pickup order, blocking edges, or decide-now vs later.

### 3. Practical Example

One specific, real scenario where this is in play. Prefer the current repo, ticket, or conversation over a generic industry story. Name real files, issues, or steps when they exist.

### 4. Practical Tips

Actionable advice, best practices, and common pitfalls. End with **one next move** the user can take in this session (a decision, a skill to run, or a single ticket to pick up).

## Style

- Follow `eli12` when `.cursor/rules/eli12.mdc` is active (plain words, real engineering terms, no metaphors).
- Use `CONTEXT.md` vocabulary when the project has one (follow `CONTEXT-MAP.md` if present).
- Keep the whole brief scannable: short paragraphs, tables over walls of text.

## Boundaries

| Need | Reach for |
| --- | --- |
| Re-pitch the last message that didn't land | `wait-what` |
| Multi-session course with lessons and retention | `teach` |
| One structured brief so you can decide now | `brief-me` (this skill) |
| Sharpen an undecided plan by interview | `grill-me` / `grill-with-docs` |
