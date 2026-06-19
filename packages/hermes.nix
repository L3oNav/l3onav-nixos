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
        provider = "openrouter";
        default = "deepseek/deepseek-v4-pro";
        # Use OpenRouter's API directly
        base_url = "https://openrouter.ai/api/v1";
      };

      # ── OpenRouter-specific settings ────────────────────────
      # Response caching: caches identical API responses at the OpenRouter
      # edge for free instant replays (zero billing on cache hits).
      openrouter = {
        response_cache = true;
        response_cache_ttl = 300;  # seconds (1-86400)
      };

      # Provider routing: controls how requests are routed across
      # backend providers on OpenRouter.
      provider_routing = {
        sort = "throughput";  # price | throughput | latency
        # require_parameters = true;
        # data_collection = "deny";
      };

      # ── Per-model overrides ─────────────────────────────────
      providers = {
        openrouter = {
          models = {
            # Chat / reasoning
            "qwen/qwen3.7-max" = {
              temperature = 0.3;
            };
            "qwen/qwen3-235b-a22b-2507" = {
              temperature = 0.3;
            };
          };
        };
      };

      # ── Auxiliary task routing ──────────────────────────────
      # Side-jobs the agent offloads. Each defaults to "auto"
      # (uses the main model). Override to pin cheaper/faster models.
      auxiliary = {
        title_gen = {
          provider = "openrouter";
          model = "qwen/qwen3-235b-a22b-2507";
        };
        compression = {
          provider = "openrouter";
          model = "qwen/qwen3-235b-a22b-2507";
        };
        web_extract = {
          provider = "openrouter";
          model = "qwen/qwen3-235b-a22b-2507";
        };
        approval = {
          provider = "openrouter";
          model = "qwen/qwen3-235b-a22b-2507";
        };
      };

      # ── Terminal: run commands locally inside the container ──
      # (the service is already containerized via Podman)
      terminal = {
        backend = "local";
        timeout = 180;
      };

      # ── Agent behavior ──────────────────────────────────────
      max_turns = 100;
      toolsets = [ "all" ];

      # ── Display ─────────────────────────────────────────────
      display = {
        tool_progress = "all";
        interim_assistant_messages = true;
        long_running_notifications = true;
      };
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
        url = "https://127.0.0.1:27123/mcp/";
        timeout = 30;
      };

      # ── QMD — Hybrid local search for Obsidian vault ────────
      # qmd provides BM25 + vector embeddings + LLM reranking,
      # all local (no cloud API costs). Models auto-download (~2GB)
      # on first run: embeddinggemma-300M, qwen3-reranker-0.6b,
      # qmd-query-expansion-1.7B.
      #
      # REQUIRED SETUP (run once on host):
      #   1. npm install -g @tobilu/qmd
      #   2. qmd collection add /home/comrade/Obsidian --name vault
      #   3. qmd context add qmd://vault "My Obsidian vault — notes, papers, research"
      #   4. qmd embed
      #   5. qmd mcp --http --daemon   (or use systemd below)
      #
      # Systemd daemon (runs on host, not in container):
      #   systemctl --user enable --now qmd-daemon
      #   → exposes qmd MCP tools at http://127.0.0.1:8181/mcp
      #
      # Tools available to Hermes once connected:
      #   mcp_qmd_search     — BM25 keyword search (~0.2s)
      #   mcp_qmd_vsearch    — Semantic vector search (~3s)
      #   mcp_qmd_deep_search — Hybrid + reranking (~2-3s warm)
      #   mcp_qmd_get        — Retrieve document by ID or path
      #   mcp_qmd_status     — Index health and stats
      qmd = {
        url = "http://127.0.0.1:8181/mcp";
        timeout = 60;
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

  # Fix /var/lib/hermes permissions so comrade (hermes group) can access .hermes
  system.activationScripts.hermes-permissions = ''
    chown hermes:hermes /var/lib/hermes /var/lib/hermes/.hermes 2>/dev/null || true
    chmod 770 /var/lib/hermes /var/lib/hermes/.hermes 2>/dev/null || true
  '';
}
