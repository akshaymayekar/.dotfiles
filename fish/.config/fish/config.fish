#### ==== editor ====
set -gx EDITOR nvim

#### ==== PATH ====
set -gx GOPATH $HOME/go
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
set -gx PATH $HOME/.local/bin $GOPATH/bin $HOME/.cargo/bin $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin $PATH

#### ==== cached activations (run `fish-regen` to rebuild caches) ====
set -l fish_cache ~/.cache/fish

for _cache_entry in "mise activate fish:$fish_cache/mise.fish" "starship init fish:$fish_cache/starship.fish"
    set -l cmd (string split ':' $_cache_entry)[1]
    set -l cache (string split ':' $_cache_entry)[2]
    if not test -f $cache
        mkdir -p (dirname $cache)
        eval $cmd > $cache 2>/dev/null
    end
    source $cache
end
