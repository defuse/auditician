# Licensing

claudit is free software under the **GNU Affero General Public License, version 3
or later**, with three additional permissions granted under AGPL section 7.

- `LICENSE` — the complete license text.
- `COPYRIGHT` — the copyright notice, the license grant, and the additional permissions.

**This file is explanation, not license terms.** Where this file and `COPYRIGHT`
disagree, `COPYRIGHT` and `LICENSE` control.

## The short version

| What you want to do | What you owe |
| --- | --- |
| Use claudit to audit your own code, or your clients' code | Nothing. |
| Sell audit reports produced with claudit | Nothing. The reports are yours. |
| Modify the agent prompts for your own use | Nothing, as long as you don't distribute or host the result. |
| Share your modified version | Publish it under the AGPL. |
| Run a modified version as an internal tool for your organization | Nothing, per additional permission 3. |
| Run a modified version as a paid service for customers | Publish your modified prompts under the AGPL, or buy a commercial license. |

The intent is simple: **claudit should be free for everyone to use and improve,
and it should not become the hidden engine of somebody's closed product.**

## Why the AGPL

Ordinary copyleft licenses have a hole: you can take the software, improve it,
run it on a server, sell access, and never share the improvements, because you
never distributed a copy to anyone. For a tool like this — whose entire value is
carefully tuned prompts driving a hosted model — that hole is the whole roof.
The AGPL closes it. Section 13 requires anyone who modifies claudit and offers it
to users over a network to offer those users the source of their modified
version.

That obligation lands unusually squarely here. For most software, the
"Corresponding Source" is less commercially valuable than the running service.
For claudit, the source *is* the product: the agent definitions in
`.claude/agents/` and the process documents in `docs/`. There is no compiled
artifact hiding the interesting part.

## How the license applies to prose

claudit is not conventional code. Almost all of it is English-language
instructions in Markdown. That doesn't affect whether it's copyrightable — these
are substantial original documents — but it does mean some AGPL vocabulary needs
reading in context. The copyright holder's stated interpretation, recorded here
so it is unambiguous to anyone considering a claudit-based product:

1. **The source form is the Markdown.** AGPL section 1 defines source as "the
   preferred form of the work for making modifications." There is no build step;
   the `.md`, `.tex`, `.json`, and shell files as distributed *are* the source.

2. **Running the prompts is running the program.** A service that loads these
   agent definitions into a language model's context in order to perform audits
   is running this work, not merely referencing it.

3. **Such a service is "interacting remotely" under section 13.** If you modify
   the agent definitions or process documents and let users anywhere reach that
   modified version over a network, section 13 is triggered, and the
   Corresponding Source you must offer is your modified Markdown.

## What the AGPL does *not* do here

Being straight about the limits, because they're real:

- **Unmodified hosting is allowed.** Section 13 triggers on modification. Anyone
  may run claudit exactly as published and charge for it. In practice this is a
  narrow gap, since a serious product would tune the prompts heavily — but it is
  a gap, and it is intentional in the AGPL's design.

- **Reimplementation is allowed, and no license can prevent it.** Copyright
  protects this particular expression, not the underlying method. Someone can
  read `docs/AUDIT-PROCESS.md`, understand the Survey → Brainstorm → Local →
  Global → Validation → Report pipeline and the invariant-centric threat modeling
  approach, write all of their own prompts from scratch, and owe nothing. That is
  how copyright works for everyone, including this project.

- **Your audit reports are not covered.** Additional permission 1 makes this
  explicit rather than leaving it to argument. Nothing claudit produces is
  encumbered.

- **The report templates are not covered.** Additional permission 2 releases
  `docs/example-report/`, `docs/example-threat-model/`, and
  `docs/SECURITY-ISSUE-TEMPLATE.md` under any terms you like. If you fill in the
  LaTeX template to produce a client deliverable, that deliverable is entirely
  yours.

- **Internal use triggers nothing.** Additional permission 3 waives section 13
  for deployments where every user is inside the operating organization and
  nobody is charged. Many companies have blanket policies against AGPL software;
  this permission exists so that a security team can adopt claudit internally
  without a legal review turning into a project.

## Third-party content

One file in this repository is not ours and is not AGPL:

`docs/example-threat-model/Wallet-App-Threat-Model.md` is reproduced from the
[Zcash documentation project](https://github.com/zodl-inc/zcash-docs) under the
MIT License, Copyright (c) 2016-2019 The Zcash Developers. It is included as a
worked example of an Invariant-Centric Threat Model so the agents have a
concrete format to follow. The full MIT notice is in
[`docs/example-threat-model/LICENSE.MIT`](docs/example-threat-model/LICENSE.MIT);
keep that file if you redistribute claudit.

MIT is compatible with the AGPL — it permits sublicensing, so a permissively
licensed document can be included in a copyleft work. The only condition is
retaining its notice.

## Commercial licensing

The AGPL is offered to the public. It does not bind the copyright holder, who is
free to offer the same work under different terms.

If you want to build claudit into a proprietary product or a paid service
without publishing your modifications, a commercial license is available.
Contact **taylor@defuse.ca**.

Buying a commercial license is a legitimate and expected path. The AGPL is here
to make sure that closed use is a deliberate, negotiated choice rather than a
free default — not to make commercial use impossible.

## Contributing

Because commercial licensing is offered, the project needs the right to license
contributions under terms other than the AGPL. Contributors keep their own
copyright and grant that right when they sign off on a commit. See
[CONTRIBUTING.md](CONTRIBUTING.md) for the full terms and the one-line mechanism.

## A note on license scanners

Because of the section 7 additional permissions, the precise SPDX expression for
this project is `AGPL-3.0-or-later` **with** a custom exception, which automated
license scanners will not recognize by name. The additional permissions only ever
*grant* rights beyond the AGPL, never restrict them, so treating this project as
plain `AGPL-3.0-or-later` is always a safe and conservative reading.
