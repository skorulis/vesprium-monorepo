# Technical direction

**Vesprium** names both the fictional world being built and the work that builds it. This document is about the *project*: how we ship software and related artifacts, not the setting itself (those notes live alongside [Premise](../premise.md) and related pages).

## One world, many small releases

The aim is **not** to design and deliver a single monolithic product up front. Instead, the project advances through **small, shippable deliverables on a steady cadence**—by default, something meaningful each week.

Each release should be:

- **Concrete** — a runnable tool, a visible improvement, a documented experiment, or another artifact others can use or react to.
- **Bounded** — scoped so it can actually land in the window, rather than sprawling into an unfinishable umbrella.
- **Cumulative** — chosen so it moves the larger vision forward, even when the step is modest.

Over time, those increments stack into the full result: tools, experiences, and lore that belong to the same world and the same standards of craft.

## How this relates to the repo

Code, assets, and worldbuilding notes may live in different corners of the monorepo, but they share one principle: **prefer shipping a thin vertical slice** over maintaining a long-running “big bang” branch. Technical decisions should stay compatible with frequent integration and visible progress.

Setting and design documents in [`docs/`](../README.md) remain **setting-first**; this folder is the place for **how we build** Vesprium as a project.

## Where concrete rules live

**Concrete rules**—the precise, enforceable definitions that software can rely on—are stored in **Swift packages** as the **primary source of truth** under the swift-modules folder. Markdown in `docs/` can explain intent and narrative; when behavior must be unambiguous (parameters, constraints, generation logic, validation), it belongs in package code so it stays **testable**, **versioned with the toolchain**, and **single-sourced** for any tool that imports those modules.
