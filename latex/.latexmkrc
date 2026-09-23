#!/usr/bin/env perl
# Еталонна конфігурація latexmk для цього репозиторію: примусово XeLaTeX +
# BibTeX. Overleaf підхоплює те саме через "% !TeX program = xelatex" у
# main.tex кожної лаби.
#
# Свідомо НЕ biber: biber — це окремий важкий процес плюс два зайві проходи
# XeLaTeX через .bcf/.run.xml. На безкоштовному плані Overleaf саме це
# з'їдало більшу частину ліміту часу компіляції.
#
# ЦЕЙ файл сюди, у latex/, покладений для довідки й НЕ використовується
# напряму: latexmk шукає .latexmkrc лише в поточному каталозі (без обходу
# батьківських), тому реальна компіляція лаби відбувається з копією, що
# лежить у кожній labs/<назва>/ — вона лише вказує TEXINPUTS на цей спільний
# каталог, а не дублює ucaphyslab.cls чи логотипи (див. коментар там).

$pdf_mode = 1;
$pdflatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
$bibtex = 'bibtex %O %B';
$bibtex_use = 2;

@default_files = glob('*.tex');

$clean_ext = 'bbl blg synctex.gz fdb_latexmk fls';
