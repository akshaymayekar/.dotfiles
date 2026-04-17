# dotfiles

Personal dotfiles for macOS (Apple Silicon). Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stack

| Layer | Tool |
|---|---|
| Terminal | [WezTerm](https://wezfurlong.org/wezterm/) / [Ghostty](https://ghostty.org) |
| Shell | [fish](https://fishshell.com) (default) / zsh |
| Prompt | [Starship](https://starship.rs) |
| Version manager | [mise](https://mise.jdx.dev) |
| Plugin manager (zsh) | [znap](https://github.com/marlonrichert/zsh-snap) |
| Packages | [Homebrew](https://brew.sh) |
| Dotfile manager | [GNU Stow](https://www.gnu.org/software/stow/) |

## Structure

```
dotfiles/
├── Brewfile                        # all explicitly installed packages
├── makefile                        # setup, stow, brew targets
├── scripts/
│   └── brew-sync.sh                # sync new brew installs into Brewfile
├── fish/
│   └── .config/fish/
│       ├── config.fish             # PATH, env, mise, starship, uv
│       ├── conf.d/
│       │   └── abbr.fish           # abbreviations (git, docker, ls, etc.)
│       ├── completions/
│       │   └── uv.fish             # lazy-loaded uv completions
│       └── functions/
│           ├── mkcd.fish           # mkdir + cd
│           ├── killport.fish       # find and kill processes on port
│           ├── fish-regen.fish     # rebuild startup caches
│           └── fish_user_key_bindings.fish
├── zsh/
│   ├── .zshenv                     # ZDOTDIR, Rust/cargo env
│   ├── .zprofile                   # Homebrew static exports (login shell)
│   ├── .zshrc                      # core zsh config, plugins, tools
│   ├── .zaliases                   # all aliases grouped by tool
│   ├── .zkeybindings               # key bindings (standard + WezTerm)
│   └── .zfunctions                 # custom shell functions (mkcd, killport)
├── starship/
│   └── .config/starship.toml       # minimal prompt config
├── wezterm/
│   └── .wezterm.lua                # WezTerm config
└── ghostty/
    └── .config/ghostty/config      # Ghostty config
```

## Fresh Machine Setup

```sh
# 1. Clone the repo
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Bootstrap everything (installs Homebrew, packages, symlinks dotfiles)
make bootstrap
```

`make bootstrap` does:
1. Installs Homebrew if not present
2. Installs all packages from `Brewfile`
3. Symlinks all dotfiles via stow

## Common Commands

```sh
make help          # list all available targets

# dotfiles
make stow          # symlink all dotfiles
make unstow        # remove all symlinks
make restow        # re-link (after adding new files)

# homebrew
make brew-install  # install packages from Brewfile
make brew-sync     # interactively add new brew installs to Brewfile

# maintenance
make clean         # remove zsh and fish startup caches
make fish-regen    # rebuild fish startup caches (after upgrading mise/starship/uv)

# vscode
make backup-vscode-extensions   # save current VSCode extensions to file
make install-vscode-extensions  # install extensions from file
```

## Shell Functions

Custom functions available in both fish and zsh:

```sh
mkcd <directory>    # create directory and cd into it
killport <port>     # find and kill processes running on port (with confirmation)
```

## Shells

Fish is the default shell. Zsh is kept as a fallback.

**Switch default in WezTerm** — edit [wezterm/.wezterm.lua](wezterm/.wezterm.lua):
```lua
config.default_prog = { "/opt/homebrew/bin/fish" }
-- config.default_prog = { "/bin/zsh", "-l" }
```

**Switch default in Ghostty** — edit [ghostty/.config/ghostty/config](ghostty/.config/ghostty/config):
```
command = /opt/homebrew/bin/fish
# command = /bin/zsh
```

## Key Bindings (WezTerm)

| Key | Action |
|---|---|
| `CMD+D` | Split pane horizontal |
| `CMD+SHIFT+D` | Split pane vertical |
| `CMD+SHIFT+↑↓←→` | Navigate panes |
| `CMD+OPT+↑↓←→` | Resize pane |
| `CMD+SHIFT+ENTER` | Toggle pane zoom |
| `CMD+←→` | Previous / next tab |
| `CMD+SHIFT+A` | Tab navigator |
| `CMD+SHIFT+P` | Command launcher |
| `CMD+K` | Clear scrollback |
| `CMD+F` | Search |
| `CMD+SHIFT+M` | Toggle fullscreen |

## Aliases & Abbreviations

### Git
| Alias | Command |
|---|---|
| `g` | `git` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gst` | `git status` |
| `gd` | `git diff` |
| `gc` | `git commit` |
| `gcmsg` | `git commit -m` |
| `gco` | `git checkout` |
| `gsw` | `git switch` |
| `gb` | `git branch` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `ggpush` | `git push origin <current-branch>` |
| `ggpull` | `git pull origin <current-branch>` |
| `gf` | `git fetch` |
| `gm` | `git merge` |
| `grb` | `git rebase` |
| `glog` | `git log --oneline --decorate --graph` |
| `gloga` | `git log --oneline --decorate --graph --all` |
| `gg` | `git gui` |
| `lg` | `lazygit` |

### Docker
| Alias | Command |
|---|---|
| `d` | `docker` |
| `dc` | `docker-compose` |
| `dps` | `docker ps` |
| `dpsa` | `docker ps -a` |
| `dex` | `docker exec -it` |
| `dlogs` | `docker logs -f` |
| `dprune` | `docker system prune -f` |
| `ld` | `lazydocker` |

### Files
| Alias | Command |
|---|---|
| `l` | `eza -lah --icons --git` |
| `ll` | `eza -lh --icons --git` |
| `la` | `eza -lah --icons --git -a` |
| `lt` | `eza --tree --icons --git` |

## Version Management (mise)

```sh
mise install node@22
mise install python@3.12
mise install java@21
mise use --global node@22      # set global default
mise use node@20               # set per-project
```

## Requirements

- macOS (Apple Silicon)
- [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts) — used by terminal and prompt
