# Repository folder structure

This monorepo groups **prose** (worldbuilding and project guidance), **reusable Swift packages** (concrete rules and shared logic), and **platform apps** (currently iOS). Paths are relative to the repository root.

## Top level

| Path | Role |
|------|------|
| [`docs/`](../README.md) | Setting-first writing: premise, politics, catalogs, and [technical direction](README.md) for how the project runs. |
| `swift-modules/` | **Swift packages**—each subdirectory is a standalone `Package.swift` module. This is where [concrete rules](README.md#where-concrete-rules-live) and library code that multiple deliverables can import should live. |
| `ios/` | Apple-platform applications and **iOS-local** tooling (Xcode projects, linters, editor rules scoped to that tree). |

New work should land in the folder that matches its responsibility: narrative and intent in `docs/`, portable logic in `swift-modules/`, and app shells or platform glue in `ios/` (or future sibling folders for other stacks).

## `swift-modules/`

Each immediate child is a **Swift package** with the usual layout:

- `Package.swift` — package manifest and targets.
- `Sources/<TargetName>/` — implementation.
- `Tests/<TargetName>Tests/` — package tests.

Example today: `swift-modules/CharacterImageGenerator/` (character rendering and related types). Build artifacts (`swift-modules/*/.build`) are ignored by git; build locally with `swift build` / `swift test` inside the package directory.

## `ios/`

Hosts Xcode projects for applications.The app targets import Swift packages from `swift-modules/` via Swift Package Manager as needed.

Current iOS app projects:

- [`ios/VespriumHackChoice/`](../../ios/VespriumHackChoice/README.md) — card-based life simulator.
- [`ios/VespriumBattler/`](../../ios/VespriumBattler/README.md) — monitor a bio-enhanced human in combat while keeping body settings under control.

`ios/.cursor/` holds Cursor rules that apply to work under `ios/`; they complement any repo-wide guidance without mixing platform-specific conventions into packages or docs.

## What does not live at the root

The root stays thin: **`README.md`**, **`.gitignore`**, and the three areas above. Avoid adding many new top-level directories without a clear split (for example a future `android/`, `web/`, or `tools/` would get their own short section here when they appear).
