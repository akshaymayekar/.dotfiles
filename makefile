.PHONY: all help stow unstow restow bootstrap install-brew brew-install brew-sync clean fish-regen vscode-stow vscode-backup vscode-install

# ── Default ───────────────────────────────────────────────────────────────────
all: stow

# ── Help ──────────────────────────────────────────────────────────────────────
help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*##"}; {printf "  \033[36m%-28s\033[0m %s\n", $$1, $$2}' | sort

# ── Bootstrap ─────────────────────────────────────────────────────────────────

bootstrap: ## full fresh machine setup (brew + packages + stow + vscode)
	$(MAKE) install-brew
	$(MAKE) brew-install
	$(MAKE) stow
	$(MAKE) vscode-install

install-brew: ## install Homebrew if not present
	@command -v brew >/dev/null 2>&1 && echo "Homebrew already installed." || \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ── Stow ──────────────────────────────────────────────────────────────────────

stow: ## symlink all dotfiles into HOME
	stow -v -t $(HOME) zsh starship wezterm fish ghostty
	$(MAKE) vscode-stow

unstow: ## remove all dotfile symlinks
	stow -D -v -t $(HOME) zsh starship wezterm fish ghostty vscode

restow: unstow stow ## re-link dotfiles (use after adding new files)

# ── Homebrew ──────────────────────────────────────────────────────────────────

brew-install: ## install all packages from Brewfile
	brew bundle install --file=$(CURDIR)/Brewfile

brew-sync: ## interactively add new brew installs to Brewfile
	@$(CURDIR)/scripts/brew-sync.sh $(CURDIR)/Brewfile

# ── Maintenance ───────────────────────────────────────────────────────────────

clean: ## remove zsh and fish startup caches
	rm -f ~/.zcompdump*
	rm -f ~/.cache/fish/mise.fish ~/.cache/fish/starship.fish

fish-regen: ## rebuild fish startup caches (run after upgrading mise/starship/uv)
	fish -c fish-regen

# ── VSCode ────────────────────────────────────────────────────────────────────

VSCODE_USER_DIR = $(HOME)/Library/Application Support/Code/User

vscode-stow: ## remove conflicting VSCode files and stow (safe: content is already in dotfiles)
	rm -f "$(VSCODE_USER_DIR)/settings.json"
	rm -f "$(VSCODE_USER_DIR)/keybindings.json"
	stow -v -t $(HOME) vscode

vscode-backup: ## save current VSCode extensions list to vscode/extensions.txt
	code --list-extensions > $(CURDIR)/vscode/extensions.txt

vscode-install: ## install VSCode extensions from vscode/extensions.txt
	xargs -L 1 code --install-extension < $(CURDIR)/vscode/extensions.txt
