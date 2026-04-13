#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const FLAG_FILE = path.join(os.homedir(), '.claude', '.orion-active');
const SKILL_PATH = path.join(__dirname, '..', 'SKILL.md');

const { getDefaultMode } = require('./orion-config');

const FALLBACK_RULES = {
  full: `You are in Orion mode (full). Respond with maximum token efficiency.
- Drop articles, filler phrases, pleasantries, hedging
- Use fragments when meaning is clear
- Use arrows (→) for causality, bullets for lists
- Keep all technical terms, code, file paths, numbers exact
- Never apply to code blocks or commits — always standard formatting there
- Auto-suspend for security warnings and irreversible action confirmations`,
  lite: `You are in Orion mode (lite). Respond concisely but professionally.
- Drop filler phrases and pleasantries
- Keep articles and full sentences
- No hedging or padding`,
  ultra: `You are in Orion mode (ultra). Maximum compression.
- Abbreviations where unambiguous (DB, auth, config, env)
- Arrows for causality (→)
- Bullets only, no prose
- All technical substance preserved`
};

function getActiveMode() {
  try {
    return fs.readFileSync(FLAG_FILE, 'utf8').trim();
  } catch (e) {
    return getDefaultMode();
  }
}

function writeFlag(mode) {
  try {
    fs.mkdirSync(path.dirname(FLAG_FILE), { recursive: true });
    if (mode === 'off') {
      try { fs.unlinkSync(FLAG_FILE); } catch (e) {}
    } else {
      fs.writeFileSync(FLAG_FILE, mode, 'utf8');
    }
  } catch (e) {}
}

function getRules(mode) {
  if (mode === 'off') return null;
  try {
    const skill = fs.readFileSync(SKILL_PATH, 'utf8');
    // Extract rules section for the active mode
    return skill;
  } catch (e) {
    return FALLBACK_RULES[mode] || FALLBACK_RULES.full;
  }
}

const mode = getActiveMode();
writeFlag(mode);

if (mode && mode !== 'off') {
  const rules = getRules(mode);
  if (rules) {
    process.stdout.write(rules + '\n\nOrion mode active: ' + mode + '. Respond with token efficiency. Say "stop orion" to deactivate.\n');
  }
}
