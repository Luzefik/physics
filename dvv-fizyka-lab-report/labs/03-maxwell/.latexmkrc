#!/usr/bin/env perl
# Конфігурація latexmk: примусово XeLaTeX + BibTeX.
# Overleaf це також підхоплює через "% !TeX program = xelatex" у main.tex.
#
# Свідомо НЕ biber: biber — це окремий важкий процес плюс два зайві проходи
# XeLaTeX через .bcf/.run.xml. На безкоштовному плані Overleaf саме це
# з'їдало більшу частину ліміту часу компіляції.

$pdf_mode = 1;
$pdflatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
$bibtex = 'bibtex %O %B';
$bibtex_use = 2;

# Голий `latexmk` без аргументів збирає .tex-файл із поточного каталогу.
# Кожна лаба в labs/<назва>/ — самодостатня папка зі своїм main.tex,
# ucaphyslab.cls, assets/ та цим файлом, тому latexmk запускають
# усередині конкретної папки лаби: cd labs/<назва> && latexmk
#
# Цей .latexmkrc продубльований у корені (шаблон-джерело) та в кожній
# labs/*/ — побайтово ідентичний скрізь. Онови один раз через
# scripts/sync-shared.sh, який розкладе зміну по всіх копіях; CI
# (.github/workflows/build.yml) перевіряє, що вони не розійшлися.
@default_files = glob('*.tex');

$clean_ext = 'bbl blg synctex.gz fdb_latexmk fls';
