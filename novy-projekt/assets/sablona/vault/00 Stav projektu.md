---
typ: tema
stav: rozpracovano
vytvoreno: {{DATUM}}
aktualizovano: {{DATUM}}
tags: [stav]
---
# Stav projektu – {{NAZEV}}

**Aktualizováno:** {{DATUM}} · **Fáze:** založení · **Termín:** ❌ doplnit · Mapa: [[00 Rozcestník]]

## Kde jsme
Projekt je založený, struktura vaultu připravená. Zatím nic dalšího.

## Další krok
Ujasnit cíle a rozsah projektu.

## Čeká na autora
```tasks
not done
tag includes #ukol/autor
sort by due
```

## Čeká na Clauda
```tasks
not done
tag includes #ukol/claude
sort by priority
```

## Otevřené otázky
```tasks
not done
tag includes #otazka
group by tags
```

## Poslední rozhodnutí
```dataview
TABLE datum, stav, oblast FROM "Rozhodnutí" SORT datum DESC LIMIT 8
```
