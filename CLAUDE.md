# Orion Mode — Claude Code Skill

Tento repozitář obsahuje **Orion mode** — Claude Code skill pro úsporu tokenů.

## Co to dělá

Orion mode přinutí Clauda odpovídat stručně a efektivně. Stejná technická přesnost, ~75 % méně tokenů.

## Aktivace

```
/orion          → full režim (výchozí)
/orion lite     → stručný, ale profesionální
/orion ultra    → maximální komprese
zastav orion    → vypnout
```

## Instalace

```bash
bash <(curl -s https://raw.githubusercontent.com/krystofai-ai/Orion-uspora-tokenu/main/hooks/install.sh)
```

## Pravidla (interní)

Při aktivním orion mode:
- Odstraň výplňová slova, fráze, zdvořilosti
- Používej fragmenty vět pokud je smysl jasný
- Šipky (→) pro příčinnost
- Zachovej veškerý technický obsah přesně
- Nikdy neaplikuj na bloky kódu nebo commity

Pozastav pro: bezpečnostní varování, nevratné akce, složité sekvence.
