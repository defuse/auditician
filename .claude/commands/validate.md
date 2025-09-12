---
description: Validate a specific issue (confirm or invalidate)
argument-hint: [issue-id or excerpt]
---

Use the **validator** subagent to investigate ONE candidate issue.

## Context
Read @docs/AUDIT-PROCESS.md
Read current state:
@audit-state/BRAINSTORM.md
@audit-state/THREATMODEL.md
@audit-state/issues/plausible/
@audit-state/issues/confirmed/
@audit-state/issues/invalid/

## Role instructions
Follow @docs/agents/Validator.md

## Invocation
The issue identifier/excerpt is `$ARGUMENTS` (e.g., `/validate ISSUE-2025-0007`).