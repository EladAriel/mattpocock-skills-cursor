# Layer order (within a vertical slice)

## Two levels — don't confuse them

**Across issues** (Matt `to-issues`): vertical slices. Each issue is a thin end-to-end path — demoable on its own. Never split "all models" then "all routes" then "all UI" into separate issues.

**Inside one issue** (this doc): build layers in dependency order:

```
models + migration → services → routes → (jobs if needed) → freeze API contract → frontend → tests
```

Tests follow `testing.md` — tracer-bullet RED→GREEN per behavior, not a batch of tests upfront.

## Within-slice sequence

1. **Data model** — SQLAlchemy model + Alembic migration (or equivalent). See `backend.md`.
2. **Service** — business logic with no HTTP awareness. Repository/DB access lives here or behind it.
3. **API schemas** — Pydantic request/response models matching the service interface.
4. **Routes** — thin handlers delegating to services. See `api.md`.
5. **Background jobs** (only if this slice needs async work) — see `jobs.md`.
6. **Freeze contract** — OpenAPI shape + shared types are stable before frontend work.
7. **Frontend** — Zod types mirroring API, TanStack Query hooks, UI. See `frontend.md`.
8. **Tests** — within-slice order in `testing.md`; one behavior at a time via `/tdd`.

For framework-specific patterns at each layer, consult the llm wiki via [`wiki-map.md`](./wiki-map.md) and the `fullstack-llm-wiki-navigator` skill.

## Slice examples

**Slice 1 — thinnest read path:** model + migration → list service → GET route → list UI + one pytest integration + one Vitest component test.

**Slice 2 — write path:** create/update service methods → POST/PATCH routes → form UI + tests.

**Foundation slice (rare):** allowed only when every downstream slice is blocked — e.g. shared auth middleware, base DI wiring. Keep it minimal; prefer tracer bullets.

## Repo-specific paths

Read `docs/agents/stack-profile.md` if present. Typical FastAPI layout:

- `app/models/` or `app/db/models/`
- `app/services/`
- `app/routers/` or `app/api/v1/`
- `alembic/versions/`

Frontend (Next.js): `src/` or `app/` per the project's App Router layout.
