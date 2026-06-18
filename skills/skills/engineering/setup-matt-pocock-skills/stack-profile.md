# Stack profile

Repo-specific fullstack conventions. Skills `implement` and `tdd` read this before `fullstack/references/` when it exists. **Repo paths here override generic references.**

## Backend

- **Framework:** FastAPI
- **ORM / migrations:** SQLAlchemy 2.0 async + Alembic
- **Model path:** `app/models/` (or `app/db/models/`)
- **Service path:** `app/services/`
- **Router path:** `app/routers/` or `app/api/v1/`
- **Migration path:** `alembic/versions/`
- **API prefix:** `/api/v1/`

## Frontend

- **Framework:** Next.js (App Router)
- **Source path:** `src/` or `app/`
- **UI kit:** shadcn/ui
- **Server state:** TanStack Query
- **API types:** Zod schemas mirroring Pydantic models

## Test runners

- **Backend:** pytest (`pytest`, integration via `TestClient` or httpx)
- **Frontend:** Vitest (or Jest if noted below)
- **E2E (optional):** Playwright

## Notes

<!-- Repo-specific overrides: alternate ORM (SQLModel), monorepo paths, auth pattern, etc. -->
