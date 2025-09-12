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
- It adds plausible issues as individual files in `audit-state/issues/plausible/`.  
- It updates `audit-state/PROGRESS.md` with file audit status and progress.
- Local auditing is about *possibility*, not proof — validation happens later.

## 4. Global Auditing

The Global Auditor Agent considers the **system as a whole**.  
- It looks for issues that depend on the interaction between components, APIs,
or trust boundaries.  
- It identifies emergent risks (e.g. privilege escalation, confused deputy,
logic flaws).  
- It adds brainstorm ideas to `audit-state/BRAINSTORM.md`.  
- It records plausible multi-component issues as individual files in
`audit-state/issues/plausible/`.
- It updates `audit-state/PROGRESS.md` with global audit phase completion status.

## 5. Issue Validation

The Issue Validator Agent investigates **one plausible issue or brainstorm item
at a time**.  
- If the issue is real, it moves the file to `audit-state/issues/confirmed/`.  
- If the issue is not valid, it moves the file to `audit-state/issues/invalid/`.  
- Confirmed issues must contain strong evidence: specific code references,
explanation of exploitability, and impact.  
- It updates `audit-state/PROGRESS.md` with validation progress and status changes.
- There must never be false positives in confirmed issues.

## 6. Report Generation

The Report Generator Agent produces the final professional audit report.  
- It uses the template in `docs/example-report/` as a style guide.  
- It summarizes the **confirmed issues**, the **final threat model**, and the
**audit methodology**.  
- The completed report is written into `output/`.  
- This report must be suitable for delivery to developers and stakeholders.

## 7. Audit Agent Coordinator

The Coordinator Agent orchestrates the full process:  
1. Initialize `audit-state/PROGRESS.md` with audit metadata and file inventory.
2. Run the Brainstorming Agent and update progress tracking.  
3. Run Local Auditing across **every file** in `audit-target/`, updating progress after each file.  
4. Run the Global Auditor Agent and mark global phase complete.  
5. For each plausible issue and brainstorm item, run the Issue Validator Agent, tracking validation progress.  
6. Run the Threat Modeling Agent to finalize `THREATMODEL.md`.  
7. Run the Report Generator Agent to create the final report in `output/` and mark audit complete.  
8. Provide summaries of progress and consistency checks to the human auditor using the progress tracking data.

# Implementation Details

## Directory Structure

All READ ONLY documentation that's useful for AI auditing agents are in docs/:

- docs/ICTM.md describes the threat modeling methodology to be used.

- docs/AUDIT-PROCESS.md is this document describing the overall audit process.

- docs/example-report contains an existing LaTeX audit report, exemplifying the format that should be used for the final output report.

All WORKING STATE should be stored in audit-state/:

- audit-state/PROGRESS.md tracks the progress of the audit including phase completion, file-by-file progress, and issue validation status. ALL agents must update this file with their progress and use it to coordinate work and avoid duplication.

- audit-state/BRAINSTORM.md contains brainstorm notes, readable and writable by
ALL agents. Any agent should feel free to add ideas to the brainstorm. The
brainstorm should be a complete list of things that might *possibly* go wrong as
well as any goals an attacker attacking the system under audit might have.
Completeness is more important than a high signal to noise ratio. BRAINSTORM.md
contains raw ideas and concepts, NOT tracked issues with IDs.

- audit-state/issues/plausible/, audit-state/issues/confirmed/, and
audit-state/issues/invalid/ contain the security issues uncovered by the audit
at various stages of their discovery. These directories are the SINGLE SOURCE OF TRUTH
for individual issue status and details. Issues all start out either as ideas in
BRAINSTORM.md or as plausible issue files in issues/plausible/. Whenever issues are
confirmed to definitely exist, they are moved to issues/confirmed/. There must
never be any false positives in issues/confirmed/. Issues are identified by their individual filenames.

Do NOT duplicate individual issue tracking information in other files.
PROGRESS.md only tracks phase completion and file audit progress, never individual
issue details or status.

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

## Issue Identification

Issues are identified by their individual filename within the appropriate directory (plausible/, confirmed/, or invalid/). This eliminates the need for separate ID generation and prevents coordination conflicts when multiple agents work simultaneously.

## Issue Severity Classification

All confirmed security issues must be assigned one of the following severity levels:

**Critical**: A vulnerability that can definitely be exploited to impact many users with devastating consequences. These issues represent immediate and severe threats that require urgent remediation.

**High**: A vulnerability that is likely to have a severe impact on many users. While not as immediately critical as Critical issues, these still pose significant security risks.

**Medium**: A vulnerability of lesser impact or one that may only be exploitable in special circumstances. These issues may affect fewer users or have limited impact.

**Low**: A vulnerability whose exploitation would have very little impact on any user or which is unlikely to ever be exploited in practice. These are often theoretical or edge-case vulnerabilities.

### Severity Assignment Guidelines

- **Critical** and **High** severity issues must be fixed as soon as possible to protect users
- **Medium** severity issues are sometimes safe to defer based on risk assessment
- **Low** severity issues are almost always safe to defer
- Consider both impact (how bad if exploited) and likelihood (probability of exploitation)
- When in doubt, assign a higher severity level - it's better to err on the side of caution

