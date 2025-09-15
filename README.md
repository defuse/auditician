# claudit

This repo contains a set of Claude Code agent definitions and English-language descriptions of security auditing processes, which together can be used to automatically perform security audits.

## Directory Layout

At a high level,

- `.claude` contains the Claude Code-specific agent and command definitions.
- `audit-state/` is the working directory used by AI auditing agents, tracking audit progress and issues.
- `docs/` contains read-only security audit process documentation useful to the AI agents.
- `audit-target/` is where the human user should put the target application's code, documentation, etc.
- `report/` is where the final audit report will be generated.

To fine-tune the AI's behavior, edit the agents' instructions in in `.claude/agents` and files in `docs/`. For example, you can put your audit report template in `docs/example-report`.

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

Launch claude code and begin the audit with `/audit`:

```
claude
...
> /audit
```

If your audit is interrupted, you can resume by simply running the `/audit` command again or asking claude to perform any of the audit stages described in `docs/AUDIT-PROCESS.md`.

### For Greater Security

Claude will ask for permission to do a lot of things. If you don't want to babysit it, you can run `claude --dangerously-skip-permissions` at your own risk.

You can use Docker to somewhat sandbox Claude by installing the [Dev Containers](marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) VSCode extension; after installation, VSCode should see the `.devcontainer` folder included in this repo and offer to relaunch so that your terminal runs inside a container. See the [Anthropic docs](https://docs.anthropic.com/en/docs/claude-code/devcontainer) for more information.