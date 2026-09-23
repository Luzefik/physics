#!/usr/bin/env perl
# Ця лаба сама по собі містить лише main.tex, references.bib та методичку
# (якщо є). ucaphyslab.cls, .latexmkrc-налаштування й логотипи — спільні,
# один-єдиний раз, у ../../latex/ (див. звідти). Цей файл лише підключає їх:
# додає ../../latex/ у TEXINPUTS, щоб xelatex знайшов там ucaphyslab.cls і
# зображення логотипів, і дублює саму конфігурацію компіляції (latexmk не
# шукає .latexmkrc у батьківських каталогах, тому без копії тут не обійтись).
#
# Не редагуйте цей файл вручну в конкретній лабі — якщо треба змінити
# конфігурацію компіляції для всіх лаб, редагуйте latex/.latexmkrc і
# скопіюйте зміну сюди ж (файл навмисно однаковий у кожній labs/*/, окрім
# автоматично обчисленого jobname нижче).

use Cwd;
use File::Basename;

my $shared = Cwd::abs_path('../../latex');
$ENV{'TEXINPUTS'} = "$shared//:" . ($ENV{'TEXINPUTS'} // '');
$ENV{'BSTINPUTS'} = "$shared//:" . ($ENV{'BSTINPUTS'} // '');

# Вихідний PDF називається як тека лаби (напр. 04-atwood.pdf), а не main.pdf —
# jobname обчислюється з назви поточної теки, тому цей рядок не треба
# правити вручну під кожну лабу.
$jobname = basename(Cwd::getcwd());

$pdf_mode = 1;
$pdflatex = 'xelatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';
$bibtex = 'bibtex %O %B';
$bibtex_use = 2;

@default_files = glob('*.tex');

$clean_ext = 'bbl blg synctex.gz fdb_latexmk fls';
