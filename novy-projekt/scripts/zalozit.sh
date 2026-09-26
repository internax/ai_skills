#!/usr/bin/env bash
# Založí strukturu projektu s Obsidian vaultem (skill novy-projekt; šablona v ../assets/sablona).
#
# Použití:  zalozit.sh [--python] <složka_projektu> [název_vaultu] [název_projektu]
#   --python         založí i složku python/ (data/, out/) pro skripty a zpracování dat
#   složka_projektu  cesta k projektu (vytvoří se, pokud neexistuje)
#   název_vaultu     název složky vaultu (výchozí: název složky projektu)
#   název_projektu   lidský název do poznámek (výchozí: název vaultu)
#
# Nic nepřepisuje: existující CLAUDE.md a nastroje/prehled.py přeskočí, do existujícího
# .gitignore jen připíše chybějící řádky. Pluginy Obsidianu (Dataview, Tasks, Templater,
# Kanban) stáhne z jejich oficiálních vydání na GitHubu.
set -euo pipefail

SKRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SABLONA="$SKRIPT_DIR/../assets/sablona"

PYTHON=0
ARGS=()
for a in "$@"; do
  case "$a" in
    --python) PYTHON=1 ;;
    -h|--help) ARGS=(); break ;;
    *) ARGS+=("$a") ;;
  esac
