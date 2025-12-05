# Audit Instructions

## Project Overview

[Brief description of what this project is and what it does]

## Audit Scope

**In Scope**: All files and components in `audit-target/`.

**Out of Scope**: [Test files, documentation, vendored dependencies, build scripts - anything that doesn't affect runtime security. Specify here, or leave blank if everything is in scope.]

## Priority Areas

[Components that are security-critical and warrant extra scrutiny. Examples: authentication, cryptography, input parsing, access control. Leave blank for equal attention to all areas.]

## Known Issues

[Any CVEs, past audit findings, or acknowledged security limitations. If none known, say so.]

## Specifications

[If the project implements protocols/standards (RFCs, EIPs, cryptographic standards, etc.), list them here with links. Auditors should verify correctness against these.]

## Threat Model Context

- **Likely attackers**: [Who would attack this? Remote attackers, malicious users, nation states, etc.]
- **Attacker goals**: [What would they want? Steal funds, exfiltrate data, RCE, privilege escalation, etc.]
- **Trust boundaries**: [What inputs are untrusted? Network data, user input, local files, etc.]

## Code Areas That Should Get Extra Attention

[Specific file paths or code areas that warrant extra scrutiny. Leave blank if no specific areas.]

## Extra Focus Areas for Global Audits

[Additional focus areas for the global auditing phase, beyond what the coordinator generates. Leave blank to use coordinator defaults.]

## Additional Context

[Any other information useful to auditors. Reference additional files in `audit-context/` if present.]

---
*This file guides the security audit. The /autocontext command can auto-generate this based on the audit target. Defaults request a comprehensive audit of everything.*
