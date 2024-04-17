{ config, pkgs, lib, inputs, system, ... }: {

  home.username = "justinpolis";

  home.packages = with pkgs; [];

  home.file.".config/nvim".source = ./.config/nvim;
  home.file.".config/fish/config.fish".source = ./.config/fish/config.fish;
  home.file.".config/fish/functions".source = ./.config/fish/functions;
  home.file.".config/starship.toml".source = ./.config/starship/starship.toml;

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

}
