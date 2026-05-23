{ config, pkgs, ... }:

{
  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;

    # ── Container ─────────────────────────────────────────────
    container = {
      enable = true;
      backend = "podman";
      hostUsers = [ "comrade" ];
      extraOptions = [
        "--gpus=all"
        "--security-opt=label=disable"
      ];
      # Mount host paths that MCP servers need access to.
      extraVolumes = [
        "/home/comrade:/home/comrade"
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
        timeout = 180;
      };

      # Agent behavior
      max_turns = 100;
      toolsets = [ "all" ];
    };

    # ── MCP Servers ───────────────────────────────────────────
    mcpServers = {
      # Anki — flashcard management and study automation.
      anki = {
        url = "http://127.0.0.1:3141";
        timeout = 30;
      };

      # Obsidian — local Obsidian vault access via MCP.
      obsidian = {
        url = "https://127.0.0.1:27124/mcp/";
        headers.Authorization = "Bearer OBSIDIAN_TOKEN_PLACEHOLDER";
        timeout = 30;
      };

    };

    environmentFiles = [ "/var/lib/hermes/env" ];

    # Extra packages the agent can use inside the container
    extraPackages = with pkgs; [
      nodejs_22
      git
      ripgrep
    ];
  };
}
