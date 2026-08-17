# Manuals

`man` is short for *manual*. This directory contains the project's prose documentation: manuals, how-to guides, tutorials, and references - everything that explains how to work with the project.

Decisions belong elsewhere: [`../adr/`](../adr/) records *why* the project is the way it is, this directory documents *how* to use it.

## Index

| Document               | Purpose                                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------------------- |
| [XAERO.md](./XAERO.md) | Project reference: what the distribution is, what is in it, the template model, and the workflows |
| [USAGE.md](./USAGE.md) | Command-level cheat sheet                                                                         |

## How to Add a Document

- Cover one topic per file and name it `UPPERCASE.md`, matching the existing documents.
- Add a row to the index table in this file.
- Formatting is handled by the `mdformat` pre-commit hook; no manual styling is required.
