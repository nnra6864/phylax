# phylax

phylax (φύλαξ) - guard, watchman

> [!WARNING]
> This was made with Claude Opus 5.5.<br>
> It's made for personal use only, so don't expect any kind of support.

A brief vulnerability sweep of a Linux server: the host, every running container, the web servers in front.<br>
Scanners find the problems, an LLM says which ones actually matter on this machine and how to fix them.<br>
Python 3.11+, standard library only.<br>

## How it works

It figures out what the machine runs, nothing to list by hand.<br>

| Step | What | Tool |
|---|---|---|
| Distro | Arch, Debian/Ubuntu, Fedora/RHEL, openSUSE, Alpine | `/etc/os-release` |
| Host packages | known CVEs | `trivy` on the package database, `arch-audit` on Arch |
| Pending updates | what a normal upgrade would fix | `checkupdates`, `apt`, `dnf`, `zypper`, `apk` |
| Web servers, sshd | angie, nginx, caddy, traefik, apache, haproxy, OpenSSH vs latest upstream | GitHub tags, advisories via the LLM |
| AUR packages | installed vs AUR version (Arch) | AUR RPC |
| Containers | every running image, its ports and compose dir, HIGH/CRITICAL | `trivy`, podman and/or docker |
| Exposure | listening sockets, published ports, running services | `ss`, `systemctl` |
| Login settings | sshd's password/PAM/root-login switches, host and containers running sshd | config files, `sshd -T` |
| Triage | what affects this machine, what to run | `claude -p` with only WebFetch/WebSearch |

The LLM can't read files or run commands, it only gets the scan data and your context files.<br>
trivy runs with `--scanners vuln`, so no secrets from images end up in the prompt.<br>
From sshd it keeps only a fixed list of yes/no switches like `PasswordAuthentication`, never passwords, hashes or keys.<br>
Only one run at a time, a second one waits (trivy's cache can't be shared).<br>

## Context

phylax can't know your firewall, VPN or which services friends depend on. Tell it in plain Markdown:<br>
`context_files = ["~/.config/phylax/site.md"]` in the config. It's sent to the provider, so no secrets.<br>

## Installation

- Scanners: `trivy`, plus `arch-audit` on Arch
```sh
sudo pacman -S trivy arch-audit
```

- Install, safe to run again
```sh
sh install.sh
```

## Alerts

sema's `scan` module runs phylax weekly as your user and posts the report to the Matrix alerts room.<br>
It pings only when there is something to act on. Add `scan` to `MODULES` in `/etc/sema/config`, then `sudo sh ~/Packages/sema/install.sh`.<br>

| Exit code | Meaning |
|---|---|
| `0` | all clear |
| `3` | something to act on |
| `1` | scan or triage failed |

## Usage

| Command | What |
|---|---|
| `phylax` | full sweep, report printed and saved |
| `phylax --no-llm` | scan data only, no LLM |
| `phylax --dry-run` | print the prompt that would be sent |
| `phylax --skip-images` | host only, skips trivy (fast) |
| `phylax -p glm` | use another provider for this run |
| `less ~/.local/state/phylax/latest.md` | last report |

## Providers

Both go through Claude Code, so the prompt and tools are identical, only the backend changes.

| Provider | Setup |
|---|---|
| `claude` | nothing, uses your `claude` login |
| `glm` | `install -m600 /dev/stdin ~/.config/phylax/glm.token`, paste the Z.ai key, Ctrl+D |

Switch with `provider = "..."` in `~/.config/phylax/config.toml`.<br>
Dropping GLM later: set `provider = "claude"`, delete the `[providers.glm]` block and the token.<br>

# ☦

```
   Ὤ
 Ὁ   Ν
Ι̅Ϲ̅ │ Χ̅Ϲ̅
───┼───
ΝΙ │ ΚΑ
   ☦
```

Εἰς δόξαν τοῦ Θεοῦ<br>
*To the glory of God*

Τῇ Ὑπεραγίᾳ Θεοτόκῳ δόξα<br>
*Glory to the Most Holy Theotokos*

Δόξα τῷ Θεῷ πάντων ἕνεκεν<br>
*Glory to God for all things*

ΑΜΗΝ

☦
