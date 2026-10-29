# dotfiles

My shell, editor, and tooling setup for macOS, Linux, and WSL, plus the scripts that bootstrap a new machine.

### 🚀 One-line Install

```bash
curl -fsSL https://raw.githubusercontent.com/nateleavitt/dotfiles/main/install.sh | bash
```

This clones the repo to `~/code/dotfiles` and runs `setup/bootstrap.sh`. Pass flags through:

```bash
curl -fsSL https://raw.githubusercontent.com/nateleavitt/dotfiles/main/install.sh | bash -s -- --dry-run --verbose
```

If prompted to install Xcode Command Line Tools, re-run the command after installation completes.

**Please note** - By default this installs my dotfiles, including Vim
settings and plugins, plus platform-specific tooling via Homebrew (macOS)
or apt (Linux/WSL). See [Sections](#sections) to run only what you need.

## Prereqs (Windows only) ##
Install WSL2
```bash
wsl --install
```

Then install Docker for Windows (https://docs.docker.com/desktop/install/windows-install/). On macOS, the `runtime` section installs OrbStack instead.

## Installation ##
```bash
git clone git@github.com:nateleavitt/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./setup/bootstrap.sh
```

Config files are symlinked into `$HOME` from the clone, so a `git pull` updates them with no re-run. Anything already in the way is backed up as `<file>.bak.<timestamp>`.

## Setup Script Usage

The setup entrypoint is `setup/bootstrap.sh` (the legacy `./bootstrap` and `./bootstrap-osx` wrappers still work).

```bash
# show help
./setup/bootstrap.sh --help

# dry run everything
./setup/bootstrap.sh --dry-run

# run only dotfiles setup
./setup/bootstrap.sh --only dotfiles

# skip optional extras
./setup/bootstrap.sh --skip extras

# combine flags
./setup/bootstrap.sh --dry-run --verbose --skip extras

# optional Python (pyenv): include in a full run
INSTALL_PYENV=1 ./setup/bootstrap.sh

# or install pyenv only (macOS needs Homebrew on PATH, e.g. run shell first)
./setup/bootstrap.sh --only python
```

## Sections

A full run goes in this order. `--only` takes one section per run.

| Section | macOS | Linux / WSL |
|---------|-------|-------------|
| `shell` | Homebrew, Oh My Zsh, `chsh` to zsh | Build libraries, ack, curl, wget, gnupg, zsh, Oh My Zsh, `chsh` to zsh |
| `dotfiles` | Symlinks `.zshrc`, `.vim*`, `.gitignore_global`, Oh My Zsh custom files | Same |
| `runtime` | rbenv + ruby-build, Node, OrbStack | Node (NodeSource LTS), PostgreSQL, rbenv + ruby-build, `~/code` |
| `python` | pyenv (opt-in) | pyenv + build deps (opt-in) |
| `editor` | VS Code, Cursor, Vim plugins (Vundle) | Vim plugins (Vundle) |
| `git` | Global gitignore, `pager.branch false` | Same |
| `extras` | Typora, Slack, ack, wget, `~/code`, macOS defaults, fonts | gcloud CLI + GKE auth plugin, `apt autoremove` |

### Servers and minimal machines

Skip the dev stack and run just the shell pieces, `shell` first (`dotfiles` creates `~/.oh-my-zsh/custom`, which makes the Oh My Zsh installer refuse to run):

```bash
./setup/bootstrap.sh --only shell
./setup/bootstrap.sh --only dotfiles
./setup/bootstrap.sh --only editor   # the vimrc errors without its plugins
./setup/bootstrap.sh --only git
```

Accounts with no password (cloud VMs with key-only SSH) can't run plain `chsh`, so the end of the `shell` section fails with `PAM: Authentication failure`. Oh My Zsh is installed by then. Set the shell with:

```bash
sudo chsh -s "$(command -v zsh)" "$USER"
```

## Machine-specific config

`~/.zshrc` sources `~/.zshrc.local` last, if it exists. Put PATH entries, aliases, and anything else specific to one machine there. This repo is public: never commit secrets, tokens, or shell history.

## Code layout

Repos live flat in `~/code/<repo>` (`$DEV_ROOT`), with no `github.com/<owner>/` nesting. If two repos share a name, pick the folder name when you clone.

- `c <repo>` jumps to a repo, with tab completion.
- `c` on its own opens an fzf picker over every repo (plain `cd ~/code` without fzf).
