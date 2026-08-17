# USAGE

## In a generated project

Re-copy the latest template changes from HEAD without re-asking any questions, reusing your previous answers:

```bash
copier recopy --vcs-ref=HEAD --defaults --overwrite
```

## In this repository (self-apply)

This repository is both the template and an instance of it, so `src/` can be rendered back onto the
repository root:

```bash
mise run copier:apply              # render src/ onto the repo root
mise run copier:apply -- --pretend # dry run, changes nothing
```

The task wraps `copier copy` with the answers in `.config/copier/self.yml`. Notes:

- `--vcs-ref=HEAD` is mandatory here: the repository has no tags, and copier would otherwise look for
  the latest one. It also means uncommitted changes under `src/` are included in the render.
- The root `.gitignore` and the `bin/.gitkeep` / `src/.gitkeep` placeholders are excluded, so the
  intentional root-only ignore entries survive and no stray `.gitkeep` lands inside `src/`.
- `doc/man/README.md` is excluded too: its root copy indexes `XAERO.md` and `USAGE.md`, which are
  root-only, so the template ships the same document with an empty index instead.
- The generated `.copier-answers.yml` is gitignored at the root; `.config/copier/self.yml` is the
  source of truth for the answers.

Commit first, then check the result: `git status --porcelain` must be **empty** when `src/` and the
root already agree. Anything that shows up is a divergence that was not mirrored into `src/`.

## Verify the template renders for a new project

```bash
copier copy . /tmp/xaero-render
```

## Work on the documentation

Format Markdown with [mdformat](https://mdformat.readthedocs.io). The pre-commit hook covers every
`*.md` that reaches a commit; run it directly for the files no hook sees (`CLAUDE.md` is gitignored)
and note that `--number` is required to keep ordered lists consecutively numbered:

```bash
uv run pre-commit run mdformat --all-files   # the hook, over the whole tree

# directly, for anything the hook skips - `mdformat-gfm` and `mdformat-frontmatter` are
# `additional_dependencies` of the hook, so a bare `mdformat` would unpad every GFM table
uv run --with mdformat-gfm --with mdformat-frontmatter mdformat --number CLAUDE.md
```

`doc/adr/_index.md` and `src/doc/adr/_index.md` are excluded on purpose - their `{PLACEHOLDER}`
frontmatter does not survive a YAML round-trip - and the `*.md.jinja` templates under `src/` are
hand-maintained.
