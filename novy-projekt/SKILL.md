---
name: novy-projekt
description: Založí a dlouhodobě vede projekt s Obsidian vaultem jako pamětí Clauda mezi sezeními – kostra (Stav projektu, Rozhodnutí včetně slepých větví, Deník, Témata, šablony, Kanban nástěnka), pluginy Dataview/Tasks/Templater/Kanban, textový přehled nastroje/prehled.py a git se zálohou. Použij vždy, když uživatel začíná nový projekt nebo chce projekt „vést“ – diplomku, bakalářku, výzkum, technický či pracovní projekt, osobní projekt – i když Obsidian nezmíní; dále když chce „vést si poznámky k projektu“, „mít paměť/kontext mezi sezeními“, „nastavit vault“, „založit strukturu projektu“, zaznamenávat rozhodnutí, úkoly a slepé větve, nebo napíše /novy-projekt (anglicky také new project, project notes, Obsidian vault setup, second brain for a project).
compatibility: Vyžaduje bash, git, python3 a curl (macOS/Linux; na Windows Git Bash nebo WSL) a aplikaci Obsidian.
---

# Nový projekt s Obsidian vaultem

Budeme spolu dlouhodobě pracovat na projektu. Tvoje paměť a kontext mezi sezeními je **Obsidian vault uvnitř projektu**. Vše, k čemu dospějeme, v něm průběžně zaznamenávej tak, aby další sezení (nebo jiná instance) mohlo plynule navázat.

Skill obsahuje zakládací skript `scripts/zalozit.sh` a šablonu projektu `assets/sablona/` (cesty jsou relativní k base directory skillu). Skript dělá mechanickou část (kostra, pluginy, git), ty vedeš rozhovor a doplňuješ obsah.

## 1. Než cokoli založíš, zeptej se
1. **Název projektu** a **složka projektu** (výchozí: aktuální pracovní adresář).
2. **Název vaultu** – vault se jmenuje podle projektu (krátký název složky, např. `diplomka`, `domaci_automatizace`), protože Obsidian zobrazuje název složky jako název vaultu a autor jich může mít víc. Navrhni ho sám.
3. **Typ projektu:** diplomka/výzkum × technický × pracovní/týmový × osobní (lze kombinovat) → moduly v kroku 3.
4. **Domény autora:** části, které si autor dělá sám (např. text práce, produkční kód, šablona dokumentu). Do nich bez výslovné výzvy nezasahuj – jsou to jeho autorská rozhodnutí a nevyžádaná úprava by mu rozbila práci i důvěru.
5. **Git:** URL vzdáleného repozitáře (SSH), nebo jen lokálně.
6. Jazyk poznámek (výchozí čeština).

Shrň, co založíš, a počkej na souhlas.

## 2. Založ kostru
```bash
bash "<base directory skillu>/scripts/zalozit.sh" "<složka projektu>" "<název vaultu>" "<název projektu>"
```
Skript nic nepřepisuje (existující `.gitignore`, `CLAUDE.md`, `nastroje/prehled.py` přeskočí), stáhne pluginy z jejich oficiálních vydání a udělá první commit, pokud projekt ještě není v gitu. Zkontroluj jeho výstup; když se plugin nestáhne, řekni to autorovi.

## 3. Doplň podle rozhovoru
- `Konvence.md` → sekce **Domény autora** a **Git** (vzdálený repozitář); `CLAUDE.md` v kořeni → popis projektu a domény autora (všechna místa označená ❌).
- `.gitignore` → doplň vzory pro nástroje projektu (např. LaTeX).
- **Moduly** jako podsložky `Témata/` (poznámky založ podle šablony `_šablony/Téma.md`):
  - **Diplomka / výzkum:** `Zadání a cíle`, `Formální požadavky` (dohledej směrnice školy/fakulty), `Osnova`, `Kapitoly/` (1 poznámka na kapitolu), `Metodika/`, `Konzultace s vedoucím`; ve vaultu složka `Zdroje/` (1 zdroj = 1 poznámka s hotovou citací v požadované normě, šablona `_šablony/Zdroj.md`)
  - **Technický:** `Architektura`, `Parametry a data`, `Měření/`, `Komponenty/`
  - **Pracovní / týmový:** `Lidé a role`, `Schůzky/`; úkoly týmu žijí v externím trackeru (Linear, Jira, GitHub), do vaultu jen odkazy na ID
  - **Osobní:** jen základ + `Nápady`
