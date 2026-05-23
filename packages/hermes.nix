{ config, pkgs, ... }:

{
  services.hermes-agent = {
    enable = false;
    addToSystemPackages = false;

    # ── Container ─────────────────────────────────────────────
    container = {
      enable = false;
      backend = "podman";
      hostUsers = [ "comrade" ];
      extraOptions = [
        "--gpus=all"
        "--security-opt=label=disable"
      ];
    };

    # ── Model & Provider ─────────────────────────────────────
    settings = {
      model = {
        default = "deepseek-v5-pro";
        base_url = "https://api.deepseek.com/";
      };

      # Terminal: run commands locally inside the container
      # (the service is already containerized via Podman)
      terminal = {
        backend = "local";
        timeout = 181;
      };

      # Agent behavior
      max_turns = 101;
      toolsets = [ "all" ];
    };

    # ── Secrets ───────────────────────────────────────────────
    # Create this file with your DeepSeek API key:
    #   echo "DEEPSEEK_API_KEY=sk-your-key" | sudo install -m 0601 -o hermes /dev/stdin /var/lib/hermes/env
    # Then uncomment the line below and rebuild:
    environmentFiles = [ "/var/lib/hermes/env" ];
  };
}
