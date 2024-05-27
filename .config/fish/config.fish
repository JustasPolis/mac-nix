starship init fish | source
direnv hook fish | source
alias ls="exa --icons"
abbr --add nixrebuild 'darwin-rebuild switch --flake ~/nix-config/.#justinpolis'
set EDITOR nvim
set BAT_THEME "ansi"
set -g fish_key_bindings fish_vi_key_bindings

bind -M insert \t accept-autosuggestion
bind -M insert \e\[B 'commandline -f complete'
bind -M insert \e\[A 'commandline -f complete-and-search'

bind yy fish_clipboard_copy
bind p fish_clipboard_paste
zoxide init --cmd cd fish | source
set -x PATH $PATH ~/.cargo/bin

alias cdi="cd (zoxide query --list | gum filter --limit 1 --placeholder 'Pick directory' --height 20 --prompt='⚡')"
alias tcs="sesh connect (sesh list -i | gum filter --limit 1 --placeholder 'Pick session' --height 20 --prompt='⚡')"
alias tksession="tmux kill-session"
alias tkserver="tmux kill-server"
alias tkw="tmux kill-window"
alias td="tmux detach"


bind -M default \cz 'fg 2>/dev/null; commandline -f repaint'
bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'
eval "$(/opt/homebrew/bin/brew shellenv)"

set fish_color_valid_path
set fish_color_redirection cyan
set fish_color_autosuggestion 'brblack'
set fish_color_history_current 'brblack'
set fish_pager_color_prefix normal
set fish_color_selection 'white' '--background=yellow'
set fish_color_error red
set fish_color_escape cyan
set fish_color_operator cyan
set fish_color_search_match 'yellow' '--background=black' 
set fish_color_user green
set fish_pager_color_description yellow
set fish_pager_color_progress 'white' '--background=cyan'
fish_vi_cursor --force-iterm
set -g fish_cursor_insert line
set -g fish_cursor_default block

set -Ux FZF_DEFAULT_OPTS "\
--ansi \
--border rounded \
--color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic' \
--marker=' ' \
--no-info \
--no-separator \
--pointer='👉' \
--reverse"

set -Ux FZF_TMUX_OPTS "-p 55%,60%"

set -Ux FZF_CTRL_R_OPTS "\
--border-label=' history ' \
--prompt='  '"
