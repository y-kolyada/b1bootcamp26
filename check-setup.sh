#!/usr/bin/env bash
# AI Bootcamp - workstation readiness check / проверка рабочего места.
#
# Run it in Ubuntu (WSL):
#     ./check-setup.sh          English output (default)
#     ./check-setup.sh --ru     вывод по-русски
#     ./check-setup.sh --uk     вивід українською
#     ./check-setup.sh --de     Ausgabe auf Deutsch
#
# It installs nothing and changes nothing. It looks, and prints PASS or FAIL
# for every item, with one line saying what to do about each FAIL. The last
# line is a one-line report to send to the trainer.
#
# ONE FILE, FOUR LANGUAGES, ON PURPOSE. Separate scripts drift apart; the
# strings below are the only thing that differs, so they sit side by side
# where a missing translation is visible at a glance - and `tools/check-strings.sh`
# compares the four key sets, because "visible at a glance" is not a verification.
# That checker was promised by this comment and written only on 2026-10-08; for
# two weeks this line described a verification that did not exist.

set -uo pipefail

LANGCHOICE=en
case "${1:-}" in
  --ru) LANGCHOICE=ru ;;
  --uk) LANGCHOICE=uk ;;
  --de) LANGCHOICE=de ;;
  --en) LANGCHOICE=en ;;
  -h|--help) sed -n '2,14p' "$0" | sed 's/^# \?//'; exit 0 ;;
  "") : ;;
  *) echo "unknown option: $1 (use --en, --ru, --uk or --de)" >&2; exit 2 ;;
esac

case "$LANGCHOICE" in
ru)
  S_OK="ОК"; S_BAD="НЕТ"; S_WARN="ГЛЯНЬ"
  T_HEAD="AI Bootcamp - проверка рабочего места"
  L_WSL="WSL2"; L_DISTRO="Дистрибутив"; L_UBUNTU="Ubuntu"; L_GIT="git"
  L_GITID="git: имя и почта"; L_GH="GitHub доступен"; L_NODE="Node.js"
  L_CODE="Редактор (IDE)"; L_EXT="Расширение Claude Code"; L_CLAUDE="Claude Code"
  L_LOGIN="Вход в аккаунт"; L_DISK="Место на диске"
  L_BROWSER="Браузер из Ubuntu"; V_NOBROWSER="открывать нечем"
  V_ALTFOUND="Claude Code нет, но помощник есть:"
  F_LOGIN2="основной путь курса - подписка родителя: claude, потом /login. Без неё скажи тренеру, пойдёшь по альтернативе"
  F_CLAUDE2="основной путь - Claude Code с подпиской; с этим помощником курс тоже идёт, скажи тренеру"
  F_WSLU="нужен пароль взрослого: sudo apt install -y wslu (без него не откроется вход)"
  V_KERNEL="ядро"; V_WSL1="похоже на WSL1:"; V_NOTWSL="это не WSL"
  V_NOTINST="не установлен"; V_NOTSET="не заданы"; V_NORESP="не отвечает"; V_SET="заданы"
  V_OLD="слишком старый"; V_HTTPS="по https"; V_VISIBLE="виден из Ubuntu"
  V_INVISIBLE="ни одна не видна из Ubuntu"; V_EMPTYEXT="списки расширений пусты"
  V_FOUNDIN="установлено в"; V_NOTIN="ни в одной из них:"
  V_CHECKING="проверяю, подожди 10-30 секунд..."; V_SUBOK="подписка работает"
  V_NOANSWER="нет ответа"; V_FREE="свободно"; V_UNKNOWN="не определяется"
  F_WSL1="в PowerShell от администратора: wsl --set-version Ubuntu 2"
  F_NOTWSL="курс идёт в Ubuntu под Windows: wsl --install -d Ubuntu"
  F_DISTRO="курс рассчитан на Ubuntu; другой дистрибутив, скорее всего, тоже подойдёт"
  F_DISTRO2="проверим вместе на первом занятии"
  F_GIT="sudo apt update && sudo apt install -y git"
  F_GITID="git config --global user.name \"Имя Фамилия\" && git config --global user.email \"почта@пример.com\""
  F_GH="проверь интернет; если сеть за фильтром - напиши тренеру до занятия"
  F_NODE="нужен 18 или новее: установи nvm, затем nvm install --lts"
  F_NODE2="установи nvm (nvm.sh), закрой и открой терминал, затем nvm install --lts"
  F_CODE="установи VS Code (или Antigravity IDE) в Windows и расширение WSL, затем открой папку через 'WSL: Connect to WSL'"
  F_EXT="в редакторе: Extensions, найти Claude Code, Install"
  F_EXTEMPTY="открой редактор хотя бы раз, потом запусти проверку заново; если Claude Code уже стоит - просто скажи тренеру"
  F_CLAUDE="npm install -g @anthropic-ai/claude-code (сначала Node); без подписки скажи тренеру - дадим бесплатный путь"
  F_DISK="лучше освободить хотя бы 3 ГБ"
  M_HEAD="Проверить самому, скрипт этого не видит:"
  M_1="Discord установлен, и ты можешь войти (от 13 лет)"
  M_2="веб-камера и наушники с микрофоном работают"
  M_3="подписка Claude Pro оформлена родителем"
  R_GOOD="ВСЁ ХОРОШО"; R_BAD="ЕСТЬ ЧТО ПОЧИНИТЬ"
  R_READY="Готово к курсу:"; R_OF="из"; R_NOTES="Замечаний:"
  R_NOTREADY_A="Не готово:"; R_NOTREADY_B="Исправь строки со словом НЕТ и запусти ещё раз."
  R_REPORT="Отчёт тренеру - скопируй одну строку:"
  U_GB="ГБ"; U_MB="МБ"
