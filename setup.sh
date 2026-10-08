#!/usr/bin/env bash
# AI Bootcamp - workstation setup / установка рабочего места.
#
# Run it in Ubuntu (WSL):
#     ./setup.sh             English output (default)
#     ./setup.sh --ru        по-русски
#     ./setup.sh --uk        українською
#     ./setup.sh --de        auf Deutsch
#     ./setup.sh --dry-run   say what it would do, change nothing
#     ./setup.sh --yes       do not ask, accept every default
#
# THE OTHER HALF OF check-setup.sh. The gate-keeper looks and changes nothing;
# this one changes things. They share the eleven items, the four languages and
# the column layout on purpose, so a participant reads one screen twice.
#
# ROOT IS AVOIDED, NOT HANDLED. Node arrives through nvm, the CLI through npm
# with a prefix inside $HOME, gh as a tarball into ~/.local/bin - none of them
# needs a password. `git` is the one exception: if it is missing, only apt can
# supply it, and that needs an adult. That one place is printed as a block of
# its own rather than as one more line, because a child who is asked for a
# password by a script will either not have it or should not type it.
#
# NOTHING IS DONE SILENTLY TO A FILE THE PARTICIPANT OWNS. ~/.gitconfig and
# ~/.bashrc are asked about, every time, even with --yes answering the rest.
#
# THE SCREEN NAMES THE PRODUCT, THE DIM LINE SHOWS THE MECHANISM. "Node.js -
# your checks will run on it" first, `nvm install --lts` underneath it. The
# rule comes from the programme's Review 1: a line names what you get, not how
# it is done.

set -uo pipefail

LANGCHOICE=en; ASSUME_YES=0; DRYRUN=0
while [ $# -gt 0 ]; do
  case "$1" in
    --ru) LANGCHOICE=ru ;;
    --uk) LANGCHOICE=uk ;;
    --de) LANGCHOICE=de ;;
    --en) LANGCHOICE=en ;;
    --yes|-y) ASSUME_YES=1 ;;
    --dry-run|-n) DRYRUN=1 ;;
    -h|--help) sed -n '2,13p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) echo "unknown option: $1 (use --en, --ru, --uk, --de, --dry-run, --yes)" >&2; exit 2 ;;
  esac
  shift
done

NVM_VERSION=v0.40.1
GH_FALLBACK=2.63.2
NODE_MIN=18

case "$LANGCHOICE" in
ru)
  S_DONE="ПОСТАВИЛ"; S_HAVE="УЖЕ БЫЛО"; S_YOU="НУЖЕН ТЫ"; S_FAIL="НЕ СМОГ"
  S_WOULD="СДЕЛАЛ БЫ"; V_EMPTYEXT="список расширений пуст"; F_EXTEMPTY="открой редактор один раз и запусти меня снова"
  T_HEAD="AI Bootcamp - настройка рабочего места"
  T_INTRO="Поставлю то, что нужно курсу. Ничего не удаляю и твои файлы не правлю без вопроса."
  T_DRY="ПРОБНЫЙ ПРОГОН: только рассказываю, что сделал бы. Ничего не меняю."
  T_TIME="Займёт 5-15 минут, в основном скачивание."
  L_WSL="Linux под Windows"; L_ARCH="Процессор"; L_GIT="git"; L_GITID="Имя в истории"
  L_NODE="Node.js"; L_CLI="Claude Code в терминале"; L_CODE="Редактор"
  L_EXT="Claude Code в редакторе"; L_GH="Отправка на GitHub"; L_GHAUTH="Вход в GitHub"
  L_LOGIN="Вход в Claude"
  L_BROWSER="Браузер из Ubuntu"
  W_WSLU="без него вход в GitHub и в Claude не сможет открыть браузер"
  V_NOBROWSER="открывать нечем"
  W_GIT="хранит историю твоего проекта и позволяет вернуться назад"
  W_GITID="этим именем будут подписаны твои изменения, и его видят все"
  W_NODE="на нём побегут твои проверки"
  W_CLI="это и есть ИИ, который делает работу; им ты пользуешься каждое занятие"
  W_CODE="здесь ты видишь свой проект и правишь его"
  W_EXT="тот же ИИ, но внутри редактора"
  W_GH="без неё твою страницу не увидит никто, кроме тебя"
  V_OK="готово"; V_FOUND="есть"; V_VER="версия"; V_NOTWSL="это не WSL"
  V_WSL1="похоже на WSL1"; V_ARCHBAD="не x86-64, скачиваемые файлы не подойдут"
  V_SKIP="пропускаю"; V_NONET="не скачалось"
  V_WINDOWS="ставится в Windows, не отсюда"; V_SIGNED="вход выполнен"
  V_NOTSIGNED="входа нет"; V_PATH="добавил в PATH"
  Q_YN="(д/н)"; Q_YES="д"; Q_NICK="Придумай себе ник латиницей (без имени и фамилии):"
  Q_GITID="Записать ник и почту-заглушку в настройки git?"
  Q_BASHRC="Дописать одну строку в ~/.bashrc, чтобы команды находились?"
  Q_GHAUTH="Войти в GitHub сейчас? Откроется браузер и будет код из восьми знаков."
  Q_APT="Запустить установку? Понадобится пароль - позови родителя."
  A_NO="понятно, не трогаю"
  ROOT_HEAD="ЗДЕСЬ НУЖЕН ВЗРОСЛЫЙ"
  ROOT_WHY="Это нельзя поставить без пароля администратора. Один раз, в самом начале."
  ROOT_WHO="Позови родителя или спроси пароль. Остальное пароля не требует."
  F_NOTWSL="курс идёт в Ubuntu под Windows. В PowerShell: wsl --install -d Ubuntu"
  F_WSL1="в PowerShell от администратора: wsl --set-version Ubuntu 2"
  F_ARCH="напиши тренеру, подберём другой способ"
  F_CODE="в Windows: winget install Microsoft.VisualStudioCode, затем поставь расширение WSL"
  F_CODE2="потом в редакторе: Ctrl+Shift+P, 'WSL: Connect to WSL', и запусти меня снова"
  F_PSPATH="в Windows PowerShell запусти этот файл - путь к нему вот такой:"
  F_GHACC="нужен бесплатный аккаунт GitHub: github.com/signup (с 13 лет, почта родителя подойдёт)"
  F_LOGIN="запусти: claude    затем /login и войди под родительским аккаунтом"
  F_RESTART="закрой терминал, открой заново и запусти меня ещё раз"
  M_HEAD="Что остаётся тебе:"
  M_CHECK="запусти проверку и пришли тренеру последнюю строку:"
  R_GOOD="РАБОЧЕЕ МЕСТО ГОТОВО"; R_PART="СДЕЛАНО НЕ ВСЁ"
  R_DONE="Поставлено:"; R_LEFT="Осталось на тебе:"; R_FAILED="Не получилось:"
