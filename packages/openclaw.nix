# ─────────────────────────────────────────────────────────────────────────────
# Capa 1: OpenClaw — Orquestación (Sistema Nervioso)
# ─────────────────────────────────────────────────────────────────────────────
# Servicio systemd 24/7 que actúa como gateway, recibiendo comandos desde
# múltiples canales (CLI, Telegram, Discord) y enrutándolos al agente
# correspondiente (Hermes, OpenCode, o directamente).
#
# Documentación: https://github.com/Scout-DJ/openclaw-nix
# OpenClaw: https://github.com/openclaw/openclaw
#
# SETUP REQUERIDO (una vez):
#   1. Copia secrets.nix.example a secrets.nix y llena los valores
#   2. Crea los archivos de secrets:
#      sudo mkdir -p /var/lib/openclaw
#      echo "TU_OPENROUTER_API_KEY" | sudo tee /var/lib/openclaw/model-api-key
#      sudo chmod 600 /var/lib/openclaw/model-api-key
#      sudo chown openclaw:openclaw /var/lib/openclaw/model-api-key
#
#   3. (Opcional) Telegram bot:
#      echo "TU_TELEGRAM_BOT_TOKEN" | sudo tee /var/lib/openclaw/telegram-token
#      sudo chmod 600 /var/lib/openclaw/telegram-token
#      sudo chown openclaw:openclaw /var/lib/openclaw/telegram-token
#
#   4. (Opcional) Discord bot:
#      echo "TU_DISCORD_BOT_TOKEN" | sudo tee /var/lib/openclaw/discord-token
#      sudo chmod 600 /var/lib/openclaw/discord-token
#      sudo chown openclaw:openclaw /var/lib/openclaw/discord-token
#
#   5. Obtener el auth token del gateway (auto-generado en primer arranque):
#      sudo cat /var/lib/openclaw/auth-token
# ─────────────────────────────────────────────────────────────────────────────
{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.openclaw = {
    enable = false;  # Liberado de NixOS — el usuario lo maneja manualmente

    # ── Dominio público (opcional) ──────────────────────────────
    # Si tienes un dominio, Caddy configurará TLS automáticamente.
    # Déjalo vacío para solo acceso local.
    domain = "";

    # ── Gateway ─────────────────────────────────────────────────
    gatewayPort = 3000;

    # ── Modelo AI ───────────────────────────────────────────────
    # Usa OpenRouter para acceder a múltiples modelos (DeepSeek, Qwen, etc.)
    # Compatible con: anthropic, openai, openrouter, ollama, etc.
    modelProvider = "openrouter";
    modelApiKeyFile = "/var/lib/openclaw/model-api-key";

    # ── Seguridad de herramientas ───────────────────────────────
    # "allowlist" = solo herramientas listadas (seguro por defecto)
    # "deny" = bloquear toda ejecución de herramientas
    toolSecurity = "allowlist";
    toolAllowlist = [
      "read"
      "write"
      "edit"
      "web_search"
      "web_fetch"
      "message"
      "tts"
      "exec"        # Necesario para delegar a Hermes/OpenCode
    ];

    # ── Telegram (opcional) ─────────────────────────────────────
    # Descomenta y configura si quieres recibir comandos por Telegram
    # telegram = {
    #   enable = true;
    #   tokenFile = "/var/lib/openclaw/telegram-token";
    # };

    # ── Discord (opcional) ──────────────────────────────────────
    # Descomenta y configura si quieres recibir comandos por Discord
    # discord = {
    #   enable = true;
    #   tokenFile = "/var/lib/openclaw/discord-token";
    # };

    # ── Auto-actualización (opcional) ───────────────────────────
    autoUpdate = {
      enable = false;  # Desactivado por defecto, activa si deseas
      schedule = "weekly";
    };

    # ── Firewall ────────────────────────────────────────────────
    # Si usas dominio público, mantén true. Si es solo local, puedes poner false.
    openFirewall = false;

    # ── Configuración extra del gateway ─────────────────────────
    # Aquí puedes agregar configuración adicional que se merge con la base.
    # Consulta la documentación de OpenClaw para todas las opciones.
    extraGatewayConfig = {
      # Ejemplo: configurar agentes y skills
      # agents = {
      #   hermes = {
      #     command = "hermes";
      #     description = "Agente de evolución y aprendizaje";
      #   };
      #   opencode = {
      #     command = "opencode";
      #     description = "Agente de ejecución de código";
      #   };
      # };
    };
  };

  # ── Integración: Permitir que OpenClaw invoque a Hermes y OpenCode ──
  # (Solo aplica cuando el servicio está enabled)
  systemd.services.openclaw-gateway = lib.mkIf config.services.openclaw.enable {
    path = with pkgs; [
      pkgs.opencode
      git
      ripgrep
      nodejs_22
    ];

    environment = {
      HERMES_BIN = "hermes";
      OPENCODE_BIN = "opencode";
      WORKSPACE_DIR = "/home/comrade";
    };
  };

  # ── Grupo compartido para integración ─────────────────────────
  # (Solo aplica cuando el servicio está enabled)
  users.users.openclaw = lib.mkIf config.services.openclaw.enable {
    extraGroups = [ "hermes" ];
  };
}
