# claudit

This repo contains a set of Claude Code agent definitions and English-language security audit process descriptions which together can be used to automatically perform security audits.

## Security & Privacy Warning

Large Language Models are vulnerable to **prompt injection attacks**. Claude may misinterpret parts of the code being audited *as prompt instructions* rather than as code to be audited, so auditing untrusted code could lead to your system becoming compromised unless you carefully monitor Claude's behavior.

Depending on your Anthropic account's settings, Anthropic may collect and store all of the data that passes through its system for use in AI training. This means that they will obtain any private source code you use this tool to audit and they will be informed of any security vulnerabilities that this tool discovers.  **Refer to Anthropic's privacy policy to understand what data they collect and what options you have for reducing their use and retention of your data.**

## Getting Started

Make a fresh clone of this repo for each audit:

```
  git clone git@github.com:defuse/claudit.git example-app-audit
  cd example-app-audit
```

Clone the thing you want to audit into `audit-target/`:

```
  cd audit-target
  git clone <whatever you want to audit>
  cd ..
```

If desired, you can customize the audit by editing `audit-context/AUDIT-INSTRUCTIONS.md`. 

You can also place additional material that the agents may find helpful during the audit, such as documentation, dependency source code, past audit reports, etc. into `audit-context/`.

Launch claude code, select the model you want to use, and begin the audit with `/audit`:

```
claude
...
> /model # Sonnet 4 is recommended for performance
> /audit
```

If your audit is interrupted, you can resume by simply running the `/audit` command again or asking claude to perform any of the audit stages described in `docs/AUDIT-PROCESS.md`.

To fine-tune the AI's behavior, edit the agents' instructions in in `.claude/agents` and files in `docs/`. For example, you can put your audit report template in `docs/example-report`.

You can also talk to claude as it's working to guide it. Watching what it's doing and collaborating with it usually produces better results than letting it do the entire audit in one go.

#### Isolating Claude in Containers

Claude will ask for permission to do a lot of things. If you don't want to babysit it, you can run `claude --dangerously-skip-permissions` at your own risk.

You can use Docker to somewhat sandbox Claude by installing the [Dev Containers](marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) VSCode extension; after installation, VSCode should see the `.devcontainer` folder included in this repo and offer to relaunch so that your terminal runs inside a container. See the [Anthropic docs](https://docs.anthropic.com/en/docs/claude-code/devcontainer) for more information.

## Directory Layout

At a high level,

- `.claude` contains the Claude Code-specific agent and command definitions.
- `audit-state/` is the working directory used by AI auditing agents, tracking audit progress and issues.
- `docs/` contains read-only security audit process documentation useful to the AI agents.
- `audit-target/` is where the human user should put the target application's code, documentation, etc.
- `report/` is where the final audit report will be generated.

## Tips

### Understanding the Audit Flow
The audit runs in phases: Survey → Brainstorm → Local (file-by-file) → Global (cross-cutting) → Validation → Report. Each phase builds on the previous ones, so don't skip ahead.

### Key Files to Watch
- `audit-state/PROGRESS.md` - Master tracking document showing audit completion status
- `audit-state/SURVEY.md` - AI's understanding of the system - verify this is accurate
- `audit-state/THREATMODEL.md` - Security model and invariants - check this matches reality
- `audit-state/issues/plausible/` - Issues found but not yet validated
- `audit-state/issues/confirmed/` - Validated security issues that will appear in the report

### Guiding the Audit
- **Before starting**: Customize `audit-context/AUDIT-INSTRUCTIONS.md` to focus on your concerns
- **During local audit**: If Claude skips files, check PROGRESS.md and explicitly tell it to audit PENDING files
- **During validation**: Claude validates 1-3 issues at a time; intervene if it gives the validator too many complex issues
- **For better results**: Add your security knowledge to BRAINSTORM.md - agents will incorporate your ideas

### Time Expectations
- Local auditing: ~5-15 minutes per file depending on complexity
- Validation: ~2-5 minutes per issue
- Full audit of a 50-file project: Several hours to a full day