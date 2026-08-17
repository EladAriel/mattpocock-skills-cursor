## What it does

`eli12` turns on a persistent explanation style for the current conversation: short sentences, concrete examples, and simple grammar, while keeping real engineering terminology and technical accuracy.

The defining constraint is that simple language must not become simplified engineering. The agent still names the real concepts, preserves causal chains and trade-offs, and defines unfamiliar terms when they first appear.

## When to reach for it

You invoke this by typing `/eli12` — the agent won't reach for it on its own. Invoke it once when you want the rest of the conversation explained at roughly a 12-year-old reading level, with a blunt, caveman-clear rhythm.

The mode survives topic changes and other skills. Say `stop eli12` or ask for the normal tone when you want to leave it.

## Caveman-clear, not technically shallow

**Caveman-clear** means one concrete idea at a time:

- Name the real component, protocol, failure mode, or trade-off.
- Define an unfamiliar term in plain words on first use.
- Explain what happens, why it happens, and what it costs.
- Keep edge cases, uncertainty, and safety warnings visible.

The result should sound simple without replacing engineering terms with childish nicknames or removing the details that make the answer correct.

## Common questions

**Does it carry into a new conversation?**

No. The active style lives only in the current conversation. Invoke `/eli12` again in a new one.

**Does it remove jargon?**

It removes unexplained jargon, not the vocabulary itself. Real engineering terms stay because learning the correct noun makes later explanations easier. The first use gets a plain-language definition.

## It's working if

- You can follow the explanation without already knowing the topic.
- Real engineering terms appear with short definitions.
- Each answer still explains causes, trade-offs, and important edge cases.
- The style remains active on later turns without another invocation.
- A clear stop request returns the agent to its normal tone.

## Where it fits

`eli12` is a reach-for-it-anytime standalone style layer. It changes how every later response is explained, including responses produced while another skill is active. Use [wait-what](https://aihero.dev/skills-wait-what) instead when only the last message needs a clearer re-pitch, and use [ask-matt](https://aihero.dev/skills-ask-matt) when you need the map of the full skill set.
