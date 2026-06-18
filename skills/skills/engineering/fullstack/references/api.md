# API layer (routes, validation, errors)

Routers are thin. Business logic stays in services — see `backend.md`.

## Versioning

- Prefix routes with `/api/v1/` (or version in `stack-profile.md`).
- Breaking changes → new version prefix, not silent breakage.

## Request / response

- Pydantic v2 models for request bodies, query params, and responses.
- Field validators for domain constraints; return **422** with structured detail on validation failure.
- Response model on every route — explicit contract for OpenAPI and frontend Zod generation.

## Error shape (RFC 9457 Problem Details)

Prefer consistent error bodies:

```json
{
  "type": "https://example.com/errors/not-found",
  "title": "Not Found",
  "status": 404,
  "detail": "User 42 does not exist"
}
```

Map domain exceptions in a service layer to HTTP status in the router or a shared exception handler — not scattered `try/except` per route.

## Route patterns

- `APIRouter` per resource; include in app with prefix + tags.
- `Depends()` for auth, pagination, and service injection.
- Pagination: cursor or offset — pick one per resource, document in OpenAPI.

## Security basics

- Validate and sanitize all inputs at the schema boundary.
- No secrets in route handlers or committed config.
- Auth dependency applied at router level when all routes need it.

## Contract freeze

Before frontend work on this slice: response shapes are stable, OpenAPI reflects reality, and shared TypeScript/Zod types can be generated or hand-written without guesswork.
