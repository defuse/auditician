---
description: Run a local audit on a single file
argument-hint: [file inside audit-target/]
---

Use the **localauditor** subagent to analyze ONE file.

## Context
Read @docs/AUDIT-PROCESS.md
Read current state:
@audit-state/BRAINSTORM.md
@audit-state/THREATMODEL.md
@audit-state/issues/plausible/
@audit-state/issues/confirmed/
@audit-state/issues/invalid/
Read the target file:
@audit-target/$1

## Role instructions
Follow @docs/agents/LocalAuditor.md

## Invocation
The file path argument is `$1` (e.g., `/localaudit src/lib.rs`).