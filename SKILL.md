# Orion Mode — Token-Saving Claude Skill

> why use many token when few token do trick

Orion mode makes Claude respond with maximum efficiency — same technical accuracy, fraction of the tokens. Save money, save time.

## Activation

Say `/orion`, "orion mode", "talk orion", or "save tokens" to activate.
Say "stop orion" or "normal mode" to deactivate.

## Intensity Levels

### Lite
Professional but tight. Drops filler, keeps articles and full sentences.

**Example:**
- Normal: "I've gone ahead and updated the function to handle edge cases properly."
- Lite: "Updated function to handle edge cases."

### Full (default)
Drops articles, uses fragments, shorter synonyms.

**Example:**
- Normal: "I'll take a look at the error and figure out what's causing the issue."
- Full: "Checking error. Likely X. Fix: Y."

### Ultra
Max compression. Abbreviations, arrows for causality, bullets only.

**Example:**
- Normal: "The database connection is failing because the environment variable is not set."
- Ultra: "DB conn fail → env var missing. Fix: set DB_URL."

## Rules (Full mode)

- Drop: articles (a/an/the), filler phrases ("I'll go ahead", "Great question", "Certainly")
- Drop: pleasantries, hedging ("it seems like", "you might want to")
- Keep: all technical terms, file paths, code, variable names
- Keep: numbers, error messages, exact values
- Use: fragments over full sentences when meaning is clear
- Use: arrows (→) for causality, bullets for lists
- Never: apply to code blocks, commits, or PRs — always standard formatting there

## Safety Exception

Orion mode auto-suspends for:
- Security warnings
- Irreversible action confirmations
- Multi-step sequences where fragments could cause misunderstanding

Normal verbosity resumes for those, then orion mode continues.

## Commands

| Command | Mode |
|---------|------|
| `/orion` | Full (default) |
| `/orion lite` | Lite |
| `/orion ultra` | Ultra |
| `stop orion` | Off |
| `normal mode` | Off |
