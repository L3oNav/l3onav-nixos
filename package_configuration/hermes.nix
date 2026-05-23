{ config, pkgs, ... }:

{
  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    container = {
      enable = true;
      backend = "podman";
      hostUsers = [ "comrade" ]; # ← Para que funcione sin sudo
      extraOptions = [
        "--gpus=all" # Para usar la GPU
        "--security-opt=label=disable"
      ];
    };

    settings = {
      model = {
        default = "deepseek-v4-pro";
        provider = "deepseek";
        base_url = "https://api.deepseek.com/";
      };
      terminal = {
        backend = "podman"; # ← Cambiar de docker a podman
      };
    };
  };
}
