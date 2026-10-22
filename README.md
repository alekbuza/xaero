# `xaero` - project meta-distribution

[![xaero][xaero-badge]][xaero-url]
[![commit-check](https://img.shields.io/badge/commit--check-enabled-brightgreen?logo=Git&logoColor=white&color=%232c9ccd)](https://github.com/commit-check/commit-check)
[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-orange.json)](https://github.com/copier-org/copier)

## Table of Contents

- [Overview](#overview)
- [Contributing](#contributing)
- [Documentation](#documentation)

## Overview

`xaero` is a meta-distribution: the base a project stands on, delivered as a
[Copier](https://copier.readthedocs.io) template. It ships no application code - only dev tools,
tasks, environment, automation, documentation, and checks, curated, version-pinned, and
upgradeable as a single unit.

### What is in the box

- **Dev tools** - pinned in `.config/mise.toml` and `pyproject.toml`, locked in `mise.lock` and
  `uv.lock`.
- **Tasks** - `mise run bootstrap` prepares a checkout, `mise run distro:hygiene` runs every check,
  and `mise tasks` lists the rest.
- **Environment** - `bin/` and `.venv/bin` on `PATH`, with no activation step.
- **Automation** - `pre-commit` git hooks, `cocogitto` versioning and changelog, and
  `copier update` for upgrades.
- **Documentation** - `doc/man/` for manuals, `doc/adr/` for decision records (MADR 4.0.0).
- **Checks** - `yamllint`, `yamlfmt`, `mdformat`, `shellcheck`, `commit-check`, and EditorConfig.

### Principles

- **Repeatable** - every tool is pinned and every resolution is locked.
- **Upgradeable** - `copier update` carries later revisions into existing projects.
- **Customizable** - `commit-check`, `cocogitto`, and `pre-commit` are each opt-out.

Full documentation lives in [`doc/man/XAERO.md`](doc/man/XAERO.md).

## Contributing

[Contribution guidelines for this project](CONTRIBUTING.md)

## Documentation

The full documentation is available in the [`doc/`](doc/) directory.

[xaero-badge]: https://img.shields.io/badge/repo-xaero-red?link=https%3A%2F%2Fcodeberg.org%2Falekbuza%2Fxaero
[xaero-url]: https://codeberg.org/alekbuza/xaero
