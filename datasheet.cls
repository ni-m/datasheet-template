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
\usepackage{lastpage}

\renewcommand{\familydefault}{\sfdefault}

\setlength\columnsep{30pt} % This is the default columnsep for all pages
\setlength{\parindent}{0cm}
\renewcommand{\arraystretch}{1.2}%
\setlength\arrayrulewidth{0.5pt}

\gdef\@projectname{}
\newcommand{\projectname}[1]{\gdef\@projectname{#1}}

\gdef\@revision{}
\newcommand{\revision}[1]{\gdef\@revision{#1}}

\gdef\@footerleft{}
\newcommand{\footerleft}[1]{\gdef\@footerleft{#1}}

\gdef\@subtitle{}
\newcommand{\subtitle}[1]{\gdef\@subtitle{#1}}

\newcommand{\HRule}{\noindent\rule{\linewidth}{2pt}}
\newcommand{\@condensedline}[1]{\scalebox{.8}[1.0]{#1}\par}

\renewcommand{\maketitle}{%
  \thispagestyle{titlepage}%
  \begingroup
    \centering\Large\bfseries
    \@condensedline{\@title}%
    \ifx\@subtitle\@empty\else\@condensedline{\@subtitle}\fi
  \endgroup
  \HRule\par
}

% --- Logo with fallback ---
\gdef\@logo{images/logo}
\newcommand{\logo}[1]{\gdef\@logo{#1}}

\gdef\@logofile{}
\AtBeginDocument{%
  \@for\@ext:=.pdf,.png,.jpg,.jpeg\do{%
    \ifx\@logofile\@empty
      \IfFileExists{\@logo\@ext}{\xdef\@logofile{\@logo\@ext}}{}%
    \fi}%
  \ifx\@logofile\@empty
    \IfFileExists{\@logo}{\xdef\@logofile{\@logo}}{}%
  \fi
  \if\@logofile\@empty
    \ClassWarningNoLine{datasheet}{Logo file `\@logo' not found, logo omitted}%
  \fi}

\newcommand{\@insertlogo}[1]{%
  \ifx\@logofile\@empty\else\includegraphics[#1]{\@logofile}\fi}

\fancypagestyle{titlepage}{
\fancyhf{}
\rhead{\parbox[][\headheight][t]{5cm}{\normalsize\raggedleft \textbf{\@projectname}}}
\lhead{\@insertlogo{height=1.9cm}}
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
\rhead{\@insertlogo{height=1cm}}
\lfoot{\@footerleft}
\rfoot{\footnotesize
  \ifx\@revision\@empty\else Rev.~\@revision\;\fi
  \ifx\@githash\@empty\else (\@githash)\fi
  \;\textbar\;Page~\thepage{} of \pageref{LastPage}}
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

\newcommand{\dsplot}[3][]{%
  \par\includegraphics[width=\columnwidth,#1]{#2}\par\nopagebreak
  \vspace{2pt}{\small #3}\par
  \vspace{\baselineskip}}

\RequirePackage{catchfile,xstring,pdftexcmds}

\gdef\@githash{}
\newcommand{\githash}[1]{\gdef\@githash{#1}} % manual override

\AtBeginDocument{%
\ifx\@githash\@empty
  \ifnum\pdf@shellescape=1
    \CatchFileDef{\@githash}{|"git describe --always --dirty"}{\endlinechar=-1}%
  \else
    \IfFileExists{.git/HEAD}{%
      \CatchFileDef{\@githead}{.git/HEAD}{\endlinechar=-1}%
      \IfBeginWith{\@githead}{ref: }{%
        \StrBehind{\@githead}{ref: }[\@gitref]%
        \IfFileExists{.git/\@gitref}{%
          \CatchFileDef{\@githead}{.git/\@gitref}{\endlinechar=-1}%
          \StrLeft{\@githead}{7}[\@githash]}{}%
      }{\StrLeft{\@githead}{7}[\@githash]}%
    }{}%
  \fi
\fi}