;;
uk)
  S_DONE="ВСТАНОВИВ"; S_HAVE="ВЖЕ БУЛО"; S_YOU="ПОТРІБЕН ТИ"; S_FAIL="НЕ ЗМІГ"
  S_WOULD="ЗРОБИВ БИ"; V_EMPTYEXT="список розширень порожній"; F_EXTEMPTY="відкрий редактор один раз і запусти мене знову"
  T_HEAD="AI Bootcamp - налаштування робочого місця"
  T_INTRO="Встановлю те, що потрібно курсу. Нічого не видаляю і твої файли не правлю без запитання."
  T_DRY="ПРОБНИЙ ЗАПУСК: лише розповідаю, що зробив би. Нічого не змінюю."
  T_TIME="Триватиме 5-15 хвилин, переважно завантаження."
  L_WSL="Linux під Windows"; L_ARCH="Процесор"; L_GIT="git"; L_GITID="Ім'я в історії"
  L_NODE="Node.js"; L_CLI="Claude Code у терміналі"; L_CODE="Редактор"
  L_EXT="Claude Code у редакторі"; L_GH="Надсилання на GitHub"; L_GHAUTH="Вхід у GitHub"
  L_LOGIN="Вхід у Claude"
  L_BROWSER="Браузер з Ubuntu"
  W_WSLU="без нього вхід у GitHub і в Claude не зможе відкрити браузер"
  V_NOBROWSER="відкривати нічим"
  W_GIT="зберігає історію твого проєкту і дає повернутися назад"
  W_GITID="цим ім'ям будуть підписані твої зміни, і його бачать усі"
  W_NODE="на ньому працюватимуть твої перевірки"
  W_CLI="це і є ШІ, який робить роботу; ним ти користуєшся щозаняття"
  W_CODE="тут ти бачиш свій проєкт і правиш його"
  W_EXT="той самий ШІ, але всередині редактора"
  W_GH="без неї твою сторінку не побачить ніхто, крім тебе"
  V_OK="готово"; V_FOUND="є"; V_VER="версія"; V_NOTWSL="це не WSL"
  V_WSL1="схоже на WSL1"; V_ARCHBAD="не x86-64, завантажені файли не підійдуть"
  V_SKIP="пропускаю"; V_NONET="не завантажилось"
  V_WINDOWS="встановлюється у Windows, не звідси"; V_SIGNED="вхід виконано"
  V_NOTSIGNED="входу немає"; V_PATH="додав у PATH"
  Q_YN="(т/н)"; Q_YES="т"; Q_NICK="Придумай собі нік латиницею (без імені та прізвища):"
  Q_GITID="Записати нік і пошту-заглушку в налаштування git?"
  Q_BASHRC="Дописати один рядок у ~/.bashrc, щоб команди знаходились?"
  Q_GHAUTH="Увійти в GitHub зараз? Відкриється браузер і буде код із восьми знаків."
  Q_APT="Запустити встановлення? Знадобиться пароль - поклич батьків."
  A_NO="зрозуміло, не чіпаю"
  ROOT_HEAD="ТУТ ПОТРІБЕН ДОРОСЛИЙ"
  ROOT_WHY="Це не встановити без пароля адміністратора. Один раз, на початку."
  ROOT_WHO="Поклич батьків або спитай пароль. Решта пароля не потребує."
  F_NOTWSL="курс іде в Ubuntu під Windows. У PowerShell: wsl --install -d Ubuntu"
  F_WSL1="у PowerShell від адміністратора: wsl --set-version Ubuntu 2"
  F_ARCH="напиши тренеру, підберемо інший спосіб"
  F_CODE="у Windows: winget install Microsoft.VisualStudioCode, потім постав розширення WSL"
  F_CODE2="далі в редакторі: Ctrl+Shift+P, 'WSL: Connect to WSL', і запусти мене знову"
  F_PSPATH="у Windows PowerShell запусти цей файл - шлях до нього такий:"
  F_GHACC="потрібен безкоштовний акаунт GitHub: github.com/signup (з 13 років, пошта батьків підійде)"
  F_LOGIN="запусти: claude    потім /login і увійди під батьківським акаунтом"
  F_RESTART="закрий термінал, відкрий знову і запусти мене ще раз"
  M_HEAD="Що залишається тобі:"
  M_CHECK="запусти перевірку і надішли тренеру останній рядок:"
  R_GOOD="РОБОЧЕ МІСЦЕ ГОТОВЕ"; R_PART="ЗРОБЛЕНО НЕ ВСЕ"
  R_DONE="Встановлено:"; R_LEFT="Залишилось на тобі:"; R_FAILED="Не вдалося:"
