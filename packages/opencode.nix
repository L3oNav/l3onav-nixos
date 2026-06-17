# ─────────────────────────────────────────────────────────────────────────────
# Capa 3: OpenCode — Ejecución (Las Manos)
# ─────────────────────────────────────────────────────────────────────────────
# Herramienta CLI para tareas de programación precisas.
# OpenClaw o Hermes pueden delegarle trabajo de código.
#
# Documentación: https://github.com/opencode-ai/opencode
# Config: ~/.config/opencode/.opencode.json o ~/.opencode.json
#
# USO:
#   Desde terminal:       opencode
#   Prompt no interactivo: opencode -p "explica este código"
#   Desde Hermes:          hermes puede invocar `opencode -p "..."`
#   Desde OpenClaw:        el gateway puede ejecutar `opencode` vía exec tool
#
# AUTENTICACIÓN (una vez instalado):
#   opencode providers login    # Login interactivo para configurar API keys
#   O usa variables de entorno: OPENROUTER_API_KEY, ANTHROPIC_API_KEY, etc.
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Instalación en Home Manager ───────────────────────────────
  home.packages = with pkgs; [
    opencode
  ];

  # ── Configuración base de OpenCode ────────────────────────────
  # El archivo se crea en ~/.config/opencode/.opencode.json
  # Las credenciales se configuran con: opencode providers login
  xdg.configFile."opencode/.opencode.json".text = builtins.toJSON {
    # Shell por defecto para el tool bash
    shell = {
      path = "/run/current-system/sw/bin/zsh";
      args = [ "-l" ];
    };

    # Agentes y sus modelos
    # ── Default: Xiaomi MiMo v2.5 ──
    #   Ventajas: rápido, barato, buen tool calling, bueno para código.
    # ── Hot-swap a Qwen 3: ──
    #   TUI:   Ctrl+O dentro de opencode y selecciona "qwen/qwen3-235b-a22b-2507"
    #   CLI:   opencode run "..." -m openrouter/qwen/qwen3-235b-a22b-2507
    #   Config: cambia "model" abajo, guarda, y reinicia opencode.
    #
    # ⚠️  NO usar en OpenRouter (sin tool calling):
    #   ❌ deepseek/deepseek-v4-pro, google/gemini-3-pro
    agents = {
      build = {
        model = "openrouter/xiaomi/mimo-v2.5";
        maxTokens = 5000;
      };
      general = {
        model = "openrouter/qwen/qwen3-235b-a22b-2507";
        maxTokens = 5000;
      };
      title = {
        model = "openrouter/qwen/qwen3-235b-a22b-2507";
        maxTokens = 80;
      };
    };

    # Habilitar auto-compactación de sesiones largas
    autoCompact = true;
  };

  # ── Variables de entorno para API keys ────────────────────────
  # OpenCode las detecta automáticamente como alternativa al config.
  # Configura en tu ~/.zshrc: export OPENROUTER_API_KEY="sk-or-v1-..."
  # O usa: opencode providers login
  # home.sessionVariables = {
  #   OPENROUTER_API_KEY = "";
  # };

  # ── Alias: `oc` → opencode con MiMo por defecto ────────────
  # opencode v1.17.7 ignora agents.build.model del config,
  # así que forzamos el modelo vía flag. Hot-swap con Ctrl+O en TUI.
  home.shellAliases = {
    oc = "opencode -m openrouter/xiaomi/mimo-v2.5";
  };

  # ── Zed: configuración inicial (luego editable por la UI) ──
  # Settings reference: https://zed.dev/docs/reference/all-settings
  # Se copia una sola vez. Después Zed lo modifica libremente.
  home.activation.zedSettings = let
    zedSettings = builtins.toJSON {
      # ── Tema ───────────────────────────────────────────────
      theme = {
        mode = "dark";
        dark = "Gruvbox Material Dark Hard";
        light = "Gruvbox Material Dark Hard";
      };

      # ── LLM: OpenRouter + DeepSeek V4 Pro (commit messages) ─
      language_models = {
        openai_compatible = {
          OpenRouter = {
            api_url = "https://openrouter.ai/api/v1";
            available_models = [
              {
                name = "deepseek/deepseek-v4-pro";
                display_name = "DeepSeek V4 Pro";
                max_tokens = 128000;
                max_output_tokens = 8192;
              }
            ];
          };
        };
      };

      # ── Fuente principal (editor) ──────────────────────────
      buffer_font_family = "FiraCode Nerd Font Mono";
      buffer_font_size = 15;

      # ── Fuente de la UI ────────────────────────────────────
      ui_font_family = "FiraCode Nerd Font Mono";
      ui_font_size = 16;

      # ── Iconos ─────────────────────────────────────────────
      icon_theme = {
        mode = "dark";
        dark = "Material Icon Theme";
        light = "Material Icon Theme";
      };

      # ── Docks ──────────────────────────────────────────────
      project_panel = {
        dock = "left";
      };
      git_panel = {
        dock = "left";
      };
      collaboration_panel = {
        button = false;
      };

      # ── Agent Panel a la derecha ───────────────────────────
      agent = {
        dock = "right";
        commit_message_model = {
          provider = "OpenRouter";
          model = "deepseek/deepseek-v4-pro";
        };
      };

      # ── Modo Vim ───────────────────────────────────────────
      vim_mode = true;

      # ── Indentación ────────────────────────────────────────
      tab_size = 2;
      hard_tabs = false;
      ensure_final_newline_on_save = true;
      remove_trailing_whitespace_on_save = true;

      # ── Autoguardado ───────────────────────────────────────
      autosave = "on_focus_change";
      format_on_save = "on";

      # ── Línea actual ───────────────────────────────────────
      current_line_highlight = "all";

      # ── Números de línea relativos ─────────────────────────
      relative_line_numbers = "enabled";

      # ── Guías de indentación ───────────────────────────────
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };

      # ── Brackets con color (rainbow brackets) ──────────────
      colorize_brackets = true;

      # ── Scroll ─────────────────────────────────────────────
      scroll_beyond_last_line = "off";

      # ── Git ────────────────────────────────────────────────
      git = {
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = true;
          delay_ms = 500;
        };
      };

      # ── Tabs ───────────────────────────────────────────────
      tabs = {
        file_icons = true;
        git_status = true;
      };

      # ── Minimap ────────────────────────────────────────────
      minimap = {
        show = "always";
      };

      # ── Cursor ─────────────────────────────────────────────
      cursor_blink = true;
      cursor_shape = "bar";

      # ── Whitespace visible ─────────────────────────────────
      show_whitespaces = "selection";

      # ── Config por lenguaje ────────────────────────────────
      languages = {
        Nix = {
          tab_size = 2;
          format_on_save = "on";
          formatter = "language_server";
        };
      };

      # ── Terminal integrada ─────────────────────────────────
      terminal = {
        font_family = "FiraCode Nerd Font Mono";
        font_size = 15;
        blinking = "terminal_controlled";
      };
    };
  in
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      dir="$HOME/.config/zed"
      mkdir -p "$dir"
      if [ ! -f "$dir/settings.json" ]; then
        echo '${zedSettings}' > "$dir/settings.json"
      fi
    '';
}
