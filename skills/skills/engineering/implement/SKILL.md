---
name: implement
description: "Implement a piece of work based on a PRD or set of issues."
disable-model-invocation: true
---

Implement the work described by the user in the PRD or issues.

Use /tdd where possible, at pre-agreed seams.

**Fullstack repos** (FastAPI + TypeScript, etc.): if `docs/agents/stack-profile.md` exists, read it first. Then read [fullstack/references/layer-order.md](../fullstack/references/layer-order.md) once per issue, and the layer-specific reference for what you're building now (`backend.md`, `api.md`, `jobs.md`, `frontend.md`).

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /review to review the work.

Commit your work to the current branch.
