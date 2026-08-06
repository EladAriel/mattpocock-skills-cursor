# Model-invoked vs user-invoked

Every `SKILL.md` in this repo is a skill. The one axis that splits them is **invocation** — who can reach it:

- **User-invoked** — reachable **only by the human invoking the skill explicitly**. Set `disable-model-invocation: true` in the frontmatter (and `policy.allow_implicit_invocation: false` in `agents/openai.yaml` for Codex metadata shipped alongside). The `description` is **human-facing**: a one-line summary read when browsing skills. Strip trigger lists ("Use when the user says…").

In Cursor, user-invoked skills are attached via **@ skill name** or by mentioning the skill in chat. Model-invoked skills are discovered automatically from their description.

- **Model-invoked** — reachable by **model or user**. The default: omit `disable-model-invocation` (and the `policy` block from `agents/openai.yaml`). The `description` is **model-facing** and keeps rich trigger phrasing ("Use when the user wants…, mentions…, asks for…") so auto-invocation fires. The test for whether a skill should stay model-invoked: _could the model usefully reach for this autonomously?_ (Reuse is the reason to extract a skill, not the test.)

Because a user-invoked skill is excluded from automatic model reach, nothing but the human can fire it — no other skill can. So a user-invoked skill may invoke model-invoked skills, but it can never reach another user-invoked skill.

Every skill also carries an `agents/openai.yaml` beside its `SKILL.md` (Codex UI metadata). Keep that in sync with frontmatter: a skill is user-invoked in both harnesses or neither.

Bucket `README.md`s and the top-level `README.md` group entries into **User-invoked** and **Model-invoked**.

## Dependencies between them

Dependencies are expressed as **`/skill`-style prose invocation** ("Run the `/grilling` skill"), not deep `../other-skill/FILE.md` cross-references. Shared reference docs live inside the skill that owns them; other skills reach that material by invoking the skill, not by linking across folders.

## Passive vs active domain work

Merely _reading_ `CONTEXT.md` for vocabulary is a one-line prose pointer, not the `domain-modeling` skill. Only the active build/sharpen discipline (challenge terms, edge-case scenarios, write ADRs, update `CONTEXT.md` inline) is `domain-modeling`.
