# LaTeX Datasheet Template

[![Keep a changelog](https://img.shields.io/badge/Keep%20a%20changelog-2.0.0-E05735?logo=keep-a-changelog)](https://keepachangelog.com/en/2.0.0/)
[![Semantic versioning](https://img.shields.io/badge/SemVer-2.0.0-3F4551?logo=semver)](https://semver.org/spec/v2.0.0.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENCE.md)

A LaTeX class for technical datasheets in the style of common datasheets: logo header, two-column feature/description block, specification tables and characteristic plots.

![Datasheet template overview](images/overview.svg)

## Features

- Title page with logo, project name, title and subtitle
- Consistent header and footer on all following pages
- Two-column layout for features, applications and description
- Full-width tables for absolute maximum ratings and electrical characteristics

## Quick start

1. Copy datasheet.cls next to your .tex file. Optionally add a logo and set its path with ```\logo{...}```.
2. Use the class:

```latex
\documentclass{datasheet}

\title{Two Columns, Tables, Plots}
\subtitle{TECHNICAL DATASHEET TEMPLATE}
\author{Marco Niederberger, Yanick Schoch}
\projectname{Datasheet template}
\revision{1.0}
\logo{images/logo.png}

\begin{document}
\maketitle
...
\end{document}
```

3. Build with your latex compiler.

See [`example.tex`](example.tex) for a complete example. The rendered PDF is attached to each [release](../../releases).

## Commands

| Command                      | Description                                  |
|------------------------------|----------------------------------------------|
| `\title{...}`                | Main title line                              |
| `\subtitle{...}`             | Second title line (optional)                 |
| `\author{...}`               | Shown in the footer of the title page        |
| `\projectname{...}`          | Shown in the header of every page            |
| `\footerleft{...}`           | Shown in the left footer of every page       |
| `\logo{...}`                 | Path to logo file                            |
| `\revision{...}`             | Document revision                            |
| `\maketitle`                 | Typesets the title block                     |

## Changelog

See [`CHANGELOG.md`](CHANGELOG.md).

## Contributing

Issues and pull requests are welcome.
Please describe the change, and attach a screenshot or PDF when it affects the layout.

## License

[MIT](LICENCE.md) © 2026 Marco Niederberger
