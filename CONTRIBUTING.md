# Contributing

Thanks for contributing! This guide walks through the workflow we follow, from setting up your environment to opening a pull request.

## Table of Contents

1. [Getting Started](#1-getting-started)
2. [Create a New Branch](#2-create-a-new-branch)
3. [Make Your Changes](#3-make-your-changes)
4. [Run Pre-Commit Hooks](#4-run-pre-commit-hooks)
5. [Commit Your Changes](#5-commit-your-changes)
6. [Push Your Changes](#6-push-your-changes)
7. [Create a Pull Request](#7-create-a-pull-request)
8. [Semantic Versioning (SemVer)](#8-semantic-versioning-semver)
9. [Style Guide](#9-style-guide)

## 1. Getting Started

This repository is generated from the shared [xaero](https://codeberg.org/alekbuza/xaero) scaffold, which provides the tooling it uses: [mise](https://mise.jdx.dev/) to manage tools and tasks, [uv](https://docs.astral.sh/uv/) for Python dependencies, and [pre-commit](https://pre-commit.com/) for hooks. The scaffold is applied with [Copier](https://copier.readthedocs.io/), and [`.copier-answers.yml`](.copier-answers.yml) records the version in use - so prefer fixing shared tooling upstream in xaero and pulling it back down over editing it here.

### Setting Up mise

#### 1.1 Install mise

Install mise with the official installer:

```bash
curl https://mise.run | sh
```

#### 1.2 Shell configuration

Activate `mise` in your shell and set the `dev` environment for this project. Follow the steps for the shell you use.

**ZSH**

```bash
echo "eval \"\$(mise activate zsh)\"" >> $HOME/.zshrc
echo "export MISE_ENV=dev" >> $HOME/.zshrc
. $HOME/.zshrc
```

**Bash**

```bash
echo "eval \"\$(mise activate bash)\"" >> $HOME/.bashrc
echo "export MISE_ENV=dev" >> $HOME/.bashrc
. $HOME/.bashrc
```

> `MISE_ENV=dev` selects this project's development profile (`mise.dev.toml`).

#### 1.3 Verify

Verify your `mise` setup with the `doctor` command:

```bash
mise doctor
```

### 1.4 Bootstrap the project

With `mise` ready, bootstrap your local environment in one step:

```bash
mise install
mise run distro:bootstrap
```

______________________________________________________________________

## 2. Create a New Branch

Start by creating a new branch for your feature or bug fix. Branch names must follow the [Conventional Branch](https://conventionalbranch.org/) specification, in the same spirit as Conventional Commits.

The format is `<type>/<description>`, where `<type>` is one of:

- **feature**: A new feature
- **bugfix**: A bug fix
- **hotfix**: An urgent fix, typically against production
- **release**: Release preparation
- **chore**: Tooling, dependencies, or other non-code changes

Use lowercase alphanumeric characters and hyphens for the `<description>` (no spaces or underscores).
You can reference the related GitHub Issue number in the description.

Examples:

```bash
git checkout -b feature/123-add-login     # new feature referencing GitHub Issue #123
git checkout -b feature/add-login         # new feature without an issue reference
git checkout -b bugfix/111-login-redirect # login redirect bugfix referencing GitHub Issue #111
git checkout -b hotfix/patch-token-leak   # hotfix without an issue reference
```

______________________________________________________________________

## 3. Make Your Changes

Make your changes and ensure your code adheres to the project's [style guidelines](#9-style-guide).

If this is your first contribution, add yourself to the `authors` list in [`cog.toml`](cog.toml) so you are correctly attributed in the generated changelog. Each entry maps your GitHub username to the name shown in the changelog:

```toml
[changelog]
authors = [
    { username = "your-github-username", signature = "Your Name" },
]
```

______________________________________________________________________

## 4. Run Pre-Commit Hooks

Pre-commit hooks are installed during [bootstrap](#1-getting-started) and run automatically when you commit. They enforce code quality and consistency (formatting, linting, shellcheck, commit-message and branch-name checks, and more).

To run them manually across the project at any time:

```bash
mise run distro:hygiene
```

If any hook fails, fix the issues it reports before proceeding.

______________________________________________________________________

## 5. Commit Your Changes

Commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification. This keeps the project history clear and, importantly, drives **automated** version bumps and changelog generation (via [Cocogitto](https://docs.cocogitto.io/)). The `check-message` pre-commit hook will reject non-conforming messages.

The format is `<type>(<optional scope>): <description>`. Common types:

- **feat**: A new feature (triggers a minor bump)
- **fix**: A bug fix (triggers a patch bump)
- **docs**: Documentation-only changes
- **style**: Changes that do not affect the meaning of the code (whitespace, formatting, etc.)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tooling

______________________________________________________________________

## 6. Push Your Changes

Push your branch to the repository. The first push needs `-u` to create the remote branch and set it as the upstream; after that, a bare `git push` is enough:

```bash
git push -u origin feature/123-add-login  # first push: create the remote branch and track it
git push                                  # subsequent pushes on the same branch
```

If you amended a commit or rebased onto `main`, your local and remote branches have diverged and the push is rejected. Force push with `--force-with-lease` so you never overwrite commits someone else pushed in the meantime:

```bash
git pull --rebase origin main  # replay your commits on top of the latest main
git push --force-with-lease    # replace the remote branch with the rebased commits
```

______________________________________________________________________

## 7. Create a Pull Request

Open a new pull requesttargeting `main`. Describe what your change does and why it is needed, and link any related issues (e.g. `Closes #123`). Make sure all hooks and CI checks pass before requesting review.

> **IMPORTANT:** The pull request title **MUST** follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format (`<type>(<optional scope>): <description>`). All commits from a PR are squashed on merge, and the PR title becomes the commit message - so it is what drives automated version bumps and changelog generation. See [Commit Your Changes](#5-commit-your-changes) for the list of types.

______________________________________________________________________

## 8. Semantic Versioning (SemVer)

We follow [Semantic Versioning](https://semver.org/) for releases. Versions are derived automatically from your Conventional Commit messages, so writing them correctly is what keeps releases accurate:

- **Major version**: Incompatible API changes (a `feat!` / `BREAKING CHANGE`).
- **Minor version**: Backward-compatible new functionality (a `feat`).
- **Patch version**: Backward-compatible bug fixes (a `fix`).

SemVer applies to official releases, not to every commit or pull request.

______________________________________________________________________

## 9. Style Guide

Please adhere to the following when contributing:

- Use descriptive names for your branches and commits.
- Follow the existing coding style in the project.
- Write clear, concise comments where they add value.

Thank you for contributing!
