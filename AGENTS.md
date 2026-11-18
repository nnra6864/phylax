# phylax: guide for agents

Weekly vulnerability sweep for any Linux server. It detects the distro, container runtimes and network software itself.
It was built for the owner's home server (`~/Containers/AGENTS.md`, read its hard rules first, they apply here too), but nothing about that machine belongs in this repo: its specifics live in `~/.config/phylax/site.md`, passed in through `context_files`.

## Layout

- `phylax`: the whole program, Python stdlib only (`#!/usr/bin/python3 -I`). Collects data, builds the prompt, runs `claude -p`, saves the report.
- `prompt.md`: generic triage instructions given to the LLM. Change judging rules here, not in code. Machine-specific rules go in a context file.
- Distro support lives in `installed_packages`, `pending_updates`, `host_vulns`; network software in `SOFTWARE`. Add to those tables rather than special-casing.
- `config.example.toml`: copied to `~/.config/phylax/config.toml` on first install. TOML: plain keys before `[tables]`.
- `install.sh` installs for the user, without sudo. Scheduling and Matrix delivery belong to sema's `scan` module (`~/Packages/sema/sema-scan`), not here.
- Exit codes are the contract with sema: 0 all clear, 3 something to act on (sema pings), 1 failed. The report is stdout, progress is stderr.

## Rules

- Scanners find, the LLM judges. Don't move detection into the prompt that a deterministic tool can do.
- Nothing secret may reach the prompt: no `.env`, no `podman inspect` on containers (only `ps --format json` fields: image, names, ports, the compose working_dir label), no `podman compose config`, trivy stays `--scanners vuln`. `podman image inspect` with an explicit `--format` of non-secret fields is fine.
- sshd: only the keys in `SSHD_KEYS` with values matching `SSHD_VALUE` leave the machine. Never read `/etc/shadow`, host keys or `authorized_keys`, and never pass `podman top` output through; it's only searched for sshd.
- The triage run gets WebFetch/WebSearch only (`--tools`), never Read/Bash.
- Providers differ only by env vars passed to Claude Code (`ANTHROPIC_BASE_URL`, token file). `ANTHROPIC_*` from the parent env is stripped first.
- The owner runs fixes. phylax never pulls, restarts or upgrades anything.
