# Copier Cheat Sheet

## In a generated project

Re-copy the latest template changes from HEAD without re-asking any questions, reusing your previous answers:

```bash
copier recopy --vcs-ref=HEAD --defaults --overwrite
```

## In this repository (self-apply)

This repository is both the template and an instance of it, so `src/` can be rendered back onto the
repository root:

```bash
mise run template:apply              # render src/ onto the repo root
mise run template:apply -- --pretend # dry run, changes nothing
```

The task wraps `copier copy` with the answers in `.config/copier/self.yml`. Notes:

- `--vcs-ref=HEAD` is mandatory here: the repository has no tags, and copier would otherwise look for
  the latest one. It also means uncommitted changes under `src/` are included in the render.
- The root `.gitignore` and the `bin/.gitkeep` / `src/.gitkeep` placeholders are excluded, so the
  intentional root-only ignore entries survive and no stray `.gitkeep` lands inside `src/`.
- The generated `.copier-answers.yml` is gitignored at the root; `.config/copier/self.yml` is the
  source of truth for the answers.

Commit first, then check the result: `git status --porcelain` must be **empty** when `src/` and the
root already agree. Anything that shows up is a divergence that was not mirrored into `src/`.

## Verify the template renders for a new project

```bash
copier copy . /tmp/xaero-render
```
