function fish_user_key_bindings
    # Standard bindings (Ctrl+R, Ctrl+A, Ctrl+E, Ctrl+W, Ctrl+U, Ctrl+K,
    # and arrow key history search) are all built-in — nothing to configure.

    # WezTerm: Home/End
    bind \e\[H beginning-of-line
    bind \e\[F end-of-line

    # WezTerm: Shift+arrows (word jump)
    bind \e\[1\;2D backward-word
    bind \e\[1\;2C forward-word
end
