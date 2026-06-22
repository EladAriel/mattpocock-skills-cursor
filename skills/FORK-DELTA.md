# Cursor fork invariants

Contract enforced after every upstream merge. See [FORK.md](./FORK.md) for sync tracking.

## Must remain absent

Upstream may re-add these Claude Code artifacts — remove them:

- `.claude-plugin/`
- `CLAUDE.md`
- `scripts/link-skills.sh`
- `skills/misc/git-guardrails-claude-code/`

## Must remain present

- [CURSOR.md](./CURSOR.md)
- [scripts/link-skills-cursor.sh](./scripts/link-skills-cursor.sh)
- [skills/misc/git-guardrails-cursor/](./skills/misc/git-guardrails-cursor/)

## Must stay Cursor-adapted

Re-apply these edits if upstream overwrites them:

- [README.md](./README.md) — clone + `link-skills-cursor.sh` quickstart, Cursor invocation wording, sync skill for updates (not bare `git pull`)
- [CONTEXT.md](./CONTEXT.md) — "loaded by Cursor"
- [docs/invocation.md](./docs/invocation.md) — Cursor @-mention behavior
- [skills/engineering/setup-matt-pocock-skills/SKILL.md](./skills/engineering/setup-matt-pocock-skills/SKILL.md) — writes `AGENTS.md`, reads `.cursor/rules/`
- [skills/engineering/fullstack/](./skills/engineering/fullstack/) — Cursor-fork reference bucket for fullstack layer conventions (not user-invoked)
- [skills/engineering/fullstack-llm-wiki-navigator/](./skills/engineering/fullstack-llm-wiki-navigator/) — model-invoked skill for local framework docs in the Fullstack LLM Wiki
- [skills/misc/README.md](./skills/misc/README.md) — `git-guardrails-cursor` and `sync-matt-pocock-skills-cursor` entries
- [CHANGELOG.md](./CHANGELOG.md) — Unreleased Cursor fork breaking-changes section

## Merge-sensitive files

Usually accept upstream as-is, then re-apply Cursor edits only if install/docs paths changed:

- New or changed skills under `skills/**`
- `package.json`, `.github/workflows/`, `.changeset/` — accept upstream unless they reintroduce Claude-only install paths (`npx skills`, `link-skills.sh`, etc.)
