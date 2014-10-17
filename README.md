Here is a list of my dotfiles and how I bootstrap a new machine 
for my local dev environment setup

**Please note** - By default this will install my dotfiles which 
includes vim settings and plugins. It also installs Homebrew, RVM, 
and Mvim by default. See options for a list of all options you would
like to install without those.

## Installation ##
By default everything is installed in your HOME folder.
```bash
git clone git@github.com:nateleavitt/dotfiles.git
cd dotfiles
bootstrap # look at options below
```

## Options ##
  * `-b <boolean>` install Homebrew (default true)
  * `-r <boolean>` install RVM (default true)
  * `-m <boolean>` install Mvim (default true)

## Examples ##
Installation without Homebrew
```bash
bootstrap -b false
```

without RVM
```bash
bootstrap -r false
```

without both Homebrew and RVM
```bash
bootstrap -b false -r false
```
