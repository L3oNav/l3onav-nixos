{ config, pkgs, lib, inputs, ... }:

let
  secrets = import /home/comrade/l3onav-nixos/secrets.nix;
in
{
  # ── Hermes Agent — NixOS Module (declarativo) ──
  #
  # El API key se toma de secrets.nix y se escribe en /var/lib/hermes/env.
  # El servicio y el CLI lo leen automáticamente.
  #
  # Uso:
  #   hermes chat              → chat interactivo
  #   hermes config            → ver config generada
  #   systemctl status hermes-agent  → estado del servicio gateway
  #
  # ⚠️ En modo managed, hermes setup/config están bloqueados a propósito.
  #    Edita este archivo y hacé nixos-rebuild switch para cambiar la config.
  # ⚠️ secrets.nix está gitignored → rebuild requiere flag --impure

  # ── Archivo .env del agente ────────────────────────────────────────
  environment.etc."hermes/env" = {
    text = ''
      DEEPSEEK_API_KEY=${secrets.deepseek-api-key}
    '';
    mode = "0600";
    user = "hermes";
    group = "hermes";
  };

  services.hermes-agent = {
    enable = true;
    environmentFiles = [ "/etc/hermes/env" ];
    addToSystemPackages = true;
  };
}
