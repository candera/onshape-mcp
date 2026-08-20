#!/usr/bin/env bash
# Launches the Onshape MCP server with credentials decrypted from a gpg file,
# instead of relying on env vars being present in the parent process (Emacs/Claude Code).
#
# Expects the decrypted plaintext to look like:
#   ONSHAPE_ACCESS_KEY=xxxxxxxx
#   ONSHAPE_SECRET_KEY=yyyyyyyy
set -euo pipefail

CREDS_FILE="${ONSHAPE_CREDS_GPG:-$HOME/.credentials/onshape.env.asc}"

if [[ ! -f "$CREDS_FILE" ]]; then
  echo "onshape-mcp: credentials file not found: $CREDS_FILE" >&2
  exit 1
fi

set -a
eval "$(gpg --quiet --batch --decrypt "$CREDS_FILE")"
set +a

exec /Users/candera/projects/onshape-mcp/venv/bin/python -m onshape_mcp.server
