# `XAERO` - Monorepo Meta-Structure

<div align="center">
  <h1>
    <a href="https://github.com/alekbuza/xaero">
      <img src="assets/xaero.png" alt="xaero" width="400"/><br/>
    </a>
  </h1>
  <p>
    <em>
      "Alas, gravity, the universal truths apply to all. Even to Xaero."
    </em>
  </p>
</div>

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/alekbuza/xaero)

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Contributing](#contributing)
- [Documentation](#documentation)

## Overview

`xaero` is the invisible backbone of your monorepo - a *meta-structure* that enforces clarity, consistency, and automation across projects and teams. It's designed to seamlessly integrate with popular monorepo tools like `bazel`, `nx`, `turborepo`, `rush`, and more.

## Core Dependencies

- [**git**](https://git-scm.com/): Version control for code history
- [**mise**](https://mise.jdx.dev/): Manages consistent language and tool versions
- [**pipx**](https://pipx.pypa.io/stable/): Manages isolated Python package environments.

## Distribution Dependencies

- [**cocogitto**](https://docs.cocogitto.io/): The conventional commit toolbox
- [**pre-commit**](https://pre-commit.com/): A framework for managing and maintaining multi-language pre-commit hooks
- [**editorconfig**](https://editorconfig.org/): Keeps code style consistent across editors
- [**Visual Studio Code**](https://code.visualstudio.com/): A lightweight, open-source code editor
- [**GitHub**](https://github.com/): Git hosting platform
- [**GitHub Codespaces**](https://github.com/features/codespaces): Cloud-based development environment

## Repository Structure

The repository is structured as follows:

```txt
├── .config/                     # Configuration files
├── .devcontainer/               # VSCode's Dev Containers and Codespaces configuration
├── .github/                     # GitHub specific configurations
├── .local/                      # Local stuff (not trackable by git)
├── .vscode/                     # VSCode "workspace" settings as well as debugging and task configurations
├── bin/                         # Stands for "binaries" and contains certain fundamental utilities
├── doc/                         # Documentation and user manual
└── src/                         # Source code
```

## Contributing

[Contribution guidelines for this project](.github/CONTRIBUTING.md)

## Documentation

The full documentation is available in the [`doc/`](doc/) directory.
