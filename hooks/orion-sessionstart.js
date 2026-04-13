#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const FLAG_FILE = path.join(os.homedir(), '.claude', '.orion-active');
const SKILL_PATH = path.join(__dirname, '..', 'SKILL.md');

const { getDefaultMode } = require('./orion-config');

const FALLBACK_RULES = {
  full: `Jsi v Orion mode (full). Odpovídej s maximální úsporou tokenů.
- Odstraň výplňová slova, zbytečné fráze, zdvořilosti, zajišťovací výrazy
- Používej fragmenty vět pokud je smysl jasný
- Používej šipky (→) pro příčinnost, odrážky pro seznamy
- Zachovej všechny technické termíny, kód, cesty k souborům, čísla přesně
- Nikdy neaplikuj na bloky kódu nebo commity — vždy standardní formátování
- Automaticky pozastav pro bezpečnostní varování a nevratné akce`,
  lite: `Jsi v Orion mode (lite). Odpovídej stručně, ale profesionálně.
- Odstraň výplňová slova a zdvořilosti
- Zachovej celé věty
- Žádné zajišťovací výrazy nebo zbytečné výplně`,
  ultra: `Jsi v Orion mode (ultra). Maximální komprese.
- Zkratky kde je to jednoznačné (DB, auth, config, env)
- Šipky pro příčinnost (→)
- Jen odrážky, žádná próza
- Veškerá technická podstata zachována`
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
    process.stdout.write(rules + '\n\nOrion mode aktivní: ' + mode + '. Odpovídej s úsporou tokenů. Řekni "zastav orion" pro deaktivaci.\n');
  }
}
