---
typ: tema
stav: rozpracovano
vytvoreno: {{DATUM}}
aktualizovano: {{DATUM}}
tags: [moc]
---
# {{NAZEV}} – rozcestník

**Kde jsme:** [[00 Stav projektu]] · **Pravidla:** [[Konvence]] · **Nástěnka:** [[Nástěnka]]

## Témata
- (ruční mapa poznámek po oblastech – doplňovat průběžně)

## Rozhodnutí
```dataview
TABLE datum, stav, oblast FROM "Rozhodnutí" WHERE stav != "zamitnuto" SORT datum DESC
```

## Slepé větve
Co jsme zkusili nebo zvažovali a zavrhli – **nemazat**, ať se tam znovu nevydáme.
```dataview
TABLE datum, oblast FROM "Rozhodnutí" WHERE stav = "zamitnuto" SORT datum DESC
```

## Rozpracované poznámky
```dataview
TABLE typ, stav, aktualizovano FROM "Témata" WHERE stav != "hotovo" AND stav != "nahrazeno" SORT aktualizovano DESC
```

## Deník
```dataview
LIST FROM "Deník" SORT file.name DESC
```
