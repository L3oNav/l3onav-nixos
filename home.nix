{ config, pkgs, ... }:

{
  imports = [
    ./packages/zsh.nix
    ./packages/opencode.nix    # Capa 3: Ejecución (Las Manos)
    ./packages/hermes-home.nix # Capa 2: Evolución (Cerebro) — Home Manager
    ./packages/alacritty.nix
    ./packages/tmux.nix
  ];

  home.username = "comrade";
  home.homeDirectory = "/home/comrade";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # ── Node.js dev ──────────────────────────────
    nodejs_22
    pnpm
    yarn

    # ── Python dev ───────────────────────────────
    python314
    sqlite
    dbeaver-bin

    # ── Tools ────────────────────────────────────
    gh
    jujutsu
    zig
    nushell
    fastfetch
    tmux
    zed-editor
    ripgrep
    fd
    tlrc
    podman-tui
    podman-compose
    dive
    discord
    wgnord
    razergenie
    spotify
    postman
    prismlauncher
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      identityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
    };
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Leonardo Nava (L3oNav)";
        email = "l3onav@outlook.com";
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwRbVMLmqtlo7TYoOaPWegtlYdlizxBGC+wX9DDWHPq";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed-signers";
      tag.gpgsign = true;
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
        "git@gitlab.com:" = {
          insteadOf = "https://gitlab.com/";
        };
      };
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
    config.theme = "gruvbox-dark";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      color_theme = "gruvbox_dark";
    };
  };

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      # ── Performance ──────────────────────────────
      fps = true;
      frametime = true;
      fps_limit = 0;

      # ── GPU ──────────────────────────────────────
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_power = true;
      gpu_mem_clock = true;
      vram = true;

      # ── CPU ──────────────────────────────────────
      cpu_stats = true;
      cpu_temp = true;
      ram = true;

      # ── Visual / layout ──────────────────────────
      throttling_status = true;
      frame_timing = true;
      text_outline = true;
      hud_compact = true;
      round_corners = 6;
      font_size = 20;
      background_alpha = 0.4;
      position = "top-left";

      # ── Don't inject into these processes ─────────
      blacklist = "zeditor,zed-editor,.zed-editor-wrapped,qmd,llama";
    };

    settingsPerApplication = {
      zeditor.no_display = true;
      "zed-editor".no_display = true;
      ".zed-editor-wrapped".no_display = true;
      qmd.no_display = true;
      llama.no_display = true;
    };

  };

  home.file.".npmrc".text = ''
    prefix=/home/comrade/.npm-global
  '';

  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  # Clipboard manager daemon — mantiene el clipboard vivo entre apps
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Wayland clipboard manager daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
