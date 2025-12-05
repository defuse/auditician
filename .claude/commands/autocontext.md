---
description: Automatically generate audit instructions and gather relevant context
---

You are tasked with generating audit instructions and gathering relevant external context for a comprehensive security audit. This runs fully automated - gather everything, then the user will review and edit your output.

**Before you begin**: Read `docs/AUDIT-PROCESS.md` to understand how the full audit works. Your job is to prepare context that will help the surveyor, brainstormer, local auditor, global auditor, and validator agents do their jobs effectively.

## Step 1: Check for Existing Instructions

Read `audit-context/AUDIT-INSTRUCTIONS.md`. If it has already been customized (not just the default template), ask the user whether to:
- Enhance it with additional context you discover
- Replace it entirely
- Abort

## Step 2: Analyze the Audit Target

Thoroughly analyze `audit-target/`:

1. **Identify the project**: Read README, package.json, Cargo.toml, go.mod, or equivalent. What is this? What does it do?

2. **Identify security-critical areas**: What components handle authentication, cryptography, parsing untrusted input, access control, financial logic, network protocols, or memory management?

3. **Identify specifications**: Does this implement any protocol, standard, or spec (RFCs, EIPs, cryptographic standards, etc.)? Look in docs, comments, and imports.

4. **Identify security-critical dependencies**: Which dependencies are on the critical path for security (crypto libs, auth libs, parsers for untrusted data)? Ignore non-security deps like UI frameworks, logging, testing tools.

## Step 3: External Intelligence

Based on Step 2, search for:

1. **Past audits**: Search "[project name] security audit report" - summarize findings if found
2. **Known vulnerabilities**: Search "[project name] CVE" or "security advisory" - document any known issues
3. **Specifications**: If it implements a spec, note the URL/reference (don't fetch entire documents)
4. **Critical dependency issues**: For security-critical deps, check for known vulnerabilities in the versions used

Note what you found and what you didn't find.

## Step 4: Generate AUDIT-INSTRUCTIONS.md

Fill in `audit-context/AUDIT-INSTRUCTIONS.md` using the section structure already defined in that file. The goal is a **comprehensive security audit** - we want to find ALL security issues, not just one category.

Think about what information will help the auditing agents:
- The **surveyor** needs to understand what the project is
- The **brainstormer** needs to know what could go wrong with this type of system
- The **local auditor** needs to know which files are security-critical
- The **global auditor** needs threat model context to guide cross-cutting analysis
- The **validator** needs to understand real-world impact to assess severity

## Step 5: Save Additional Context

If you found useful external resources (past audit reports, relevant documentation), save summaries or links to `audit-context/`.

## Key Principles

- **Don't invent information**: If searches find nothing, say "no results found." Hallucinated CVEs or past findings would actively mislead auditors.
- **Comprehensive scope by default**: Include everything in audit-target/ unless there's a clear reason to exclude it (test fixtures, generated files, etc.).
- **Be concise**: These instructions will be read into the context of all auditing agents. Keep it focused and avoid unnecessary verbosity.
