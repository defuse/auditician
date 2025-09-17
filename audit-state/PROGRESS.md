# Audit Progress Tracking

This file tracks the progress of the security audit to ensure all phases are completed.

## Audit Metadata
- **Target Project**: [To be filled by Coordinator]
- **Audit Started**: [To be filled by Coordinator]
- **Last Updated**: [To be updated by agents]

## Phase Completion
- [ ] PROGRESS.md initialization completed.
- [ ] Surveying completed.
- [ ] Brainstorming completed
- [ ] First pass of threat modeling completed.
- [ ] Ensure File Audit Progress table below is fully populated.
- [ ] Local auditing completed
- [ ] Re-read this entire file (`PROGRESS.md`) to catch any notes added by subagents.
- [ ] Global auditing completed (only check when all global audits are marked complete below)
- [ ] Re-read this entire file (`PROGRESS.md`) to catch any notes added by subagents.
- [ ] Issue validation completed (only check when issues/plausible directory is empty)
- [ ] Final pass of threat modeling completed
- [ ] Report generation completed
- [ ] Quality control agent has been run

## File Audit Progress
| File Path | Status | Agent | Timestamp |
|-----------|---------|-------|-----------|
| | | | |

**Status**: `PENDING` | `IN_PROGRESS` | `COMPLETED` | `SKIPPED`

## Global Audits Progress

| Focus Area | Status | Agent | Timestamp |
|-----------|---------|-------|-----------|
| | | | |

## Notes
[Any relevant notes about blockers or coordination issues. This section may be used as a general poster board for communication between agents.]

### Global Audit Focus Areas Recommended by Local Audit Agents
[Local Auditing agents should add recommended focus areas for the global auditor here]

## Instructions for Agents

This file tracks phase completion and audit progress. Individual issue details are tracked as separate files in the `audit-state/issues/` directories.

- Update timestamps in `YYYY-MM-DD HH:MM:SS UTC` format
- Check off completed phases in Phase Completion section
- Local auditors: update File Audit Progress table
- Global auditors: update Global Audits Progress table
- Add notes about blockers or coordination issues as needed