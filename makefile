.PHONY: stow unstow restow bootstrap update lock clean

# default target
all: stow

# symlink dotfiles into $HOME
stow:
	stow -v -t $(HOME) zsh starship wezterm

# remove symlinks
unstow:
	stow -D -v -t $(HOME) zsh starship wezterm

# re-link (good after edits)
restow: unstow stow

# run first-time setup (submodules, stow, etc.)
bootstrap:
	git submodule update --init --recursive
	$(MAKE) stow

# pull latest plugin submodules (review diffs before committing)
update:
	git submodule update --remote --merge
	git status

# lock current plugin SHAs into repo
lock:
	git add zsh/plugins -A
	git commit -m "Lock plugin SHAs"

# clean zsh caches
clean:
	rm -f ~/.zcompdump*
