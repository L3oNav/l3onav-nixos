# ─────────────────────────────────────────────────────────────────────────────
# Capa 2: Hermes — Evolución (Cerebro) — Home Manager
# ─────────────────────────────────────────────────────────────────────────────
# Hermes Agent configurado como servicio de usuario (systemd user unit).
# El CLI y el gateway comparten estado vía $HOME/.hermes/.
#
# Uso:
#   hermes chat              → chat interactivo
#   hc                       → alias para hermes chat
#   hermes config            → ver config generada
#   systemctl --user status hermes-agent  → estado del servicio gateway
#
# El API key se toma de secrets.nix y se escribe en ~/.hermes/.env.
# Hermes lo lee automáticamente desde $HERMES_HOME/.env.
#
# ⚠️ secrets.nix está gitignored → rebuild requiere flag --impure
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

let
  secrets = import /home/comrade/l3onav-nixos/secrets.nix;
  hermesHome = "${config.home.homeDirectory}/.hermes";
in
{
  # ── Paquete + CLI ──────────────────────────────────────────────────
  home.packages = with pkgs; [
    hermes-agent
  ];

  # ── Entorno ────────────────────────────────────────────────────────
  home.sessionVariables = {
    HERMES_HOME = hermesHome;
  };

  # ── API Key (.env) ─────────────────────────────────────────────────
  home.file.".hermes/.env" = {
    text = ''
      DEEPSEEK_API_KEY=${secrets.deepseek-api-key}
    '';
  };

  # ── Managed mode marker ────────────────────────────────────────────
  home.file.".hermes/.managed".text = "";

  # ── MCP Servers ────────────────────────────────────────────────────
  home.file.".hermes/config.yaml".text = builtins.toJSON {
    mcp_servers = {
      blender = {
        command = "${pkgs.uv}/bin/uvx";
        args = [ "blender-mcp" ];
        enabled = true;
      };
      anki = {
        command = "npx";
        args = [ "mcp-remote" "http://127.0.0.1:3141" ];
        enabled = true;
      };
    };
  };

  # ── Directorios runtime ────────────────────────────────────────────
  home.file.".hermes/cron/.keep".text = "";
  home.file.".hermes/sessions/.keep".text = "";
  home.file.".hermes/logs/.keep".text = "";
  home.file.".hermes/memories/.keep".text = "";
  home.file.".hermes/plugins/.keep".text = "";

  # ── Alias ──────────────────────────────────────────────────────────
  home.shellAliases = {
    hc = "hermes chat";
    hcfg = "hermes config";
  };

  # ── Servicio gateway (systemd user unit) ───────────────────────────
  systemd.user.services.hermes-agent = {
    Unit = {
      Description = "Hermes Agent Gateway (user)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "HERMES_HOME=${hermesHome}"
        "HERMES_MANAGED=true"
      ];
      ExecStart = "${pkgs.hermes-agent}/bin/hermes gateway";
      Restart = "always";
      RestartSec = 5;
      WorkingDirectory = config.home.homeDirectory;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
