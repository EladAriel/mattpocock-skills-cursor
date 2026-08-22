## What it does

`eli12` is the default explanation style for every talk and session: plain words and short sentences, like talking to a 12-year-old, while keeping real engineering terminology and technical accuracy.

The defining constraint is that simple language must not become simplified engineering. The agent still names the real concepts, preserves causal chains and trade-offs, and defines unfamiliar terms when they first appear. It does not use metaphors, analogies, or cute nicknames for technical things.

## When to reach for it

ELI12 is **always on** when `.cursor/rules/eli12.mdc` is installed (`alwaysApply: true`). The `setup-matt-pocock-skills` seed installs it by default. You do not need to type `/eli12` each session.

Say `stop eli12` or ask for the normal tone when you want to opt out for the rest of the current conversation. Type `/eli12` to re-read the style definition or reinforce it if the rule is not installed.

## Simple words, not technically shallow

**Simple words** means one idea at a time:

- Name the real component, protocol, failure mode, or trade-off.
- Define an unfamiliar term in plain words on first use.
- Explain what happens, why it happens, and what it costs.
- Keep edge cases, uncertainty, and safety warnings visible.
- Do not use metaphors, analogies, or story comparisons.
- Do not replace engineering terms with childish nicknames.

The result should sound simple without removing the details that make the answer correct.

## Common questions

**Does it carry into a new conversation?**

Yes, when the `eli12.mdc` rule is installed. Every new session loads it automatically. Without the rule, invoke `/eli12` once per conversation.

**Does it remove jargon?**

It removes unexplained jargon, not the vocabulary itself. Real engineering terms stay because learning the correct noun makes later explanations easier. The first use gets a plain-language definition.

## It's working if

- You can follow the explanation without already knowing the topic.
- Real engineering terms appear with short definitions.
- Each answer still explains causes, trade-offs, and important edge cases.
- Explanations use plain words without metaphors or analogies.
- A clear stop request returns the agent to its normal tone for that conversation.

## Where it fits

`eli12` is the default style layer for every response. It applies across topics and other skills. Use [wait-what](https://aihero.dev/skills-wait-what) instead when only the last message needs a clearer re-pitch, and use [ask-matt](https://aihero.dev/skills-ask-matt) when you need the map of the full skill set.
