{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./declaration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Rust kernel support is built into linuxPackages_latest via config.
  # To customize kernel features, use extraStructuredConfig:
  # boot.kernelPatches = [{ name = "Rust"; patch = null;
  #   extraStructuredConfig = { RUST = lib.kernel.yes; }; }];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
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

  # Sound with PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
  users.users.l3onav = {
    isNormalUser = true;
    description = "Leonardo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "adbusers"
      "libvirtd"
    ];
    packages = with pkgs; [ thunderbird ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
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
    bottles
    power-profiles-daemon
    android-tools
  ];

  system.stateVersion = "25.11";
}
