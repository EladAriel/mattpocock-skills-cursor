# WORKFLOW

## General Flow

1. If you have codebase use `/grill-with-docs` and if you don't have use `/grill-me` to create shared language with LLM.
2. When done we invoke the `/to-spec` skill to produce a spec (make sure you stay within the same conversation of step 1.)
3. When done we invoke the `/to-tickets` skill to break a plan into tracer-bullet tickets with blocking edges.
4. Work tickets in pickup order. For each ticket, invoke `/implement` (which uses `/tdd` for test-driven development and `/verify-work` to prove zero regressions).
5. If the code needs refactoring then use `improve-codebase-architecture` skill (or `batch-refactor` for wide multi-file updates).

## Fullstack AI Application Flow

For **FastAPI + TypeScript** apps (Next.js frontend, pytest + Vitest). Follow the **General Flow** above — fullstack only adds layer conventions *inside* each issue. Matt's vertical slices win; never split work into horizontal milestones ("all models", then "all routes", then "all UI").

### 0. One-time setup (app repo)

Run **`setup-matt-pocock-skills`** before your first feature. Opt in to:

- **Stack profile** → `docs/agents/stack-profile.md` (paths, ORM choice: SQLAlchemy, SQLModel, or Beanie)
- **Fullstack LLM Wiki** → `fullstack-llm-wiki/` (local framework docs; clone via setup Section F)
- **Cursor rules** → `backend-layers.mdc`, `code-quality.mdc`, etc.
- Optionally **`git-guardrails-cursor`** → blocks destructive git + DB commands

### 1–3. Plan (same conversation)

Same as General Flow steps 1–3. Do not compact or clear context until after **`to-tickets`**.

At **`to-tickets`**, slices stay **vertical** — each ticket is demoable end-to-end. Example:

- **Slice 1:** thinnest read path (model → service → GET route → list UI → tests)
- **Slice 2:** write path (create/update → POST/PATCH → form UI → tests)

A foundation-only slice (shared auth, base DI) is allowed only when every downstream slice is blocked.

See [`skills/skills/engineering/fullstack/references/layer-order.md`](skills/skills/engineering/fullstack/references/layer-order.md).

### 4. Build (fresh session per issue)

Copy the pickup order from step 3. For **each ticket**, start a **new session** and invoke **`implement`** with the spec + that single ticket. `implement` uses **`tdd`** inside.

**Read order at the start of each issue:**

1. `docs/agents/stack-profile.md` (if present)
2. `fullstack/references/layer-order.md`
3. The layer-specific reference for what you're building now
4. For framework API patterns → `fullstack/references/wiki-map.md` + `fullstack-llm-wiki-navigator` skill

**Within-slice layer order** (one behavior at a time via TDD):

```
models + migration → services → API schemas → routes → (jobs if needed)
  → freeze API contract → frontend → tests
```

| Layer | Reference |
|-------|-----------|
| Framework docs (LangChain, LangGraph, FastAPI, SQLAlchemy, Next.js, pytest, etc.) | [`wiki-map.md`](skills/skills/engineering/fullstack/references/wiki-map.md) + `fullstack-llm-wiki-navigator` |
| Models, migrations, services (SQLAlchemy / SQLModel / Beanie) | [`backend.md`](skills/skills/engineering/fullstack/references/backend.md) |
| Routes, validation, errors, `/api/v1/` | [`api.md`](skills/skills/engineering/fullstack/references/api.md) |
| Background jobs (Celery, ARQ, BackgroundTasks) | [`jobs.md`](skills/skills/engineering/fullstack/references/jobs.md) |
| UI after contract frozen (Zod, TanStack Query, shadcn) | [`frontend.md`](skills/skills/engineering/fullstack/references/frontend.md) |
| Test order within slice (pytest → Vitest) | [`testing.md`](skills/skills/engineering/fullstack/references/testing.md) |

**TDD rule:** tracer-bullet RED→GREEN per behavior — never write all backend tests then all frontend tests.

**Ship per issue:** `/verify-work` (run tests + typecheck to prove zero regressions) → `/code-review` & `/adversarial-review` → `/simplify` → run manual QA checklist (or Playwright MCP against hints in `.scratch/<feature>/qa/`) → `/commit-push-pr` (include simple Mermaid diagrams: system flow, user flow, architecture, sequence) → merge (user) → mark issue complete → checkout `main`. Run the full test suite once at the end of the slice.

### 5. Refactor

Same as General Flow — **`improve-codebase-architecture`** when structural work is needed.

### Example session

1. `/grill-with-docs` → `/to-spec` → `/to-tickets` (one conversation)
2. Ticket: *"User can list stress tests"* — **new session**
3. `/implement` + spec + ticket → stack profile + layer-order → TDD: migration → service test → route test → Zod type → list component test
4. `/code-review` → `/simplify` → run manual QA checklist → PR → merge → mark issue complete → checkout `main`

Full reference index: [`skills/skills/engineering/fullstack/README.md`](skills/skills/engineering/fullstack/README.md). Unsure which skill to use? **`ask-matt`**.
