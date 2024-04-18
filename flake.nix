{
  description = "JustinPolis Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nix-darwin.url = "github:wegank/nix-darwin/mddoc-remove";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
  }: let
    configuration = {pkgs, ...}: {
      environment = {
        shells = [pkgs.fish];
        systemPackages = with pkgs; [
          git
          neovim-nightly-overlay.packages.${pkgs.system}.default
          home-manager
          nixfmt
          ripgrep
          jq
          eza
          stylua
          shfmt
          btop
          zoxide
          alejandra
          nil
          curl
          starship
          fd
          fzf
          bat
          lua-language-server
        ];
      };
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;
      programs.direnv.enable = true;
      programs.fish.enable = true;
      programs.fish.interactiveShellInit = ''
        set fish_greeting
      '';
      # shortcuts fix defaults read -g NSUserKeyEquivalents
      # remap keys fix cmd <-> option key
      # yabai fix stuff
      # fix fish underlines and bold
      # fish kity tab bold and italics
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.defaults.NSGlobalDomain = {
        AppleShowAllExtensions = true;

        KeyRepeat = 1;
        InitialKeyRepeat = 7;

        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };
      system.stateVersion = 4;
      system.keyboard.enableKeyMapping = true;
      system.keyboard.userKeyMapping = [
        {
          HIDKeyboardModifierMappingSrc = 30064771125;
          HIDKeyboardModifierMappingDst = 30064771172;
        }
        {
          HIDKeyboardModifierMappingSrc = 30064771172;
          HIDKeyboardModifierMappingDst = 30064771125;
        }
      ];

      system.defaults.NSGlobalDomain.AppleFontSmoothing = 0;
      system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
      system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = false;
      system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
      system.defaults.NSGlobalDomain.NSWindowResizeTime = 0.0;
      system.defaults.NSGlobalDomain."com.apple.springing.enabled" = false;
      system.defaults.NSGlobalDomain._HIHideMenuBar = true;
      system.defaults.dock.autohide = true;
      system.defaults.dock.autohide-delay = 0.0;
      system.defaults.dock.autohide-time-modifier = 0.0;
      system.defaults.dock.enable-spring-load-actions-on-all-items = false;
      system.defaults.dock.launchanim = false;
      system.defaults.dock.mineffect = "scale";

      nixpkgs.hostPlatform = "aarch64-darwin";
      users.users."justinpolis" = {
        home = "/Users/justinpolis";
        description = "home";
      };

      environment.variables.EDITOR = "nvim";

      homebrew = {
        enable = true;

        onActivation = {
          autoUpdate = false;
          cleanup = "zap";
        };

        taps = [
          "homebrew/cask-fonts"
          "homebrew/services"
          "homebrew/cask-versions"
          "koekeishiya/formulae"
        ];

        brews = [
          "xcodes"
          "yabai"
          "skhd"
        ];

        casks = [
          "appcleaner"
          "mos"
          "kitty"
          "firefox"
          "bitwarden"
          "google-chrome"
          "alacritty"
          "wezterm"
        ];
      };
    };
  in {
    darwinConfigurations."justinpolis" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users."justinpolis" = import ./home.nix;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."justinpolis".pkgs;
  };
}
