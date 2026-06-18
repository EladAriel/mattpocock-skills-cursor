# Fullstack references

On-demand layer conventions for FastAPI + TypeScript fullstack repos. **Not a skill** — no `SKILL.md`, zero idle context load. Existing skills reach these files via context pointers when building fullstack work.

## Conflict rule

**Matt's flow wins** on orchestration and slice shape (`grill-with-docs` → `to-prd` → `to-issues` → `implement` / `tdd`). These references only govern **layer order inside one vertical slice**.

| Scope | Owner |
|-------|-------|
| How issues are split | `to-issues` — vertical tracer bullets |
| Order inside one issue | References below |
| Test philosophy | `tdd` — RED→GREEN tracer bullets, never horizontal test batches |

## References

| File | Read when |
|------|-----------|
| [references/layer-order.md](./references/layer-order.md) | Starting a fullstack issue or breaking a plan into slices |
| [references/backend.md](./references/backend.md) | Models, migrations, services, repositories |
| [references/api.md](./references/api.md) | Routes, validation, error shapes, versioning |
| [references/jobs.md](./references/jobs.md) | Background work, queues, async tasks |
| [references/frontend.md](./references/frontend.md) | UI after API contract is frozen |
| [references/testing.md](./references/testing.md) | Test order within a vertical slice |

If the app repo has `docs/agents/stack-profile.md` (from `setup-matt-pocock-skills`), read it first — repo-specific paths override generic conventions here.

Pattern source: [ATTRIBUTION.md](./ATTRIBUTION.md).