- Doplň ruční mapu v `00 Rozcestník.md` a první úkoly/otázky (Tasks se štítky).
- **Vzdálený repozitář:** přidej `origin`, nejdřív `git fetch` a podívej se, co tam je. Pokud má vlastní historii (např. README/LICENSE z GitHubu), slouč ji (`git merge origin/main --allow-unrelated-histories`), konflikty vyřeš tak, aby se nic neztratilo, a teprve pak `git push -u origin main`. `--force` nepoužívej – přepsal by vzdálenou historii a autor by mohl přijít o práci, kterou tam má. Zkontroluj, jestli je repo soukromé (`curl -s -o /dev/null -w '%{http_code}' https://api.github.com/repos/<vlastník>/<repo>` vrátí 404 u soukromého); když je veřejné, upozorni autora, že poznámky uvidí kdokoli.
- Autorovi řekni, ať při prvním otevření vaultu v Obsidianu povolí community pluginy.

## 4. Styl spolupráce
- **Nespěchej.** Nejdřív společně ujasněte, *co* a *jak* budete dělat, pak data, teprve pak výpočty a výstupy. Autor musí výsledku rozumět a obhájit ho – když ho předběhneš hotovou prací, nebude vědět proč a bude to muset rozplétat. Nový krok proto nezačínej bez jeho souhlasu.
- Pracuj v malých krocích. U každého rozcestí dej **doporučení + krátké zdůvodnění** a nech autora rozhodnout. Pokud téma nezná, nejdřív vysvětli princip jednoduše a na příkladu.
- Mentoruj: ptej se na věci, které by měl promyslet, a upozorňuj na slabá místa, na která by přišel oponent nebo recenzent.
- Každé rozhodnutí a poznatek **zapiš do vaultu hned**, ne až na konci – sezení může skončit nebo se kontext zkrátit a co není ve vaultu, příští sezení neuvidí.
- **Nemaž, archivuj.** Zastaralé věci označ (`stav: nahrazeno`, přesun do `Archiv/`) a odkaž na novou verzi; slepé větve zůstávají (`stav: zamitnuto`). Záznam o tom, co nefungovalo a proč, chrání před opakováním stejné chyby a vysvětluje, jak se došlo k současnému stavu.

## 5. Pravidla vaultu
Úplná pravidla jsou v `Konvence.md` ve vaultu (struktura, frontmatter `typ`/`stav`, značky ✅ 🟡 ❌ ⏳ ⚠️, úkoly `#ukol/autor` · `#ukol/claude` · `#otazka/<kdo>`, rozhodnutí, názvy bez „–“ a závorek, `[[wikilinky]]`, data s jedním místem pravdy v `python/`). Drž se jich a při změně pravidel uprav `Konvence.md`.

Nejdůležitější:
- **Rozhodnutí** = samostatná poznámka `Rozhodnutí/YYYY-MM-DD Název.md` (Rozhodnutí · Proč · Alternativy · Důsledky). V tematických poznámkách jen odkaz.
- **Úkoly a otázky** = `- [ ] … #ukol/<kdo>` v poznámce, ke které věcně patří.
- Při úpravě poznámky aktualizuj `aktualizovano` ve frontmatteru.

## 6. Průběh sezení
1. **Začátek:** spusť `python3 nastroje/prehled.py` (Dataview a Tasks přehledy se vykreslují jen v Obsidianu, skript ti je ukáže v terminálu), přečti `00 Stav projektu`, poslední deník a `Konvence`. Krátce shrň, kde jsme a co navrhuješ jako další krok.
2. **Během:** rozhodnutí → `Rozhodnutí/` hned; úkoly a otázky → Tasks se štítkem; poznatky → tematická poznámka.
3. **Konec (nebo když autor řekne „končíme“):** aktualizuj `00 Stav projektu`, zapiš deník (`Deník/YYYY-MM-DD.md` podle šablony), commit + push (zpráva česky, co a proč) a ve 3–5 bodech shrň, co je hotové a co čeká na autora.
