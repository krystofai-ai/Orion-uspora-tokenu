<div align="center">

# ⚡ orion

### proč používat mnoho tokenů když stačí málo

[![hvězdy](https://img.shields.io/github/stars/krystofai-ai/Orion-uspora-tokenu?style=flat-square&color=yellow)](https://github.com/krystofai-ai/Orion-uspora-tokenu/stargazers)
[![poslední commit](https://img.shields.io/github/last-commit/krystofai-ai/Orion-uspora-tokenu?style=flat-square)](https://github.com/krystofai-ai/Orion-uspora-tokenu/commits)
[![licence](https://img.shields.io/badge/licence-MIT-blue?style=flat-square)](LICENSE)

[Před/Po](#předpo) • [Instalace](#instalace) • [Úrovně](#úrovně) • [Jak funguje](#jak-funguje)

</div>

---

Claude Code skill který šetří ~75 % výstupních tokenů tím, že mluví stručně — bez ztráty technické přesnosti.

Místo zdlouhavého vysvětlení dostaneš přímou odpověď: *"Nový ref při každém renderu. Inline object prop = nový ref = re-render. Obal do `useMemo`."*

## Před/Po

| 🐌 Normální Claude (69 tokenů) | ⚡ Orion Claude (19 tokenů) |
|---|---|
| „Důvod proč se tvůj React komponent znovu renderuje je pravděpodobně ten, že vytváříš nový object reference při každém renderu. Když předáváš inline objekt jako prop, React's mělké porovnání ho vidí jako jiný objekt pokaždé, což spustí re-render." | „Nový ref při každém renderu. Inline object prop = nový ref = re-render. Obal do `useMemo`." |

| 🐌 Normální Claude (84 tokenů) | ⚡ Orion Claude (21 tokenů) |
|---|---|
| „Chyba je způsobena tím, že se pokoušíš přistupovat k vlastnosti objektu který je `undefined`. Měl bys přidat kontrolu zda objekt existuje před přístupem k jeho vlastnostem, nebo použít optional chaining operátor." | „obj je undefined. Přidej optional chaining: `obj?.property` nebo zkontroluj zda obj existuje." |

## Instalace

```bash
bash <(curl -s https://raw.githubusercontent.com/krystofai-ai/Orion-uspora-tokenu/main/hooks/install.sh)
```

Nainstaluje 2 Claude Code hooky a zaregistruje je v `settings.json`. Node.js je potřeba.

## Použití

```
/orion          → aktivace (full režim, výchozí)
/orion lite     → profesionální, ale stručný
/orion ultra    → maximální komprese
zastav orion    → deaktivace
normální režim  → deaktivace
```

## Úrovně

### Lite — profesionální a stručný
Odstraňuje výplně, zachovává celé věty a gramatiku.

> „Funkce opravena. Okrajové případy ošetřeny."

### Full — výchozí orion
Zkrácené věty, fragmenty, žádné zbytečnosti.

> „Fce opravena. Edge cases OK."

### Ultra — maximální komprese
Zkratky, šipky pro příčinnost, jen odrážky.

> „fce OK. edge cases → fix. deploy."

## Jak funguje

Orion instaluje dva hooky do Claude Code:

- **SessionStart** — načte pravidla na začátku každé session
- **UserPromptSubmit** — sleduje příkazy `/orion` a deaktivaci

Pravidla jsou uložena v `SKILL.md`. Bez zásahu do kódu, jen čisté hooky.

## Výsledky úspory

| Úloha | Normálně | Orion | Ušetřeno |
|-------|----------|-------|----------|
| Vysvětlení kódu | 312 tokenů | 89 tokenů | **71 %** |
| Oprava chyby | 198 tokenů | 67 tokenů | **66 %** |
| Přehled architektury | 445 tokenů | 134 tokenů | **70 %** |
| Průměr | — | — | **~65 %** |

## Bezpečnost

Orion se automaticky pozastaví pro:
- Bezpečnostní varování
- Potvrzení nevratných akcí
- Složité sekvence kde by fragmenty mohly způsobit nedorozumění

Bloky kódu a commity vždy standardní formátování — orion nikdy neovlivňuje samotný kód.

## Požadavky

- [Claude Code](https://claude.ai/code)
- Node.js

## Licence

MIT — od [@krystof_ai](https://instagram.com/krystof_ai)
