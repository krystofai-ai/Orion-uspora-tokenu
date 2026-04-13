# Orion Mode — Token-Saving Claude Skill

> why use many token when few token do trick

**~75% fewer output tokens. Same technical accuracy.**

Orion mode makes Claude respond with maximum efficiency — no filler, no fluff, pure substance. Save money on API costs, get faster responses, stay focused.

## Install

```bash
bash <(curl -s https://raw.githubusercontent.com/krystofai/orion/main/hooks/install.sh)
```

Or clone and run locally:

```bash
git clone https://github.com/krystofai/orion
bash orion/hooks/install.sh
```

## Usage

| Command | Effect |
|---------|--------|
| `/orion` | Activate (full mode, default) |
| `/orion lite` | Professional but concise |
| `/orion ultra` | Maximum compression |
| `stop orion` | Deactivate |
| `normal mode` | Deactivate |

## Modes

**Lite** — drops filler, keeps articles and full sentences. Professional tone.

**Full** (default) — drops articles, uses fragments, shorter synonyms. ~65% token reduction.

**Ultra** — abbreviations, arrows for causality, bullets only. ~80% token reduction.

## Benchmarks

| Task | Normal | Orion Full | Saved |
|------|--------|------------|-------|
| Code explanation | 312 tokens | 89 tokens | 71% |
| Bug fix | 198 tokens | 67 tokens | 66% |
| Architecture review | 445 tokens | 134 tokens | 70% |

## How It Works

Orion installs two Claude Code hooks:
- **SessionStart** — loads orion rules at the start of every session
- **UserPromptSubmit** — tracks when you activate/deactivate orion mode

Rules are stored in `SKILL.md` and loaded dynamically based on intensity level.

## Safety

Orion auto-suspends for:
- Security warnings
- Irreversible action confirmations
- Multi-step sequences where fragments could cause misunderstanding

Code blocks and commits always use standard formatting — orion never affects actual code.

## Requirements

- [Claude Code](https://claude.ai/code)
- Node.js

## License

MIT — by [@krystof_ai](https://instagram.com/krystof_ai)
