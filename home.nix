{
  config,
  pkgs,
  lib,
  inputs,
  unstable,
  system,
  ...
}: {
  home.username = "justinpolis";

  home.packages = with pkgs; [];

  home.file.".config/fish/config.fish".source = ./.config/fish/config.fish;
  home.file.".config/fish/functions".source = ./.config/fish/functions;
  home.file.".config/yabai".source = ./.config/yabai;
  home.file.".config/starship.toml".source = ./.config/starship/starship.toml;
  home.file.".config/skhd".source = ./.config/skhd;
  home.file.".config/kitty".source = ./.config/kitty;
  home.file.".config/git".source = ./.config/git;
  home.file.".config/nvim".source = ./.config/nvim;
  home.file.".config/alacritty".source = ./.config/alacritty;
  home.file."/.hammerspoon".source = ./.config/hammerspoon;

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
