# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/2.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-11-11

This release improves the usability of the template.
Spacing that previously had to be adjusted by hand is now built into the class.
It also adds the git hash to the footer, so every PDF can be traced back to the commit it was built from.
Existing documents still compile without changes.

### Added
- Add `\subtitle` command and `\maketitle` for the title block
- Add optional `\logo` command
- Add optional `\footerleft` command
- Add right footer with revision, git hash and "Page x of y"; missing parts are omitted
- Add git hash detection
- Add `dsitems` environment for compact bullet lists with a heading, e.g. FEATURES
- Add custom `abstract` environment for the description on the title page
- Add `\dsheading` command for consistently spaced section headings
- Add `\dsplot` command for plots with a caption

### Changed
- Move title and subtitle from the example into the class
- Without a logo, the title page content starts higher; the footer stays in place
- Columns in `multicols` are no longer stretched to equal height

## [0.1.0] - 2024-01-08

First release

[0.1.0]: https://github.com/ni-m/datasheet-template/releases/tag/v0.1
[0.2.0]: https://github.com/ni-m/datasheet-template/releases/tag/v0.2.0
