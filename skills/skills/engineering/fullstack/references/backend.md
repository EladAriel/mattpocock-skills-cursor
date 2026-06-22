# Backend (models, migrations, services)

Read `docs/agents/stack-profile.md` for repo-specific paths and ORM choice. **Matt layer separation always applies** — router → service → repository/ODM, regardless of ORM.

## Stack default

**SQLAlchemy 2.0 async** + **Alembic** + **Pydantic v2** for API schemas. FastAPI `Depends()` for DI.

| ORM | Use when |
|-----|----------|
| **SQLAlchemy** | Default — full control, async-first |
| **SQLModel** | Less model duplication on SQLAlchemy + Pydantic |
| **Beanie** | MongoDB — async ODM on Pydantic + PyMongo |

## Layer separation

```
Router → Service → Repository / ODM → DB
```

- **Router:** HTTP only — parse request, call service, map response/errors. No `Session`, no `Document.find`, no PyMongo calls.
- **Service:** business rules, transaction boundaries, orchestration. Accepts primitives/schemas, returns domain results.
- **Repository / ODM:** persistence. One per aggregate or bounded context.

## Framework patterns

For models, migrations, sessions, DI, and ODM API detail, search the llm wiki via [`wiki-map.md`](./wiki-map.md) and the `fullstack-llm-wiki-navigator` skill.

## Quality

Match `.cursor/rules/backend-layers.mdc` and `code-quality.mdc` when installed.
