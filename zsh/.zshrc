#### ==== core ====
export EDITOR="nvim"
setopt prompt_subst hist_ignore_dups share_history
autoload -Uz compinit
if [[ ! -f ~/.zcompdump || ~/.zshrc -nt ~/.zcompdump ]]; then compinit; else compinit -C; fi

#### ==== PATH (no slow subshells) ====
export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"

#### ==== completion styles ====
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true

#### ==== directory options ====
setopt auto_cd auto_pushd pushd_ignore_dups pushd_minus

#### ==== key bindings ====
source "$ZDOTDIR/.zkeybindings"

#### ==== aliases ====
source "$ZDOTDIR/.zaliases"

#### ==== Znap (plugin manager) ====
# one-time bootstrap if missing
if [[ ! -r "$HOME/.zsh/znap/znap.zsh" ]]; then
  mkdir -p "$HOME/.zsh"
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.zsh/znap"
fi
source "$HOME/.zsh/znap/znap.zsh"

# plugins
znap source romkatv/zsh-defer
zsh-defer znap source zsh-users/zsh-autosuggestions
zsh-defer znap source zdharma-continuum/fast-syntax-highlighting


# starship prompt
znap eval starship 'starship init zsh'

# ──────────────────────────────────────────────────────────────────────
# LAZY-LOADED VERSION MANAGERS (for speed)
# ──────────────────────────────────────────────────────────────────────

# mise - cached activation
znap eval mise 'mise activate zsh'

# uv - cached shell completion (faster than raw eval)
znap eval uv 'uv generate-shell-completion zsh'


#### ==== functions ====
source "$ZDOTDIR/.zfunctions"

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
