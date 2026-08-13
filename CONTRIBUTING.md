# Contributing to auditician

Contributions are welcome — improved agent prompts, sharper process
documentation, fixes for cases where the agents go wrong.

Because prompt quality is the whole product here, the most valuable
contributions are usually concrete: a case where an agent produced a false
positive and the prompt change that fixed it, not a general rewrite.

## Contributor License Agreement

auditician is released under the GNU AGPL v3 or later (see [LICENSING.md](LICENSING.md)),
and commercial licenses are also offered to organizations that want to use it in
a proprietary product. That second option only remains possible if the project
can license *all* of its content under those terms — including yours.

So contributions are accepted under the following agreement. **You keep the
copyright in your contribution.**

By signing off on a commit, you certify that:

1. **You wrote it, or you have the right to submit it.** The contribution is
   your original work, or you have sufficient rights to submit it under these
   terms. It is not subject to any other license or agreement that conflicts
   with them.

2. **You retain your copyright.** Nothing here assigns or transfers ownership of
   your contribution to anyone.

3. **You license it to the public under the AGPL.** You grant every recipient of
   auditician a license to your contribution under the GNU Affero General Public
   License version 3 or later, together with the additional permissions stated
   in [COPYRIGHT](COPYRIGHT).

4. **You license it to the maintainer under any terms.** You grant Taylor Hornby
   a perpetual, worldwide, non-exclusive, irrevocable, royalty-free,
   transferable, and sublicensable license to reproduce, modify, prepare
   derivative works of, publicly display, publicly perform, and distribute your
   contribution, and to license and sublicense it to third parties under any
   terms, including terms that differ from the GNU AGPL and including
   proprietary terms.

5. **You provide it as-is.** Your contribution is offered without warranty of
   any kind, to the extent permitted by law.

6. **Your record is public.** You understand that your contribution, your
   sign-off, and the name and email address you sign off with are public and are
   kept indefinitely as part of the project's history.

Clause 4 is the one that makes commercial licensing possible. If you are not
willing to grant it, please open an issue describing the problem and the fix
rather than submitting the fix as a patch — a described improvement someone else
implements independently carries no such obligation.

If you are contributing on behalf of an employer, make sure you actually have
the authority to grant clause 4 before signing off.

## How to sign off

Add a `Signed-off-by` line to each commit, which git will write for you:

```
git commit -s -m "your message"
```

This produces a trailer like:

```
Signed-off-by: Your Name <your.email@example.com>
```

Use your real name and a working email address. A pull request whose commits are
not signed off cannot be merged.

## Practical notes

- Keep changes to `.claude/agents/*.md` focused. These files are loaded into the
  model's context on every invocation, so unnecessary length has a real cost.
- Do not add license header comments to files in `.claude/agents/` or
  `.claude/commands/`. Their YAML frontmatter must be the first thing in the
  file, and every added line is context spent on each run. The repository-level
  `LICENSE` and `COPYRIGHT` files cover everything.
- If you change how the audit process works, update `docs/AUDIT-PROCESS.md` to
  match.
- Say what you tested against. "Ran a full audit on <project> and the validator
  stopped flagging X" is far more useful than a diff on its own.
