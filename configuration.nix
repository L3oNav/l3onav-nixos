{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./declaration.nix
    # ── Sistema 3 Capas ──
    ./packages/openclaw.nix        # Capa 1: Orquestación (Sistema Nervioso)
    ./packages/integration.nix     # Scripts de integración entre capas
    ./packages/tailscale.nix       # Tailscale VPN — acceso remoto seguro
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
      limine = {
        enable = true;
        enrollConfig = true;
        panicOnChecksumMismatch = true;
        maxGenerations = 10;
        secureBoot.enable = true;
        extraEntries = ''
          /Windows
              protocol: efi_chainload
              comment: Windows 11
              path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
    };
  };

  # Entrada manual para Windows
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Rust kernel support is built into linuxPackages_latest via config.
  # To customize kernel features, use extraStructuredConfig:
  # boot.kernelPatches = [{ name = "Rust"; patch = null;
  #   extraStructuredConfig = { RUST = lib.kernel.yes; }; }];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons   # pinyin, shuangpin, wubi, etc.
        fcitx5-rime                         # rime engine (alternative)
      ];
    };
  };

  # X11 / XWayland apps need these; the fcitx5 module skips them
  # when waylandFrontend=true, but we have xserver enabled.
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  services.gnome.gnome-keyring.enable = true;

  # ── GNOME + GDM ──
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ── XDG Desktop Portal (NO xdg-desktop-portal-hyprland! ──
  # Hyprland 0.54+ has the portal built-in; external package causes D-Bus conflict)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Printing
  services.printing.enable = true;
  hardware.openrazer.enable = true;

  # Sound with PipeWire
  services.dbus.enable = true;
  services.dbus.implementation = "broker";
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # TPM2
  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
    tctiEnvironment.interface = "tabrmd";
  };

  # User account
  users.users.comrade = {
    isNormalUser = true;
    description = "Leonardo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "adbusers"
      "libvirtd"
      "audio"
      "realtime"
      "pipewire"
      "openrazer"
    ];
    packages = with pkgs; [ thunderbird ];
  };
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.12"
  ];
  # System packages
  environment.systemPackages = with pkgs; [
    # ── Input method (fcitx5) ──
    fcitx5-gtk                   # GTK2/3/4 IM module
    libsForQt5.fcitx5-qt          # Qt5 IM module
    qt6Packages.fcitx5-qt         # Qt6 IM module
    qt6Packages.fcitx5-configtool # fcitx5 configuration GUI

    # ── Editors & tools ──
    vim
    wget
    curl
    gedit
    pcmanfm
    rofi
    _1password-cli
    _1password-gui
    clock-rs
    pipes
    killall
    zbar
    ffmpeg
    obsidian
    obs-studio
    p7zip
    quickshell
    grim
    slurp
    power-profiles-daemon
    android-tools
    inputs.helium.packages.${system}.default
    brave
    openrazer-daemon
    protonup-qt
    lutris
    bottles
    heroic
    polychromatic
    zsh-powerlevel10k
    meslo-lgs-nf # Recommended Nerd Font
    anki
    libreoffice
    uv
    nvidia-container-toolkit
    ventoy-full
    sbctl
    limine-full
    docker-compose
    docker
    lnav
    ripgrep
    tree
    ticktick
    lmstudio
    unityhub
    telegram-desktop
    beekeeper-studio
    davinci-resolve

    # ── QMD GPU wrapper (shadows npm-installed qmd in PATH) ──
    (import ./packages/qmd-cuda.nix {
      inherit (pkgs) lib writeShellScriptBin runCommand coreutils stdenv vulkan-loader nodejs_22;
    })

    # ── Wayland tools ──
    waybar             # status bar
    dunst              # notification daemon
    wlogout            # logout menu
    wl-clipboard       # Wayland clipboard CLI
    cliphist           # Wayland clipboard manager daemon
    swaybg             # wallpaper
    brightnessctl      # backlight control
    libsForQt5.qt5ct   # Qt5 theming
    qt6Packages.qt6ct  # Qt6 theming
  ];

  security.sudo.extraRules = [
    {
      users = [ "comrade" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/podman";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  hardware.nvidia-container-toolkit.enable = true;

  # ── QMD MCP daemon (GPU-accelerated search) ──
  # ON-DEMAND: No arranca al boot. Inícialo con:
  #   sudo systemctl start qmd-mcp
  # Se auto-detiene tras 1 hora.
  systemd.services.qmd-mcp = {
    description = "QMD MCP Server — hybrid search for Obsidian vault";
    after = [ "network.target" ];

    serviceConfig = {
      User = "comrade";
      Group = "users";
      ExecStart = "/run/current-system/sw/bin/qmd mcp --http --daemon";
      Restart = "on-failure";
      RestartSec = 10;

      # ── Resource limits ──────────────────────────
      MemoryMax = "4G";
      CPUQuota = "200%";        # max 2 cores
      Nice = 15;                # baja prioridad de CPU
      IOSchedulingClass = "idle";

      # ── Auto-stop ────────────────────────────────
      RuntimeMaxSec = 3600;     # 1 hora máximo, luego se apaga solo

      # ── GPU access ───────────────────────────────
      SupplementaryGroups = [ "render" "video" ];
      DeviceAllow = "/dev/dri/renderD128 rw";
      DevicePolicy = "closed";
    };

    environment = {
      QMD_EMBED_MODEL = "hf:Qwen/Qwen3-Embedding-4B-GGUF/Qwen3-Embedding-4B-Q4_K_M.gguf";
      QMD_RERANK_MODEL = "hf:ggml-org/Qwen3-Reranker-0.6B-Q8_0-GGUF/qwen3-reranker-0.6b-q8_0.gguf";
      QMD_GENERATE_MODEL = "hf:tobil/qmd-query-expansion-1.7B-gguf/qmd-query-expansion-1.7B-q4_k_m.gguf";
      QMD_EMBED_PARALLELISM = "1";
      QMD_LLAMA_GPU = "vulkan";
    };
  };

  programs.zsh.enable = true;

  users.users.comrade = {
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.zsh;
  nix = {
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };

    # Flakes settings
    package = pkgs.nixVersions.latest;
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
  ];
  system.stateVersion = "26.05";
}
