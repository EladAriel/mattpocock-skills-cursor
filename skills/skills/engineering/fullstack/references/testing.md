# Testing (within a vertical slice)

Matt `tdd` owns the loop: one test → one implementation → repeat. This doc only orders **which layer to test next** inside one slice.

**Never** write all backend tests then all frontend tests (horizontal slicing).

## Within-slice test order

For each behavior in the slice, tracer-bullet through layers:

1. **Service unit test** (pytest) — exercise business logic through the service public interface. Mock repository if needed; don't hit HTTP yet.
2. **Route integration test** (pytest + `TestClient` or httpx) — one endpoint, real app wiring, test DB or fixtures. Verifies HTTP contract.
3. **Frontend component test** (Vitest/Jest + Testing Library) — render with MSW mocking the frozen API response.
4. **Optional E2E** (Playwright) — only for critical paths or cross-slice flows; not every slice.

## Ship

Follow `tdd` §6 — session files only, commit, PR. Run full suite once at end of slice, not after every single test during development.

## Framework patterns

For pytest fixtures, async test setup, Jest/Vitest patterns, and MSW detail, search the llm wiki via [`wiki-map.md`](./wiki-map.md) and the `fullstack-llm-wiki-navigator` skill.
