#!/usr/bin/env bash
# Розкладає спільні файли з кореня репозиторію (ucaphyslab.cls, .latexmkrc,
# assets/, references.bib) по всіх самодостатніх папках labs/*/.
#
# Кожна лаба в labs/<назва>/ має власні копії цих файлів, щоб коректно
# компілюватись і локально, і в Overleaf (zip-завантаження чи GitHub-імпорт
# конкретної підпапки), без symlink'ів. Корінь репозиторію лишається
# єдиним джерелом правди для спільних файлів — редагуйте їх тільки тут,
# а тоді запустіть цей скрипт, щоб розкласти зміну по лабах.
#
# references.bib НЕ перезаписується скриптом, якщо в лабі він уже
# відрізняється від кореневого (у кожної лаби зазвичай свій список джерел) —
# копіюється тільки якщо файла в лабі ще немає.
#
# Використання:
#   ./scripts/sync-shared.sh

set -euo pipefail
cd "$(dirname "$0")/.."

if [ ! -d labs ]; then
  echo "labs/ не знайдено — запускайте скрипт з кореня репозиторію." >&2
  exit 1
fi

for dir in labs/*/; do
  name="$(basename "$dir")"
  cp ucaphyslab.cls "$dir"
  cp .latexmkrc "$dir"
  cp -R assets "$dir"
  if [ ! -f "${dir}references.bib" ]; then
    cp references.bib "$dir"
  fi
  echo "synced: $name"
done

echo "Готово. Перевірте 'git diff' перед комітом."
