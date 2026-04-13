#!/bin/bash
set -e

REPO="https://raw.githubusercontent.com/krystofai-ai/Orion-uspora-tokenu/main"
HOOK_DIR="$HOME/.claude/hooks"
SETTINGS="$HOME/.claude/settings.json"

echo "⚡ Installing Orion mode..."

# Check for Node.js
if ! command -v node &>/dev/null; then
  echo "Error: Node.js is required. Install from https://nodejs.org" >&2
  exit 1
fi

# Check for curl
if ! command -v curl &>/dev/null; then
  echo "Error: curl is required." >&2
  exit 1
fi

# Create hooks dir
mkdir -p "$HOOK_DIR"

# Download hook files from GitHub
echo "  Downloading hook files..."
curl -fsSL "$REPO/hooks/orion-config.js"       -o "$HOOK_DIR/orion-config.js"
curl -fsSL "$REPO/hooks/orion-sessionstart.js"  -o "$HOOK_DIR/orion-sessionstart.js"
curl -fsSL "$REPO/hooks/orion-mode-tracker.js"  -o "$HOOK_DIR/orion-mode-tracker.js"
curl -fsSL "$REPO/hooks/orion-statusline.sh"    -o "$HOOK_DIR/orion-statusline.sh"
chmod +x "$HOOK_DIR/orion-statusline.sh"

echo "  Hook files installed."

# Backup settings.json
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "$SETTINGS.orion-backup"
fi

# Wire hooks into settings.json
node - "$HOOK_DIR" "$SETTINGS" <<'NODEJS'
const fs = require('fs');
const os = require('os');
const hookDir = process.argv[1];
const settingsPath = process.argv[2];

let settings = {};
try { settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8')); } catch(e) {}

if (!settings.hooks) settings.hooks = {};

// SessionStart hook
if (!settings.hooks.SessionStart) settings.hooks.SessionStart = [];
const hasSession = settings.hooks.SessionStart.some(h =>
  h.hooks && h.hooks.some(hh => hh.command && hh.command.includes('orion-sessionstart'))
);
if (!hasSession) {
  settings.hooks.SessionStart.push({
    matcher: '',
    hooks: [{ type: 'command', command: `node "${hookDir}/orion-sessionstart.js"` }]
  });
}

// UserPromptSubmit hook
if (!settings.hooks.UserPromptSubmit) settings.hooks.UserPromptSubmit = [];
const hasPrompt = settings.hooks.UserPromptSubmit.some(h =>
  h.hooks && h.hooks.some(hh => hh.command && hh.command.includes('orion-mode-tracker'))
);
if (!hasPrompt) {
  settings.hooks.UserPromptSubmit.push({
    matcher: '',
    hooks: [{ type: 'command', command: `node "${hookDir}/orion-mode-tracker.js"` }]
  });
}

// Ensure settings file exists
fs.mkdirSync(require('path').dirname(settingsPath), { recursive: true });
fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2));
console.log('  Hooks registered in settings.json.');
NODEJS

echo ""
echo "✅ Orion mode installed!"
echo ""
echo "Usage:"
echo "  /orion        — activate (full mode, ~65% fewer tokens)"
echo "  /orion lite   — lite mode"
echo "  /orion ultra  — ultra compression (~80% fewer tokens)"
echo "  stop orion    — deactivate"
echo ""
echo "Restart Claude Code to activate."
