% LaTeX class for datasheets
%
% MIT License
%
% Copyright (c) 2024 Marco Niederberger, marco@ni-m.ch
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
% Usage: place .cls file in same directory as .tex file and reference class 
% in .tex file with: \documentclass{datasheet}
%
% Marco Niederberger <marco@ni-m.ch> 2024-01-08
%------------------------------------------------------------------------------%


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{datasheet}[2024-01-08 Datasheet template by @ni-m]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[a4paper,12pt]{article}

\usepackage[table]{xcolor}
\usepackage{tabularx}  % Table with \textwidth
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
% \usepackage[showframe]{geometry}
\usepackage{geometry}
\geometry{papersize={210mm,297mm},total={160mm,230mm},top=20mm}
\usepackage{amscd}
\usepackage{graphicx}
\usepackage{fancyhdr}
\usepackage{textcomp}
\usepackage{txfonts}
\usepackage{paralist}
\usepackage{multicol}
\usepackage{tabularx}  % Table with \textwidth
\usepackage{siunitx}
\usepackage{catchfile} % used for gitHash extraction
\usepackage{xstring}   % used for gitHash extraction
\usepackage{datetime2} % Use ISO 8601 for date display
\usepackage{helvet}
\renewcommand{\familydefault}{\sfdefault}

\setlength\columnsep{30pt} % This is the default columnsep for all pages
\setlength{\parindent}{0cm}
\renewcommand{\arraystretch}{1.2}%
\setlength\arrayrulewidth{0.5pt}

\gdef\@projectname{}
\newcommand{\projectname}[1]{\gdef\@projectname{#1}}

\gdef\@revision{}
\newcommand{\revision}[1]{\gdef\@revision{#1}}

\fancypagestyle{titlepage}{
\fancyhf{}
\rhead{\parbox[][\headheight][t]{5cm}{\normalsize\raggedleft \textbf{\@projectname}}}
% \rhead{\textbf{\@projectname}}
\lhead{\includegraphics[height=1.9cm]{images/logo.png}}
\rfoot{\bf \@author}
\renewcommand{\headrulewidth}{2pt}
\renewcommand{\footrulewidth}{2pt}

% headheight + headsep = constant; keeps upper edge of body on the same height in every style
\setlength{\headheight}{2cm}
\setlength{\headsep}{1.3cm}

\setlength{\abovecaptionskip}{1pt plus 3pt minus 2pt}
}

\fancypagestyle{layoutAll}{
\fancyhf{}
\lhead{\bf \@projectname}
\rhead{\includegraphics[width=3cm]{images/logo.png}}
% \lfoot{Marco Niederberger, Yanick Schoch}
\rfoot{\thepage}
\renewcommand{\headrulewidth}{2pt}
\renewcommand{\footrulewidth}{2pt}

% headheight + headsep = constant; keeps upper edge of body on the same height in every style
\setlength{\headheight}{2.3cm}
\setlength{\headsep}{1cm}

\setlength{\abovecaptionskip}{1pt plus 3pt minus 2pt}
}

\abovedisplayskip=14pt plus 3pt minus 3pt
\abovedisplayshortskip=14pt plus 3pt
\belowdisplayskip=14pt plus 3pt minus 3pt
\belowdisplayshortskip=14pt plus 3pt minus 3pt

% Git hash extraction and custom cmd
% \CatchFileDef{\headfull}{.git/HEAD}{}
% \StrGobbleRight{\headfull}{1}[\head]
% \StrBehind[2]{\head}{/}[\branch]
% \IfFileExists{.git/refs/heads/\branch}{
%     \CatchFileDef{\commit}{.git/refs/heads/\branch}{}
% }{
%     \newcommand{\commit}{\dots~(in \emph{packed-refs})}
% }
