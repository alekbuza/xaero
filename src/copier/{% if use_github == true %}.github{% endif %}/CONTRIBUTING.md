# Contributing

## Table of Contents

1. [Create a New Branch](#1-create-a-new-branch)
2. [Make Your Changes](#2-make-your-changes)
3. [Run Pre-Commit Hooks](#3-run-pre-commit-hooks)
4. [Commit Your Changes](#4-commit-your-changes)
5. [Push Your Changes](#5-push-your-changes)
6. [Create a Pull Request](#6-create-a-pull-request)
7. [Semantic Versioning (SemVer)](#7-semantic-versioning-semver)
8. [Issues](#8-issues)
9. [Style Guide](#9-style-guide)

## 1. Create a New Branch

Start by creating a new branch for your feature or bug fix:

```bash
git checkout -b feature/TICKET-ID/your-feature-name
```

## 2. Make Your Changes

Make your changes and ensure your code adheres to the project's style guidelines.

## 3. Run Pre-Commit Hooks

Before committing your changes, ensure that you have passed all pre-commit hooks. These hooks are set up to maintain code quality and consistency. You can run them manually with:

```bash
mise run hygiene
```

If any hooks fail, please fix the issues they identify before proceeding.

## 4. Commit Your Changes

When committing your changes, please follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification. This will help us create a clear and understandable project history.

Here are some common commit message formats:

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc.)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools and libraries such as documentation generation

Example commit message:

```bash
git commit -m "feat: add new authentication feature"
```

## 5. Push Your Changes

Push your changes to the repository:

```bash
git push origin feature/TICKET-ID/your-feature-name
```

## 6. Create a Pull Request

Go to the original repository and click on "New Pull Request." Choose your branch and submit the pull request. Be sure to describe your changes and why they are needed.

## 7. Semantic Versioning (SemVer)

We follow [Semantic Versioning](https://semver.org/) for releases of the project. Please ensure that your changes align with the following versioning principles when preparing for a release:

- **Major version**: Incremented for incompatible API changes.
- **Minor version**: Incremented for adding functionality in a backward-compatible manner.
- **Patch version**: Incremented for backward-compatible bug fixes.

Please note that SemVer applies only to official releases and not to every commit or pull request.

## 8. Issues

For tracking issues, please use [tracker](https://github.com/alekbuza/xaero/issues). Make sure to provide as much detail as possible when creating a new issue.

## 9. Style Guide

Please adhere to the following guidelines when contributing:

- Use descriptive names for your branches and commits.
- Follow the existing coding style in the project.
- Write clear, concise comments in your code.

Thank you for contributing!