;;
uk)
  S_OK="ОК"; S_BAD="НІ"; S_WARN="ГЛЯНЬ"
  T_HEAD="AI Bootcamp - перевірка робочого місця"
  L_WSL="WSL2"; L_DISTRO="Дистрибутив"; L_UBUNTU="Ubuntu"; L_GIT="git"
  L_GITID="git: ім'я та пошта"; L_GH="GitHub доступний"; L_NODE="Node.js"
  L_CODE="Редактор (IDE)"; L_EXT="Розширення Claude Code"; L_CLAUDE="Claude Code"
  L_LOGIN="Вхід в акаунт"; L_DISK="Місце на диску"
  L_BROWSER="Браузер з Ubuntu"; V_NOBROWSER="відкривати нічим"
  V_ALTFOUND="Claude Code немає, але помічник є:"
  F_LOGIN2="основний шлях курсу - підписка батьків: claude, потім /login. Без неї скажи тренеру, підеш альтернативою"
  F_CLAUDE2="основний шлях - Claude Code з підпискою; з цим помічником курс теж іде, скажи тренеру"
  F_WSLU="потрібен пароль дорослого: sudo apt install -y wslu (без нього вхід не відкриється)"
  V_KERNEL="ядро"; V_WSL1="схоже на WSL1:"; V_NOTWSL="це не WSL"
  V_NOTINST="не встановлено"; V_NOTSET="не задані"; V_NORESP="не відповідає"; V_SET="задані"
  V_OLD="занадто стара"; V_HTTPS="через https"; V_VISIBLE="видно з Ubuntu"
  V_INVISIBLE="жодного не видно з Ubuntu"; V_EMPTYEXT="списки розширень порожні"
  V_FOUNDIN="встановлено в"; V_NOTIN="в жодному з них:"
  V_CHECKING="перевіряю, зачекай 10-30 секунд..."; V_SUBOK="підписка працює"
  V_NOANSWER="немає відповіді"; V_FREE="вільно"; V_UNKNOWN="не визначається"
  F_WSL1="у PowerShell від адміністратора: wsl --set-version Ubuntu 2"
  F_NOTWSL="курс іде в Ubuntu під Windows: wsl --install -d Ubuntu"
  F_DISTRO="курс розрахований на Ubuntu; інший дистрибутив, найімовірніше, теж підійде"
  F_DISTRO2="подивимось разом на першому занятті"
  F_GIT="sudo apt update && sudo apt install -y git"
  F_GITID="git config --global user.name \"Ім'я Прізвище\" && git config --global user.email \"пошта@приклад.com\""
  F_GH="перевір інтернет; якщо мережа за фільтром - напиши тренеру до заняття"
  F_NODE="потрібен 18 або новіший: встанови nvm, потім nvm install --lts"
  F_NODE2="встанови nvm (nvm.sh), закрий і відкрий термінал, потім nvm install --lts"
  F_CODE="встанови VS Code (або Antigravity IDE) у Windows і розширення WSL, потім відкрий теку через 'WSL: Connect to WSL'"
  F_EXT="у редакторі: Extensions, знайти Claude Code, Install"
  F_EXTEMPTY="відкрий редактор хоча б раз, потім запусти перевірку знову; якщо Claude Code вже стоїть - просто скажи тренеру"
  F_CLAUDE="npm install -g @anthropic-ai/claude-code (спочатку Node); без підписки скажи тренеру - дамо безкоштовний шлях"
  F_DISK="краще звільнити хоча б 3 ГБ"
  M_HEAD="Перевір сам, скрипт цього не бачить:"
  M_1="Discord встановлено, і ти можеш увійти (від 13 років)"
  M_2="вебкамера та навушники з мікрофоном працюють"
  M_3="підписку Claude Pro оформив хтось із батьків"
  R_GOOD="ВСЕ ДОБРЕ"; R_BAD="Є ЩО ПОЛАГОДИТИ"
  R_READY="Готово до курсу:"; R_OF="з"; R_NOTES="Зауважень:"
  R_NOTREADY_A="Не готово:"; R_NOTREADY_B="Виправ рядки зі словом НІ і запусти ще раз."
  R_REPORT="Звіт тренеру - скопіюй один рядок:"
  U_GB="ГБ"; U_MB="МБ"
