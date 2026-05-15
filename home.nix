{ config, pkgs, ... }:

{
  home.username = "l3onav";
  home.homeDirectory = "/home/l3onav";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    git
    gh
    jujutsu
    zig
    nushell
    alacritty
    fzf
    direnv
    fastfetch
    btop
    zellij
    neovim
    zed-editor
    ripgrep
    fd
    bat
    eza
    zoxide
    tlrc
    podman-tui
    podman-compose
    dive
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "man"
      ];
      theme = "agnoster";
    };
    shellAliases = {
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      v = "nvim";
      c = "clear";
    };
    initContent = ''
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
    '';
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
        normal.family = "JetBrains Mono";
      };
    };
  };
}
