# Physics Lab Reports

Звіти з лабораторних робіт (ДВВ «Основи прикладної фізики», УКУ), LaTeX.

https://docs.google.com/spreadsheets/d/17TN7GFV0l6zM1AK0DieCDqUy5HemCSIcZ0o4taTAYok/edit?usp=sharing -- таблиці


## Структура

```
labs/
├── 01-pendulums/   Математичний і фізичний (оборотний) маятники
├── 02-oberbeck/    Маятник Обербека
├── 03-maxwell/     Маятник Максвелла
├── 04-atwood/      Машина Атвуда
└── _template/      Порожній темплейт для нової лаби

latex/              Спільні файли: ucaphyslab.cls, логотипи, .latexmkrc
```

Кожна папка в `labs/` містить `main.tex` (редагуй тільки його — назву,
студента, дату, зміст секцій), `references.bib` і методичку (PDF), якщо
вона є. Стилі, шрифти й логотип — спільні, лежать у `latex/`; не редагуй
`ucaphyslab.cls`.

Нова лаба — скопіюй `labs/_template/` під новою назвою (`labs/05-.../`).

## Компіляція

Локально (потрібен XeLaTeX, напр. MacTeX/TeX Live):

```bash
cd labs/04-atwood      # тека потрібної лаби
latexmk main.tex       # компіляція (XeLaTeX + BibTeX)
latexmk -c              # прибрати артефакти збірки, лишити PDF
latexmk -C              # повне очищення разом із PDF
```

Overleaf: **New Project → GitHub repo**, імпортуй увесь репозиторій, тоді
в **Menu → Main document** вибери потрібний `labs/<лаба>/main.tex`.

Кожен пуш/PR також автоматично збирається в CI
(`.github/workflows/build.yml`) — готові PDF можна забрати з вкладки
Actions.
