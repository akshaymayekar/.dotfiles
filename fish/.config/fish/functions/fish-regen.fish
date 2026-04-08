function fish-regen --description 'Rebuild fish startup caches (run after updating mise/starship/uv)'
    set -l fish_cache ~/.cache/fish
    echo "Regenerating fish caches..."
    mise activate fish > $fish_cache/mise.fish && echo "  mise: done"
    starship init fish > $fish_cache/starship.fish && echo "  starship: done"
    uv generate-shell-completion fish > ~/.config/fish/completions/uv.fish && echo "  uv: done"
    echo "Done. Restart fish to apply."
end
