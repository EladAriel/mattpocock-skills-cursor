# Frontend (after API contract frozen)

Do not build UI against guessed API shapes. Complete routes + Pydantic schemas for this slice first (`api.md`), then frontend.

Read `docs/agents/stack-profile.md` for framework paths and test runner.

## Stack default

**Next.js App Router** + **TypeScript** + **TanStack Query** + **shadcn/ui** (Radix primitives).

## API consumer layer

1. **Zod schemas** mirroring Pydantic response/request shapes — single source for runtime validation.
2. **Typed fetch wrapper** or generated client — centralize base URL, auth headers, error parsing (Problem Details).
3. **TanStack Query** hooks per resource — `useQuery` for reads, `useMutation` for writes with cache invalidation.

## UI

- Server Components for data that can fetch on server; Client Components for interactivity.
- Loading: skeletons, not spinners alone (`interaction-patterns` spirit).
- Forms: validate with Zod on client; server remains authoritative.

## State

- Server state → TanStack Query.
- Client-only UI state → React `useState` or Zustand slices when prop drilling hurts.

## Testing default

**Vitest** + Testing Library for components. **Jest** if `stack-profile.md` says so — patterns transfer directly.

Mock API with **MSW** handlers matching the frozen contract.

## Accessibility

Keyboard focus, labels on inputs, semantic HTML. WCAG 2.2 AA for new interactive UI.