;;
de)
  S_OK="OK"; S_BAD="FEHLER"; S_WARN="PRÜFEN"
  T_HEAD="AI Bootcamp - Prüfung des Arbeitsplatzes"
  L_WSL="WSL2"; L_DISTRO="Distribution"; L_UBUNTU="Ubuntu"; L_GIT="git"
  L_GITID="git: Name und E-Mail"; L_GH="GitHub erreichbar"; L_NODE="Node.js"
  L_CODE="Editor (IDE)"; L_EXT="Claude-Code-Erweiterung"; L_CLAUDE="Claude Code"
  L_LOGIN="Angemeldet"; L_DISK="Speicherplatz"
  L_BROWSER="Browser aus Ubuntu"; V_NOBROWSER="nichts zum Oeffnen da"
  V_ALTFOUND="kein Claude Code, aber ein Helfer ist da:"
  F_LOGIN2="Hauptweg des Kurses ist das Abo der Eltern: claude, dann /login. Ohne Abo sag es dem Trainer"
  F_CLAUDE2="Hauptweg ist Claude Code mit Abo; mit diesem Helfer laeuft der Kurs auch, sag es dem Trainer"
  F_WSLU="Passwort eines Erwachsenen: sudo apt install -y wslu (sonst oeffnet die Anmeldung nicht)"
  V_KERNEL="Kernel"; V_WSL1="sieht nach WSL1 aus:"; V_NOTWSL="das ist kein WSL"
  V_NOTINST="nicht installiert"; V_NOTSET="nicht gesetzt"; V_NORESP="keine Antwort"; V_SET="gesetzt"
  V_OLD="zu alt"; V_HTTPS="über https"; V_VISIBLE="aus Ubuntu sichtbar"
  V_INVISIBLE="keiner aus Ubuntu sichtbar"; V_EMPTYEXT="Erweiterungslisten kamen leer zurück"
  V_FOUNDIN="installiert in"; V_NOTIN="in keinem davon:"
  V_CHECKING="prüfe, das dauert 10-30 Sekunden..."; V_SUBOK="das Abo funktioniert"
  V_NOANSWER="keine Antwort"; V_FREE="frei"; V_UNKNOWN="nicht feststellbar"
  F_WSL1="in PowerShell als Administrator: wsl --set-version Ubuntu 2"
  F_NOTWSL="der Kurs läuft in Ubuntu unter Windows: wsl --install -d Ubuntu"
  F_DISTRO="der Kurs setzt Ubuntu voraus; eine andere Distribution geht höchstwahrscheinlich auch"
  F_DISTRO2="wir schauen es uns in der ersten Stunde gemeinsam an"
  F_GIT="sudo apt update && sudo apt install -y git"
  F_GITID="git config --global user.name \"Vorname Nachname\" && git config --global user.email \"du@beispiel.com\""
  F_GH="prüfe deine Internetverbindung; ist das Netz gefiltert, schreib dem Trainer vor der Stunde"
  F_NODE="18 oder neuer wird gebraucht: nvm installieren, dann nvm install --lts"
  F_NODE2="nvm installieren (nvm.sh), Terminal schließen und neu öffnen, dann nvm install --lts"
  F_CODE="VS Code (oder Antigravity IDE) unter Windows samt WSL-Erweiterung installieren, dann den Ordner über 'WSL: Connect to WSL' öffnen"
  F_EXT="im Editor: Extensions, Claude Code suchen, Install"
  F_EXTEMPTY="öffne den Editor mindestens einmal und starte die Prüfung erneut; ist Claude Code schon installiert, sag einfach dem Trainer Bescheid"
  F_CLAUDE="npm install -g @anthropic-ai/claude-code (zuerst Node); ohne Abo sag es dem Trainer - es gibt einen kostenlosen Weg"
  F_DISK="besser mindestens 3 GB frei machen"
  M_HEAD="Das hier selbst prüfen - das Skript sieht es nicht:"
  M_1="Discord ist installiert und du kannst dich anmelden (ab 13)"
  M_2="Webcam und Headset-Mikrofon funktionieren"
  M_3="das Claude-Pro-Abo wurde von einem Elternteil abgeschlossen"
  R_GOOD="ALLES GUT"; R_BAD="ES GIBT WAS ZU TUN"
  R_READY="Bereit für den Kurs:"; R_OF="von"; R_NOTES="Hinweise:"
  R_NOTREADY_A="Nicht bereit:"; R_NOTREADY_B="Korrigiere die mit FEHLER markierten Zeilen und starte erneut."
  R_REPORT="Bericht für den Trainer - eine Zeile kopieren:"
  U_GB="GB"; U_MB="MB"
