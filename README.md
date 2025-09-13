# claudit

This repository defines a complete workflow for running structured AI-assisted
security audits. It uses Claude Code slash commands to coordinate multiple
specialized agents (brainstorming, threat modeling, local auditing, global
auditing, issue validation, reporting, and coordination).

## Directory Layout

- `docs/`
  - `AUDIT-PROCESS.md` – overview of the full audit process
  - `ICTM.md` – description of the Invariant-Centric Threat Modeling methodology
  - `example-report/` – LaTeX example report (formatting reference)
  - `example-threat-model` - An example threat model for reference by the threat modeling agent.
- `audit-state/`
  - `BRAINSTORM.md` – raw brainstorm notes from agents
  - `PROGRESS.md` – progress tracking during the audit
  - `SURVEY.md` - A broad overview of the audit target, to aid agents' understandings.
  - `THREATMODEL.md` – evolving invariant-centric threat model
  - `issues/plausible/` – individual files for issues suspected but not yet validated
  - `issues/confirmed/` – individual files for issues confirmed to be real
  - `issues/invalid/` – individual files for disproven issues
  - `globals/` - results of 'global' feature or area-focused audits
- `audit-target/` – **place your target project here**
- `output/` – final audit report is written here
- `.claude/agents` - prompt definitions for each agent
- `.claude/commands` - slash commands for claude code

## Getting Started

1. Clone this repo fresh for each audit:

```
    git clone <this-repo-url> my-audit
    cd my-audit
```

2. Put the project to audit inside audit-target/.

3. Run the full process:
    claude --verbose # --verbose if you want to watch what the sub-agents are doing
    /audit

4. Or run agents individually:
    /brainstorm
    /threatmodel
    /localaudit path/to/file
    /globalaudit
    /validate <issue-id>
    /report

Results appear in audit-state/, final report in output/.