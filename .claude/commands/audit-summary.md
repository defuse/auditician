---
description: Generate a prioritized summary of audit state for report writing
---

Generate a concise, actionable summary of the current audit state.

## Context

Read current audit state:
@audit-state/PROGRESS.md
@audit-state/SURVEY.md
@audit-state/BRAINSTORM.md
@audit-state/THREATMODEL.md
@audit-state/issues/plausible/
@audit-state/issues/confirmed/
@audit-state/issues/invalid/
@audit-state/globals/
@audit-state/proofs/
@report/

## Output Structure

Produce the following sections:

### 1. Audit Process Status Table

| Phase | Status | Details |
|-------|--------|---------|
| Survey | [checkmark] Complete / In Progress / Not Started | Brief notes |
| Brainstorming | ... | ... |
| Threat Modeling | ... | ... |
| Local Audits | ... | X/Y files complete |
| Global Audits | ... | X/Y focus areas complete |
| Security Proofs | ... | X proofs attempted |
| Issue Validation | ... | X confirmed, Y invalid, Z plausible remaining |
| Report Generation | ... | ... |
| Quality Control | ... | ... |

For incomplete phases, note what specific work remains.

### 2. Prioritized Issue Table

Create a table of ALL confirmed issues, sorted by severity (Critical first, then High, Medium, Low, Info):

| # | Severity | Issue Title | Location | Impact Summary | Confidence |
|---|----------|-------------|----------|----------------|------------|
| 1 | Critical | Brief title | file.rs:123 | One-line impact | High/Med/Low |

For each issue, read the issue file and extract:
- **Issue Title**: Short, descriptive title (not the filename)
- **Location**: Primary file and line number(s)
- **Impact Summary**: One-line description of user harm (e.g., "Fund theft via change spoofing")
- **Confidence**: Assessment of exploitability evidence quality:
  - **High**: Clear code path, concrete attack scenario, validated with line numbers
  - **Medium**: Plausible attack but some assumptions required
  - **Low**: Theoretical or requires unlikely conditions

### 3. Issue Counts

```
CONFIRMED: X issues (Y Critical, Z High, ...)
INVALID: X issues
PLAUSIBLE (pending validation): X issues
```

### 4. Plausible Issues Awaiting Validation

If any remain, list with severity and one-line description for prioritization.

### 5. Key Themes / Systemic Issues

Note patterns across issues (e.g., "Multiple memory clearing issues", "Consistent change output validation gaps").

### 6. Recommendations for Next Steps

- Which issues to write up first (highest severity + confidence)
- What validation work remains
- Coverage gaps noticed

## Guidelines

- Be concise - this is a summary for quick scanning
- Prioritize by user impact (fund theft > privacy leak > DoS > code quality)
- For confidence assessment, actually read issue files and assess evidence quality
- Flag any issues that seem like potential false positives
- Output directly to the conversation (do not write to a file)
