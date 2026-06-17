# ─────────────────────────────────────────────────────────────────────────────
# Capa 3: OpenCode — Ejecución (Las Manos)
# ─────────────────────────────────────────────────────────────────────────────
# Herramienta CLI para tareas de programación precisas.
# OpenClaw o Hermes pueden delegarle trabajo de código.
#
# Documentación: https://github.com/Hy4ri/opencode-flake
# OpenCode: https://github.com/opencode-ai/opencode
#
# USO:
#   Desde terminal: opencode
#   Desde Hermes: hermes puede invocar `opencode` con instrucciones
#   Desde OpenClaw: el gateway puede ejecutar `opencode` vía exec tool
#
# CONFIGURACIÓN:
#   OpenCode usa variables de entorno para API keys.
#   Configura en tu shell o en ~/.config/opencode/config.json
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Instalación en Home Manager ───────────────────────────────
  home.packages = with pkgs; [
    opencode
  ];

  # ── Variables de entorno para OpenCode ────────────────────────
  # OpenCode detecta automáticamente estas variables.
  # Configúralas según tu proveedor preferido.
  home.sessionVariables = {
    # OpenRouter (recomendado — acceso a múltiples modelos)
    # OPENROUTER_API_KEY = "";  # Configura en secrets o shell

    # OpenAI (alternativo)
    # OPENAI_API_KEY = "";

    # Anthropic (alternativo)
    # ANTHROPIC_API_KEY = "";

    # Directorio de trabajo por defecto
    OPENCODE_WORKDIR = "/home/comrade";
  };

  # ── Configuración de OpenCode (opcional) ──────────────────────
  # Crea el directorio de configuración si no existe
  xdg.configFile."opencode/config.json".text = builtins.toJSON {
    # Proveedor por defecto
    provider = "openrouter";
    model = "deepseek/deepseek-v4-pro";

    # Configuración de OpenRouter
    openrouter = {
      baseUrl = "https://openrouter.ai/api/v1";
    };

    # Herramientas habilitadas
    tools = {
      file_read = true;
      file_write = true;
      file_edit = true;
      terminal = true;
      web_search = true;
      web_fetch = true;
    };

    # Configuración de terminal
    terminal = {
      timeout = 180;
      shell = "zsh";
    };
  };
}
