# WORKFLOW

1. If you have codebase use `/grill-with-docs` and if you don't have use `/grill-me` to create shared language with LLM.
2. When done we invoke the `/to-prd` skill to product PRD (make sure you stay within the same conversation of step 1.)
3. When done we invoke the `/to-issues` skill to break a plan into independently-grabbable issues using vertical slices.
4. Copy the `Suggested pickup order` from step 3. We invoke the `/tdd` skill for test driven development.
5. If the code need refactoring then use `improve-codebase-architecture` skill.