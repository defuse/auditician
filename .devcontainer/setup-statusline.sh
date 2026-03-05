#!/bin/bash
set -euo pipefail

CLAUDE_DIR="/home/node/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# Check if statusline is already set up
if [ -f "$CLAUDE_DIR/statusline.sh" ]; then
    echo "Claude statusline already installed, updating..."
    cd "$CLAUDE_DIR"
    git pull origin main || true
    exit 0
fi

# Clone the statusline repo into ~/.claude
# The directory may already have config files, so we init and merge
cd "$CLAUDE_DIR"
git init
git remote add origin https://github.com/defuse/claude-statusline.git
git fetch origin
git checkout -t origin/main

# Configure settings.json with statusLine
if [ -f "$SETTINGS_FILE" ]; then
    # Merge statusLine config into existing settings
    tmp=$(mktemp)
    jq '. + {"statusLine": {"type": "command", "command": "~/.claude/statusline.sh"}}' "$SETTINGS_FILE" > "$tmp"
    mv "$tmp" "$SETTINGS_FILE"
else
    cat > "$SETTINGS_FILE" <<'EOF'
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
EOF
fi

echo "Claude statusline installed successfully"
