#### ==== core ====
export ZDOTDIR="${ZDOTDIR:-$HOME}"
export EDITOR="nvim"
setopt prompt_subst hist_ignore_dups share_history
autoload -Uz compinit
if [[ ! -f ~/.zcompdump || ~/.zshrc -nt ~/.zcompdump ]]; then compinit; else compinit -C; fi

#### ==== PATH (no slow subshells) ====
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"

#### ==== aliases ====
alias dc='docker-compose'
alias cls='clear'
alias nv='nvim'
alias pc='open -a /Applications/PyCharm\ CE.app/Contents/MacOS/pycharm'
alias make='gmake'

#### ==== Znap (plugin manager) ====
# one-time bootstrap if missing
if [[ ! -r "$HOME/.zsh/znap/znap.zsh" ]]; then
  mkdir -p "$HOME/.zsh"
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.zsh/znap"
fi
source "$HOME/.zsh/znap/znap.zsh"

# plugins (kept tiny for speed)
znap source ohmyzsh/ohmyzsh plugins/common-aliases
znap source ohmyzsh/ohmyzsh plugins/git
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting   # keep after autosuggestions

# Lib for shorthand cd
znap source ohmyzsh/ohmyzsh lib/completion
znap source ohmyzsh/ohmyzsh lib/directories

# starship prompt
znap eval starship 'starship init zsh'

#### ==== lazy-load heavy toolchains (on first use) ====
if command -v pyenv >/dev/null 2>&1; then
  pyenv() { unfunction pyenv 2>/dev/null; eval "$(command pyenv init -)"; command pyenv "$@"; }
fi
if command -v fnm >/dev/null 2>&1; then
  fnm() { unfunction fnm 2>/dev/null; eval "$(command fnm env --use-on-cd --shell zsh)"; command fnm "$@"; }
fi
if command -v jenv >/dev/null 2>&1; then
  jenv() { unfunction jenv 2>/dev/null; export PATH="$HOME/.jenv/bin:$PATH"; eval "$(command jenv init -)"; command jenv "$@"; }
fi
if command -v uv >/dev/null 2>&1; then
  uv() { unfunction uv 2>/dev/null; eval "$(command uv generate-shell-completion zsh 2>/dev/null || true)"; command uv "$@"; }
fi

# --- Auto-update Znap + plugins (weekly) ---
# Drop this near the end of your .zshrc (after sourcing Znap & declaring plugins)

# Only in interactive shells
[[ -o interactive ]] || return

# How often to update (days)
: ${ZNAP_AUTO_UPDATE_DAYS:=7}

# Paths
_znap_stamp="${HOME}/.zsh/.znap-last-update"
_znap_log="${HOME}/.zsh/.znap-update.log"
_znap_lock="${HOME}/.zsh/.znap-update.lock"

# Use zsh's EPOCHSECONDS for robust time math
zmodload zsh/datetime 2>/dev/null

_znap_needs_update() {
  local now=$EPOCHSECONDS
  local interval=$(( ZNAP_AUTO_UPDATE_DAYS * 24 * 60 * 60 ))
  [[ ! -f "$_znap_stamp" ]] && return 0
  local last; read -r last <"$_znap_stamp" || last=0
  (( now - last >= interval ))
}

_znap_safe_update() {
  # poor-man's lock to avoid multiple shells racing
  if mkdir "$_znap_lock" 2>/dev/null; then
    {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] znap pull start"
      znap pull
      znap compile
      echo $EPOCHSECONDS >| "$_znap_stamp"
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] znap pull done"
    } >>"$_znap_log" 2>&1
    rmdir "$_znap_lock" 2>/dev/null
  fi
}

if _znap_needs_update; then
  # run fully in background; do not block your prompt
  (_znap_safe_update) &!
fi

######################################################################
