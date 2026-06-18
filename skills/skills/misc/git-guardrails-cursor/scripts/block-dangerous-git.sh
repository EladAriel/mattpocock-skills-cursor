#!/bin/bash

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

DANGEROUS_PATTERNS=(
  "git push"
  "git reset --hard"
  "git clean -fd"
  "git clean -f"
  "git branch -D"
  "git checkout \."
  "git restore \."
  "push --force"
  "reset --hard"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    cat <<EOF
{
  "permission": "deny",
  "user_message": "Blocked dangerous git command: $COMMAND",
  "agent_message": "BLOCKED: '$COMMAND' matches dangerous pattern '$pattern'. The user has prevented you from running this command."
}
EOF
    exit 0
  fi
done

echo '{ "permission": "allow" }'
exit 0
