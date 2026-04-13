#!/bin/bash
set -e

HOOK_DIR="$HOME/.claude/hooks"
SETTINGS="$HOME/.claude/settings.json"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS_SRC="$REPO_DIR/hooks"

echo "⚡ Installing Orion mode..."

# Check for Node.js
if ! command -v node &>/dev/null; then
  echo "Error: Node.js is required. Install from https://nodejs.org" >&2
  exit 1
fi

# Create hooks dir
mkdir -p "$HOOK_DIR"

# Copy hook files
cp "$HOOKS_SRC/orion-config.js"       "$HOOK_DIR/orion-config.js"
cp "$HOOKS_SRC/orion-sessionstart.js" "$HOOK_DIR/orion-sessionstart.js"
cp "$HOOKS_SRC/orion-mode-tracker.js" "$HOOK_DIR/orion-mode-tracker.js"
cp "$HOOKS_SRC/orion-statusline.sh"   "$HOOK_DIR/orion-statusline.sh"
chmod +x "$HOOK_DIR/orion-statusline.sh"

echo "  Hook files installed."

# Backup settings.json
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "$SETTINGS.orion-backup"
fi

# Wire hooks into settings.json using Node.js
node - "$SETTINGS" <<'NODEJS'
const fs = require('fs');
const os = require('os');
const settingsPath = process.argv[1];
const hookDir = `${os.homedir()}/.claude/hooks`;

let settings = {};
try { settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8')); } catch(e) {}

if (!settings.hooks) settings.hooks = {};

// SessionStart hook
if (!settings.hooks.SessionStart) settings.hooks.SessionStart = [];
const sessionHook = { matcher: '', hooks: [{ type: 'command', command: `node "${hookDir}/orion-sessionstart.js"` }] };
const hasSession = settings.hooks.SessionStart.some(h => h.hooks && h.hooks.some(hh => hh.command && hh.command.includes('orion-sessionstart')));
if (!hasSession) settings.hooks.SessionStart.push(sessionHook);

// UserPromptSubmit hook
if (!settings.hooks.UserPromptSubmit) settings.hooks.UserPromptSubmit = [];
const promptHook = { matcher: '', hooks: [{ type: 'command', command: `node "${hookDir}/orion-mode-tracker.js"` }] };
const hasPrompt = settings.hooks.UserPromptSubmit.some(h => h.hooks && h.hooks.some(hh => hh.command && hh.command.includes('orion-mode-tracker')));
if (!hasPrompt) settings.hooks.UserPromptSubmit.push(promptHook);

fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2));
console.log('  Hooks registered in settings.json.');
NODEJS

echo ""
echo "✅ Orion mode installed!"
echo ""
echo "Usage:"
echo "  /orion        — activate (full mode)"
echo "  /orion lite   — lite mode"
echo "  /orion ultra  — ultra compression"
echo "  stop orion    — deactivate"
echo ""
echo "~75% fewer output tokens. Same accuracy."