;;
*)
  S_OK="OK"; S_BAD="FAIL"; S_WARN="LOOK"
  T_HEAD="AI Bootcamp - workstation readiness check"
  L_WSL="WSL2"; L_DISTRO="Distribution"; L_UBUNTU="Ubuntu"; L_GIT="git"
  L_GITID="git: name and email"; L_GH="GitHub reachable"; L_NODE="Node.js"
  L_CODE="Editor (IDE)"; L_EXT="Claude Code extension"; L_CLAUDE="Claude Code"
  L_LOGIN="Signed in"; L_DISK="Disk space"
  L_BROWSER="Browser from Ubuntu"; V_NOBROWSER="nothing to open it with"
  V_ALTFOUND="no Claude Code, but an assistant is here:"
  F_LOGIN2="the course's main path is a parent's subscription: claude, then /login. Without one, tell the trainer"
  F_CLAUDE2="the main path is Claude Code with a subscription; the course also runs with this assistant, tell the trainer"
  F_WSLU="an adult password is needed: sudo apt install -y wslu (the sign-in cannot open otherwise)"
  V_KERNEL="kernel"; V_WSL1="looks like WSL1:"; V_NOTWSL="this is not WSL"
  V_NOTINST="not installed"; V_NOTSET="not set"; V_NORESP="no response"; V_SET="set"
  V_OLD="too old"; V_HTTPS="over https"; V_VISIBLE="visible from Ubuntu"
  V_INVISIBLE="none visible from Ubuntu"; V_EMPTYEXT="extension lists came back empty"
  V_FOUNDIN="installed in"; V_NOTIN="in none of them:"
  V_CHECKING="checking, this takes 10-30 seconds..."; V_SUBOK="the subscription works"
  V_NOANSWER="no answer"; V_FREE="free"; V_UNKNOWN="cannot be determined"
  F_WSL1="in PowerShell as administrator: wsl --set-version Ubuntu 2"
  F_NOTWSL="the course runs in Ubuntu under Windows: wsl --install -d Ubuntu"
  F_DISTRO="the course assumes Ubuntu; another distribution will most likely work too"
  F_DISTRO2="we will look at it together in session one"
  F_GIT="sudo apt update && sudo apt install -y git"
  F_GITID="git config --global user.name \"First Last\" && git config --global user.email \"you@example.com\""
  F_GH="check your internet; if the network is filtered, message the trainer before the session"
  F_NODE="18 or newer is needed: install nvm, then nvm install --lts"
  F_NODE2="install nvm (nvm.sh), close and reopen the terminal, then nvm install --lts"
  F_CODE="install VS Code (or Antigravity IDE) on Windows plus the WSL extension, then open the folder via 'WSL: Connect to WSL'"
  F_EXT="in the editor: Extensions, search Claude Code, Install"
  F_EXTEMPTY="open the editor at least once, then run this check again; if Claude Code is already installed, just tell the trainer"
  F_CLAUDE="npm install -g @anthropic-ai/claude-code (Node first); without a subscription tell the trainer - there is a free path"
  F_DISK="better to free up at least 3 GB"
  M_HEAD="Check these yourself - the script cannot see them:"
  M_1="Discord is installed and you can sign in (13+)"
  M_2="the webcam and the headset microphone work"
  M_3="the Claude Pro subscription is taken out by a parent"
  R_GOOD="ALL GOOD"; R_BAD="SOMETHING TO FIX"
  R_READY="Ready for the course:"; R_OF="of"; R_NOTES="Notes:"
  R_NOTREADY_A="Not ready:"; R_NOTREADY_B="Fix the lines marked FAIL and run it again."
  R_REPORT="Report for the trainer - copy one line:"
  U_GB="GB"; U_MB="MB";;
