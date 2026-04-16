.PHONY: all help stow unstow restow bootstrap install-brew brew-install brew-sync clean fish-regen backup-vscode-extensions install-vscode-extensions

# ── Default ───────────────────────────────────────────────────────────────────
all: stow

# ── Help ──────────────────────────────────────────────────────────────────────
help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*##"}; {printf "  \033[36m%-28s\033[0m %s\n", $$1, $$2}' | sort

# ── Bootstrap ─────────────────────────────────────────────────────────────────

bootstrap: ## full fresh machine setup (brew + packages + stow)
	$(MAKE) install-brew
	$(MAKE) brew-install
	$(MAKE) stow

install-brew: ## install Homebrew if not present
	@command -v brew >/dev/null 2>&1 && echo "Homebrew already installed." || \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ── Stow ──────────────────────────────────────────────────────────────────────

stow: ## symlink all dotfiles into HOME
	stow -v -t $(HOME) zsh starship wezterm fish ghostty

unstow: ## remove all dotfile symlinks
	stow -D -v -t $(HOME) zsh starship wezterm fish ghostty

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

backup-vscode-extensions: ## save installed VSCode extensions to file
	code --list-extensions > vscode-extensions.txt

install-vscode-extensions: ## install VSCode extensions from file
	cat vscode-extensions.txt | xargs -L 1 code --install-extension
