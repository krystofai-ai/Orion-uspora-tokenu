#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const VALID_MODES = ['off', 'lite', 'full', 'ultra', 'commit', 'review', 'compress'];

function getConfigDir() {
  if (process.env.XDG_CONFIG_HOME) return path.join(process.env.XDG_CONFIG_HOME, 'orion');
  if (process.platform === 'win32') return path.join(process.env.APPDATA || os.homedir(), 'orion');
  return path.join(os.homedir(), '.config', 'orion');
}

function getConfigPath() {
  return path.join(getConfigDir(), 'config.json');
}

function getDefaultMode() {
  if (process.env.ORION_DEFAULT_MODE && VALID_MODES.includes(process.env.ORION_DEFAULT_MODE)) {
    return process.env.ORION_DEFAULT_MODE;
  }
  try {
    const raw = fs.readFileSync(getConfigPath(), 'utf8');
    const config = JSON.parse(raw);
    if (config.defaultMode && VALID_MODES.includes(config.defaultMode)) {
      return config.defaultMode;
    }
  } catch (e) {}
  return 'full';
}

module.exports = { getDefaultMode, getConfigDir, getConfigPath, VALID_MODES };
