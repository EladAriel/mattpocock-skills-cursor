# WORKFLOW

## General Flow

1. If you have codebase use `/grill-with-docs` and if you don't have use `/grill-me` to create shared language with LLM.
2. When done we invoke the `/to-prd` skill to product PRD (make sure you stay within the same conversation of step 1.)
3. When done we invoke the `/to-issues` skill to break a plan into independently-grabbable issues using vertical slices.
4. Copy the `Suggested pickup order` from step 3. For each issue, invoke `/implement` (which uses `/tdd` for test-driven development).
5. If the code need refactoring then use `improve-codebase-architecture` skill.

## Fullstack AI Application Flow

For **FastAPI + TypeScript** apps (Next.js frontend, pytest + Vitest). Follow the **General Flow** above — fullstack only adds layer conventions *inside* each issue. Matt's vertical slices win; never split work into horizontal milestones ("all models", then "all routes", then "all UI").

### 0. One-time setup (app repo)

Run **`setup-matt-pocock-skills`** before your first feature. Opt in to:

- **Stack profile** → `docs/agents/stack-profile.md` (paths, ORM choice: SQLAlchemy, SQLModel, or Beanie)
- **Cursor rules** → `backend-layers.mdc`, `code-quality.mdc`, etc.
- Optionally **`git-guardrails-cursor`** → blocks destructive git + DB commands

### 1–3. Plan (same conversation)

Same as General Flow steps 1–3. Do not compact or clear context until after **`to-issues`**.

At **`to-issues`**, slices stay **vertical** — each issue is demoable end-to-end. Example:

- **Slice 1:** thinnest read path (model → service → GET route → list UI → tests)
- **Slice 2:** write path (create/update → POST/PATCH → form UI → tests)

A foundation-only slice (shared auth, base DI) is allowed only when every downstream slice is blocked.

See [`skills/skills/engineering/fullstack/references/layer-order.md`](skills/skills/engineering/fullstack/references/layer-order.md).

### 4. Build (fresh session per issue)

Copy the `Suggested pickup order` from step 3. For **each issue**, start a **new session** and invoke **`implement`** with the PRD + that single issue. `implement` uses **`tdd`** inside.

**Read order at the start of each issue:**

1. `docs/agents/stack-profile.md` (if present)
2. `fullstack/references/layer-order.md`
3. The layer-specific reference for what you're building now

**Within-slice layer order** (one behavior at a time via TDD):

```
models + migration → services → API schemas → routes → (jobs if needed)
  → freeze API contract → frontend → tests
```

| Layer | Reference |
|-------|-----------|
| Models, migrations, services (SQLAlchemy / SQLModel / Beanie) | [`backend.md`](skills/skills/engineering/fullstack/references/backend.md) |
| Routes, validation, errors, `/api/v1/` | [`api.md`](skills/skills/engineering/fullstack/references/api.md) |
| Background jobs (Celery, ARQ, BackgroundTasks) | [`jobs.md`](skills/skills/engineering/fullstack/references/jobs.md) |
| UI after contract frozen (Zod, TanStack Query, shadcn) | [`frontend.md`](skills/skills/engineering/fullstack/references/frontend.md) |
| Test order within slice (pytest → Vitest) | [`testing.md`](skills/skills/engineering/fullstack/references/testing.md) |

**TDD rule:** tracer-bullet RED→GREEN per behavior — never write all backend tests then all frontend tests.

**Ship per issue:** `/review` → commit (or PR). Run the full test suite once at the end of the slice.

### 5. Refactor

Same as General Flow — **`improve-codebase-architecture`** when structural work is needed.

### Example session

1. `/grill-with-docs` → `/to-prd` → `/to-issues` (one conversation)
2. Issue: *"User can list stress tests"* — **new session**
3. `/implement` + PRD + issue → stack profile + layer-order → TDD: migration → service test → route test → Zod type → list component test
4. `/review` → commit

Full reference index: [`skills/skills/engineering/fullstack/README.md`](skills/skills/engineering/fullstack/README.md). Unsure which skill to use? **`ask-matt`**.