done
if [[ ${#ARGS[@]} -lt 1 ]]; then
  sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
fi
set -- "${ARGS[@]}"

PROJEKT="$1"
mkdir -p "$PROJEKT"
PROJEKT="$(cd "$PROJEKT" && pwd)"
VAULT="${2:-$(basename "$PROJEKT")}"
NAZEV="${3:-$VAULT}"
DATUM="$(date +%Y-%m-%d)"
CIL="$PROJEKT/$VAULT"

if [[ -e "$CIL" ]]; then
  echo "❌ $CIL už existuje – nic nepřepisuji. Zvol jiný název vaultu." >&2
  exit 1
fi
if find "$PROJEKT" -maxdepth 2 -type d -name .obsidian | grep -q .; then
  echo "⚠️  V projektu už je jiný Obsidian vault – nastroje/prehled.py pak bude potřebovat cestu jako argument." >&2
fi

echo "→ Vault: $CIL"
cp -R "$SABLONA/vault" "$CIL"
mv "$CIL/Deník/DATUM.md" "$CIL/Deník/$DATUM.md"
mv "$CIL/Rozhodnutí/DATUM Struktura projektu a vaultu.md" "$CIL/Rozhodnutí/$DATUM Struktura projektu a vaultu.md"

zkopiruj_pokud_chybi() {  # zdroj cil
  if [[ -e "$2" ]]; then echo "   přeskočeno (existuje): ${2#$PROJEKT/}"; else mkdir -p "$(dirname "$2")"; cp "$1" "$2"; fi
}
# .gitignore: nový zkopírovat, do existujícího připsat jen chybějící řádky (původní obsah zůstává)
if [[ -e "$PROJEKT/.gitignore" ]]; then
  python3 - "$SABLONA/gitignore" "$PROJEKT/.gitignore" <<'PY'
import sys
sablona, cil = sys.argv[1], sys.argv[2]
mame = {l.strip() for l in open(cil, encoding="utf-8")}
chybi = [l.rstrip("\n") for l in open(sablona, encoding="utf-8")
         if l.strip() and not l.startswith("#") and l.strip() not in mame]
if chybi:
    with open(cil, "a", encoding="utf-8") as f:
        f.write("\n# --- doplněno skillem novy-projekt (Obsidian, Claude, Python) ---\n" + "\n".join(chybi) + "\n")
    print(f"   .gitignore: připsáno {len(chybi)} chybějících řádků, původní obsah beze změny")
else:
    print("   .gitignore: nic nechybí")
PY
else
  cp "$SABLONA/gitignore" "$PROJEKT/.gitignore"
fi
CLAUDE_NOVY=0
[[ -e "$PROJEKT/CLAUDE.md" ]] || CLAUDE_NOVY=1
zkopiruj_pokud_chybi "$SABLONA/CLAUDE.md" "$PROJEKT/CLAUDE.md"
zkopiruj_pokud_chybi "$SABLONA/nastroje/prehled.py" "$PROJEKT/nastroje/prehled.py"
if [[ $PYTHON -eq 1 ]]; then
  mkdir -p "$PROJEKT/python/data" "$PROJEKT/python/out"
  for f in data/.gitkeep out/.gitkeep; do [[ -e "$PROJEKT/python/$f" ]] || cp "$SABLONA/python/$f" "$PROJEKT/python/$f"; done
fi

# Zástupné texty {{NAZEV}}, {{VAULT}}, {{DATUM}} a řádky {{JEN_PYTHON}} – jen v nově založených
# souborech (šablony Templateru v _šablony a existující CLAUDE.md se nemění)
SOUBORY=("$CIL")
[[ $CLAUDE_NOVY -eq 1 ]] && SOUBORY+=("$PROJEKT/CLAUDE.md")
NAZEV="$NAZEV" VAULT="$VAULT" DATUM="$DATUM" PYTHON="$PYTHON" python3 - "${SOUBORY[@]}" <<'PY'
import os, sys, pathlib
nahr = {"{{NAZEV}}": os.environ["NAZEV"], "{{VAULT}}": os.environ["VAULT"], "{{DATUM}}": os.environ["DATUM"]}
python = os.environ["PYTHON"] == "1"
soubory = []
for a in sys.argv[1:]:
    p = pathlib.Path(a)
    soubory += [q for q in p.rglob("*.md") if "_šablony" not in q.parts] if p.is_dir() else [p]
for p in soubory:
    s = p.read_text(encoding="utf-8")
    radky = []
    for r in s.splitlines(keepends=True):
        if "{{JEN_PYTHON}}" in r:
            if not python:
                continue
            r = r.replace(" {{JEN_PYTHON}}", "").replace("{{JEN_PYTHON}}", "")
        radky.append(r)
    n = "".join(radky)
    for k, v in nahr.items():
        n = n.replace(k, v)
    if n != s:
        p.write_text(n, encoding="utf-8")
PY

echo "→ Pluginy Obsidianu"
OBS="$CIL/.obsidian"
mkdir -p "$OBS/plugins"
cat > "$OBS/community-plugins.json" <<'JSON'
[
  "dataview",
  "obsidian-tasks-plugin",
  "templater-obsidian",
  "obsidian-kanban"
]
JSON
CHYBY=0
while read -r ID REPO; do
  mkdir -p "$OBS/plugins/$ID"
  for f in main.js manifest.json styles.css; do
    if ! curl -fsSL "https://github.com/$REPO/releases/latest/download/$f" -o "$OBS/plugins/$ID/$f"; then
      [[ "$f" == styles.css ]] && rm -f "$OBS/plugins/$ID/$f" && continue
      echo "   ⚠️  nepodařilo se stáhnout $ID/$f" >&2; CHYBY=1
    fi
  done
  echo "   $ID"
done <<'LIST'
dataview blacksmithgu/obsidian-dataview
obsidian-tasks-plugin obsidian-tasks-group/obsidian-tasks
templater-obsidian SilentVoid13/Templater
obsidian-kanban mgmeyers/obsidian-kanban
LIST
cat > "$OBS/plugins/templater-obsidian/data.json" <<'JSON'
{
  "templates_folder": "_šablony"
}
JSON

echo "→ Git"
if git -C "$PROJEKT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "   projekt už je v gitu – nic necommituji; zkontroluj 'git status' a commitni ručně"
else
  git -C "$PROJEKT" init -q -b main
  git -C "$PROJEKT" add -A
  if git -C "$PROJEKT" commit -q -m "Založení projektu $NAZEV: vault $VAULT, nastroje"; then
    echo "   první commit vytvořen"
  else
    echo "   ⚠️  commit se nepovedl (nastav git user.name/user.email) – soubory jsou připravené" >&2
  fi
fi

echo
echo "✅ Hotovo: $PROJEKT"
echo "   Obsidian → Open folder as vault → $CIL"
[[ $CHYBY -eq 1 ]] && echo "   ⚠️  Některé pluginy se nestáhly – nainstaluj je v Obsidianu ručně (Community plugins)."
echo "   Při prvním otevření povol v Obsidianu community pluginy (Turn on community plugins)."
echo "   Přehled v terminálu: python3 nastroje/prehled.py"
