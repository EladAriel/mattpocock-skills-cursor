# Testing (within a vertical slice)

Matt `tdd` owns the loop: one test → one implementation → repeat. This doc only orders **which layer to test next** inside one slice.

**Never** write all backend tests then all frontend tests (horizontal slicing).

## Within-slice test order

For each behavior in the slice, tracer-bullet through layers:

1. **Service unit test** (pytest) — exercise business logic through the service public interface. Mock repository if needed; don't hit HTTP yet.
2. **Route integration test** (pytest + `TestClient` or httpx) — one endpoint, real app wiring, test DB or fixtures. Verifies HTTP contract.
3. **Frontend component test** (Vitest/Jest + Testing Library) — render with MSW mocking the frozen API response.
4. **Optional E2E** (Playwright) — only for critical paths or cross-slice flows; not every slice.

## Backend patterns

- Fixtures: `conftest.py` for DB session, async client, factory helpers.
- `@pytest.mark.parametrize` for input variants.
- Integration tests: prefer testcontainers or a dedicated test DB over mocking the database in integration tests.

## Frontend patterns

- MSW handlers colocated with tests or a shared `mocks/` folder.
- `renderHook` for TanStack Query hooks.
- `test.each` / `it.each` for variant tables.

## Gaps

- **Beanie/SQLModel:** use Context7 for fixture patterns; keep tests on public interfaces.
- **Jest vs Vitest:** default Vitest; if repo uses Jest, same structure applies.

## Ship

Follow `tdd` §6 — session files only, commit, PR. Run full suite once at end of slice, not after every single test during development.
