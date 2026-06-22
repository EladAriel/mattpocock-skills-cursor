# Wiki map (framework documentation)

Framework API patterns and examples live in the [Fullstack LLM Wiki](https://github.com/EladAriel/fullstack-llm-wiki) — not in this repo. Use the `fullstack-llm-wiki-navigator` skill to read it.

## Locate the wiki

1. `frameworks/index.md` at workspace root (wiki opened directly), or
2. `fullstack-llm-wiki/frameworks/index.md` (wiki cloned into the app repo — default for Matt fullstack apps)

If neither exists, clone the wiki or run `setup-matt-pocock-skills` Section F.

## Entry indexes

Start at the nearest entry index, then walk down:

| When building… | Wiki entry index (from wiki root) |
|----------------|-----------------------------------|
| Unsure which area | `frameworks/index.md` |
| FastAPI, Pydantic, Redis | `frameworks/backend/index.md` |
| SQLAlchemy, Alembic, Beanie, PyMongo, MongoDB, Postgres | `frameworks/db/index.md` |
| React, Next.js, TanStack, Zod, shadcn/ui | `frameworks/ui/index.md` |
| pytest, Jest | `frameworks/test/index.md` |

## Navigation rule

**Entry index → nearest directory `index.md` → most specific page.**

- `index.md` = navigation map
- `_source_index.md` = original copied documentation

Mention source-commit date or staleness when the answer depends on current framework behavior.