;;
de)
  S_DONE="INSTALLIERT"; S_HAVE="WAR SCHON DA"; S_YOU="DU BIST DRAN"; S_FAIL="FEHLER"
  S_WOULD="WÜRDE ICH TUN"; V_EMPTYEXT="Erweiterungsliste ist leer"; F_EXTEMPTY="öffne den Editor einmal und starte mich erneut"
  T_HEAD="AI Bootcamp - Arbeitsplatz einrichten"
  T_INTRO="Ich installiere, was der Kurs braucht. Ich lösche nichts und ändere deine Dateien nur auf Rückfrage."
  T_DRY="TESTLAUF: ich sage nur, was ich täte. Ich ändere nichts."
  T_TIME="Dauert 5-15 Minuten, meist Herunterladen."
  L_WSL="Linux unter Windows"; L_ARCH="Prozessor"; L_GIT="git"; L_GITID="Name in der Historie"
  L_NODE="Node.js"; L_CLI="Claude Code im Terminal"; L_CODE="Editor"
  L_EXT="Claude Code im Editor"; L_GH="Hochladen zu GitHub"; L_GHAUTH="GitHub-Anmeldung"
  L_LOGIN="Claude-Anmeldung"
  L_BROWSER="Browser aus Ubuntu"
  W_WSLU="ohne ihn kann die Anmeldung bei GitHub und Claude keinen Browser oeffnen"
  V_NOBROWSER="nichts zum Oeffnen da"
  W_GIT="speichert die Geschichte deines Projekts und lässt dich zurückgehen"
  W_GITID="mit diesem Namen werden deine Änderungen unterschrieben, und alle sehen ihn"
  W_NODE="darauf laufen deine Prüfungen"
  W_CLI="das ist die KI, die die Arbeit macht; du nutzt sie in jeder Stunde"
  W_CODE="hier siehst du dein Projekt und bearbeitest es"
  W_EXT="dieselbe KI, aber im Editor"
  W_GH="ohne das sieht deine Seite niemand außer dir"
  V_OK="fertig"; V_FOUND="vorhanden"; V_VER="Version"; V_NOTWSL="das ist kein WSL"
  V_WSL1="sieht nach WSL1 aus"; V_ARCHBAD="kein x86-64, die Downloads passen nicht"
  V_SKIP="übersprungen"; V_NONET="Download fehlgeschlagen"
  V_WINDOWS="wird in Windows installiert, nicht von hier"; V_SIGNED="angemeldet"
  V_NOTSIGNED="nicht angemeldet"; V_PATH="in PATH aufgenommen"
  Q_YN="(j/n)"; Q_YES="j"; Q_NICK="Denk dir einen Nicknamen aus (ohne Vor- und Nachnamen):"
  Q_GITID="Nickname und Platzhalter-E-Mail in die git-Einstellungen schreiben?"
  Q_BASHRC="Eine Zeile in ~/.bashrc ergänzen, damit die Befehle gefunden werden?"
  Q_GHAUTH="Jetzt bei GitHub anmelden? Es öffnet sich der Browser mit einem achtstelligen Code."
  Q_APT="Installation starten? Dafür wird ein Passwort gebraucht - hol deine Eltern."
  A_NO="verstanden, ich lasse es"
  ROOT_HEAD="HIER WIRD EIN ERWACHSENER GEBRAUCHT"
  ROOT_WHY="Das geht nicht ohne Administrator-Passwort. Einmal, ganz am Anfang."
  ROOT_WHO="Hol deine Eltern oder frage nach dem Passwort. Alles andere braucht keins."
  F_NOTWSL="der Kurs läuft in Ubuntu unter Windows. In PowerShell: wsl --install -d Ubuntu"
  F_WSL1="in PowerShell als Administrator: wsl --set-version Ubuntu 2"
  F_ARCH="schreib dem Trainer, wir finden einen anderen Weg"
  F_CODE="in Windows: winget install Microsoft.VisualStudioCode, dann die WSL-Erweiterung installieren"
  F_CODE2="danach im Editor: Ctrl+Shift+P, 'WSL: Connect to WSL', und starte mich erneut"
  F_PSPATH="starte diese Datei in Windows PowerShell - der Pfad dorthin:"
  F_GHACC="du brauchst ein kostenloses GitHub-Konto: github.com/signup (ab 13, die E-Mail der Eltern geht)"
  F_LOGIN="starte: claude    dann /login und mit dem Konto der Eltern anmelden"
  F_RESTART="schließe das Terminal, öffne es neu und starte mich noch einmal"
  M_HEAD="Was bei dir bleibt:"
  M_CHECK="starte die Prüfung und schick dem Trainer die letzte Zeile:"
  R_GOOD="ARBEITSPLATZ IST FERTIG"; R_PART="NOCH NICHT ALLES"
  R_DONE="Installiert:"; R_LEFT="Bleibt bei dir:"; R_FAILED="Fehlgeschlagen:"
