{
  description = "JustinPolis Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    neovim-nightly-overlay,
  }: let
    unstable = import nixpkgs-unstable {
      system = "aarch64-darwin";
    };

    configuration = {pkgs, ...}: {
      environment = {
        shells = [pkgs.fish];
        systemPackages = with pkgs; [
          git
          neovim-unwrapped
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
          python39
          boringtun
          wireguard-tools
          direnv
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
      system.configurationRevision = self.rev or self.dirtyRev or null;
      #system.keyboard.swapLeftCommandAndLeftAlt = true;
      system.defaults.NSGlobalDomain = {
        AppleShowAllExtensions = true;

        KeyRepeat = 1;
        InitialKeyRepeat = 10;

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
        {
          HIDKeyboardModifierMappingDst = 30064771181;
          HIDKeyboardModifierMappingSrc = 30064771129;
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
      system.defaults.dock.autohide = true;
      system.defaults.dock.autohide-delay = 1000.0;
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
          "FelixKratz/formulae"
          "JustasPolis/formulae"
        ];

        brews = [
          "yabai"
          "rust"
          "node"
          "swiftlint"
          "swiftformat"
          "borders"
          "switchaudio-osx"
          "nowplaying-cli"
          "blueutil"
          "mac-apps"
        ];

        casks = [
          "appcleaner"
          "mos"
          "kitty"
          "bitwarden"
          "monitorcontrol"
          "hammerspoon"
          "raycast"
          "obsidian"
          "xcodes"
          "qbittorrent"
          "swiftformat-for-xcode"
          "bartender"
          "iina"
          "visual-studio-code"
          #"betterdisplay"
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
          home-manager.extraSpecialArgs = {inherit inputs unstable;};
          home-manager.users."justinpolis" = import ./home.nix;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."justinpolis".pkgs;
  };
}
