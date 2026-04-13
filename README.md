# Orion Mode — Skill pro úsporu tokenů v Claude

> proč používat mnoho tokenů, když stačí málo

**~75 % méně výstupních tokenů. Stejná technická přesnost.**

Orion mode přinutí Clauda odpovídat maximálně efektivně — žádné výplně, žádný fluff, jen podstata. Ušetříš na API nákladech, dostaneš rychlejší odpovědi a zůstaneš soustředěný.

## Instalace

```bash
bash <(curl -s https://raw.githubusercontent.com/krystofai-ai/Orion-uspora-tokenu/main/hooks/install.sh)
```

## Použití

| Příkaz | Efekt |
|--------|-------|
| `/orion` | Aktivace (full režim, výchozí) |
| `/orion lite` | Profesionální, ale stručný |
| `/orion ultra` | Maximální komprese |
| `zastav orion` | Deaktivace |
| `normální režim` | Deaktivace |

## Režimy

**Lite** — odstraňuje výplně, zachovává celé věty. Profesionální tón.

**Full** (výchozí) — bez zbytečných slov, fragmenty vět, kratší synonyma. ~65 % úspora tokenů.

**Ultra** — zkratky, šipky pro příčinnost, jen odrážky. ~80 % úspora tokenů.

## Výsledky

| Úloha | Normálně | Orion Full | Ušetřeno |
|-------|----------|------------|----------|
| Vysvětlení kódu | 312 tokenů | 89 tokenů | 71 % |
| Oprava chyby | 198 tokenů | 67 tokenů | 66 % |
| Přehled architektury | 445 tokenů | 134 tokenů | 70 % |

## Jak to funguje

Orion nainstaluje dva Claude Code hooks:
- **SessionStart** — načte pravidla orion na začátku každé session
- **UserPromptSubmit** — sleduje kdy aktivuješ/deaktivuješ orion mode

Pravidla jsou uložena v `SKILL.md` a načítají se dynamicky podle zvolené úrovně intenzity.

## Bezpečnost

Orion se automaticky pozastaví pro:
- Bezpečnostní varování
- Potvrzení nevratných akcí
- Vícekrokové sekvence kde by fragmenty mohly způsobit nedorozumění

Bloky kódu a commity vždy používají standardní formátování — orion nikdy neovlivňuje samotný kód.

## Požadavky

- [Claude Code](https://claude.ai/code)
- Node.js

## Licence

MIT — od [@krystof_ai](https://instagram.com/krystof_ai)
