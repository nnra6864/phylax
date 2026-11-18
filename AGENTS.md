# phylax: guide for agents

Weekly vulnerability sweep for the home server described in `~/Containers/AGENTS.md`. Read that file's hard rules first; they apply here too.

## Layout

- `phylax`: the whole program, Python stdlib only (`#!/usr/bin/python3 -I`). Collects data, builds the prompt, runs `claude -p`, saves the report.
- `prompt.md`: triage instructions given to the LLM. Change judging rules here, not in code.
- `config.example.toml`: copied to `~/.config/phylax/config.toml` on first install. TOML: plain keys before `[tables]`.
- `install.sh` installs for the user, without sudo. Scheduling and Matrix delivery belong to sema's `scan` module (`~/Packages/sema/sema-scan`), not here.
- Exit codes are the contract with sema: 0 all clear, 3 something to act on (sema pings), 1 failed. The report is stdout, progress is stderr.

## Rules

- Scanners find, the LLM judges. Don't move detection into the prompt that a deterministic tool can do.
- Nothing secret may reach the prompt: no `.env`, no `podman inspect` on containers, no `podman compose config`, trivy stays `--scanners vuln`. `podman image inspect` with an explicit `--format` of non-secret fields is fine.
- The triage run gets WebFetch/WebSearch only (`--tools`), never Read/Bash.
- Providers differ only by env vars passed to Claude Code (`ANTHROPIC_BASE_URL`, token file). `ANTHROPIC_*` from the parent env is stripped first.
- The owner runs fixes. phylax never pulls, restarts or upgrades anything.
