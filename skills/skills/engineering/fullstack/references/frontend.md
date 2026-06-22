# Frontend (after API contract frozen)

Do not build UI against guessed API shapes. Complete routes + Pydantic schemas for this slice first (`api.md`), then frontend.

Read `docs/agents/stack-profile.md` for framework paths and test runner.

## API consumer layer

1. **Zod schemas** mirroring Pydantic response/request shapes — single source for runtime validation.
2. **Typed fetch wrapper** or generated client — centralize base URL, auth headers, error parsing (Problem Details).
3. **TanStack Query** hooks per resource — `useQuery` for reads, `useMutation` for writes with cache invalidation.

## State

- Server state → TanStack Query.
- Client-only UI state → React `useState` or Zustand slices when prop drilling hurts.

## Accessibility

Keyboard focus, labels on inputs, semantic HTML. WCAG 2.2 AA for new interactive UI.

## Framework patterns

For Next.js, React, TanStack Query, Zod, shadcn/ui, and component testing detail, search the llm wiki via [`wiki-map.md`](./wiki-map.md) and the `fullstack-llm-wiki-navigator` skill.
