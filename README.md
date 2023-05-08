Here is a list of my dotfiles and how I bootstrap a new machine 
for my local dev environment setup

**Please note** - By default this will install my dotfiles which 
includes vim settings and plugins. It also installs Homebrew, RVM, 
and Mvim by default. See options for a list of all options you would
like to install without those.

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
bootstrap # look at options below
```

## Options ##
  * `-b <boolean>` install Homebrew (default true)
  * `-m <boolean>` install Mvim (default true)

## Examples ##
Installation without Homebrew
```bash
bootstrap -b false
```

without both Homebrew and mvim
```bash
bootstrap -b false -m false
```

## Todos ##
Need to update scripts
