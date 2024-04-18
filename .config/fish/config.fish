starship init fish | source
direnv hook fish | source
alias ls="exa --icons"
abbr --add nixrebuild 'darwin-rebuild switch --flake ~/nix-config/.#justinpolis'
set EDITOR nvim
set BAT_THEME "ansi"
set -g fish_key_bindings fish_vi_key_bindings

bind -M insert \t accept-autosuggestion
bind -M insert \cn 'commandline -f complete'
bind -M insert \cp 'commandline -f complete-and-search'

bind yy fish_clipboard_copy
bind p fish_clipboard_paste
zoxide init --cmd cd fish | source
set -x PATH $PATH ~/.cargo/bin

bind -M default \cz 'fg 2>/dev/null; commandline -f repaint'
bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'
eval "$(/opt/homebrew/bin/brew shellenv)"

set fish_color_valid_path
set fish_color_redirection cyan
set fish_color_history_current
