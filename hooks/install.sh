#!/bin/bash
set -e

REPO="https://raw.githubusercontent.com/krystofai-ai/Orion-uspora-tokenu/main"
HOOK_DIR="$HOME/.claude/hooks"
SETTINGS="$HOME/.claude/settings.json"

echo "⚡ Instaluji Orion mode..."

# Kontrola Node.js
if ! command -v node &>/dev/null; then
  echo "Chyba: Node.js je potřeba. Stáhni na https://nodejs.org" >&2
  exit 1
fi

# Kontrola curl
if ! command -v curl &>/dev/null; then
  echo "Chyba: curl je potřeba." >&2
  exit 1
fi

# Vytvoření složky pro hooky
mkdir -p "$HOOK_DIR"

# Stažení hook souborů z GitHubu
echo "  Stahuji soubory..."
curl -fsSL "$REPO/hooks/orion-config.js"       -o "$HOOK_DIR/orion-config.js"
curl -fsSL "$REPO/hooks/orion-sessionstart.js"  -o "$HOOK_DIR/orion-sessionstart.js"
curl -fsSL "$REPO/hooks/orion-mode-tracker.js"  -o "$HOOK_DIR/orion-mode-tracker.js"
curl -fsSL "$REPO/hooks/orion-statusline.sh"    -o "$HOOK_DIR/orion-statusline.sh"
chmod +x "$HOOK_DIR/orion-statusline.sh"

# Instalace jako Claude Code skill (slash command)
SKILL_DIR="$HOME/.claude/skills/orion"
mkdir -p "$SKILL_DIR"
curl -fsSL "$REPO/SKILL.md" -o "$SKILL_DIR/SKILL.md"

echo "  Soubory nainstalovány."

# Záloha settings.json
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "$SETTINGS.orion-backup"
fi

# Zapojení hooků do settings.json
node - "$HOOK_DIR" "$SETTINGS" <<'NODEJS'
const fs = require('fs');
const os = require('os');
const hookDir = process.argv[2];
const settingsPath = process.argv[3];

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

fs.mkdirSync(require('path').dirname(settingsPath), { recursive: true });
fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2));
console.log('  Hooky zaregistrovány v settings.json.');
NODEJS

echo ""
echo "✅ Orion mode nainstalován!"
echo ""
echo "Použití:"
echo "  /orion        — aktivace (full režim, ~65 % méně tokenů)"
echo "  /orion lite   — lite režim"
echo "  /orion ultra  — ultra komprese (~80 % méně tokenů)"
echo "  zastav orion  — deaktivace"
echo ""
echo "Restartuj Claude Code pro aktivaci."
