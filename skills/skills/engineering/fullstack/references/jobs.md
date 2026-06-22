# Background jobs

Only add background execution when the vertical slice needs work outside the request lifecycle.

## Decision table

| Need | Use |
|------|-----|
| Fire-and-forget after response, same process | FastAPI `BackgroundTasks` |
| Async Python, Redis-backed, FastAPI-native | **ARQ** |
| Scheduled tasks, chains, priority queues, mature ops | **Celery** + Redis broker |
| Simple Redis queue, sync workers | **RQ** (lighter than Celery; less FastAPI-native than ARQ) |

Default lean choice for FastAPI: **ARQ** for async workers; **BackgroundTasks** for trivial deferral.

## Rules

- **Idempotency:** job handlers must tolerate retry. Use idempotency keys or dedup locks (Redis) for side effects.
- **Payload size:** large results → object store (S3/R2); Redis for status/metadata only.
- **Enqueue from services**, not routers — router calls service; service enqueues if needed.
- **Test the handler** in isolation (unit) plus one integration test that enqueues and verifies outcome.

## When to skip

If the slice completes within request time (e.g. sending one email with a provider SDK), prefer synchronous service call or `BackgroundTasks` — don't reach for Celery prematurely.

## Framework patterns

For FastAPI `BackgroundTasks` and Redis detail, search the llm wiki via [`wiki-map.md`](./wiki-map.md) and the `fullstack-llm-wiki-navigator` skill.
