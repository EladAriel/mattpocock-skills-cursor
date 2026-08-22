# Manual QA

Disclosed reference for `/implement` in Agent mode. After the full test suite passes and before `/code-review`, write one manual QA markdown file per ticket.

## Output path

- **Feature slice known:** `.scratch/<feature-slug>/qa/<NN>-<slug>-manual-qa.md`
- **Fallback** (GitHub-only tracker, no slice dir): `.scratch/qa/<ticket-id>-manual-qa.md`

Derive `<feature-slug>`, `<NN>`, and `<slug>` from the ticket path or issue reference loaded at the start of the run. Commit the file with the implementation.

## Required sections (in order)

### 1. Header

- Ticket reference (id, issue number, or file path)
- **Built in this run:** 1–2 sentences summarising observable behaviour added

### 2. Prerequisites

Checkbox list of setup a human or agent needs before running cases — dev server URL, auth state, seed data, feature flags, etc. Omit when nothing special is required.

### 3. Test cases

One case per acceptance criterion from the ticket (plus regressions where relevant). Use this shape for each:

| Field | Required | Purpose |
| --- | --- | --- |
| **What we added** | Yes | Observable behaviour introduced in this run |
| **Steps** | Yes | Numbered actions a human or agent can follow |
| **Expected result** | Yes | Pass/fail observable outcome |
| **Maps to** | Yes | Which acceptance criterion this verifies |
| **Playwright hint** | No | URL, selectors, assertions — enough for Playwright MCP to automate without rewriting the case |

### 4. Regression

Checkbox list of existing behaviour that should still work after this slice. Skip when the slice is isolated and regression is covered by automated tests only — say so explicitly.

### 5. Out of scope

Behaviours deliberately not built in this run, so reviewers do not hunt for them.

## Writing rules

- **Behavioral, not procedural** — describe what to observe, not file paths or line numbers (same durability principle as triage agent briefs).
- **One criterion, one case** — every ticket acceptance criterion gets at least one test case.
- **Backend-only slices** — skip UI/E2E cases; state "No UI cases — backend-only slice" under Test cases.
- **Checkbox format** — use `- [ ]` on prerequisites and regression items so humans and agents can mark pass/fail.
- **Playwright hints are optional** — include them when a case touches UI or HTTP; omit for pure unit-level behaviour already covered by automated tests.

## Example skeleton

````markdown
# Manual QA: User can list stress tests

**Ticket:** T01 / `.scratch/stress-tests/issues/01-list-stress-tests.md`
**Built in this run:** GET `/api/v1/stress-tests` returns a paginated list; the dashboard shows an empty state or rows for each test.

## Prerequisites

- [ ] Backend running at `http://localhost:8000`
- [ ] Frontend running at `http://localhost:3000`
- [ ] At least one stress test seeded (for non-empty case)

## Test cases

### TC01 — Empty list shows empty state

**What we added:** List page renders an empty-state message when no stress tests exist.

**Steps:**
1. Open the stress tests list page with an empty database.
2. Wait for the list to finish loading.

**Expected result:** Page shows "No stress tests yet" (or equivalent empty-state copy); no error toast.

**Maps to:** Acceptance criterion 1 — empty list shows helpful message.

**Playwright hint:** `goto /stress-tests`, expect `[data-testid="empty-state"]` visible, expect text "No stress tests yet".

### TC02 — API returns stress test rows

**What we added:** GET `/api/v1/stress-tests` returns `{ items: [...] }` for seeded data.

**Steps:**
1. Seed one stress test via the API or fixture.
2. `curl http://localhost:8000/api/v1/stress-tests`.

**Expected result:** HTTP 200; JSON body contains one item with `id`, `name`, and `created_at`.

**Maps to:** Acceptance criterion 2 — list endpoint returns persisted tests.

## Regression

- [ ] Existing auth/login flow still works.
- [ ] Unrelated dashboard widgets still load.

## Out of scope

- Creating or editing stress tests (T02).
- Pagination beyond the first page.
````

## Done when

The manual QA file exists, covers every in-scope acceptance criterion from the ticket, and is committed with the implementation.
