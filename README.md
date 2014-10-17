Here is a list of my dotfiles and how I bootstrap a new machine 
for my local dev environment setup

*Please note* - By default this will install my dotfiles which includes vim settings and
plugins. It also installs Homebrew and RVM by default. See examples if
you would like to install without those.

## Installation ##
  * First, clone the repo
  * Then cd into the `dotfiles` folder and run `bootstrap`

then run the same command with the following options
  * Don't install Homebrew `-b false`
  * Don't install RVM `-r false`

## Examples ##
Installation without Homebrew
```bash
bootstrap -b false
```

without RVM
```bash
bootstrap -r false
```

without both
```bash
bootstrap -b false -r false
```

## More Info ##
