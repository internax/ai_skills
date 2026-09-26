# {{NAZEV}}

❌ Doplnit 2–3 věty: o čem projekt je, cíl, termín.

## Pracovní postup
- **Znalostní báze = Obsidian vault `{{VAULT}}/`.** Na začátku sezení spusť `python3 nastroje/prehled.py`, pak přečti `{{VAULT}}/00 Stav projektu.md`, poslední deník a `{{VAULT}}/Konvence.md`.
- Rozhodnutí → `{{VAULT}}/Rozhodnutí/` (1 poznámka = 1 rozhodnutí, slepá větev = `stav: zamitnuto`); úkoly a otázky → Tasks se štítkem `#ukol/autor`, `#ukol/claude`, `#otazka/...`. Nic nemazat.
- **Nespěchat:** nejdřív společně promyslet co a jak, pak data, pak výstupy. Nový krok jen se souhlasem autora.
- **Domény autora** (bez výslovné výzvy neměnit): ❌ doplnit – viz `{{VAULT}}/Konvence.md`.
- Data a skripty v `python/` (`data/` vstupy, `out/` výstupy); čísla mají jedno místo pravdy v kódu. {{JEN_PYTHON}}
- **Konec sezení:** aktualizovat `00 Stav projektu`, zapsat deník, commit (a push, pokud je nastavený vzdálený repozitář).
