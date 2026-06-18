# Backend (models, migrations, services)

## Stack default

**SQLAlchemy 2.0 async** + **Alembic** + **Pydantic v2** for API schemas. FastAPI `Depends()` for DI.

Read `docs/agents/stack-profile.md` for repo-specific paths and ORM choice. **Matt layer separation always applies** — router → service → repository/ODM, regardless of ORM.

## Models (SQLAlchemy)

- One model per aggregate/table; explicit `__tablename__`, typed columns, relationships with `lazy="selectin"` or explicit loading strategy.
- Prefer UUID primary keys for user-facing entities unless ADR says otherwise.
- Index foreign keys and columns used in filters/sorts.

## Migrations (Alembic)

- Every model change gets a reversible migration in `alembic/versions/`.
- Use `alembic revision --autogenerate` then review — autogenerate is a draft, not gospel.
- Data migrations: separate revision, idempotent where possible.
- Async projects: `env.py` uses `async_engine` + `run_sync` for offline/online modes.

## SQLModel (PostgreSQL / SQLite)

[SQLModel](https://sqlmodel.tiangolo.com) is a thin layer on **SQLAlchemy + Pydantic** — same layer separation, less model duplication.

### Model split

Separate **table**, **create**, **public**, and **update** models — don't expose table models directly from routes:

```python
class HeroBase(SQLModel):
    name: str = Field(index=True)
    secret_name: str
    age: int | None = Field(default=None, index=True)

class Hero(HeroBase, table=True):
    id: int | None = Field(default=None, primary_key=True)

class HeroCreate(HeroBase):
    pass

class HeroPublic(HeroBase):
    id: int

class HeroUpdate(SQLModel):
    name: str | None = None
    secret_name: str | None = None
    age: int | None = None
```

### Session DI

Routers receive a session via `Depends`; services accept a `Session` (or repository) — not raw engine access in routes:

```python
def get_session():
    with Session(engine) as session:
        yield session

@app.post("/heroes/", response_model=HeroPublic)
def create_hero(*, session: Session = Depends(get_session), hero: HeroCreate):
    db_hero = Hero.model_validate(hero)
    session.add(db_hero)
    session.commit()
    session.refresh(db_hero)
    return db_hero
```

Queries use `session.exec(select(Hero).where(...))` or `session.get(Hero, id)`.

### Migrations

`SQLModel.metadata` is SQLAlchemy metadata — **Alembic autogenerate works** the same as plain SQLAlchemy. Point Alembic at `SQLModel.metadata` (or a shared `Base.metadata`).

### Async

SQLModel tutorials use sync `Session`. For async FastAPI, use SQLAlchemy 2 `async_sessionmaker` with SQLModel `table=True` classes — same models, async session in `Depends()`. Prefer the stack profile's choice; don't mix sync sessions inside async routes.

### Service layer

Keep routers thin: route validates `HeroCreate`, calls `HeroService.create(session, hero)`, returns `HeroPublic`. Map `Hero` → `HeroPublic` in the service or a small mapper.

## Beanie + PyMongo (MongoDB)

[Beanie](https://github.com/BeanieODM/beanie) is an async ODM on **Pydantic + PyMongo**. [PyMongo](https://github.com/mongodb/mongo-python-driver) is the official driver — Beanie uses `AsyncMongoClient` under the hood.

### When to use which

| Tool | Use when |
|------|----------|
| **Beanie `Document`** | Normal CRUD, typed models, indexes, app schema migrations |
| **Raw PyMongo** | One-off admin scripts, pipelines Beanie doesn't express, GridFS, driver-level options |

Don't query MongoDB from routers — services call `Document` methods or an injected collection.

### Document models

```python
from beanie import Document, Indexed, init_beanie
from pydantic import BaseModel

class Category(BaseModel):
    name: str
    description: str

class Product(Document):
    name: str
    description: str | None = None
    price: Indexed(float)
    category: Category

    class Settings:
        name = "products"  # collection name
```

- Embed Pydantic `BaseModel` for subdocuments; use `Indexed()` for index hints.
- `Settings.name` sets the collection; `Settings.indexes` for compound indexes when needed.

### Startup (`init_beanie`)

Initialize once at app startup (FastAPI lifespan) — before any DB access:

```python
from contextlib import asynccontextmanager
from pymongo import AsyncMongoClient
from beanie import init_beanie

@asynccontextmanager
async def lifespan(app: FastAPI):
    client = AsyncMongoClient(settings.mongodb_url)
    await init_beanie(
        database=client[settings.db_name],
        document_models=[Product, Order],  # or ["app.models.Product", ...]
        allow_index_dropping=False,
    )
    yield
    await client.close()

app = FastAPI(lifespan=lifespan)
```

`init_beanie` registers collections and syncs indexes (`allow_index_dropping=False` in production).

### CRUD in services

Documents are Pydantic-like with async query API — keep this in services, not routers:

```python
product = await Product.find_one(Product.price < 10)
await product.set({Product.name: "Gold bar"})
await Product.insert_many([...])
```

### Migrations (Beanie)

Beanie has a **built-in migration system** (not Alembic). Use Beanie migrations for collection schema/index changes on MongoDB repos. SQL Alembic migrations do not apply.

### Raw PyMongo (when needed)

For driver-level access, inject `AsyncMongoClient` or a database handle via lifespan + `Depends()`:

```python
client = AsyncMongoClient(uri, server_api=ServerApi("1"))
db = client.get_database("mydb")
collection = db.get_collection("movies")
doc = await collection.find_one({"title": "Back to the Future"})
```

Prefer Beanie `Document` for application code; reserve raw collections for exceptions.

## Layer separation

```
Router → Service → Repository / ODM → DB
```

- **Router:** HTTP only — parse request, call service, map response/errors. No `Session`, no `Document.find`, no PyMongo calls.
- **Service:** business rules, transaction boundaries, orchestration. Accepts primitives/schemas, returns domain results.
- **Repository / ODM:** persistence — SQLAlchemy queries, SQLModel session ops, or Beanie `Document` methods. One per aggregate or bounded context.

Inject via FastAPI `Depends()`:

```python
async def get_user_service(
    repo: UserRepository = Depends(get_user_repository),
) -> UserService:
    return UserService(repo)
```

## Quality

Match `.cursor/rules/backend-layers.mdc` and `code-quality.mdc` when installed.
