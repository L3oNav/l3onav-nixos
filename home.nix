{ config, pkgs, ... }:

{
  home.username = "comrade";
  home.homeDirectory = "/home/comrade";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    gh
    jujutsu
    zig
    nushell
    fastfetch
    zellij
    zed-editor
    ripgrep
    fd
    tlrc
    podman-tui
    podman-compose
    dive
    discord
    wgnord
    gnomeExtensions.razer-puppy
    razergenie
    spotify
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Leonardo";
      user.email = "l3onav@example.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      color_theme = "dracula";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
      };
      font = {
        size = 11;
        normal.family = "FiraCode Nerd Font Mono";
        bold.family = "FiraCode Nerd Font Mono";
        bold.style = "Bold";
        italic.family = "FiraCode Nerd Font Mono";
        italic.style = "Italic";
      };
    };
  };
}
