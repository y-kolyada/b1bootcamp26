#!/usr/bin/env bash
# AI Bootcamp - byte-level properties that travel silently, or do not.
# / свойства, которые не видно при чтении: бит исполнения и BOM.
#
#     tools/check-modes.sh            check the course and the template
#     tools/check-modes.sh REPO ...   check the named repositories
#
# NOT FOR PARTICIPANTS. A maintainer's check, in tools/ for that reason.
#
# WHY IT EXISTS. On 2026-10-08 a participant's path was walked on a fresh copy
# for the first time, and the very first command of the template's README -
# `./check.sh` - died with "Permission denied". git had recorded the file as
# 100644. The same was true of setup.sh, the first command of «Твой ход 0».
#
# WHY NOBODY SAW IT. This working tree lives on /mnt/c, a Windows filesystem,
# where every file reads as rwxrwxrwx no matter what git stored, and git itself
# sets core.filemode=false there. `chmod +x` is accepted and changes nothing;
# `ls -l` shows the bit; a local run works. The defect is invisible from here
# and certain on the child's machine. That asymmetry is the whole reason this
# check reads the INDEX and never the filesystem.
#
# WHAT IT CAN REDDEN:
#   1. any *.sh that git holds as 100644 - the state it was written in;
#   2. any *.ps1 without a UTF-8 BOM.
#
# WHY THE BOM IS HERE, BESIDE THE EXECUTABLE BIT. They are the same class of
# defect: a property that is invisible when reading the file, that no editor
# shows, and whose loss produces an error naming something else entirely.
# Without the BOM, Windows PowerShell 5.1 reads the file as the ANSI code page
# and the Cyrillic breaks the parse with «Unexpected token» - five errors, none
# of which mentions encoding. Recorded twice: when the file was written
# (2026-10-08), and when it was carried to a second host (2026-10-09), where the
# bytes arrived intact and the marker did not.

set -uo pipefail

HERE=$(cd "$(dirname "$0")/.." && pwd)
REPOS=("$@")
[ ${#REPOS[@]} -eq 0 ] && REPOS=("$HERE" "$HERE/../b1bootcamp26-template")

BAD=0
r() { printf '\033[31m%s\033[0m' "$1"; }
g() { printf '\033[32m%s\033[0m' "$1"; }

echo
echo "  Что записал git: бит исполнения и BOM"
echo "  ----------------------------------------------"

for repo in "${REPOS[@]}"; do
  name=$(basename "$(cd "$repo" 2>/dev/null && pwd || echo "$repo")")
  if ! git -C "$repo" rev-parse --git-dir >/dev/null 2>&1; then
    # A submodule nobody initialised is not a green result and not a failure.
    echo "  $name: НЕ РЕПОЗИТОРИЙ - пропущен, не проверен"
    continue
  fi

  n=0
  while read -r mode _ _ path; do
    [ -z "${path:-}" ] && continue
    n=$((n+1))
    if [ "$mode" != "100755" ]; then
      echo "  $name/$path: $(r "$mode") - должно быть 100755"
      echo "      -> git -C $repo update-index --chmod=+x $path"
      BAD=$((BAD+1))
    fi
  done < <(git -C "$repo" ls-files -s -- '*.sh')

  [ "$n" -eq 0 ] && echo "  $name: НИ ОДНОГО .sh - проверять нечего"
  [ "$n" -gt 0 ] && [ "$BAD" -eq 0 ] && echo "  $name: .sh в индексе - $n, бит на месте у всех"

  # BOM у каждого .ps1: читаем ИЗ GIT, а не с диска - на диске файл может быть
  # починен локально, а в репозиторий уехать без маркера.
  while read -r _mode _hash _stage path; do
    [ -z "${path:-}" ] && continue
    head=$(git -C "$repo" show ":$path" 2>/dev/null | head -c 3 | od -An -tx1 | tr -d ' \n')
    if [ "$head" = "efbbbf" ]; then
      echo "  $name/$path: $(g 'BOM на месте')"
    else
      echo "  $name/$path: $(r 'НЕТ BOM') - первые байты: ${head:-пусто}"
      echo "      -> Windows PowerShell прочитает файл как ANSI и упадёт на кириллице"
      BAD=$((BAD+1))
    fi
  done < <(git -C "$repo" ls-files -s -- '*.ps1')
done

echo "  ----------------------------------------------"
if [ "$BAD" -eq 0 ]; then printf '  %s\n\n' "$(g 'ВСЁ СОШЛОСЬ')"
else printf '  %s - .sh без бита - их: %s\n\n' "$(r 'НЕ СОШЛОСЬ')" "$BAD"; fi
[ "$BAD" -eq 0 ]
