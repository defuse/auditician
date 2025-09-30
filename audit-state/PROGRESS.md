# Audit Progress Tracking

This file tracks the progress of the security audit to ensure all phases are completed.

## Audit Metadata
- **Target Project**: [To be filled by Coordinator]
- **Audit Started**: [To be filled by Coordinator]
- **Last Updated**: [To be updated by agents]

## Phase Completion (Audit Coordinator's Checklist)
- [ ] Surveying completed.
- [ ] PROGRESS.md initialization completed.
- [ ] Brainstorming completed
- [ ] First pass of threat modeling completed.
- [ ] Ensure File Audit Progress table below is fully populated and `audit-context/AUDIT-INSTRUCTIONS.md` has been considered.
- [ ] Local auditing completed
- [ ] Re-read this entire file (`PROGRESS.md`) to catch any notes added by subagents.
- [ ] Global auditing focus area list has been generated (taking `audit-context/AUDIT-INSTRUCTIONS.md` into account).
- [ ] Global auditing completed (only check when all global audits are marked complete below)
- [ ] Re-read this entire file (`PROGRESS.md`) to catch any notes added by subagents.
- [ ] Issue validation completed (only check when issues/plausible directory is empty)
- [ ] Report generation completed
- [ ] Quality control agent has been run

## File Audit Progress
| File Path | Status | Agent | Timestamp |
|-----------|---------|-------|-----------|
| | | | |

**Status**: `PENDING` | `IN_PROGRESS` | `COMPLETED` | `SKIPPED`

## Global Audits Progress

| Focus Area | Focus Area Category | Status | Agent | Timestamp |
|-----------|---------|-------|-----------|
| | | | | |

**Focus Area Category:** `SENSITIVE_COMPONENT` | `COMMON_BUG_PATTERN` | `ATTACKER_GOAL` | `THINK_LIKE_AN_ATTACKER` | `EXPAND_ON_FINDINGS` | `USER_SUGGESTED` | `OTHER`

## Instructions for Agents

This file tracks phase completion and audit progress. Individual issue details are tracked as separate files in the `audit-state/issues/` directories.

- Update timestamps in `YYYY-MM-DD HH:MM:SS UTC` format
- Check off completed phases in Phase Completion section
- Local auditors: update File Audit Progress table
- Global auditors: update Global Audits Progress table
- Do not pollute this file with verbose status updates such as results of global or local audits. Stick to the tables and sections already in this file, do not add new ones.

## Notes
[Any relevant notes about blockers or coordination issues. This section may be used as a general poster board for communication between agents.]

### Global Audit Focus Areas Recommended by Local Audit Agents
[Local Auditing agents should add recommended focus areas for the global auditor here]
