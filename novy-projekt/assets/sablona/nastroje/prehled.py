#!/usr/bin/env python3
"""Textový přehled Obsidian vaultu – totéž, co ukazují Dataview/Tasks přehledy v Obsidianu.

Použití:  python3 nastroje/prehled.py [cesta_k_vaultu] [--vse]
          (bez cesty najde vault sám: složku s .obsidian v kořeni projektu)

Vypíše: otevřené úkoly podle vlastníka (#ukol/…), otevřené otázky (#otazka/…),
poslední rozhodnutí, slepé větve (stav: zamitnuto) a rozpracované poznámky.
Jen čte soubory, nic nezapisuje. Pouze standardní knihovna.
"""
import re
import sys
from collections import defaultdict
from pathlib import Path

POSLEDNICH_ROZHODNUTI = 8
IGNOROVAT = {".obsidian", ".trash", "_šablony", "Archiv"}
UKOL = re.compile(r"^\s*- \[ \] (.+)$")
STITEK = re.compile(r"#(ukol|otazka)/([\w-]+)")


def najdi_vault(argv):
    if argv:
        return Path(argv[0]).expanduser()
    koren = Path(__file__).resolve().parent.parent
    vaulty = sorted(d for d in koren.iterdir() if (d / ".obsidian").is_dir())
    if len(vaulty) == 1:
        return vaulty[0]
    sys.exit("Vault nenalezen (nebo je jich víc) – zadej cestu jako argument.")


def frontmatter(text):
    if not text.startswith("---\n"):
        return {}
    konec = text.find("\n---", 4)
    if konec < 0:
        return {}
    fm = {}
    for radek in text[4:konec].splitlines():
        if ":" in radek and not radek.startswith(" "):
            k, v = radek.split(":", 1)
            fm[k.strip()] = v.strip().strip('"')
    return fm


def poznamky(vault):
    for p in sorted(vault.rglob("*.md")):
        if IGNOROVAT & set(p.relative_to(vault).parts):
            continue
        text = p.read_text(encoding="utf-8")
        yield p, frontmatter(text), text


def zkrat(s, n=110):
    s = re.sub(r"\s+", " ", s).strip()
    return s if len(s) <= n else s[: n - 1] + "…"


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    vse = "--vse" in sys.argv
    vault = najdi_vault(args)

    ukoly = defaultdict(list)      # vlastník -> [(poznámka, text)]
    otazky = defaultdict(list)
    rozhodnuti, zamitnuto, rozpracovane = [], [], []

    navrhy = 0
    for p, fm, text in poznamky(vault):
        nazev = p.stem
        if "kanban-plugin" in fm:  # karty nástěnky nejsou úkoly
            continue
        for radek in text.splitlines():
            m = UKOL.match(radek)
            if not m:
                continue
            obsah = m.group(1)
            stitky = STITEK.findall(obsah)
            cisty = zkrat(STITEK.sub("", obsah))
            if not stitky:
                ukoly["(bez vlastníka)"].append((nazev, cisty))
            for druh, kdo in stitky:
                (ukoly if druh == "ukol" else otazky)[kdo].append((nazev, cisty))

        typ, stav = fm.get("typ", ""), fm.get("stav", "")
        if typ == "rozhodnuti":
            zaznam = (fm.get("datum", ""), nazev, stav)
            (zamitnuto if stav == "zamitnuto" else rozhodnuti).append(zaznam)
        elif "Deník" in p.parts or nazev.startswith("00 "):
            pass
        elif stav == "navrh":
            navrhy += 1
        elif stav in ("rozpracovano", "ceka"):
            rozpracovane.append((fm.get("aktualizovano", ""), nazev, stav))

    def sekce(titul):
        print(f"\n## {titul}")

    print(f"# Přehled vaultu: {vault}")
    stav_projektu = vault / "00 Stav projektu.md"
    if stav_projektu.exists():
        t = stav_projektu.read_text(encoding="utf-8")
        m = re.search(r"## Další krok\n(.+?)(?=\n## )", t, re.S)
        if m:
            sekce("Další krok (z 00 Stav projektu)")
            print(m.group(1).strip())
    for titul, data in (("Otevřené úkoly", ukoly), ("Otevřené otázky", otazky)):
        sekce(titul)
        if not data:
            print("- (nic)")
        for kdo in sorted(data):
            print(f"### {kdo} ({len(data[kdo])})")
            for nazev, t in data[kdo]:
                print(f"- {t}  ← [[{nazev}]]")

    sekce("Poslední rozhodnutí")
    for datum, nazev, stav in sorted(rozhodnuti, reverse=True)[: None if vse else POSLEDNICH_ROZHODNUTI]:
        print(f"- {nazev}  ({stav})")
    sekce("Slepé větve")
    for datum, nazev, _ in sorted(zamitnuto, reverse=True):
        print(f"- {nazev}")
    sekce("Rozpracované poznámky")
    for akt, nazev, stav in sorted(rozpracovane, reverse=True):
        print(f"- {nazev}  ({stav}, {akt})")
    print(f"(+ {navrhy} poznámek ve stavu navrh)")


if __name__ == "__main__":
    main()
