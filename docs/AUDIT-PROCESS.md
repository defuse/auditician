# Audit Process

This is a global overview of the entire security audit process. Individual
agents should refer to this file for an understanding of how their work fits
into the total task of performing an audit.

A security audit consists of seven continually-operating processes:

1. Brainstorming
2. Threat modeling
3. Local auditing
4. Global auditing
5. Issue confirmation and validation
6. Report generation
7. Audit agent coordination

## 1. Brainstorming

I see auditing as a creative process, so once any engagement begins, the first
thing I do is start brainstorming. Before I look at anything specific to the
target project, I think about what kind of project it is and try to enumerate
all the things that could possibly go wrong with that kind of thing. For
example, if it’s an encryption program, I think about: weak key generation,
nonce reuse, weak encryption algorithms, lack of authentication, side-channel
attacks, and so on. I write all of these possibilities down. The point of this
exercise is to bring all of the things that might go wrong into your short-term
memory so that they will stand out to you, if they actually have gone wrong,
while you’re reading the relevant code.

Next, I learn as much as I can about the target project without diving into
anything too technical. I read the docs, the changelog, issues that look
relevant to security on the issue tracker, google for past vulnerabilities, and
read any past audit reports of the project. I build and use the project, too. As
I am doing that, I keep expanding my brainstorm notes with new ideas that come
to mind.

At the end of the brainstorming and research phase, you should have a list of
potential bugs and attacker goals. Your potential-bugs list is a brainstorm that
ideally includes all weaknesses that could possibly exist in the target project
(e.g. weak random number generator), and your attacker-goals list is a
brainstorm that ideally includes any goals an attacker might have (e.g. decrypt
the data).

## 2. Threat Modeling

At this point, you have a good understanding of what the target project is, what
weaknesses it might have, and the various ways attackers might try to attack its
users. If time permits, you can write up a formal (or at least detailed) threat
model for the project. If you do this right, it will help the developers
understand the security properties of their own software that they need to
maintain in the future, help users understand what security properties they’re
actually getting, and speed up future audits.

There are many valid approaches to threat modeling, a common one is STRIDE,
however I prefer an approach that I call Invariant-Centric Threat Modeling which
puts users first, requiring security properties to be written in language that
users can actually understand, and considers it a “bug” if users ever think they
are getting some security property that they actually are not.

## 3. Local Auditing

The Local Auditor Agent examines **one file** from the codebase at a time.  
- It reviews the file line by line, considering all brainstorm items and the
current threat model.  
- It adds new attacker goals or weaknesses to `audit-state/BRAINSTORM.md`.  
- It adds plausible issues, with file path and line references, to
`audit-state/ISSUES-PLAUSIBLE.md`.  
- Local auditing is about *possibility*, not proof — validation happens later.

## 4. Global Auditing

The Global Auditor Agent considers the **system as a whole**.  
- It looks for issues that depend on the interaction between components, APIs,
or trust boundaries.  
- It identifies emergent risks (e.g. privilege escalation, confused deputy,
logic flaws).  
- It adds brainstorm ideas to `audit-state/BRAINSTORM.md`.  
- It records plausible multi-component issues in
`audit-state/ISSUES-PLAUSIBLE.md`.

## 5. Issue Validation

The Issue Validator Agent investigates **one plausible issue or brainstorm item
at a time**.  
- If the issue is real, it moves it into `audit-state/ISSUES-CONFIRMED.md`.  
- If the issue is not valid, it moves it into `audit-state/ISSUES-INVALID.md`.  
- Confirmed issues must contain strong evidence: specific code references,
explanation of exploitability, and impact.  
- There must never be false positives in `ISSUES-CONFIRMED.md`.

## 6. Report Generation

The Report Generator Agent produces the final professional audit report.  
- It uses the template in `docs/example-report/` as a style guide.  
- It summarizes the **confirmed issues**, the **final threat model**, and the
**audit methodology**.  
- The completed report is written into `output/`.  
- This report must be suitable for delivery to developers and stakeholders.

## 7. Audit Agent Coordinator

The Coordinator Agent orchestrates the full process:  
1. Run the Brainstorming Agent.  
2. Run Local Auditing across **every file** in `audit-target/`.  
3. Run the Global Auditor Agent.  
4. For each plausible issue and brainstorm item, run the Issue Validator Agent.  
5. Run the Threat Modeling Agent to finalize `THREATMODEL.md`.  
6. Run the Report Generator Agent to create the final report in `output/`.  
7. Provide summaries of progress and consistency checks to the human auditor.

# Implementation Details

## Directory Structure

All READ ONLY documentation that's useful for AI auditing agents are in docs/:

- docs/ICTM.md describes the threat modeling methodology to be used.

- docs/AUDIT-PROCESS.md is this document describing the overall audit process.

- docs/example-report contains an existing LaTeX audit report, exemplifying the format that should be used for the final output report.

All WORKING STATE should be stored in audit-state/:

- audit-state/BRAINSTORM.md contains brainstorm notes, readable and writable by
ALL agents. Any agent should feel free to add ideas to the brainstorm. The
brainstorm should be a complete list of things that might *possibly* go wrong as
well as any goals an attacker attacking the system under audit might have.
Completeness is more important than a high signal to noise ratio.

- audit-state/ISSUES-PLAUSIBLE.md, audit-state/ISSUES-CONFIRMED.md,
audit-state/ISSUES-INVALID.md contain the security issues uncovered by the audit
at various stages of their discovery. Issues all start out either as ideas in
BRAINSTORM.md or as plausible issues in ISSUES-PLAUSIBLE.md. Whenever issues are
confirmed to definitely exist, they are moved to ISSUES-CONFIRMED.md. There must
never be any false positives in ISSUES-CONFIRMED.md.

- audit-state/THREATMODEL.md should contain an Invariant-Centric Threat Model
(see docs/ICTM.md) for the application being audited. This threat model should
be updated by auditing agents as the audit progresses and uncovers new
information about the target application. It must be CORRECT and SIMPLE enough
for the actual users of the application to understand.

The source code, design documents, etc. belonging to the application under audit
will be in audit-target/. Agents SHOULD NOT modify any files in this directory,
i.e. all audit notes and other state should go in audit-state/.

output/ will contain the final audit report (in the format exemplified in
docs/example-report) once the audit is complete.

## Agents

Agent prompts are defined in docs/agents/*.md.

## Commands

The following slash commands are available:

- `/brainstorm` → runs Brainstorming Agent.
- `/threatmodel` → runs Threat Modeling Agent.
- `/localaudit <file>` → runs Local Auditor Agent on `<file>`  
- `/globalaudit` → runs Global Auditor Agent  
- `/validate <issue-id>` → runs Issue Validator Agent on `<issue-id>`  
- `/report` → runs Report Generator Agent  
- `/audit` → runs the full audit process via the Coordinator Agent  