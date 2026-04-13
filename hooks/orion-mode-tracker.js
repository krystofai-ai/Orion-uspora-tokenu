#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const FLAG_FILE = path.join(os.homedir(), '.claude', '.orion-active');

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

try {
  const input = JSON.parse(fs.readFileSync('/dev/stdin', 'utf8'));
  const prompt = (input.prompt || '').toLowerCase().trim();

  if (prompt.includes('zastav orion') || prompt.includes('normální režim') || prompt.includes('stop orion') || prompt.includes('normal mode')) {
    writeFlag('off');
  } else if (prompt.startsWith('/orion')) {
    const arg = prompt.replace('/orion', '').trim();
    if (arg === 'lite') writeFlag('lite');
    else if (arg === 'ultra') writeFlag('ultra');
    else if (arg === 'off') writeFlag('off');
    else writeFlag('full');
  } else if (prompt.includes('orion mode') || prompt.includes('mluv jako orion') || prompt.includes('šetři tokeny')) {
    writeFlag('full');
  }
} catch (e) {}
