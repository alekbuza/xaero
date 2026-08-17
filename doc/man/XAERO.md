# XAERO

`xaero` is a **meta-distribution**: the foundational layer - the base - that a project stands on,
delivered as a [Copier](https://copier.readthedocs.io) template. It ships no application code and
authors none of the tools it carries. What it distributes is the base itself - dev tools, tasks,
environment, automation, documentation, and checks - curated, version-pinned, wired together, and
upgradeable as a single unit.

The positioning is recorded in
[ADR 0001](../adr/0001-position-xaero-as-a-meta-distribution.md).

Related documents:

- [`USAGE.md`](USAGE.md) - the command-level cheat sheet.
- [`../adr/`](../adr/) - Architectural Decision Records (MADR 4.0.0).

## Table of Contents

- [What xaero is](#what-xaero-is)
- [What is in the box](#what-is-in-the-box)
- [Design principles](#design-principles)
- [Repository layout](#repository-layout)
- [The toolchain](#the-toolchain)
- [The template model](#the-template-model)
- [Workflows](#workflows)
- [Conventions](#conventions)
- [Evolving the toolchain](#evolving-the-toolchain)
- [Verification](#verification)

## What xaero is

A project that starts from scratch spends its first days on decisions that have nothing to do with the
problem it exists to solve: which formatter, which linter, how versions get pinned, what a commit
message must look like, how a release is cut, where documentation lives. xaero answers those questions
once, encodes the answers as configuration, and makes the result reusable.

Concretely, xaero is:

- **A distribution, not a tool.** It authors none of the software it ships. Its work is selection,
  pinning, configuration, and integration: deciding which tools a project should stand on, fixing
  their versions, writing their configuration, and connecting them so that each one's output is the
  next one's input.
- **"Meta" because it distributes distributions.** It builds and hosts no artifact of its own. It
  draws from existing channels - `aqua` and `mise` for binaries, PyPI through `uv` for the Python
  tooling, `pre-commit` for hook repositories - and curates them into one coherent, versioned set.
  One level up from the things it delivers.
- **A base layer.** A fixed repository layout for source, scripts, configuration, and documentation,
  together with everything under [What is in the box](#what-is-in-the-box), so that every project
  derived from it looks the same and any contributor can navigate an unfamiliar one.
- **A foundation that keeps updating.** A project generated from xaero records the answers it was
  generated with and can pull later revisions of the base in, so improvements reach existing projects
  instead of only new ones.

Equally important is what xaero deliberately is **not**:

- Not a framework or a library - nothing here is imported, linked, or executed at your project's runtime.
- Not a distribution of *our* software - every tool it carries belongs to someone else, and xaero
  neither vendors nor forks any of them.
- Not language-specific in intent. Python appears because the tooling itself is Python-based
  (`copier`, `pre-commit`, `commit-check`); the base layout and the git conventions are language-neutral.
- Not a fixed bill of materials. See [Evolving the toolchain](#evolving-the-toolchain).

## What is in the box

Six pillars. Each names what a project receives and where that lives; the toolchain table under
[The toolchain](#the-toolchain) is the per-tool detail.

| Pillar            | What a project receives                                                                                      | Where it lives                                                |
| ----------------- | ------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------- |
| **Dev tools**     | A curated tool set pinned to exact versions and locked per platform, plus the Python-side dev dependencies   | `.config/mise.toml`, `mise.lock`, `pyproject.toml`, `uv.lock` |
| **Tasks**         | A task runner surface - the distribution's equivalent of a `Makefile` - namespaced `distro:`                 | `.config/mise/tasks/`                                         |
| **Environment**   | `bin/` and `.venv/bin` on `PATH`, so project-local executables and the virtualenv resolve without activation | `[env]` in `.config/mise.toml`                                |
| **Automation**    | Hooks installed into git, releases derived from commit history, and template updates carried into projects   | `.pre-commit-config.yaml`, `cog.toml`, `copier.yaml`          |
| **Documentation** | A place for manuals and a place for decisions, each with an index and a rule for adding to it                | `doc/man/`, `doc/adr/`                                        |
| **Checks**        | Formatting and linting for YAML, Markdown, and shell, plus commit-message and branch-name enforcement        | `.pre-commit-config.yaml`, `cchk.toml`, `.editorconfig`       |

Current scope, stated plainly so the table is not read as a promise:

- **Environment** is `PATH` wiring today. The `[env]` block is the declared surface for project
  variables; nothing else is set there yet.
- **Automation** runs locally. `pre-commit` fires on commit and `cocogitto` cuts releases on demand;
  no CI pipeline ships with the base. `trivy`, `cosign`, and `slsa-verifier` are pinned and installed
  but not yet wired into any task or hook - see
  [Pinned but not yet wired](#pinned-but-not-yet-wired).

And three properties the base is expected to hold:

- **Repeatable.** Every tool is pinned and every resolution is locked, so the same checkout yields
  byte-identical tooling on every machine and in CI.
- **Upgradeable.** A generated project records its answers in `.copier-answers.yml`; `copier update`
  carries later revisions of the base into it.
- **Customizable.** The questionnaire decides what is rendered - `commit-check`, `cocogitto`, and
  `pre-commit` are each opt-out, and the changelog metadata is answered per project.

## Design principles

**1. The distribution is the product.** There is no application code in this repository, and there is
not meant to be. Every file here is configuration, a task definition, or documentation. The value
delivered is the curation and the wiring between tools, not any of the tools individually.

**2. Dogfooding through the dual tree.** `copier.yaml` declares `_subdirectory: src`, so `src/` is the
tree that gets rendered into generated projects, while the repository root is *that same tree, already
rendered*. xaero is therefore always its own first consumer: it runs on the base it distributes, and a
change that breaks generated projects breaks xaero itself, immediately and visibly.

**3. Configuration lives under `.config/`.** Tool configuration is kept out of the repository root
wherever the tool allows it (`.config/mise.toml`, `.config/yamllint.yaml`, `.config/yamlfmt.yaml`,
`.config/mise/tasks/`). Only files whose tools insist on a root location (`.editorconfig`,
`.pre-commit-config.yaml`, `cog.toml`, `cchk.toml`, `pyproject.toml`) stay at the top level.

**4. Pinned *and* locked.** `.config/mise.toml` pins an exact version for every tool; `mise.lock`
records the resolved artifacts per platform. `pyproject.toml` declares the Python dev dependencies;
`uv.lock` locks them. Two developers on two machines get byte-identical tooling.

**5. Tools are replaceable.** The set below is the current answer, not a permanent one. Tools are
expected to be added, swapped, reconfigured, or removed as the ecosystem moves - which is precisely
why they are distributed behind a template with recorded answers rather than copy-pasted into each
project. The base is the constant; its contents are not.

## Repository layout

```text
.
|- .config/                 # tool configuration, kept out of the root
|  |- copier/self.yml       # answers used to render src/ back onto this repo (root-only)
|  |- mise/tasks/           # mise file-tasks (the task runner surface)
|  |- mise.toml             # tool version pins
|  |- mise.lock             # resolved tool artifacts per platform
|  |- yamlfmt.yaml          # YAML formatter config
|  `- yamllint.yaml         # YAML linter config
|- assets/                  # project assets, e.g. the logo (root-only)
|- bin/                     # project-local executables; on PATH via mise (.gitkeep placeholder)
|- doc/
|  |- adr/                  # Architectural Decision Records (MADR 4.0.0)
|  `- man/                  # project documentation - its README index, this file, and USAGE.md
|- src/                     # THE TEMPLATE TREE (see "The template model")
|- .editorconfig            # editor-level whitespace/charset rules
|- .gitignore
|- .pre-commit-config.yaml  # the hook suite
|- cchk.toml                # commit-check: commit message and branch name rules
|- cog.toml                 # cocogitto: changelog and release rules
|- copier.yaml              # the template questionnaire (root-only)
|- pyproject.toml           # Python project metadata + dev dependency group
`- uv.lock                  # locked Python dev dependencies
```

The tree under `src/` mirrors the above - that is the point - with these differences:

```text
src/
|- src/.gitkeep             # placeholder for the generated project's source directory
|- bin/.gitkeep             # placeholder for the generated project's bin/
|- doc/man/README.md        # generic index; the manuals themselves are xaero's own, not inherited
`- ...                      # every other path matches the root, verbatim or as a .jinja template
```

`src/src/` and `src/bin/` exist only so that a generated project starts with those directories
present; the `.gitkeep` files are excluded when the template is re-applied to an existing project.

## The toolchain

| Tool                                                             | Role                                                                | Configured in                              | Invoked by                            | Pinned in                                               |
| ---------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------ | ------------------------------------- | ------------------------------------------------------- |
| [copier](https://copier.readthedocs.io)                          | Renders the template; carries later updates into generated projects | `copier.yaml`                              | `copier` CLI, `mise run copier:apply` | `pyproject.toml` (dev group)                            |
| [mise](https://mise.jdx.dev)                                     | Tool-version manager and task runner                                | `.config/mise.toml`, `.config/mise/tasks/` | the developer / CI                    | installed outside the repo; pins itself via `mise.lock` |
| [uv](https://docs.astral.sh/uv/)                                 | Python environment and dependency resolution                        | `pyproject.toml`, `uv.lock`                | `mise run distro:uv:sync`             | `.config/mise.toml`                                     |
| Python                                                           | Runtime for the Python-based tooling                                | `pyproject.toml` (`requires-python`)       | uv                                    | `.config/mise.toml` (3.14)                              |
| [pre-commit](https://pre-commit.com)                             | Hook framework - runs every check below                             | `.pre-commit-config.yaml`                  | git hooks, `mise run distro:hygiene`  | `pyproject.toml` (dev group)                            |
| [commit-check](https://github.com/commit-check/commit-check)     | Commit-message and branch-name policy                               | `cchk.toml`                                | `check-message`, `check-branch` hooks | `pyproject.toml` + hook `rev`                           |
| [cocogitto](https://docs.cocogitto.io)                           | Conventional-commit releases and changelog                          | `cog.toml`                                 | `cog` CLI, on `main` only             | `.config/mise.toml`                                     |
| [EditorConfig](https://editorconfig.org)                         | Editor-level charset, EOL, indentation                              | `.editorconfig`                            | the editor                            | n/a (a spec, not a binary)                              |
| [yamlfmt](https://github.com/google/yamlfmt)                     | YAML formatter                                                      | `.config/yamlfmt.yaml`                     | `yamlfmt` hook                        | hook `rev`                                              |
| [yamllint](https://yamllint.readthedocs.io)                      | YAML linter (`--strict`)                                            | `.config/yamllint.yaml`                    | `yamllint` hook                       | hook `rev`                                              |
| [mdformat](https://mdformat.readthedocs.io)                      | Markdown formatter; normalises GFM tables to padded form            | `.pre-commit-config.yaml` (hook `args`)    | `mdformat` hook, `mdformat` CLI       | `pyproject.toml` (dev group) + hook `rev`               |
| [shellcheck](https://www.shellcheck.net)                         | Shell script analysis                                               | - (defaults)                               | local `shellcheck` hook               | `.config/mise.toml`                                     |
| [trivy](https://trivy.dev)                                       | Vulnerability / misconfiguration scanning                           | -                                          | *not yet wired*                       | `.config/mise.toml`                                     |
| [cosign](https://docs.sigstore.dev/cosign/)                      | Artifact signing and verification                                   | -                                          | *not yet wired*                       | `.config/mise.toml`                                     |
| [slsa-verifier](https://github.com/slsa-framework/slsa-verifier) | Provenance verification                                             | -                                          | *not yet wired*                       | `.config/mise.toml`                                     |
| [usage](https://usage.jdx.dev)                                   | CLI spec used by mise for task metadata                             | -                                          | mise, internally                      | `.config/mise.toml`                                     |

### copier

The template engine. `copier.yaml` holds the questionnaire; `_subdirectory: src` tells Copier that
only `src/` is the template body. Generating a project writes the answers to `.copier-answers.yml` in
the destination, which is what makes later `copier update` / `copier recopy` runs possible without
re-answering anything.

### mise

Two responsibilities. First, tool versions: `[tools]` in `.config/mise.toml` pins every binary, and
`mise.lock` records the resolved artifacts. Second, tasks: everything under `.config/mise/tasks/` is a
file-task, where the directory path becomes the task name (`.config/mise/tasks/distro/uv/sync` is
`distro:uv:sync`) and the `#MISE` comments supply the description and dependencies. `[env]` prepends
`bin/` and `.venv/bin/` to `PATH`, so project-local executables and the uv-managed virtualenv are
available without activation.

### uv

Resolves and installs the Python dev dependencies declared in the `dev` dependency group of
`pyproject.toml` into `.venv/`, locked by `uv.lock`. It is also the release plumbing: `cog` calls
`uv version <v>` as a pre-bump hook so the package version and the git tag never drift apart.

### pre-commit

The execution point for the whole hygiene suite. Installed into `.git/hooks` for both the
`pre-commit` and `commit-msg` stages by `mise run distro:pre-commit:install`. The current suite:

- **General** (`pre-commit/pre-commit-hooks`): `trailing-whitespace`, `check-docstring-first`,
  `check-merge-conflict`, `check-executables-have-shebangs`, `check-symlinks`, `forbid-submodules`,
  `forbid-new-submodules`.
- **YAML**: `yamlfmt` (with `-conf .config/yamlfmt.yaml`), then `yamllint`
  (`--strict -c .config/yamllint.yaml`).
- **Markdown**: `mdformat` with the `mdformat-gfm` and `mdformat-frontmatter` plugins, run as
  `--number` so ordered lists keep their consecutive numbering instead of collapsing to `1.`. It
  matches `*.md` only - `*.md.jinja` files under `src/` are formatted by hand, because running a
  Markdown formatter over Jinja block constructs risks mangling the template.
- **Shell**: a local `shellcheck` hook over every file identified as a shell script.
- **Git**: `check-message` and `check-branch` from commit-check.

Two deliberate gaps in Markdown coverage:

- `doc/adr/_index.md` and `src/doc/adr/_index.md` are **excluded**. They are MADR templates whose
  frontmatter holds `{PLACEHOLDER}` values, which YAML parses as flow mappings and re-emits
  corrupted (`date: {YYYY-MM-DD ...}` becomes `date: {YYYY-MM-DD ...: null}`). They carry no tables
  and need no formatting. This is intentional, not an oversight.
- `CLAUDE.md` is gitignored, so no hook ever sees it. Its tables are hand-maintained; run
  `uv run --with mdformat-gfm --with mdformat-frontmatter mdformat --number CLAUDE.md` manually after
  editing them - the plugins are mandatory, a bare `mdformat` strips the GFM table padding.

### commit-check

Enforces the git conventions described under [Conventions](#conventions). It runs as a pre-commit
hook, so a non-conforming commit is rejected locally rather than in review.

### cocogitto

Reads the conventional commits that commit-check guarantees and derives the next semantic version, the
changelog entry, and the tag from them. Restricted to `main` (`branch_whitelist`). Changelog rendering
targets Codeberg (`remote = "codeberg.org"`).

### EditorConfig

The lowest layer of the formatting stack: UTF-8, LF endings, final newline, trimmed trailing
whitespace, two-space YAML indentation, tabs in `Makefile`, and relaxed rules for Markdown. It applies
in the editor, before any hook runs.

### mdformat

Markdown is the documentation format everywhere in this repository - `README.md`, the man pages under
`doc/man/`, and the ADRs under `doc/adr/` - so it gets a formatter of its own instead of being left to
editor conventions. `mdformat` rewrites each document to a canonical form: GFM tables padded to a fixed
column width, unified emphasis and list markers, and - because of `--number` - ordered lists that keep
consecutive numbering rather than collapsing to a repeated `1.`. Two plugins extend the base CommonMark
formatter and are supplied as `additional_dependencies` on the hook: `mdformat-gfm` (tables,
strikethrough, task lists, autolinks) and `mdformat-frontmatter` (the YAML frontmatter that every MADR
record carries).

It is reachable two ways, and both are deliberate:

- **As a pre-commit hook**, configured in `.pre-commit-config.yaml`, which is what makes the formatting
  non-negotiable for anything that reaches a commit. Its file coverage and the two intentional
  exclusions are described under [pre-commit](#pre-commit).
- **As a CLI**, run on demand through `uv run --with`, which is how the two plugins reach it - they are
  `additional_dependencies` of the hook, not project dependencies, so a bare `mdformat` would reformat
  GFM tables to the unpadded style. That covers the files no hook ever sees, `CLAUDE.md` being the
  standing example.

```bash
uv run pre-commit run mdformat --all-files   # the hook, over the whole tree

# directly, for anything the hook skips - the plugins must be passed explicitly
uv run --with mdformat-gfm --with mdformat-frontmatter mdformat --number <file>
```

Because the hook matches `*.md` only, the `*.md.jinja` templates under `src/` stay hand-maintained -
running a Markdown formatter over Jinja block constructs risks mangling the template.

### Pinned but not yet wired

`trivy`, `cosign`, and `slsa-verifier` are pinned in `.config/mise.toml` and locked, so they are
installed and on `PATH` - but no task or hook currently invokes them. They are staged for a future
supply-chain and scanning workflow. `usage` is a dependency of mise's own task metadata handling
rather than something invoked directly. Treat all four as available, not as active checks.

## The template model

### The dual tree

The single rule that governs every change in this repository:

> A change to a root file must be mirrored into its `src/` counterpart, and vice versa.

| Root                                                      | Template source under `src/`                                              |
| --------------------------------------------------------- | ------------------------------------------------------------------------- |
| `.pre-commit-config.yaml`                                 | `{% if use_pre_commit == true %}.pre-commit-config.yaml{% endif %}.jinja` |
| `cog.toml`                                                | `{% if use_cocogitto == true %}cog.toml{% endif %}.jinja`                 |
| `cchk.toml`                                               | `{% if use_commit_check == true %}cchk.toml{% endif %}.jinja`             |
| `pyproject.toml`, `README.md`                             | `pyproject.toml.jinja`, `README.md.jinja`                                 |
| `.config/**`, `.editorconfig`, `.gitignore`, `doc/adr/**` | the same path under `src/`, copied verbatim                               |

Three mechanics make this work:

- **Conditional filenames.** A filename of the form `{% if use_x == true %}name{% endif %}.jinja`
  renders to an empty name when the answer is `false`, and Copier skips empty filenames. That is how
  an optional tool's config disappears entirely from a project that opted out.
- **`.jinja` suffix.** Files ending in `.jinja` have their contents rendered, so answer variables
  (`{{ project_name }}`, `{{ cocogitto_changelog_owner }}`, ...) get substituted. Files without the
  suffix are copied byte-for-byte.
- **`{% raw %}` escaping.** Cocogitto has its own `{{version}}` / `{{package}}` placeholders in
  `cog.toml`. Inside `cog.toml.jinja` they must be wrapped in `{% raw %}...{% endraw %}`, or Copier
  consumes them at render time and the generated `cog.toml` loses its hooks.

### The questionnaire

Defined in `copier.yaml`:

| Question                         | Type             | Default        | Asked when      |
| -------------------------------- | ---------------- | -------------- | --------------- |
| `project_name`                   | str              | -              | always          |
| `project_short_description`      | str              | -              | always          |
| `project_description`            | str (multiline)  | -              | always          |
| `use_commit_check`               | bool             | `true`         | always          |
| `use_cocogitto`                  | bool             | `true`         | always          |
| `cocogitto_changelog_path`       | str              | `CHANGELOG.md` | `use_cocogitto` |
| `cocogitto_changelog_template`   | str              | `remote`       | `use_cocogitto` |
| `cocogitto_changelog_remote`     | str              | `github.com`   | `use_cocogitto` |
| `cocogitto_changelog_owner`      | str              | -              | `use_cocogitto` |
| `cocogitto_changelog_repository` | str              | -              | `use_cocogitto` |
| `cocogitto_changelog_authors`    | yaml (multiline) | one entry      | `use_cocogitto` |
| `use_pre_commit`                 | bool             | `true`         | always          |

`project_short_description` becomes the README heading suffix and `pyproject.toml`'s `description`;
`project_description` is injected as the README's Overview section, so it may contain Markdown - but
its headings must start at `###`, since it sits under the `## Overview` heading.

`_exclude` drops `src/.gitkeep` and `bin/.gitkeep` when the operation is an *update*, so re-applying
the template into an established project does not resurrect placeholder files.

### Answers: two files, two purposes

- **`.copier-answers.yml`** - written by Copier into the destination. In a generated project it is
  committed and is what `copier update` reads. In *this* repository it is gitignored, because the
  root is a rendering artifact rather than a real destination.
- **`.config/copier/self.yml`** - root-only, hand-maintained, and the source of truth for rendering
  `src/` back onto this repository. `mise run copier:apply` feeds it to Copier via `--data-file`.

### Intentional root/`src` divergences

These are correct as they stand and must not be "fixed":

- The root `.gitignore` adds `# copier` (`.copier-answers.yml`) and `# llm` entries that the
  template's `.gitignore` does not carry.
- Root-only, with no `src/` counterpart: `copier.yaml`, `CLAUDE.md`, `.config/copier/self.yml`,
  `.config/mise/tasks/copier/apply`, `doc/man/USAGE.md`, `doc/man/XAERO.md` (this file), and `assets/`.
  All of them are template-maintenance or xaero-specific concerns that a generated project has no use for.
- `doc/man/README.md` exists on both sides with different content: the root copy indexes the two
  root-only manuals above, while the template copy ships the same prose with an empty index. It is
  therefore excluded from `copier:apply`, alongside the root `.gitignore`.
- `doc/adr/README.md` likewise diverges by its index only. ADR 0000 (Use MADR) is a genuine convention
  and ships to generated projects, so the template copy lists it; ADR 0001 records xaero's own
  positioning and is root-only, so only the root copy lists it. Excluded from `copier:apply` for the
  same reason as `doc/man/README.md`.

## Workflows

### Generate a new project

```bash
copier copy https://codeberg.org/alekbuza/xaero <destination>
cd <destination>
mise run bootstrap
```

### Bootstrap an existing checkout

```bash
mise run bootstrap          # -> distro:bootstrap -> distro:uv:sync + distro:pre-commit:install
```

| Task                           | Effect                                               |
| ------------------------------ | ---------------------------------------------------- |
| `bootstrap`                    | Umbrella entry point; depends on `distro:bootstrap`  |
| `distro:bootstrap`             | `distro:uv:sync` + `distro:pre-commit:install`       |
| `distro:uv:sync`               | `uv sync`                                            |
| `distro:pre-commit:install`    | Installs the `pre-commit` and `commit-msg` git hooks |
| `distro:hygiene`               | `uv run pre-commit run --all-files`                  |
| `distro:pre-commit:autoupdate` | `uv run pre-commit autoupdate`                       |
| `copier:apply`                 | Renders `src/` onto this repository root (root-only) |

### Run the checks

```bash
mise run distro:hygiene                          # the whole suite
uv run pre-commit run yamllint --all-files       # or: yamlfmt, shellcheck, check-message, check-branch
```

### Update a generated project to a newer xaero

```bash
copier recopy --vcs-ref=HEAD --defaults --overwrite
```

Details and caveats are in [`USAGE.md`](USAGE.md).

### Self-apply (this repository only)

```bash
mise run copier:apply -- --pretend    # dry run
mise run copier:apply                 # render src/ onto the root
```

### Refresh the pins

```bash
mise lock                             # regenerate mise.lock after editing .config/mise.toml
mise run distro:pre-commit:autoupdate # bump hook revs in .pre-commit-config.yaml
uv lock --upgrade                     # bump the Python dev dependencies
```

Every one of these touches a file that has a `src/` counterpart. Mirror it.

## Conventions

### Commits

Enforced by commit-check (`cchk.toml`) through the `check-message` hook:

- [Conventional Commits](https://www.conventionalcommits.org), imperative subject, at most 80 characters.
- Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`.
- Merge commits and WIP commits are rejected.
- `ai_attribution = "forbid"` - commit messages must carry no AI signature and no AI `Co-Authored-By`
  trailer.
- Bot authors (`dependabot[bot]`, `renovate[bot]`, `copilot[bot]`) are exempt.

### Branches

Enforced by the `check-branch` hook, following [Conventional Branch](https://conventionalbranch.org):
`feature/`, `bugfix/`, `hotfix/`, `release/`, `chore/`, `feat/`, `fix/`.

### Releases

Run through cocogitto on `main` only. `cog bump` executes `uv version <v>` as a pre-bump hook, writes
the changelog to `CHANGELOG.md`, and then **pushes `main` and the tag**. It publishes immediately -
run it deliberately.

### Hosting

Codeberg (Forgejo), not GitHub. Use the `fj` CLI. `cog.toml`'s changelog remote is set accordingly.

## Evolving the toolchain

The tool set is expected to change. A tool may be added, replaced by a better one, reconfigured, or
dropped when it stops earning its place. What must stay stable is the *procedure*, so that downstream
projects can absorb the change without surprises:

1. **Record the decision.** Add an ADR under `doc/adr/` (copy `_index.md` to `NNNN-short-title.md`,
   fill the frontmatter and the Context / Considered Options / Decision Outcome sections, then add a
   row to the index table in `doc/adr/README.md`). Adding, replacing, or removing a tool is exactly
   the kind of decision ADRs exist for.
2. **Decide whether it is optional.** If downstream projects should be able to opt out, add a
   `use_<tool>` question to `copier.yaml` and gate the config file with a conditional filename. If it
   is mandatory, no question is needed.
3. **Change both trees together.** Root and `src/` in the same commit. Removing a tool means removing
   its pin from `.config/mise.toml` *and* `src/.config/mise.toml`, its hook from both pre-commit
   configs, its config file from both trees, and its question from `copier.yaml`.
4. **Update the tasks.** If the tool has an entry point, add or retire the corresponding file-task
   under `.config/mise/tasks/` - and its `src/` mirror.
5. **Update the documentation.** The toolchain table in this file is normative; keep it accurate,
   including the "pinned but not yet wired" list.
6. **Verify.** See below.
7. **Communicate the update path.** Downstream projects pick the change up with
   `copier update` / `copier recopy`. A removed tool leaves its files behind in projects that already
   have them - say so in the release notes when that applies.

## Verification

There is no test suite. Validating a change to xaero means rendering it.

```bash
mise run distro:hygiene              # lint and format everything
copier copy . /tmp/xaero-render      # smoke-test a fresh generation end to end
mise run copier:apply                # self-apply
git status --porcelain               # must be EMPTY
```

The last two lines are the real test. With a clean worktree beforehand, rendering `src/` onto the root
must produce no changes at all - the root is already exactly what the template generates. **Anything
that appears in `git status` afterwards is a change that was made to the root but never mirrored into
`src/`** (or the reverse). That invariant is what keeps the dual tree honest.
