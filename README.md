# `XAERO` - Monorepo Meta-Structure [![xaero][xaero-badge]][xaero-url]

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

[![ci](https://github.com/alekbuza/xaero/actions/workflows/conventional-commits.yaml/badge.svg)](https://github.com/alekbuza/xaero/actions/workflows/conventional-commits.yaml)

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Contributing](#contributing)
- [Documentation](#documentation)

## Overview

`xaero` is the invisible backbone of your monorepo - a *meta-structure* that enforces clarity, consistency, and automation across projects and teams. It's designed to seamlessly integrate with popular monorepo tools like `bazel`, `nx`, `turborepo`, `rush`, and more.

## System Dependencies

- [**git**](https://git-scm.com/): Version control for code history
- [**mise**](https://mise.jdx.dev/): Manages consistent language and tool versions
- [**python**](https://www.python.org/): Python is a high-level programming language known for its simplicity and readability
- [**pipx**](https://pipx.pypa.io/stable/): Manages isolated Python package environments

## Distribution Dependencies

- [**editorconfig**](https://editorconfig.org/): Keeps code style consistent across editors
- [**usage**](https://usage.jdx.dev/): A specification for CLIs
- [**cosign**](https://github.com/sigstore/cosign): Code signing and transparency for containers and binaries
- [**slsa-verifier**](https://github.com/slsa-framework/slsa-verifier): Verify provenance from SLSA compliant builders
- [**pre-commit**](https://pre-commit.com/): A framework for managing and maintaining multi-language pre-commit hooks
- [**shellcheck**](https://github.com/koalaman/shellcheck): ShellCheck, a static analysis tool for shell scripts
- [**cocogitto**](https://docs.cocogitto.io/): The conventional commit toolbox
- [**trivy**](https://trivy.dev/latest/): Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more

## GitHub Dependencies

- [**GitHub**](https://github.com/): Git hosting platform
- [**CLI**](https://cli.github.com/): GitHub’s official command line tool
- [**Visual Studio Code**](https://code.visualstudio.com/): A lightweight, open-source code editor
- [**GitHub Codespaces**](https://github.com/features/codespaces): Cloud-based development environment

## Repository Structure

The repository is structured as follows:

```txt
├── .config/                     # Configuration files
├── .devcontainer/               # VSCode's Dev Containers and Codespaces configuration
├── .github/                     # GitHub specific configurations
├── .local/                      # Local stuff (not trackable by git)
├── .vscode/                     # VSCode "workspace" settings as well as debugging and task configurations
├── assets/                      # Static resources
├── bin/                         # Stands for "binaries" and contains certain fundamental utilities
├── doc/                         # Documentation and user manual
└── src/                         # Source code
```

## Contributing

[Contribution guidelines for this project](.github/CONTRIBUTING.md)

## Documentation

The full documentation is available in the [`doc/`](doc/) directory.

[xaero-url]: https://github.com/alekbuza/xaero
[xaero-badge]: https://img.shields.io/badge/monorepo-xaero-red?link=https%3A%2F%2Fgithub.com%2Falekbuza%2Fxaero