;;
*)
  S_DONE="INSTALLED"; S_HAVE="ALREADY THERE"; S_YOU="YOUR TURN"; S_FAIL="FAILED"
  S_WOULD="WOULD DO"; V_EMPTYEXT="the extension list came back empty"; F_EXTEMPTY="open the editor once and run me again"
  T_HEAD="AI Bootcamp - workstation setup"
  T_INTRO="I install what the course needs. I delete nothing and touch your own files only after asking."
  T_DRY="DRY RUN: I only say what I would do. I change nothing."
  T_TIME="Takes 5-15 minutes, mostly downloading."
  L_WSL="Linux under Windows"; L_ARCH="Processor"; L_GIT="git"; L_GITID="Name in the history"
  L_NODE="Node.js"; L_CLI="Claude Code in the terminal"; L_CODE="Editor"
  L_EXT="Claude Code in the editor"; L_GH="Uploading to GitHub"; L_GHAUTH="GitHub sign-in"
  L_LOGIN="Claude sign-in"
  L_BROWSER="Browser from Ubuntu"
  W_WSLU="without it the GitHub and Claude sign-ins cannot open a browser"
  V_NOBROWSER="nothing to open it with"
  W_GIT="keeps your project's history and lets you go back"
  W_GITID="your changes are signed with this name, and everyone can see it"
  W_NODE="your checks will run on it"
  W_CLI="this is the AI that does the work; you use it every session"
  W_CODE="this is where you see your project and edit it"
  W_EXT="the same AI, but inside the editor"
  W_GH="without it nobody but you will see your page"
  V_OK="done"; V_FOUND="present"; V_VER="version"; V_NOTWSL="this is not WSL"
  V_WSL1="looks like WSL1"; V_ARCHBAD="not x86-64, the downloads will not fit"
  V_SKIP="skipped"; V_NONET="download failed"
  V_WINDOWS="installed in Windows, not from here"; V_SIGNED="signed in"
  V_NOTSIGNED="not signed in"; V_PATH="added to PATH"
  Q_YN="(y/n)"; Q_YES="y"; Q_NICK="Pick a nickname in Latin letters (no first or last name):"
  Q_GITID="Write the nickname and a placeholder e-mail into your git settings?"
  Q_BASHRC="Append one line to ~/.bashrc so the commands are found?"
  Q_GHAUTH="Sign in to GitHub now? A browser opens with an eight-character code."
  Q_APT="Start the installation? It needs a password - fetch a parent."
  A_NO="understood, leaving it alone"
  ROOT_HEAD="AN ADULT IS NEEDED HERE"
  ROOT_WHY="This cannot be installed without an administrator password. Once, at the very start."
  ROOT_WHO="Fetch a parent or ask for the password. Nothing else needs one."
  F_NOTWSL="the course runs in Ubuntu under Windows. In PowerShell: wsl --install -d Ubuntu"
  F_WSL1="in PowerShell as administrator: wsl --set-version Ubuntu 2"
  F_ARCH="write to the trainer, we will find another way"
  F_CODE="in Windows: winget install Microsoft.VisualStudioCode, then add the WSL extension"
  F_CODE2="then in the editor: Ctrl+Shift+P, 'WSL: Connect to WSL', and run me again"
  F_PSPATH="in Windows PowerShell, run this file - here is its path:"
  F_GHACC="you need a free GitHub account: github.com/signup (13 and over, a parent's e-mail works)"
  F_LOGIN="run: claude    then /login and sign in with a parent's account"
  F_RESTART="close the terminal, open it again and run me once more"
  M_HEAD="What is left for you:"
  M_CHECK="run the check and send the trainer its last line:"
  R_GOOD="THE WORKSTATION IS READY"; R_PART="NOT EVERYTHING IS DONE"
  R_DONE="Installed:"; R_LEFT="Left for you:"; R_FAILED="Failed:"
