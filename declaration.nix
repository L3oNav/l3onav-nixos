{ config, pkgs, ... }:

{
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10; # Give games higher priority
      };
      gpu = {
        apply_gpu_optimisations = "accept_responsibility";
        gpu_device = 0;
      };
    };
  };

  services.openssh.enable = true;
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      # enableNvidia is deprecated; hardware.nvidia-container-toolkit.enable is set in configuration.nix
    };
  };
  environment.etc."cdi/nvidia.yaml".source = "/run/cdi/nvidia-container-toolkit.json";

  # Symlink /var/run/docker.sock to the Podman socket so tools that
  # hardcode the Docker socket path work without DOCKER_HOST being set.
  systemd.tmpfiles.rules = [
    "L+ /var/run/docker.sock - - - - /run/user/${toString config.users.users.comrade.uid}/podman/podman.sock"
  ];
}
