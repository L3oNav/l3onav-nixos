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
    ./packages/hermes.nix
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
        qt6Packages.fcitx5-chinese-addons  # pinyin, shuangpin, wubi, etc.
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

  # X11 and GNOME
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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
      "hermes"
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
    xwallpaper
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
    gnome-shell-extensions
    quickshell
    grim
    gnome-tweaks
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
    xsel
    ticktick
    lmstudio
    unityhub
    telegram-desktop
    beekeeper-studio
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
      options = "--delete-older-than 7d";
    };

    # Flakes settings
    package = pkgs.nixVersions.latest;
  };
  programs.nix-ld.enable = true;
  system.stateVersion = "25.11";
}
