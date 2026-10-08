#!/usr/bin/env bash
# AI Bootcamp - the four key sets, compared / сверка четырёх наборов строк.
#
#     tools/check-strings.sh            check every script
#     tools/check-strings.sh FILE ...   check the named scripts
#
# NOT FOR PARTICIPANTS. This is a maintainer's check and lives in tools/ for
# that reason; nothing a participant is asked to run touches this directory.
#
# WHY IT EXISTS. check-setup.sh carries four languages in one file and its own
# header says the arrangement is safe because "a checker compares the four key
# sets, because 'visible at a glance' is not a verification". That checker was
# never written - found 2026-10-08 - so for two weeks the file asserted a
# verification that did not exist. This is it.
#
# WHAT IT CAN REDDEN, which is the point of having it:
#   1. a key set in one language that another language is missing;
#   2. a key the script body uses and some language never defines - the case
#      that prints an empty value on a child's screen in one language only;
#   3. a key every language defines and nobody uses - dead weight that drifts.

set -uo pipefail

cd "$(dirname "$0")/.." || exit 2
FILES=("$@")
[ ${#FILES[@]} -eq 0 ] && FILES=(check-setup.sh setup.sh)

LANGS=(ru uk de en)
BAD=0

# The English block is the `*)` fallback, not `en)`, in both scripts: it is also
# the default, and a separate `en)` clause would have to be kept identical to it.
# Written as [)] rather than \) because awk takes these as dynamic regexes and
# warns on an escape it does not need. The last block is `*)`, not `en)`.
block_pattern() { case "$1" in en) printf '^[*][)]' ;; *) printf '^%s[)]' "$1" ;; esac; }

keys_of() {
  awk -v start="$2" '
    $0 ~ start { inb = 1; next }
    # ru, uk and de end at `;;`; the `*)` block is last and ends at `esac`.
    inb && (/^[[:space:]]*;;[[:space:]]*$/ || /^esac$/) { inb = 0 }
    inb { print }
  ' "$1" | grep -oE '(^|[[:space:]])[A-Z][A-Z0-9_]*=' | tr -d ' =' | sort -u
}

body_of() {
  # everything outside the case statement that holds the language blocks
  awk '/^case "\$LANGCHOICE" in$/ { inc = 1 } /^esac$/ && inc { inc = 0; next } !inc { print }' "$1"
}

for f in "${FILES[@]}"; do
  [ -r "$f" ] || { echo "НЕТ ФАЙЛА: $f"; BAD=$((BAD+1)); continue; }
  echo "  $f"
  REF=$(keys_of "$f" "$(block_pattern ru)")
  REFN=$(printf '%s\n' "$REF" | grep -c . || true)
  if [ "$REFN" -eq 0 ]; then
    echo "    ПУСТО: в блоке ru не нашлось ни одного ключа - разбор не сработал"
    BAD=$((BAD+1)); continue
  fi

  # 1 and 2: every language defines exactly the same keys
  for l in "${LANGS[@]}"; do
    K=$(keys_of "$f" "$(block_pattern "$l")")
    MISS=$(comm -23 <(printf '%s\n' "$REF") <(printf '%s\n' "$K"))
    EXTRA=$(comm -13 <(printf '%s\n' "$REF") <(printf '%s\n' "$K"))
    if [ -n "$MISS" ]; then
      echo "    $l: НЕТ КЛЮЧЕЙ: $(printf '%s' "$MISS" | tr '\n' ' ')"; BAD=$((BAD+1))
    fi
    if [ -n "$EXTRA" ]; then
      echo "    $l: ЛИШНИЕ КЛЮЧИ: $(printf '%s' "$EXTRA" | tr '\n' ' ')"; BAD=$((BAD+1))
    fi
  done

  # 3: a key no language is read by
  BODY=$(body_of "$f")
  # A key is read as $K, as ${K} or as ${#K} - all three count as read.
  #
  # THE HERE-STRING IS THE FIX, NOT A STYLE CHOICE. This was written as
  # `printf '%s' "$BODY" | grep -q ...`, and under `set -o pipefail` that lies:
  # grep exits at the first match, printf is still writing, printf dies of
  # SIGPIPE with 141, and the pipeline reports failure for a key that WAS found.
  # Whether it lies depends on where in the body the first match falls relative
  # to the pipe buffer, so the same file passed and failed on different days.
  # A check that reddens at random is worse than no check: it teaches that red
  # means nothing. Found 2026-10-08, on `V_KERNEL`, read at check-setup.sh:232.
  # The earlier `S_OK` false alarm had this cause too and was misdiagnosed as a
  # pattern bug; the pattern was fine both times.
  UNUSED=""
  for k in $REF; do
    grep -qE "[$]\{?#?${k}[^A-Z0-9_]" <<< "$BODY" || UNUSED="$UNUSED $k"
  done
  [ -n "$UNUSED" ] && { echo "    НИКТО НЕ ЧИТАЕТ:$UNUSED"; BAD=$((BAD+1)); }

  [ "$BAD" -eq 0 ] && echo "    $REFN ключей, четыре языка, расхождений нет"
done

echo
if [ "$BAD" -eq 0 ]; then echo "  ВСЁ СОШЛОСЬ"; else echo "  РАСХОЖДЕНИЙ: $BAD"; fi
[ "$BAD" -eq 0 ]
