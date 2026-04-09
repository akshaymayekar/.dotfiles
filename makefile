.PHONY: stow unstow restow bootstrap update lock clean brew-install brew-dump brew-sync

# default target
all: stow

# symlink dotfiles into $HOME
stow:
	stow -v -t $(HOME) zsh starship wezterm fish ghostty

# remove symlinks
unstow:
	stow -D -v -t $(HOME) zsh starship wezterm fish ghostty

# re-link (good after edits)
restow: unstow stow

# run first-time setup (submodules, stow, etc.)
bootstrap:
	git submodule update --init --recursive
	$(MAKE) brew-install
	$(MAKE) stow

# pull latest plugin submodules (review diffs before committing)
update:
	git submodule update --remote --merge
	git status

# lock current plugin SHAs into repo
lock:
	git add zsh/plugins -A
	git commit -m "Lock plugin SHAs"

# install all packages from Brewfile
brew-install:
	brew bundle install --file=$(CURDIR)/Brewfile

# update Brewfile from explicitly installed packages
brew-dump:
	brew bundle dump --force --no-upgrade --file=$(CURDIR)/Brewfile

# interactively add new explicitly installed packages to Brewfile
brew-sync:
	@$(CURDIR)/scripts/brew-sync.sh $(CURDIR)/Brewfile

# clean zsh caches
clean:
	rm -f ~/.zcompdump*

backup-vscode-extensions:
	code --list-extensions > vscode-extensions.txt

install-vscode-extensions:
	cat vscode-extensions.txt | xargs -L 1 code --install-extension
