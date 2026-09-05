## What it does

`brief-me` turns one topic into a fixed four-section brief: Understand it, See it, Practical Example, Practical Tips. The topic can be a concept, or an overloaded action list from planning or implementation (tickets, decision maps, step piles).

It does not open a teaching workspace, and it does not re-pitch the last message. It is a one-shot scan so you can decide the next move while the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) is producing a lot of output. The defining constraint is the fixed shape: exactly those four headings, with **See it** limited to comparison tables or Mermaid/conceptual diagrams — no metaphors — so it stays compatible with [eli12](https://aihero.dev/skills-eli12).

## When to reach for it

You invoke this by typing `/brief-me` (or attaching `@brief-me`); the agent won't reach for it on its own.

| What you want | What to reach for |
| --- | --- |
| A concept or ticket pile explained in a fixed, scannable shape | `brief-me` |
| The last message re-pitched because it didn't land | [wait-what](https://aihero.dev/skills-wait-what) |
| A multi-session course with lessons and retention | [teach](https://aihero.dev/skills-teach) |
| To sharpen an undecided plan by interview | [grill-me](https://aihero.dev/skills-grill-me) / [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |

Reach for it mid-flow: after `/to-tickets` dumped a long pickup order, during `/wayfinder` when the decision map is dense, or mid-`/implement` when a seam or term is blocking you.

## The four beats

The leading word is **brief**. Four beats, always the same order:

1. **Understand it** — core idea, why it exists, main trade-off
2. **See it** — table or diagram (structure you can act on for an action pile)
3. **Practical Example** — one real scenario, preferably from this repo or thread
4. **Practical Tips** — pitfalls, and one next move for this session

That last beat is the point of the skill in this workflow: after a pile of LLM actions, you walk away knowing what to do next, not only what the pile meant.

## Common questions

**How is this different from wait-what?**
`wait-what` repairs one message that already failed. `brief-me` is proactive: you name a topic or point at a pile, and get a structured brief even when nothing "went wrong."

**How is this different from teach?**
`teach` is stateful and multi-session. `brief-me` writes nothing by default and finishes in one reply.

**Can See it use an analogy?**
No. This fork keeps [eli12](https://aihero.dev/skills-eli12) as the default explanation style. See it uses tables and diagrams only.

## It's working if

- The reply has exactly four sections with those headings, and nothing before the first.
- See it is a table or diagram, not a metaphor.
- For an action pile, See it shows pickup order or blocking edges you can use.
- Practical Tips ends with one concrete next move for this session.
- You can skim the brief and choose a ticket, decision, or skill without re-reading the whole pile.

## Where it fits

`brief-me` is a **reach-for-it-anytime standalone**. It plugs into the main flow wherever output volume outruns comprehension: after [to-tickets](https://aihero.dev/skills-to-tickets), inside [wayfinder](https://aihero.dev/skills-wayfinder), or mid-[implement](https://aihero.dev/skills-implement). Its neighbours are [wait-what](https://aihero.dev/skills-wait-what) (re-pitch) and [teach](https://aihero.dev/skills-teach) (course). When you are not sure which skill fits, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
