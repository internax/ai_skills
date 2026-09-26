---
typ: tema
stav: rozpracovano
vytvoreno: {{DATUM}}
aktualizovano: {{DATUM}}
tags: [konvence]
---
# Konvence projektu

## Složky projektu
| Složka | Obsah |
|---|---|
| `{{VAULT}}/` | tento Obsidian vault – paměť a kontext projektu |
| `python/` | skripty a notebooky; `data/` vstupy, `out/` výstupy (grafy, tabulky) |
| `nastroje/` | pomocné skripty (`prehled.py`) |

## Dělba práce
### Domény autora
Části, které si autor dělá sám a do kterých Claude **nezasahuje bez výslovné výzvy**:
- ❌ doplnit (např. text práce, produkční kód)

### Role Clauda
Rešerše, data, výpočty a grafy, návrhy; **paměť a kontext drží v tomto vaultu**.

## Vault
```
{{VAULT}}/
├── 00 Stav projektu.md   ← číst jako první, aktualizovat na konci sezení
├── 00 Rozcestník.md      ← mapa + Dataview přehledy (rozhodnutí, slepé větve, rozpracované)
├── Konvence.md           ← tato poznámka
├── Rozhodnutí/           ← 1 rozhodnutí = 1 poznámka; slepá větev = stav zamitnuto
├── Deník/                ← 1 sezení = 1 poznámka YYYY-MM-DD
├── Témata/               ← věcné poznámky, podsložky podle modulů projektu
├── Nástěnka.md           ← Kanban
├── Archiv/               ← nahrazené poznámky (nic se nemaže)
├── _šablony/             ← Templater
└── images/
```

### Přehled v terminálu
`python3 nastroje/prehled.py` – totéž co Dataview/Tasks přehledy, čitelné i pro Clauda (spouští ho na začátku sezení).

### Frontmatter (každá poznámka)
`typ`: tema | rozhodnuti | denik | zdroj | kapitola | mereni
`stav`: navrh | rozpracovano | ceka | rozhodnuto | hotovo | zamitnuto | nahrazeno
`vytvoreno`, `aktualizovano` (YYYY-MM-DD), `tags`. Při každé úpravě aktualizovat `aktualizovano`. Další klíče jsou povolené.

### Značky v textu (jen tyto)
✅ hotovo/ověřeno · 🟡 odhad/předběžné · ❌ chybí · ⏳ čeká na někoho · ⚠️ pozor/riziko

### Úkoly a otázky (plugin Tasks)
- `- [ ] text #ukol/autor 📅 2026-10-15` · vlastník: `#ukol/autor`, `#ukol/claude`, případně `#ukol/<role>`; otázky: `#otazka/autor`, `#otazka/<role>` (např. `#otazka/vedouci`, `#otazka/klient`)
- priorita ⏫ 🔼 🔽; hotovo `- [x] … ✅ 2026-10-16`
- úkol patří do poznámky, ke které se věcně vztahuje; přehled je v [[00 Stav projektu]]

### Rozhodnutí
- `Rozhodnutí/YYYY-MM-DD Název.md` (šablona `_šablony/Rozhodnutí`): Rozhodnutí · Proč · Alternativy · Důsledky
- V tematických poznámkách **jen odkaz**, obsah nekopírovat
- Slepé větve se nemažou: `stav: zamitnuto` → zobrazí se v [[00 Rozcestník#Slepé větve]]

### Názvy a odkazy
- Diakritika a mezery OK; **bez „–“, závorek, lomítek a dvojteček**
- Odkazy vždy `[[wikilink]]`, hustě; obrázky do `images/`, relativně `![](images/x.png)`

## Data a čísla
- Každé tvrzení z externího zdroje má zdroj.
- Čísla mají **jedno místo pravdy** – v kódu (`python/`) s hodnotou, stavem a zdrojem; poznámky odkazují nebo obsahují tabulku generovanou skriptem.
- Odhady značit 🟡 a do finálních výstupů je nepouštět bez ověření.

## Git
- Repozitář = celý projekt. Git spravuje Claude z terminálu (ne plugin Obsidian Git).
- Commit + push na konci každého sezení, zpráva česky: co a proč. Nikdy `--force`.
- Vzdálený repozitář: ❌ doplnit
