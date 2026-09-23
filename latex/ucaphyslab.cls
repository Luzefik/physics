%% ucaphyslab.cls
%% Клас для звітів з лабораторних робіт ДВВ «Основи прикладної фізики» (1.26-27), УКУ.
%% Викладач: Володимир Коломієць.
%% Уся верстка та брендинг живуть тут — main.tex містить лише метадані й контент.
%% Вимагає компіляції XeLaTeX (fontspec + polyglossia).

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ucaphyslab}[2026/01/01 v1.0 UCU physics lab report template]

\RequirePackage{etoolbox}

%% ------------------------------------------------------------------
%% Опції класу
%% ------------------------------------------------------------------
\newtoggle{ucu@english}
\togglefalse{ucu@english}
\newtoggle{ucu@slogan}
\togglefalse{ucu@slogan}

\DeclareOption{ukrainian}{\togglefalse{ucu@english}}
\DeclareOption{english}{\toggletrue{ucu@english}}
\DeclareOption{slogan}{\toggletrue{ucu@slogan}}
\DeclareOption*{%
  \ClassWarningNoLine{ucaphyslab}{Невідома опція класу '\CurrentOption' буде проігнорована}%
}
\ExecuteOptions{ukrainian}
\ProcessOptions\relax

%% article підтримує лише 10/11/12pt.
\LoadClass[10pt,a4paper]{article}

%% ------------------------------------------------------------------
%% Базові пакети
%% ------------------------------------------------------------------
\RequirePackage{geometry}
\geometry{a4paper,left=22mm,right=22mm,top=25mm,bottom=25mm,headheight=14pt,headsep=8mm}

\RequirePackage{fontspec}
\RequirePackage{polyglossia}

\iftoggle{ucu@english}{%
  \setdefaultlanguage{english}
  \setotherlanguage{ukrainian}
}{%
  \setdefaultlanguage{ukrainian}
  \setotherlanguage{english}
}

\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{fancyhdr}
%% Формули та одиниці вимірювання.
\RequirePackage{amsmath}
\RequirePackage{siunitx}
%% Бібліографія — класичний BibTeX, а НЕ biblatex+biber (дешевша збірка,
%% той самий references.bib і ті самі \cite{}).
\RequirePackage{cite}

%% ------------------------------------------------------------------
%% Фірмовий колір УКУ (єдиний акцентний колір шаблону)
%% ------------------------------------------------------------------
\definecolor{ucured}{HTML}{7F1716}
\definecolor{ucutext}{HTML}{2B2B2B}
\definecolor{ucugray}{HTML}{8A8A8A}

\AtBeginDocument{\color{ucutext}}

%% ------------------------------------------------------------------
%% Шрифти: Charis SIL (текст) + Fira Sans (заголовки/титулка) + Fira Mono
%%
%% Гарнітури вантажаться за ІМЕНЕМ ФАЙЛУ (kpathsea), а не за назвою — це
%% швидше, ніж пошук через fontconfig. Резервний DejaVu лишається, тож
%% компіляція ніколи не падає через відсутній шрифт.
%% ------------------------------------------------------------------
\newtoggle{ucu@mainfontsc}
\togglefalse{ucu@mainfontsc}

\IfFontExistsTF{CharisSIL-Regular.ttf}{%
  \setmainfont{CharisSIL}[%
    Extension      = .ttf,
    UprightFont    = *-Regular,
    BoldFont       = *-Bold,
    ItalicFont     = *-Italic,
    BoldItalicFont = *-BoldItalic,
  ]%
  %% Капітельний варіант визначаємо ОДИН раз окремою гарнітурою замість
  %% \addfontfeature на кожному використанні — інакше XeLaTeX створює новий
  %% інстанс шрифту в кожному місці титулки.
  \newfontfamily\ucu@scfont{CharisSIL}[%
    Extension   = .ttf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
    Letters     = SmallCaps,
  ]%
  \toggletrue{ucu@mainfontsc}%
}{%
  \ClassWarningNoLine{ucaphyslab}{Шрифт 'Charis SIL' не знайдено. Використано резервний DejaVu Serif. Встановіть пакет TeX Live 'charissil' для коректного брендингу}%
  \IfFontExistsTF{DejaVuSerif.ttf}{%
    \setmainfont{DejaVuSerif}[%
      Extension      = .ttf,
      UprightFont    = *,
      BoldFont       = *-Bold,
      ItalicFont     = *-Italic,
      BoldItalicFont = *-BoldItalic,
    ]%
  }{%
    \ClassWarningNoLine{ucaphyslab}{Резервний шрифт 'DejaVu Serif' також не знайдено. Використано типовий шрифт LaTeX}%
  }%
}

