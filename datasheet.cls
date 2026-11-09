% LaTeX class for datasheets
%
% MIT License
%
% Copyright (c) 2024-2026 Marco Niederberger, marco@ni-m.ch
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


%==============================================================================%
% Identification and options
%==============================================================================%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{datasheet}[2024-01-08 Datasheet template by @ni-m]

% Pass all options on to article
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[a4paper,12pt]{article}


%==============================================================================%
% Packages
%==============================================================================%
% Encoding and fonts (Helvetica as default text font)
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{textcomp}
\RequirePackage{txfonts}
\RequirePackage{helvet}
\renewcommand{\familydefault}{\sfdefault}

% Page layout and header/footer
\RequirePackage{geometry}
\geometry{papersize={210mm,297mm},total={160mm,230mm},top=20mm}
% \geometry{showframe} % uncomment to debug the layout
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}  % \pageref{LastPage} for "Page x of y"

% Tables, lists, columns
\RequirePackage[table]{xcolor}
\RequirePackage{tabularx}  % tables with \textwidth
\RequirePackage{multicol}
\RequirePackage{paralist}

% Graphics, math, units, dates
\RequirePackage{graphicx}
\RequirePackage{amscd}
\RequirePackage{siunitx}
\RequirePackage{datetime2} % ISO 8601 date display

% Git hash extraction
\RequirePackage{catchfile}
\RequirePackage{xstring}
\RequirePackage{pdftexcmds} % \pdf@shellescape, works with every engine


%==============================================================================%
% General layout
%==============================================================================%
\setlength{\columnsep}{30pt} % default column separation on all pages
\setlength{\parindent}{0cm}
\renewcommand{\arraystretch}{1.2}
\setlength{\arrayrulewidth}{0.5pt}

% Display math spacing; article resets these in \normalsize,
% so they have to be appended there to take effect
\g@addto@macro\normalsize{%
  \setlength{\abovedisplayskip}{14pt plus 3pt minus 3pt}%
  \setlength{\abovedisplayshortskip}{14pt plus 3pt}%
  \setlength{\belowdisplayskip}{14pt plus 3pt minus 3pt}%
  \setlength{\belowdisplayshortskip}{14pt plus 3pt minus 3pt}}


%==============================================================================%
% Document metadata (user commands)
%==============================================================================%
% \projectname{...}: shown in the header of every page
\gdef\@projectname{}
\newcommand{\projectname}[1]{\gdef\@projectname{#1}}

% \subtitle{...}: optional second title line
\gdef\@subtitle{}
\newcommand{\subtitle}[1]{\gdef\@subtitle{#1}}

% \revision{...}: shown in the footer, omitted if empty
\gdef\@revision{}
\newcommand{\revision}[1]{\gdef\@revision{#1}}

% \footerleft{...}: left footer on the following pages
\gdef\@footerleft{}
\newcommand{\footerleft}[1]{\gdef\@footerleft{#1}}

% \logo{...}: path to the logo, with or without extension
\gdef\@logo{images/logo}
\newcommand{\logo}[1]{\gdef\@logo{#1}}

% \githash{...}: overrides the automatically detected git hash
\gdef\@githash{}
\newcommand{\githash}[1]{\gdef\@githash{#1}}


%==============================================================================%
% Logo detection
%==============================================================================%
% Tries the common extensions first, then the path as given.
% If nothing is found, the logo is omitted with a warning.
\gdef\@logofile{}
\AtBeginDocument{%
  \@for\@ext:=.pdf,.png,.jpg,.jpeg\do{%
    \ifx\@logofile\@empty
      \IfFileExists{\@logo\@ext}{\xdef\@logofile{\@logo\@ext}}{}%
    \fi}%
  \ifx\@logofile\@empty
    \IfFileExists{\@logo}{\xdef\@logofile{\@logo}}{}%
  \fi
  \ifx\@logofile\@empty
    \ClassWarningNoLine{datasheet}{Logo file `\@logo' not found, logo omitted}%
  \fi}

% \@insertlogo{<includegraphics options>}: prints nothing if no logo was found
\newcommand{\@insertlogo}[1]{%
  \ifx\@logofile\@empty\else\includegraphics[#1]{\@logofile}\fi}


%==============================================================================%
% Git hash detection
%==============================================================================%
% 1. With -shell-escape: git describe (tags, packed refs, -dirty).
% 2. Without: read .git/HEAD and the branch ref directly.
% Skipped if \githash{...} was set manually. Prints nothing outside a repo.
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
        }{\StrLeft{\@githead}{7}[\@githash]}% detached HEAD
      }{}%
    \fi
  \fi}


%==============================================================================%
% Title block
%==============================================================================%
% Horizontal rule below the title
\newcommand{\HRule}{\noindent\rule{\linewidth}{2pt}}

% Horizontally condensed title line
\newcommand{\@condensedline}[1]{\scalebox{.8}[1.0]{#1}\par}

% \maketitle: title, optional subtitle and rule; sets the title page style
\renewcommand{\maketitle}{%
  \thispagestyle{titlepage}%
  \begingroup
    \centering\Large\bfseries
    \@condensedline{\@title}%
    \ifx\@subtitle\@empty\else\@condensedline{\@subtitle}\fi
  \endgroup
  \HRule\par}


%==============================================================================%
% Page styles
%==============================================================================%
% Right footer, empty parts are omitted:
%   revision set:     "Rev. x (hash) | Page n of m"
%   no revision:      "Commit hash | Page n of m"
%   neither:          "Page n of m"
\newcommand{\@revisionfooter}{%
  \footnotesize
  \ifx\@revision\@empty
    \ifx\@githash\@empty\else Commit~\@githash\;\textbar\;\fi
  \else
    Rev.~\@revision
    \ifx\@githash\@empty\else\ (\@githash)\fi
    \;\textbar\;%
  \fi
  Page~\thepage{} of \pageref{LastPage}}

% headheight + headsep is constant in both styles,
% so the body starts at the same height on every page

% Title page: large logo, project name on the right, author in the footer
\fancypagestyle{titlepage}{%
  \fancyhf{}%
  \lhead{\@insertlogo{height=1.9cm}}%
  \rhead{\parbox[][\headheight][t]{5cm}{\normalsize\raggedleft\textbf{\@projectname}}}%
  \rfoot{\bfseries\@author}%
  \renewcommand{\headrulewidth}{2pt}%
  \renewcommand{\footrulewidth}{2pt}%
  \setlength{\headheight}{2cm}%
  \setlength{\headsep}{1.3cm}%
  \setlength{\abovecaptionskip}{1pt plus 3pt minus 2pt}%
}

% Following pages: project name, small logo, revision and page number
\fancypagestyle{layoutAll}{%
  \fancyhf{}%
  \lhead{\bfseries\@projectname}%
  \rhead{\@insertlogo{height=1cm}}%
  \lfoot{\@footerleft}%
  \rfoot{\@revisionfooter}%
  \renewcommand{\headrulewidth}{2pt}%
  \renewcommand{\footrulewidth}{2pt}%
  \setlength{\headheight}{2.3cm}%
  \setlength{\headsep}{1cm}%
  \setlength{\abovecaptionskip}{1pt plus 3pt minus 2pt}%
}


%==============================================================================%
% Content macros
%==============================================================================%
% \dsplot[<includegraphics options>]{<file>}{<caption>}
% Column-wide plot with a caption kept close to its image.
\newcommand{\dsplot}[3][]{%
  \par\includegraphics[width=\columnwidth,#1]{#2}\par\nopagebreak
  \vspace{2pt}{\small #3}\par
  \vspace{\baselineskip}}
