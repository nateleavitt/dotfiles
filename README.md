### 🚀 One-line Install

```bash
curl -fsSL https://raw.githubusercontent.com/nateleavitt/dotfiles/main/install.sh | bash
```

Pass flags through to `setup/bootstrap.sh`:

```bash
curl -fsSL https://raw.githubusercontent.com/nateleavitt/dotfiles/main/install.sh | bash -s -- --dry-run --verbose
```

If prompted to install Xcode Command Line Tools, re-run the command after installation completes.

Here is a list of my dotfiles and how I bootstrap a new machine
for my local dev environment setup

**Please note** - By default this installs my dotfiles, including Vim
settings and plugins, plus platform-specific tooling via Homebrew (macOS)
or apt (Linux/WSL). See setup options below to run only selected sections.

## Prereqs  (Windows only) ##
Install WSL2 (Windows only)
```bash
wsl --install
```

Then install Docker for Windows (https://docs.docker.com/desktop/install/windows-install/)

## Installation ##
By default everything is installed in your HOME folder.
```bash
git clone git@github.com:nateleavitt/dotfiles.git
cd dotfiles
./bootstrap
```

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
