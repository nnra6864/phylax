# phylax

phylax (φύλαξ) - guard, watchman

> [!WARNING]
> This was made with Claude Opus 5.5.<br>
> It's made for personal use only, so don't expect any kind of support.

A brief vulnerability sweep of this server: the host, every running container, angie.<br>
Scanners find the problems, an LLM says which ones actually matter here and how to fix them.<br>
Python 3.11+, standard library only.<br>

## How it works

| Step | What | Tool |
|---|---|---|
| Host packages | Arch security tracker | `arch-audit` |
| Pending updates | what `pacman -Syu` would fix | `checkupdates` |
| AUR packages (angie, ...) | installed vs AUR version | AUR RPC |
| angie | installed vs latest tag, then CHANGES | GitHub, LLM |
| Containers | every running image, HIGH/CRITICAL, vulns only | `trivy --image-src podman` |
| Exposure | public / NetBird / localhost | `~/Containers/AGENTS.md`, `ss` |
| Triage | what affects us, what to run | `claude -p` with only WebFetch/WebSearch |

The LLM can't read files or run commands, it only gets the scan JSON and the context file.<br>
trivy runs with `--scanners vuln`, so no secrets from images end up in the prompt.<br>

## Installation

- Scanners
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