;;
esac

DONE=0; LEFT=0; BROKE=0

g() { printf '\033[32m%s\033[0m' "$1"; }
r() { printf '\033[31m%s\033[0m' "$1"; }
y() { printf '\033[33m%s\033[0m' "$1"; }
b() { printf '\033[1m%s\033[0m' "$1"; }
dim() { printf '\033[2m%s\033[0m' "$1"; }

# ALIGNMENT IS COUNTED IN CHARACTERS, NOT BYTES - the same reason as in
# check-setup.sh: printf '%-32s' counts bytes and Cyrillic takes two.
pad() { local s="$1" n="$2" k; k=$(( n - ${#s} )); [ "$k" -lt 1 ] && k=1
        printf '%s%*s' "$s" "$k" ''; }
MARKW=${#S_DONE}
for w in "$S_HAVE" "$S_YOU" "$S_FAIL" "$S_WOULD"; do [ ${#w} -gt "$MARKW" ] && MARKW=${#w}; done
lbl() { pad "$1" $(( 28 + MARKW - $2 )); }

row()  { printf '  [ %s ] %s %s\n' "$2" "$(lbl "$1" "$3")" "$4"; }
did()  { if [ "$DRYRUN" -eq 1 ]; then row "$1" "$(y "$S_WOULD")" ${#S_WOULD} "$2"
         else row "$1" "$(g "$S_DONE")" ${#S_DONE} "$2"; DONE=$((DONE+1)); fi; }
had()  { row "$1" "$(dim "$S_HAVE")" ${#S_HAVE} "$2"; }
yours(){ row "$1" "$(y "$S_YOU")" ${#S_YOU} "$2"; LEFT=$((LEFT+1))
         [ -n "${3:-}" ] && printf '         %s %s\n' "$(dim '->')" "$3"; return 0; }
broke(){ row "$1" "$(r "$S_FAIL")" ${#S_FAIL} "$2"; BROKE=$((BROKE+1))
         [ -n "${3:-}" ] && printf '         %s %s\n' "$(dim '->')" "$3"; return 0; }
why()  { printf '         %s %s\n' "$(dim '~')" "$(dim "$1")"; }

# EVERY COMMAND IS SHOWN BEFORE IT RUNS, DIMMED. The screen names the product;
# this line is where a curious participant sees the mechanism. Under --dry-run
# the line is printed and the command is not run.
run() {
  printf '         %s %s\n' "$(dim '$')" "$(dim "$*")"
  [ "$DRYRUN" -eq 1 ] && return 0
  "$@" >/dev/null 2>&1
}
runsh() {
  printf '         %s %s\n' "$(dim '$')" "$(dim "$1")"
  [ "$DRYRUN" -eq 1 ] && return 0
  bash -c "$1" >/dev/null 2>&1
}

# ASKING IS NEVER SKIPPED FOR A FILE THE PARTICIPANT OWNS. --yes answers the
# ordinary questions; the two that write into $HOME outside our own directories
# pass force=own and are asked anyway.
ask() {
  local q="$1" force="${2:-}" a
  if [ "$DRYRUN" -eq 1 ]; then printf '         %s %s %s\n' "$(dim '?')" "$(dim "$q")" "$(dim "[$V_SKIP]")"; return 1; fi
  if [ "$ASSUME_YES" -eq 1 ] && [ "$force" != "own" ]; then return 0; fi
  printf '         %s %s %s ' "$(y '?')" "$q" "$Q_YN"
  read -r a </dev/tty 2>/dev/null || return 1
  case "$a" in [$Q_YES]*|[Yy]*|[Дд]*|[Тт]*|[Jj]*) return 0 ;; *) printf '         %s %s\n' "$(dim '->')" "$(dim "$A_NO")"; return 1 ;; esac
}

echo
echo "  $(b "$T_HEAD")"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "  ------------------------------------------------------------------"
[ "$DRYRUN" -eq 1 ] && { echo "  $(y "$T_DRY")"; echo; }
echo "  $T_INTRO"
echo "  $(dim "$T_TIME")"
echo

# ---------------------------------------------------------------- 1. WSL2
# NOTHING BELOW CAN BE FIXED FROM HERE IF THIS FAILS, so it stops instead of
# installing into a place the course does not support.
if ! grep -qi microsoft /proc/version 2>/dev/null; then
  broke "$L_WSL" "$V_NOTWSL" "$F_NOTWSL"; echo; exit 1
fi
case "$(uname -r)" in
  *WSL2*|*microsoft-standard*) had "$L_WSL" "$V_FOUND" ;;
  *) broke "$L_WSL" "$V_WSL1" "$F_WSL1"; echo; exit 1 ;;
esac

ARCH=$(uname -m)
case "$ARCH" in
  x86_64|amd64) had "$L_ARCH" "$ARCH" ;;
  *) broke "$L_ARCH" "$ARCH - $V_ARCHBAD" "$F_ARCH" ;;
esac

# ---------------------------------------------------------------- 2. apt: git, wslu
# THE ONLY STEP THAT CAN NEED A PASSWORD, AND IT IS PRINTED AS A BLOCK.
#
# TWO PACKAGES, ONE PASSWORD, ONE ADULT. Asking twice would mean calling a
# parent twice, so what apt owns is collected and installed in one go.
#
# WHY `wslu` IS NOT OPTIONAL HERE. Both sign-ins below hand a URL to a browser:
# `gh auth login --web` and, later, `claude` with `/login`. A fresh Ubuntu under
# WSL has no browser to hand it to, and `wslu` is what makes `xdg-open` reach the
# browser already running in Windows. Found 2026-10-08 on the conductor's own
# machine: without it the device flow printed its code and never completed, and
# the only visible error came from snapd about mount namespaces - a message that
# names neither the browser nor the cause. A participant would have read that as
# the course being broken.
if command -v git >/dev/null 2>&1; then
  had "$L_GIT" "$V_VER $(git --version | awk '{print $3}')"
fi
if command -v wslview >/dev/null 2>&1; then
  had "$L_BROWSER" "$V_FOUND"
fi

NEEDAPT=""
command -v git     >/dev/null 2>&1 || NEEDAPT="$NEEDAPT git"
command -v wslview >/dev/null 2>&1 || NEEDAPT="$NEEDAPT wslu"

if [ -n "$NEEDAPT" ]; then
  echo
  echo "  $(y "$ROOT_HEAD")"
  echo "  $ROOT_WHY"
  echo "  $(dim "$ROOT_WHO")"
  echo
  case "$NEEDAPT" in *git*)  yours "$L_GIT" "$V_NOTSIGNED" ""; why "$W_GIT" ;; esac
  case "$NEEDAPT" in *wslu*) yours "$L_BROWSER" "$V_NOBROWSER" ""; why "$W_WSLU" ;; esac
  if ask "$Q_APT"; then
    runsh "sudo apt-get update && sudo apt-get install -y$NEEDAPT"
    case "$NEEDAPT" in *git*)
      if command -v git >/dev/null 2>&1; then did "$L_GIT" "$V_OK"; LEFT=$((LEFT-1)); fi ;;
    esac
    case "$NEEDAPT" in *wslu*)
      if command -v wslview >/dev/null 2>&1; then did "$L_BROWSER" "$V_OK"; LEFT=$((LEFT-1)); fi ;;
    esac
  fi
fi

# ---------------------------------------------------------------- 3. git identity
# A NICKNAME, NOT A NAME. Every commit carries user.name and user.email, the
# work is handed in through a public pull request, and the repository's own
# rule is that no participant's identity reaches it. The gate-keeper already
# refuses to print the name on screen; this is the other end of the same rule.
if command -v git >/dev/null 2>&1; then
  GN=$(git config --global user.name 2>/dev/null || true)
  GM=$(git config --global user.email 2>/dev/null || true)
  if [ -n "$GN" ] && [ -n "$GM" ]; then
    had "$L_GITID" "$V_FOUND"
  else
    yours "$L_GITID" "$V_NOTSIGNED" ""
    why "$W_GITID"
    if ask "$Q_GITID" own; then
      printf '         %s %s ' "$(y '?')" "$Q_NICK"
      NICK=""; read -r NICK </dev/tty 2>/dev/null || true
      NICK=$(printf '%s' "$NICK" | tr -cd 'A-Za-z0-9._-')
      if [ -n "$NICK" ]; then
        run git config --global user.name "$NICK"
        run git config --global user.email "$NICK@users.noreply.github.com"
        did "$L_GITID" "$NICK"; LEFT=$((LEFT-1))
      fi
    fi
  fi
fi

# ---------------------------------------------------------------- 4. PATH for $HOME tools
# gh GOES INTO ~/.local/bin SO THAT NO STEP NEEDS ROOT. That directory is on
# PATH on a fresh Ubuntu only after a login shell has seen it exist, so it is
# exported here for this run and offered for the next one.
mkdir -p "$HOME/.local/bin"
case ":$PATH:" in
  *":$HOME/.local/bin:"*) : ;;
  *) PATH="$HOME/.local/bin:$PATH"
     if ! grep -qs 'HOME/.local/bin' "$HOME/.bashrc"; then
       if ask "$Q_BASHRC" own; then
         [ "$DRYRUN" -eq 1 ] || printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
         did "PATH" "$V_PATH"
       fi
     fi ;;
esac

# ---------------------------------------------------------------- 5. Node.js
# nvm, NOT apt. nvm installs into $HOME, which keeps both this step and the
# global npm install below out of root's way entirely.
node_major() { command -v node >/dev/null 2>&1 && node -v 2>/dev/null | tr -d 'v' | cut -d. -f1; }
NM=$(node_major || true)
if [ -n "${NM:-}" ] && [ "$NM" -ge "$NODE_MIN" ] 2>/dev/null; then
  had "$L_NODE" "$V_VER $(node -v)"
else
  yours "$L_NODE" "$V_NOTSIGNED" ""
  why "$W_NODE"
  if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    runsh "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash"
  fi
  if [ -s "$HOME/.nvm/nvm.sh" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.nvm/nvm.sh"
    runsh ". \"\$HOME/.nvm/nvm.sh\" && nvm install --lts"
    [ "$DRYRUN" -eq 1 ] || { . "$HOME/.nvm/nvm.sh"; nvm use --lts >/dev/null 2>&1 || true; }
    NM=$(node_major || true)
    if [ -n "${NM:-}" ] && [ "$NM" -ge "$NODE_MIN" ] 2>/dev/null; then
      did "$L_NODE" "$V_VER $(node -v)"; LEFT=$((LEFT-1))
    elif [ "$DRYRUN" -eq 0 ]; then
      broke "$L_NODE" "$V_NONET" "$F_RESTART"
    fi
  elif [ "$DRYRUN" -eq 0 ]; then
    broke "$L_NODE" "$V_NONET" "$F_RESTART"
  fi
fi

# ---------------------------------------------------------------- 6. Claude Code CLI
# npm -g WITHOUT ROOT. With nvm's node the prefix is already inside $HOME. If
# node came from somewhere root owns, the prefix is moved into $HOME instead of
# reaching for sudo.
if command -v claude >/dev/null 2>&1; then
  had "$L_CLI" "$(claude --version 2>/dev/null | head -1)"
elif command -v npm >/dev/null 2>&1; then
  yours "$L_CLI" "$V_NOTSIGNED" ""
  why "$W_CLI"
  PREFIX=$(npm config get prefix 2>/dev/null || echo "")
  if [ -n "$PREFIX" ] && [ ! -w "$PREFIX" ]; then
    run npm config set prefix "$HOME/.npm-global"
    PATH="$HOME/.npm-global/bin:$PATH"
    if ! grep -qs 'npm-global/bin' "$HOME/.bashrc"; then
      if ask "$Q_BASHRC" own; then
        [ "$DRYRUN" -eq 1 ] || printf '\nexport PATH="$HOME/.npm-global/bin:$PATH"\n' >> "$HOME/.bashrc"
      fi
    fi
  fi
  run npm install -g @anthropic-ai/claude-code
  if command -v claude >/dev/null 2>&1; then
    did "$L_CLI" "$(claude --version 2>/dev/null | head -1)"; LEFT=$((LEFT-1))
  elif [ "$DRYRUN" -eq 0 ]; then
    broke "$L_CLI" "$V_NONET" "$F_RESTART"
  fi
else
  yours "$L_CLI" "$V_SKIP" "$F_RESTART"
fi

# ---------------------------------------------------------------- 7. The editor
# VS CODE IS A WINDOWS PROGRAM AND THIS SCRIPT RUNS IN UBUNTU. It is not
# installed from here and the script does not pretend otherwise: it says where
# the one command belongs. The extension, by contrast, is installed through the
# `code` command that WSL exposes once the editor is connected.
IDE=""
for c in code antigravity-ide; do command -v "$c" >/dev/null 2>&1 && { IDE="$c"; break; }; done
if [ -z "$IDE" ]; then
  yours "$L_CODE" "$V_WINDOWS" "$F_PSPATH"
  WINPATH="\\\\wsl$\\${WSL_DISTRO_NAME:-Ubuntu}$(printf '%s' "$PWD" | tr '/' '\\')\\setup-windows.ps1"
  printf '         %s %s\n' "$(dim '>')" "$(b "$WINPATH -Lang $LANGCHOICE")"
  printf '         %s %s\n' "$(dim '->')" "$F_CODE"
  printf '         %s %s\n' "$(dim '->')" "$F_CODE2"
  why "$W_CODE"
  yours "$L_EXT" "$V_SKIP" ""
else
  had "$L_CODE" "$IDE"
  EXTLIST=$("$IDE" --list-extensions 2>/dev/null || true)
  if printf '%s' "$EXTLIST" | grep -qi claude; then
    had "$L_EXT" "$V_FOUND"
  else
    why "$W_EXT"
    run "$IDE" --install-extension anthropic.claude-code
    EXTAFTER=$("$IDE" --list-extensions 2>/dev/null || true)
    # AN EMPTY LIST IS NOT A FAILED INSTALL - the same rule the gate-keeper
    # states: the editor may never have been opened, or another profile is
    # active, and calling that a failure asserts what was not established.
    if [ "$DRYRUN" -eq 1 ] || printf '%s' "$EXTAFTER" | grep -qi claude; then
      did "$L_EXT" "$V_OK"
    elif [ -z "$EXTAFTER" ]; then
      yours "$L_EXT" "$V_EMPTYEXT" "$F_EXTEMPTY"
    else
      broke "$L_EXT" "$V_NONET" "$F_CODE2"
    fi
  fi
fi

# ---------------------------------------------------------------- 8. gh
# THE STEP THAT MAKES SESSION ONE POSSIBLE. The page has to leave the machine,
# and `gh` is how a participant creates the repository, pushes and turns on
# Pages without ever handling a token. Installed as a tarball into
# ~/.local/bin, so it needs no password either.
if command -v gh >/dev/null 2>&1; then
  had "$L_GH" "$V_VER $(gh --version 2>/dev/null | head -1 | awk '{print $3}')"
else
  yours "$L_GH" "$V_NOTSIGNED" ""
  why "$W_GH"
  GHVER=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/cli/cli/releases/latest 2>/dev/null \
          | sed 's#.*/tag/v##' | tr -cd '0-9.')
  [ -z "$GHVER" ] && GHVER="$GH_FALLBACK"
  GHTGZ="gh_${GHVER}_linux_amd64"
  runsh "curl -fsSL https://github.com/cli/cli/releases/download/v${GHVER}/${GHTGZ}.tar.gz -o /tmp/${GHTGZ}.tar.gz && tar -xzf /tmp/${GHTGZ}.tar.gz -C /tmp && install -m 0755 /tmp/${GHTGZ}/bin/gh \"\$HOME/.local/bin/gh\" && rm -rf /tmp/${GHTGZ} /tmp/${GHTGZ}.tar.gz"
  if command -v gh >/dev/null 2>&1; then
    did "$L_GH" "$V_VER $GHVER"; LEFT=$((LEFT-1))
  elif [ "$DRYRUN" -eq 0 ]; then
    broke "$L_GH" "$V_NONET" "$F_RESTART"
  fi
fi

# gh SIGN-IN IS OFFERED, NEVER FORCED, AND NEVER DONE WITH SOMEONE ELSE'S
# ACCOUNT. If there is no account yet the script says where to make one rather
# than failing with a word a participant cannot act on.
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then
    had "$L_GHAUTH" "$V_SIGNED"
  else
    yours "$L_GHAUTH" "$V_NOTSIGNED" "$F_GHACC"
    if ask "$Q_GHAUTH"; then
      printf '         %s %s\n' "$(dim '$')" "$(dim 'gh auth login --web --git-protocol https')"
      [ "$DRYRUN" -eq 1 ] || gh auth login --web --git-protocol https </dev/tty
      if gh auth status >/dev/null 2>&1; then did "$L_GHAUTH" "$V_SIGNED"; LEFT=$((LEFT-1)); fi
    fi
  fi
fi

# ---------------------------------------------------------------- 9. Claude sign-in
# NEVER AUTOMATED, BY DECISION. The subscription is a parent's and the script
# does not touch someone else's account.
NEEDLOGIN=0
if ! command -v claude >/dev/null 2>&1 || [ -z "$(ls -A "$HOME/.claude" 2>/dev/null)" ]; then
  NEEDLOGIN=1
fi

# ---------------------------------------------------------------- the end
echo
echo "  ------------------------------------------------------------------"
if [ "$BROKE" -eq 0 ] && [ "$LEFT" -eq 0 ]; then
  printf '  %s  %s %s\n' "$(g "$R_GOOD")" "$R_DONE" "$DONE"
else
  printf '  %s  %s %s' "$(y "$R_PART")" "$R_DONE" "$DONE"
  [ "$LEFT"  -gt 0 ] && printf '   %s %s' "$R_LEFT" "$LEFT"
  [ "$BROKE" -gt 0 ] && printf '   %s %s' "$(r "$R_FAILED")" "$BROKE"
  echo
fi
echo
echo "  $M_HEAD"
[ "$NEEDLOGIN" -eq 1 ] && echo "    $L_LOGIN: $F_LOGIN"
echo "    $M_CHECK"
echo "      ./check-setup.sh --$LANGCHOICE"
echo

[ "$BROKE" -eq 0 ]
