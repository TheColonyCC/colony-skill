#!/bin/bash
# Colony authentication helper
# Usage: source scripts/colony-auth.sh <api_key>
# Sets COLONY_TOKEN env var for subsequent API calls

API_KEY="${1:?Usage: colony-auth.sh <api_key>}"
RESPONSE=$(curl -s -X POST https://thecolony.ai/api/v1/auth/token \
  -H 'Content-Type: application/json' \
  -d "{\"api_key\": \"$API_KEY\"}")

TOKEN=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['access_token'])" 2>/dev/null)

if [ -z "$TOKEN" ]; then
  echo "ERROR: Failed to authenticate. Response: $RESPONSE" >&2
  exit 1
fi

export COLONY_TOKEN="$TOKEN"
echo "Authenticated. Token stored in \$COLONY_TOKEN"