esac

PASS=0; FAIL=0; WARN=0; CODES=""

g() { printf '\033[32m%s\033[0m' "$1"; }
r() { printf '\033[31m%s\033[0m' "$1"; }
y() { printf '\033[33m%s\033[0m' "$1"; }
dim() { printf '\033[2m%s\033[0m' "$1"; }

# ALIGNMENT IS COUNTED IN CHARACTERS, NOT BYTES. printf '%-32s' counts bytes,
# and Cyrillic takes two per character in UTF-8, so the column breaks on every
# Russian label. ${#s} counts characters, so the padding is done here instead.
pad()  { local s="$1" n="$2" k; k=$(( n - ${#s} )); [ "$k" -lt 1 ] && k=1
         printf '%s%*s' "$s" "$k" ''; }

# ONE SPACE EACH SIDE OF THE MARKER, AND THE LABEL COLUMN ABSORBS THE REST.
# Padding a marker out to a fixed width only looks even when the word's length
# matches the field's parity: "OK" centres in a field of four and cannot in a
# field of five, and the leftover space reads as a mistake. So every marker
# gets exactly one space on each side - the same on every row - and the label
# column is widened by whatever the marker gave up, which keeps every value in
# one column in every language.
MARKW=${#S_OK}
[ ${#S_BAD}  -gt "$MARKW" ] && MARKW=${#S_BAD}
[ ${#S_WARN} -gt "$MARKW" ] && MARKW=${#S_WARN}
lbl()  { pad "$1" $(( 32 + MARKW - $2 )); }
ok()   { printf '  [ %s ] %s %s\n' "$(g "$S_OK")" "$(lbl "$1" ${#S_OK})" "$2"; PASS=$((PASS+1)); }
bad()  { printf '  [ %s ] %s %s\n' "$(r "$S_BAD")" "$(lbl "$1" ${#S_BAD})" "$2"; FAIL=$((FAIL+1)); CODES="$CODES$3"
         printf '         %s %s\n' "$(dim '->')" "$4"; }
warn() { printf '  [ %s ] %s %s\n' "$(y "$S_WARN")" "$(lbl "$1" ${#S_WARN})" "$2"; WARN=$((WARN+1))
         printf '         %s %s\n' "$(dim '->')" "$3"; }

echo
echo "  $T_HEAD"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "  ------------------------------------------------------------------"
echo

# 1. Linux under Windows
if grep -qi microsoft /proc/version 2>/dev/null; then
  KER=$(uname -r)
  case "$KER" in
    *WSL2*|*microsoft-standard*) ok "$L_WSL" "$V_KERNEL $KER" ;;
    *) bad "$L_WSL" "$V_WSL1 $KER" "W" "$F_WSL1" ;;
  esac
else
  bad "$L_WSL" "$V_NOTWSL" "W" "$F_NOTWSL"
fi

# 2. Distribution
if [ -r /etc/os-release ]; then
  . /etc/os-release
  case "${ID:-}" in
    ubuntu) ok "$L_UBUNTU" "${VERSION_ID:-?}" ;;
    *) warn "$L_DISTRO" "${PRETTY_NAME:-?}" "$F_DISTRO" ;;
  esac
else
  warn "$L_DISTRO" "$V_UNKNOWN" "$F_DISTRO2"
fi

# 2.1 A browser reachable from Ubuntu
# THIS ROW EXISTS BECAUSE TWO SIGN-INS DEPEND ON IT. `gh auth login --web` and
# `claude` with `/login` both hand a URL to a browser, and a fresh Ubuntu under
# WSL has none; `wslu` provides `wslview`, which passes the URL to the browser
# already open in Windows. Measured 2026-10-08 on the conductor's machine:
# without it the device flow printed its code and never completed, and the only
# error on screen came from snapd about mount namespaces - naming neither the
# browser nor the cause. A gate-keeper that looks silently at this costs a
# participant an evening.
if command -v wslview >/dev/null 2>&1; then
  ok "$L_BROWSER" "wslview"
else
  bad "$L_BROWSER" "$V_NOBROWSER" "B" "$F_WSLU"
fi

# 3. git
if command -v git >/dev/null 2>&1; then
  ok "$L_GIT" "$(git --version | awk '{print $3}')"
  NAME=$(git config --global user.name 2>/dev/null || true)
  MAIL=$(git config --global user.email 2>/dev/null || true)
  if [ -n "$NAME" ] && [ -n "$MAIL" ]; then
    # THE NAME ITSELF IS NOT PRINTED. Participants are minors and they paste
    # this whole output into a chat, not just the one report line they are
    # told to copy. Measured 2026-09-22: the row read out a real full name.
    # The check is that both are set, and that is all the screen needs to say.
    ok "$L_GITID" "$V_SET"
  else
    bad "$L_GITID" "$V_NOTSET" "G" "$F_GITID"
  fi
else
  bad "$L_GIT" "$V_NOTINST" "G" "$F_GIT"
fi

# 4. Network and GitHub
if command -v git >/dev/null 2>&1 && \
   timeout 25 git ls-remote https://github.com/git/git HEAD >/dev/null 2>&1; then
  ok "$L_GH" "$V_HTTPS"
else
  bad "$L_GH" "$V_NORESP" "N" "$F_GH"
fi

# 5. Node - the course's tests run on it
if command -v node >/dev/null 2>&1; then
  NV=$(node -v | tr -d 'v'); MAJ=${NV%%.*}
  if [ "${MAJ:-0}" -ge 18 ] 2>/dev/null; then
    ok "$L_NODE" "v$NV"
  else
    bad "$L_NODE" "v$NV - $V_OLD" "D" "$F_NODE"
  fi
else
  bad "$L_NODE" "$V_NOTINST" "D" "$F_NODE2"
fi

# 6. The editor, and the Claude Code extension in it
# EITHER IDE COUNTS. The studio is fixed - Claude Code - but it is hosted by
# VS Code or by Antigravity IDE, and the extension lives in whichever one the
# participant actually uses. Measured 2026-09-22: `code --list-extensions`
# returned nothing while `antigravity-ide --list-extensions` returned
# anthropic.claude-code, so looking at one editor alone calls a ready
# workstation unready.
IDES=""; EXTALL=""; EXTIN=""; LISTED=0
for ide in code antigravity-ide; do
  command -v "$ide" >/dev/null 2>&1 || continue
  IDES="$IDES $ide"
  LIST=$(timeout 30 "$ide" --list-extensions 2>/dev/null || true)
  [ -n "$LIST" ] && LISTED=1
  EXTALL="$EXTALL$LIST
"
  if printf '%s' "$LIST" | grep -qi 'claude'; then EXTIN="$EXTIN $ide"; fi
done

if [ -z "$IDES" ]; then
  bad "$L_CODE" "$V_INVISIBLE" "V" "$F_CODE"
else
  ok "$L_CODE" "$V_VISIBLE:$IDES"
  # AN EMPTY LIST IS NOT "THE EXTENSION IS MISSING". A list can come back empty
  # because the editor is installed but has never been opened, or because a
  # different profile is active. Calling that a missing extension asserts what
  # the check does not establish.
  if [ -n "$EXTIN" ]; then
    ok "$L_EXT" "$V_FOUNDIN$EXTIN"
  elif [ "$LISTED" -eq 0 ]; then
    warn "$L_EXT" "$V_EMPTYEXT" "$F_EXTEMPTY"
  else
    NEXT=$(printf '%s' "$EXTALL" | grep -c '^[A-Za-z0-9_-][A-Za-z0-9_.-]*\.[A-Za-z0-9_-][A-Za-z0-9_.-]*$' || true)
    bad "$L_EXT" "$V_NOTIN$IDES ($NEXT)" "E" "$F_EXT"
  fi
fi

# 7. Claude Code - installed, and actually signed in
#
# THREE STATES, NOT TWO, BY THE CONDUCTOR'S DECISION OF 2026-10-08. The course's
# main path is a parent's Claude subscription and it keeps the session's
# attention. A participant without one is NOT unprepared: the method is the same
# with a free assistant, and session one carries that alternative. So a missing
# sign-in warns and names the main path, and red is kept for the one state that
# really blocks - no assistant of any kind on the machine.
#
# WHAT STILL REDDENS, so this row is not decoration: nothing to work with. A
# browser-only participant lands here too, which is why the line says to tell
# the trainer rather than pretending the machine is ready.
if command -v claude >/dev/null 2>&1; then
  ok "$L_CLAUDE" "$(claude --version 2>/dev/null | head -1)"
  printf '  [ %*s ] %s %s\n' "$MARKW" '' "$(lbl "$L_LOGIN" "$MARKW")" "$(dim "$V_CHECKING")"
  ANSWER=$(timeout 90 claude -p 'Reply with exactly one word: ready' --model haiku 2>&1 || true)
  if printf '%s' "$ANSWER" | grep -qi 'ready\|готово'; then
    printf '\033[1A\033[2K'
    ok "$L_LOGIN" "$V_SUBOK"
  else
    printf '\033[1A\033[2K'
    SHORT=$(printf '%s' "$ANSWER" | tr '\n' ' ' | cut -c1-60)
    warn "$L_LOGIN" "${SHORT:-$V_NOANSWER}" "$F_LOGIN2"
  fi
else
  ALT=""
  command -v gemini >/dev/null 2>&1 && ALT="$ALT gemini"
  command -v copilot >/dev/null 2>&1 && ALT="$ALT copilot"
  case "${IDES:-}" in *antigravity*) ALT="$ALT antigravity" ;; esac
  if [ -n "$ALT" ]; then
    warn "$L_CLAUDE" "$V_ALTFOUND$ALT" "$F_CLAUDE2"
  else
    bad "$L_CLAUDE" "$V_NOTINST" "C" "$F_CLAUDE"
  fi
fi

# 8. Disk space
AVAIL=$(df -Pm "$HOME" 2>/dev/null | awk 'NR==2{print $4}')
if [ -n "${AVAIL:-}" ] && [ "$AVAIL" -ge 3000 ] 2>/dev/null; then
  ok "$L_DISK" "$((AVAIL/1024)) $U_GB $V_FREE"
else
  warn "$L_DISK" "${AVAIL:-?} $U_MB" "$F_DISK"
fi

echo
echo "  ------------------------------------------------------------------"
echo "  $M_HEAD"
echo "    - $M_1"
echo "    - $M_2"
echo "    - $M_3"
echo "  ------------------------------------------------------------------"
echo

TOTAL=$((PASS+FAIL))
if [ "$FAIL" -eq 0 ]; then
  printf '  %s  %s %s %s %s. ' "$(g "$R_GOOD")" "$R_READY" "$PASS" "$R_OF" "$TOTAL"
  [ "$WARN" -gt 0 ] && printf '%s %s.' "$R_NOTES" "$WARN"
  echo; echo
else
  printf '  %s  %s %s %s %s. %s\n\n' "$(r "$R_BAD")" "$R_NOTREADY_A" "$PASS" "$R_OF" "$TOTAL" "$R_NOTREADY_B"
fi

echo "  $R_REPORT"
echo "    BOOTCAMP-CHECK ok=$PASS fail=$FAIL warn=$WARN codes=${CODES:-none} $(date '+%Y-%m-%d')"
echo

[ "$FAIL" -eq 0 ]
