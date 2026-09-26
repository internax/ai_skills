# ai_skills

Skilly pro [Claude Code](https://claude.com/claude-code).

## Instalace
Každý skill je složka se souborem `SKILL.md`. Nalinkuj ji do `~/.claude/skills/`:
```bash
ln -s "$(pwd)/novy-projekt" ~/.claude/skills/novy-projekt
```
Pak v Claude Code stačí napsat `/novy-projekt`.

## Skilly
| Skill | Co dělá |
|---|---|
| [`novy-projekt`](novy-projekt/SKILL.md) | Založí projekt s Obsidian vaultem jako dlouhodobou pamětí Clauda: Stav projektu, Rozhodnutí (i slepé větve), Deník, Témata, šablony Templateru, Kanban nástěnka, pluginy Dataview/Tasks/Templater/Kanban, textový přehled `nastroje/prehled.py`, složka `python/` a git. Vede spolupráci po sezeních. |

### `novy-projekt` bez Clauda
Kostru jde založit i samotným skriptem:
```bash
novy-projekt/scripts/zalozit.sh <složka_projektu> [název_vaultu] [název_projektu]
```
Pluginy Obsidianu se stahují z jejich oficiálních vydání na GitHubu, v repozitáři nejsou.