%% Малі капітелі для титулки: справжня OpenType-функція Charis SIL,
%% або класичний \scshape як безпечний резерв для інших шрифтів.
\newcommand{\ucu@sc}[1]{%
  \iftoggle{ucu@mainfontsc}{{\ucu@scfont#1}}{{\scshape#1}}%
}

\IfFontExistsTF{FiraSans-Regular.otf}{%
  \setsansfont{FiraSans}[%
    Extension      = .otf,
    UprightFont    = *-Regular,
    BoldFont       = *-Bold,
    ItalicFont     = *-Italic,
    BoldItalicFont = *-BoldItalic,
  ]%
  % Накреслення заголовків: у брендбуці — Fira Sans SemiBold.
  \newfontfamily\ucuheadfont{FiraSans}[%
    Extension   = .otf,
    UprightFont = *-SemiBold,
    ItalicFont  = *-SemiBoldItalic,
  ]%
}{%
  \ClassWarningNoLine{ucaphyslab}{Шрифт 'Fira Sans' не знайдено. Використано резервний DejaVu Sans. Встановіть пакет TeX Live 'fira' для коректного брендингу}%
  \IfFontExistsTF{DejaVuSans.ttf}{%
    \setsansfont{DejaVuSans}[%
      Extension      = .ttf,
      UprightFont    = *,
      BoldFont       = *-Bold,
      ItalicFont     = *-Oblique,
      BoldItalicFont = *-BoldOblique,
    ]%
  }{%
    \ClassWarningNoLine{ucaphyslab}{Резервний шрифт 'DejaVu Sans' також не знайдено. Використано типовий шрифт LaTeX}%
  }%
  \newcommand{\ucuheadfont}{\sffamily\bfseries}%
}

\IfFontExistsTF{FiraMono-Regular.otf}{%
  \setmonofont{FiraMono}[%
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
}{%
  \ClassWarningNoLine{ucaphyslab}{Шрифт 'Fira Mono' не знайдено. Використано резервний DejaVu Sans Mono}%
  \IfFontExistsTF{DejaVuSansMono.ttf}{%
    \setmonofont{DejaVuSansMono}[%
      Extension   = .ttf,
      UprightFont = *,
      BoldFont    = *-Bold,
    ]%
  }{}%
}

\setlength{\parindent}{0pt}
\setlength{\parskip}{0.4em}
\linespread{1.15}

%% ------------------------------------------------------------------
%% Мовно-залежні підписи та ім'я файлу логотипу
%% ------------------------------------------------------------------
\iftoggle{ucu@english}{%
  \newcommand{\ucu@biblabel}{References}
  \newcommand{\ucu@labelstudent}{Performed by}
  \newcommand{\ucu@labelteacher}{Reviewed by}
  \newcommand{\ucu@labeldate}{Date performed}
  \newcommand{\ucu@pagelabel}{page}
  \newcommand{\ucu@superheader}{Elective Course \textperiodcentered\ \textquotedblleft Fundamentals of Applied Physics\textquotedblright\ (1.26-27) \textperiodcentered\ Lab Report \textperiodcentered\ 2026}
  \newcommand{\ucu@uniname}{Ukrainian Catholic University}
  \newcommand{\ucu@submittedline}{Lab report submitted for the}
  \newcommand{\ucu@courseline}{\textquotedblleft Fundamentals of Applied Physics\textquotedblright\ elective course (1.26-27)}
  \newcommand{\ucu@inthe}{in the}
  \newcommand{\ucu@facultyname}{Faculty of Applied Sciences}
}{%
  \newcommand{\ucu@biblabel}{Список джерел}
  \newcommand{\ucu@labelstudent}{Виконав(ла)}
  \newcommand{\ucu@labelteacher}{Перевірив(ла)}
  \newcommand{\ucu@labeldate}{Дата виконання}
  \newcommand{\ucu@pagelabel}{сторінка}
  \newcommand{\ucu@superheader}{ДВВ «Основи прикладної фізики» (1.26-27) \textperiodcentered\ Лабораторна робота \textperiodcentered\ 2026}
  \newcommand{\ucu@uniname}{Український Католицький Університет}
  \newcommand{\ucu@submittedline}{Звіт з лабораторної роботи, виконаної в межах ДВВ}
  \newcommand{\ucu@courseline}{«Основи прикладної фізики» (1.26-27)}
  \newcommand{\ucu@inthe}{}
  \newcommand{\ucu@facultyname}{Факультет прикладних наук}
}

%% Печатка УКУ та лого факультету — поки лише в англомовному варіанті
%% (окремих українських версій файлів не надано), тому спільні для обох мов.
\newcommand{\ucu@sealfile}{logo/uku_logo___seal_engl.png}
\newcommand{\ucu@facultylogofile}{logo/Applied_Sciences_ENG.png}

%% Офіційне гасло УКУ. Формулювання не перекладається й не перефразовується
%% незалежно від мовної опції класу.
\newcommand{\ucu@slogantext}{%
  {\addfontfeature{LetterSpace=10.0}\color{ucured}\small СВІДЧИТИ. СЛУЖИТИ. СПІЛКУВАТИСЯ.}%
}

%% ------------------------------------------------------------------
%% Заголовки секцій: Fira Sans SemiBold 12pt, колір ucured, лише рівень 1
%% ------------------------------------------------------------------
\setcounter{secnumdepth}{1}
\setcounter{tocdepth}{1}

\titleformat{\section}
  {\normalfont\ucuheadfont\fontsize{12}{14}\selectfont\color{ucured}}
  {\thesection.}{0.5em}{}
\titlespacing*{\section}{0pt}{1.1em}{0.5em}

\titleformat{\subsection}
  {\normalfont\ucuheadfont\fontsize{10.5}{13}\selectfont\color{ucured}}
  {}{0pt}{}
\titlespacing*{\subsection}{0pt}{0.9em}{0.4em}

%% ------------------------------------------------------------------
%% Списки: компактні, маркер — маленький квадрат ucured
%% ------------------------------------------------------------------
\setlist[itemize]{nosep,leftmargin=1.2em,label={\color{ucured}\rule{0.8ex}{0.8ex}}}
\setlist[enumerate]{nosep,leftmargin=1.4em}

%% ------------------------------------------------------------------
%% Блок "keyfacts" — врізка з ключовим результатом/формулою.
%% Реалізовано на голому боксі замість mdframed: врізка ніколи не розривається
%% між сторінками, тому вся машинерія mdframed тут була зайвою.
%% ------------------------------------------------------------------
\newsavebox{\ucu@kfbox}
\newenvironment{keyfacts}{%
  \par\addvspace{8pt}%
  \begin{lrbox}{\ucu@kfbox}%
  \begin{minipage}{\dimexpr\linewidth-12pt\relax}%
  \setlength{\parskip}{0.4em}%
}{%
  \end{minipage}%
  \end{lrbox}%
  \noindent
  %% Лінійка виступає на 6pt над і під вмістом — той самий внутрішній
  %% відступ, що давав mdframed (innertopmargin/innerbottommargin).
  {\color{ucured}\rule[-\dimexpr\dp\ucu@kfbox+6pt\relax]{2pt}%
    {\dimexpr\ht\ucu@kfbox+\dp\ucu@kfbox+12pt\relax}}%
  \hspace{10pt}\usebox{\ucu@kfbox}%
  \par\addvspace{8pt}%
}

%% ------------------------------------------------------------------
%% hyperref (завантажується майже останнім)
%% bookmarks=false + pdfpagelabels=false навмисно: і закладки, і мітки
%% сторінок (через \setcounter{page}{1} після титулки) змушували hyperref
%% просити "Rerun", тобто зайвий прохід XeLaTeX на кожній збірці.
%% ------------------------------------------------------------------
\RequirePackage[bookmarks=false,pdfpagelabels=false]{hyperref}
\hypersetup{
  colorlinks=true,
  allcolors=ucured,
  breaklinks=true,
}
\iftoggle{ucu@english}{\hypersetup{pdflang=en}}{\hypersetup{pdflang=uk}}
\urlstyle{same}

%% ------------------------------------------------------------------
%% Метадані звіту: командний інтерфейс main.tex
%% ------------------------------------------------------------------
\newcommand{\labtitle}[1]{\def\ucu@title{#1}}
\let\ucu@title\@empty

%% Необов'язковий підзаголовок під назвою — напр. номер роботи
%% ("Лабораторна робота № 3") або одне речення про суть досліду.
\newcommand{\labsubtitle}[1]{\def\ucu@tagline{#1}}
\let\ucu@tagline\@empty

%% \par (не \\) навмисно: у p-колонці tabular з \centering ручний перенос \\
%% псує спільну базову лінію рядка таблиці відносно сусідньої комірки.
%% #1 = ім'я, #2 = URL профілю (може бути порожнім — тоді без посилання).
\newcommand{\ucu@studentline}[2]{%
  \def\ucu@linktmp{#2}%
  \ifx\ucu@linktmp\@empty
    \ucu@sc{\textbf{\color{ucured}#1}}\par\smallskip
  \else
    \href{#2}{\ucu@sc{\textbf{\color{ucured}#1}}}\par\smallskip
  \fi
}

\newcounter{ucu@nmembers}
\newcommand{\ucu@memberlist}{}
\newcommand{\ucu@authorlist}{}
%% Використання: \student{Ім'я Прізвище} (для групової роботи — кілька разів).
\newcommand{\student}[2][]{%
  \stepcounter{ucu@nmembers}%
  \g@addto@macro\ucu@memberlist{\ucu@studentline{#2}{#1}}%
  \ifnum\value{ucu@nmembers}=1
    \renewcommand{\ucu@authorlist}{#2}%
  \else
    \g@addto@macro\ucu@authorlist{, #2}%
  \fi
}

\newcommand{\teacher}[1]{\def\ucu@teacher{#1}}
\let\ucu@teacher\@empty

\newcommand{\labdate}[1]{\def\ucu@date{#1}}
\let\ucu@date\@empty

\AtBeginDocument{%
  \hypersetup{pdftitle=\ucu@title,pdfauthor=\ucu@authorlist}%
}

%% ------------------------------------------------------------------
%% Титульна сторінка
%% ------------------------------------------------------------------
\fancypagestyle{ucutitle}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

\fancypagestyle{ucubody}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0.6pt}
  \renewcommand{\headrule}{{\color{ucured}\hrule width\headwidth height\headrulewidth}}
  \renewcommand{\footrulewidth}{0pt}
  \fancyhead[L]{\sffamily\small\color{ucured}\ucu@courseline}%
  %% Без "з N": lastpage/\pageref{LastPage} змушували latexmk робити
  %% зайвий прохід XeLaTeX на кожній збірці.
  \fancyhead[R]{\sffamily\small\color{ucured}\ucu@pagelabel\ \thepage}%
}

\newcommand{\maketitlepage}{%
  \thispagestyle{ucutitle}
  \begin{center}
  %% Явні \vspace керують усім вертикальним ритмом титулки; \parskip з
  %% основного тексту тут лише заважає (накопичується на кожному \par і
  %% зсуває вміст, аж до переповнення сторінки), тож на титулці він вимкнений.
  \setlength{\parskip}{0pt}%
  \vspace*{18mm}
  {\ucu@sc{\fontsize{15}{18}\selectfont\color{ucured}\ucu@uniname}}\par
  \vspace{10mm}
  {\ucu@sc{\fontsize{10.5}{13}\selectfont\ucu@superheader}}\par
  \vspace{4mm}
  {\color{black}\rule{\linewidth}{0.5pt}}\par
  \vspace{7mm}
  {\bfseries\fontsize{20}{25}\selectfont\ucu@title}\par
  \ifdefvoid{\ucu@tagline}{}{%
    \vspace{4mm}
    {\itshape\fontsize{10.5}{13}\selectfont\color{ucugray}\ucu@tagline}\par
  }%
  \vspace{5mm}
  {\color{black}\rule{\linewidth}{0.5pt}}\par
  \vspace{10mm}
  \noindent
  \begin{tabular}[t]{@{}>{\centering\arraybackslash}p{0.44\linewidth}@{\hspace{0.06\linewidth}}>{\centering\arraybackslash}p{0.44\linewidth}@{}}
  {\itshape\ucu@labelstudent:}\par\smallskip
  \ucu@memberlist
  &
  \ifdefvoid{\ucu@teacher}{}{%
    {\itshape\ucu@labelteacher:}\par\smallskip
    \ucu@sc{\textbf{\color{ucured}\ucu@teacher}}\par\smallskip
  }%
  \end{tabular}\par
  \vspace{10mm}
  {\itshape\ucu@submittedline\par\ucu@courseline}\par
  \ifdefvoid{\ucu@inthe}{}{%
    \vspace{3mm}
    {\itshape\ucu@inthe}\par
  }%
  \vspace{3mm}
  {\color{ucured}\ucu@facultyname}\par
  \vfill
  \includegraphics[height=22mm]{\ucu@sealfile}%
  \hspace{8mm}%
  \includegraphics[height=18mm]{\ucu@facultylogofile}\par
  \vspace{6mm}
  \iftoggle{ucu@slogan}{\ucu@slogantext\par\vspace{4mm}}{}
  \ifdefvoid{\ucu@date}{}{{\itshape\ucu@labeldate: }\ucu@date\par}
  \vspace*{14mm}
  \end{center}
  \clearpage
  \setcounter{page}{1}
  \pagestyle{ucubody}
}

%% ------------------------------------------------------------------
%% Список джерел.
%% Стиль unsrturl (пакет urlbst): нумерація за порядком цитування, і —
%% на відміну від звичайного unsrt — друкує поле url клікабельним
%% посиланням.
%% ------------------------------------------------------------------
\newcommand{\ucuprintbibliography}{%
  \clearpage
  \renewcommand{\refname}{\ucu@biblabel}%
  \bibliographystyle{unsrturl}%
  \bibliography{references}%
}

\endinput
