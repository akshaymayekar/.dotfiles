# Needed before any other zsh files load
export ZDOTDIR="${ZDOTDIR:-$HOME}"

# Rust setup (adds ~/.cargo/bin to PATH etc.)
. "$HOME/.cargo/env"