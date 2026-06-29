#!/usr/bin/env bash
set -euo pipefail

FORK_MD="skills/FORK.md"
REPOSITORY="${REPOSITORY:?REPOSITORY is required}"

if [[ ! -f "$FORK_MD" ]]; then
  echo "::error::Missing $FORK_MD"
  exit 1
fi

LAST_SYNCED="$(
  grep -E 'Last synced upstream commit:' "$FORK_MD" \
    | sed -E 's/.*Last synced upstream commit:\*\* ([a-f0-9]+).*/\1/'
)"
if [[ -z "$LAST_SYNCED" ]]; then
  echo "::error::Could not parse last synced commit from $FORK_MD"
  exit 1
fi

UPSTREAM_SHA="$(gh api repos/mattpocock/skills/commits/main --jq .sha)"
COMPARE_JSON="$(gh api "repos/mattpocock/skills/compare/${LAST_SYNCED}...main")"
AHEAD_BY="$(echo "$COMPARE_JSON" | jq -r '.ahead_by')"
COMPARE_URL="$(echo "$COMPARE_JSON" | jq -r '.html_url')"

echo "Last synced: $LAST_SYNCED"
echo "Upstream main: $UPSTREAM_SHA"
echo "Commits ahead: $AHEAD_BY"

if [[ "$AHEAD_BY" -eq 0 ]]; then
  echo "Fork is up to date with upstream."
  exit 0
fi

COMMITS="$(
  echo "$COMPARE_JSON" \
    | jq -r '.commits[] | "- [\(.sha[0:7])](\(.html_url)) \(.commit.message | split("\n")[0])"' \
    | head -20
)"

MORE_COMMITS=""
if [[ "$AHEAD_BY" -gt 20 ]]; then
  MORE_COMMITS="_…and $((AHEAD_BY - 20)) more. See [compare view](${COMPARE_URL})._"
fi

TITLE="Upstream mattpocock/skills has new commits — sync this fork"
ISSUE_MARKER="<!-- check-upstream-skills -->"

BODY_FILE="$(mktemp)"
trap 'rm -f "$BODY_FILE"' EXIT

cat >"$BODY_FILE" <<EOF
${ISSUE_MARKER}

## Upstream update available

[mattpocock/skills](https://github.com/mattpocock/skills) has **${AHEAD_BY}** new commit(s) since this fork was last synced.

| | SHA |
|---|---|
| Last synced (this fork) | \`${LAST_SYNCED}\` |
| Upstream \`main\` | \`${UPSTREAM_SHA:0:7}\` |

### Recent upstream commits

${COMMITS}

${MORE_COMMITS}

### What to do

1. Open this repo in Cursor (workspace root = this fork).
2. Invoke **@sync-matt-pocock-skills-cursor** to merge upstream into the \`skills/\` subtree and re-apply [FORK-DELTA.md](skills/FORK-DELTA.md) invariants.
3. Reload Cursor after syncing.

Tracked in [skills/FORK.md](skills/FORK.md). Opened by [check-upstream-skills](.github/workflows/check-upstream-skills.yml).
EOF

EXISTING="$(
  gh issue list \
    --repo "$REPOSITORY" \
    --state open \
    --search "in:title \"Upstream mattpocock/skills has new commits\"" \
    --json number \
    --jq '.[0].number // empty'
)"

if [[ -n "$EXISTING" ]]; then
  COMMENT_FILE="$(mktemp)"
  trap 'rm -f "$BODY_FILE" "$COMMENT_FILE"' EXIT
  cat >"$COMMENT_FILE" <<EOF
${ISSUE_MARKER}

Still **${AHEAD_BY}** commit(s) behind upstream (\`${UPSTREAM_SHA:0:7}\`). Last synced: \`${LAST_SYNCED}\`.

[Compare upstream changes](${COMPARE_URL})
EOF
  gh issue comment "$EXISTING" --repo "$REPOSITORY" --body-file "$COMMENT_FILE"
  echo "Commented on existing issue #${EXISTING}"
else
  gh issue create --repo "$REPOSITORY" --title "$TITLE" --body-file "$BODY_FILE"
  echo "Created new issue"
fi
