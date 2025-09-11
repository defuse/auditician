# Audit Progress Tracking

This file tracks the progress of the security audit to ensure all phases are completed and provide visibility into the audit state.

## Audit Metadata

- **Audit Started**: [To be filled by Coordinator]
- **Target Project**: [To be filled by Coordinator]
- **Last Updated**: [To be updated by agents]

## Phase Completion Status

### 1. Brainstorming Phase
- [ ] Initial brainstorming completed
- [ ] Target project research completed
- [ ] Attack surface enumeration completed
- **Last Updated**: [Timestamp]
- **Notes**: [Any relevant notes about brainstorming progress]

### 2. Threat Modeling Phase
- [ ] Initial threat model created
- [ ] Security invariants documented
- [ ] Known weaknesses documented
- [ ] Final threat model completed
- **Last Updated**: [Timestamp]
- **Notes**: [Any relevant notes about threat modeling progress]

### 3. Local Auditing Phase
- **Files to Audit**: [Total count - to be filled by Coordinator]
- **Files Completed**: [Count]
- **Files Remaining**: [Count]
- **Last Updated**: [Timestamp]

#### File-by-File Progress
| File Path | Status | Issues Found | Agent | Timestamp |
|-----------|---------|-------------|-------|-----------|
| | | | | |

**Status Legend**: `PENDING` | `IN_PROGRESS` | `COMPLETED` | `SKIPPED`

### 4. Global Auditing Phase
- [ ] System-wide analysis completed
- [ ] Inter-component security review completed
- [ ] Architecture-level issues identified
- **Last Updated**: [Timestamp]
- **Notes**: [Any relevant notes about global audit progress]

### 5. Issue Validation Phase
- **Total Issues to Validate**: [Count]
- **Issues Validated**: [Count]
- **Issues Remaining**: [Count]
- **Last Updated**: [Timestamp]

#### Issue Validation Progress
| Issue ID | Source | Status | Validator | Timestamp |
|----------|--------|---------|-----------|-----------|
| | | | | |

**Status Legend**: `PENDING` | `IN_PROGRESS` | `CONFIRMED` | `INVALID`

### 6. Report Generation Phase
- [ ] Report structure created
- [ ] Confirmed issues documented
- [ ] Threat model integrated
- [ ] Executive summary written
- [ ] Final report completed
- **Last Updated**: [Timestamp]
- **Notes**: [Any relevant notes about report progress]

## Issue Summary

### By Status
- **Brainstorm Items**: [Count]
- **Plausible Issues**: [Count]
- **Confirmed Issues**: [Count]
- **Invalid Issues**: [Count]

### By Severity (for confirmed issues)
- **Critical**: [Count]
- **High**: [Count]
- **Medium**: [Count]
- **Low**: [Count]

## Overall Audit Progress
- **Estimated Completion**: [Percentage]
- **Estimated Time Remaining**: [Estimate]
- **Blockers/Issues**: [Any current blockers]

## Instructions for Agents

### For All Agents
- Update the "Last Updated" timestamp for your relevant section when you make changes
- Use the format: `YYYY-MM-DD HH:MM:SS UTC`
- Add brief notes about significant findings or decisions

### For Coordinator Agent
- Initialize this file with target project information and file counts
- Update overall progress estimates
- Monitor for blockers and coordination issues

### For Local Auditor Agent
- Update the file-by-file progress table when starting and completing file audits
- Set status to `IN_PROGRESS` when starting a file, `COMPLETED` when done
- Record the count of issues found for each file

### For Global Auditor Agent
- Check off completed tasks in the Global Auditing Phase section
- Update notes with any architectural findings

### For Validator Agent
- Update the issue validation progress table when starting and completing validations
- Track the movement of issues between PLAUSIBLE → CONFIRMED/INVALID

### For Report Generator Agent
- Update the Report Generation Phase checklist as report sections are completed

### Issue ID Format
All issues should use 32-bit random hexadecimal IDs generated from `/dev/urandom`:
```bash
hexdump -n 4 -e '4/1 "%02x"' /dev/urandom
```
Example: `a7f3b2c8`, `de4f91ab`