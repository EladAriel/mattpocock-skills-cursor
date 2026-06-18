#!/usr/bin/env bash
set -euo pipefail

# Links all skills in the repository to a Cursor skills directory.
#
# Usage:
#   ./scripts/link-skills-cursor.sh            # global → ~/.cursor/skills/
#   ./scripts/link-skills-cursor.sh --project  # project → .cursor/skills/ (cwd)

REPO="$(cd "$(dirname "$0")/.." && pwd)"

PROJECT=false
for arg in "$@"; do
  case "$arg" in
    --project) PROJECT=true ;;
    -h|--help)
      echo "Usage: $0 [--project]"
      echo "  (default)  Link skills to ~/.cursor/skills/"
      echo "  --project  Link skills to .cursor/skills/ in the current directory"
      exit 0
      ;;
    *)
      echo "error: unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

if [ "$PROJECT" = true ]; then
  DEST="$(pwd)/.cursor/skills"
else
  DEST="$HOME/.cursor/skills"
fi

# If the destination is a symlink that resolves into this repo, we'd end up
# writing the per-skill symlinks back into the repo's own skills/ tree. Detect
# and bail out instead of polluting the working copy.
if [ -L "$DEST" ]; then
  resolved="$(readlink -f "$DEST")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "error: $DEST is a symlink into this repo ($resolved)." >&2
      echo "Remove it (rm \"$DEST\") and re-run; the script will recreate it as a real dir." >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$DEST"

find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -print0 |
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    rm -rf "$target"
  fi

  ln -sfn "$src" "$target"
  echo "linked $name -> $src"
done

echo ""
echo "Done. Skills linked to $DEST"
echo "Reload Cursor (Cmd/Ctrl+Shift+P → Developer: Reload Window) to pick up changes."
