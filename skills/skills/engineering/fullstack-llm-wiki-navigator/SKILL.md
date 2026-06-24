---
name: fullstack-llm-wiki-navigator
description: Use when answering framework or library questions from a local fullstack-llm-wiki Markdown documentation tree in any AI IDE.
---

# Fullstack LLM Wiki Navigator

Use the local Fullstack LLM Wiki files as the primary documentation source for framework questions.

## Auto-Use Triggers

Use this skill automatically when the user asks about a framework or library covered by this wiki, even if they do not explicitly name the skill.

Also use this skill when the user asks to "search in the llm wiki", "look in the llm wiki", "search the local wiki", or uses similar wording for a framework/library topic.

## Locate The Wiki

1. If `frameworks/index.md` exists in the current repo root, use the current repo root as the wiki root.
2. Otherwise, if `fullstack-llm-wiki/frameworks/index.md` exists, use `fullstack-llm-wiki/` as the wiki root.
3. If neither path exists, say the local wiki is not available. Tell the user to clone it:

```bash
git clone https://github.com/EladAriel/fullstack-llm-wiki.git fullstack-llm-wiki
```

Or run `setup-matt-pocock-skills` and opt in to the Fullstack LLM Wiki (Section F).

## Workflow

1. Identify the framework wiki directory.
   - Use `frameworks/index.md` to choose the category and framework.
   - AI examples: LangChain uses `frameworks/ai/langchain/`, LangGraph uses `frameworks/ai/langgraph/`, Langfuse uses `frameworks/ai/langfuse/`, Model Context Protocol uses `frameworks/ai/modelcontextprotocol/`, and Ragas uses `frameworks/ai/ragas/`.
   - Other examples: FastAPI uses `frameworks/backend/fastapi/`, React uses `frameworks/ui/react/`, and SQLAlchemy uses `frameworks/db/sqlalchemy/`.
2. Open the framework root index first.
   - For Model Context Protocol, read `frameworks/ai/modelcontextprotocol/index.md` from the wiki root.
   - For FastAPI, read `frameworks/backend/fastapi/index.md` from the wiki root.
3. Read the status metadata.
   - Note source repo, branch, docs path, source commit, source commit date, and generated time.
4. Use the root index to choose the closest content area.
5. Open the nearest directory-level `index.md`.
6. Open the most specific content page listed by that directory index.
7. Prefer the local wiki over general model knowledge.
8. Mention source path, commit date, or staleness when freshness matters.

## Navigation Rules

- Treat `index.md` files as navigation files unless the file is named `_source_index.md`.
- Treat `_source_index.md` as original copied documentation content.
- Do not skip directory indexes for broad topics; they are the map for child pages.
- If multiple pages may apply, read the directory index first, then the most specific pages.
- If the wiki does not cover the question, say so before using general knowledge.

## Prompt Invocation

The user can directly request a wiki lookup with natural language:

```text
Search in the llm wiki about FastAPI dependency injection.
```

```text
Look in the llm wiki for React server components.
```

```text
Search the llm wiki for LangChain tool calling.
```

```text
Look in the llm wiki for Model Context Protocol transports.
```

```text
Search the local wiki for Ragas evaluation metrics.
```

```text
Search the llm wiki for SQLAlchemy relationships.
```
