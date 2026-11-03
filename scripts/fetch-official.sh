#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$ROOT/references/official"
BASE="https://raw.githubusercontent.com/MiniMax-AI/MiniMax-H3/main/skills/h3-prompt-writing"

cat <<'EOF'
This script downloads the official MiniMax H3 prompt-writing documents:

  - SKILL.md
  - references/base-en.txt
  - references/ref-en.txt

They are governed by the MiniMax H3 Community License Agreement:
https://huggingface.co/MiniMaxAI/MiniMax-H3/blob/main/LICENSE

The license grants rights only within the "Applicable Territory":
worldwide excluding the European Union, the United Kingdom,
the Republic of Korea and the United States of America.

By continuing, you confirm that you are in the Applicable Territory and
that you accept the license terms. The downloaded files are for your own
use with this skill and are not redistributed by this repository.

EOF

printf "Type 'yes' to continue: "
read -r answer
if [ "$answer" != "yes" ]; then
  echo "Aborted."
  exit 1
fi

mkdir -p "$DEST"

echo "Fetching..."
curl -fsSL "$BASE/SKILL.md" -o "$DEST/official-skill.md"
curl -fsSL "$BASE/references/base-en.txt" -o "$DEST/base-en.txt"
curl -fsSL "$BASE/references/ref-en.txt" -o "$DEST/ref-en.txt"

echo
echo "Done. Files in $DEST:"
ls -1 "$DEST"
