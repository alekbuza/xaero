# Architectural Decision Records

This directory contains the Architectural Decision Records (ADRs).
ADRs document significant decisions made about the architecture, tooling, process, and infrastructure of the project.

ADRs follow the [MADR 4.0.0](https://adr.github.io/madr/) template defined in [`_index.md`](./_index.md). New ADRs must be numbered sequentially and stored in this directory.

## Index

| ADR                                                           | Title                                       | Status   |
| ------------------------------------------------------------- | ------------------------------------------- | -------- |
| [0000](./0000-use-markdown-architectural-decision-records.md) | Use Markdown Architectural Decision Records | accepted |

## How to Add a New ADR

- Copy `_index.md` to a new file named `NNNN-short-title.md` where `NNNN` is the next sequential number.
- Fill in all required frontmatter fields (`status`, `date`, `decision-makers`).
- Complete all mandatory sections: Context and Problem Statement, Considered Options, and Decision Outcome.
- Add a row to the index table in this file.
- Submit the new ADR as a pull request.