All confirmed issue files in `audit-state/issues/confirmed/` must include their severity classification along with justification for the assigned level.

## Agents

Agent prompts are defined in .claude/agents/*.md and docs/agents/*.md.

## Commands

The following slash commands are available:

- `/brainstorm` → runs Brainstorming Agent.
- `/threatmodel` → runs Threat Modeling Agent.
- `/localaudit <file>` → runs Local Auditor Agent on `<file>`  
- `/globalaudit` → runs Global Auditor Agent  
- `/validate <issue-id>` → runs Issue Validator Agent on `<issue-id>`  
- `/report` → runs Report Generator Agent  
- `/audit` → runs the full audit process via the Coordinator Agent  

## Other Process Information (General Information)

### Source Code Review

Finally, the actual review process begins. I start by understanding the directory structure of the project (the tree command is very helpful!). Then, I start reading code file-by-file. If there is an entrypoint to the project (i.e. main())), I will usually start there. But generally, I will just read each file, in alphabetical order.

You might be a little surprised by the fact I read the files in alphabetical order. Wouldn’t it be better to understand the program by tracing through call stacks, understanding how classes relate to each other by drawing UML diagrams, and so forth? In a time-crunched audit (as all audits are), this actually isn’t the best use of time. It’s important to understand how the code you’re reading fits in to the overall structure of the program, but if the code is well-written and classes and functions are well-named, you can often correctly guess how it fits in. In practice, I find most of my bugs in this linear scan of the code. A linear scan of the code also guarantees a kind of completeness: you can be sure that you’ve at least had your eyeballs pointed at every single line of code in the project.

For this to work, the brainstorming process mentioned above is essential. Without it, problems won’t “jump out” at you as you are reading through the code. It’s also important to continue that same brainstorming process as you read the code, making note of any new ideas for potential problems that come to mind as you are diving deeper into the code. Make notes, like “this function returns -1 on error, if the caller doesn’t check it, a decryption error might be unnoticed, is the caller actually checking it?”, instead of getting bogged down confirming problems in this part of the process.

After the first pass of source code review, you should have an expanded set of notes with some potential issues, which you’ll want to check later. I use a star system to help prioritize which possible problems are most-worth looking into later, e.g. “*** it looks like it’s using rand() to generate key!?”, “* make sure the caller doesn’t pass a negative number here or else this will panic”.

You should also be confused about a lot of things and have notes like “I don’t get how this works!?”, “*** wtf how can this possibly be secure!!??”. In this stage, we’ve been going for breadth and speed rather than depth and confirmation; this is normal.

This is a good point to pause and do even more brainstorming. Ask yourself “what else could go wrong?”, “could any of the more-minor problems I’ve identified be combined together to attack the system in bigger ways?”

### Check Priority Potential Issues

After reviewing most or all of the code, you should have a much better understanding of how the code works, where things are, and a big list of TODOs: possible problems and a bunch of things you’re really confused about. The next step is to confirm some of those potential issues. This is the part where you actually need to start tracing through call stacks, understanding classes' relationships to each other, understanding if vulnerable-looking code is actually something an attacker’s input can reach, and so on.

If you’re really time-crunched, you won’t be able to check everything, so prioritize by which problems you intuitively think are most likely to be “real”, and by which kinds of problems would be the worst for the project’s users.

A key thing to look for in this stage is the correctness (or incorrectness) of how different components of the software interface with each other. This is especially true when the different components were written by different people, e.g. if your target software uses a library, you want to carefully read that library’s documentation and make sure it’s being used correctly.

At the end of this stage, you should have found the bulk of the issues which you can begin writing up in your report.

### Deep Analysis for Correctness

Following the steps above will give you a broad and efficient coverage of the entire project, and you will likely have found most of the bugs that will make it into your report. For some kinds of code, it’s unavoidably necessary to dive in much deeper and check that everything is correct.

“Correctness” means that the code always does what it is intended to, i.e. that there are no bugs at all. As much as security engineers like to talk about “security bugs” as a distinct category from “ordinary” kinds of bugs, security is really about correctness. That’s because any kind of bug, even ones that seem benign, can potentially be used by an attacker to further their goals.

For certain kinds of code, especially cryptography, parsers, and anything enforcing access control, there is no way to assure security except to deeply understand and ensure the absolute correctness of all of the relevant code. The modern way to do this is via formal verification, a computer-checkable proof that the code will always do exactly what it is intended to do. Formal verification is expensive to implement (but tools are getting better), and it depends on having a detailed specification of what the code is “supposed to do”, so it is not always a viable option.

The next best thing is for a human—the auditor—to carefully check that everything is correct. Based on the preceding stages, you should have a good idea of which parts of the target program are ultra-security-critical and are worthy of checking for correctness in extreme detail. The mindset to be in here is that of someone trying to prove the code is correct. Unless you are absolutely, mathematically, convinced that the code is correct and conforms to its specification, you still have more work to do.

Doing this is extremely costly; whereas you might be able to get through a dozen source code files in a day of normal review, it might take an entire day of careful thinking to ensure the correctness of just one part of a cryptographic algorithm or protocol.

There are some tricks to avoid this, such as writing randomized tests to compare two implementations of cryptographic primitives against each other, but to whatever degree the relevant code is absolutely essential for security, you often have to spend a lot of time checking its correctness.