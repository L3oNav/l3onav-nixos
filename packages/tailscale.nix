# ─────────────────────────────────────────────────────────────────────────────
# Tailscale VPN — acceso remoto a los agentes desde otros dispositivos
# ─────────────────────────────────────────────────────────────────────────────
# PRIMER ARRANQUE (solo una vez):
#   sudo tailscale up --ssh
#
# OPCIÓN CERO-CONFIG (sin intervención manual nunca):
#   1. Ve a https://login.tailscale.com/admin/settings/keys
#   2. Genera un auth key (reusable, ephemeral=false)
#   3. echo "tskey-auth-..." | sudo tee /var/lib/tailscale/authkey
#   4. sudo nixos-rebuild switch
#
# Una vez autenticado, todo es automático en cada boot:
#   - tailscaled arranca con el sistema
#   - OpenClaw se expone en https://nixos.<tu-tailnet>.ts.net
#   - Tailscale SSH disponible sin llaves
#
# Uso desde otros dispositivos en el tailnet:
#   Web:  https://nixos.<tu-tailnet>.ts.net    → OpenClaw Gateway
#   CLI:  ssh comrade@nixos.<tu-tailnet>.ts.net → hermes, qhermes, opencode
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

{
  services.tailscale = {
    enable = true;
    # Para autenticación cero-config, crea el archivo y descomenta:
    # authKeyFile = "/var/lib/tailscale/authkey";
    extraUpFlags = [ "--ssh" ];
  };

  # ── Firewall ─────────────────────────────────────────────────────
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 3000 ];
  };

  # ── Exponer OpenClaw vía Tailscale Serve (HTTPS) ─────────────────
  # https://nixos.<tu-tailnet>.ts.net → localhost:3000
  # --bg persiste en el estado de tailscaled (sobrevive reboots).
  # El oneshot se ejecuta en cada boot para asegurar que esté activo.
  systemd.services.tailscale-serve-openclaw = {
    description = "Expose OpenClaw gateway over Tailscale Serve (HTTPS)";
    after = [ "tailscaled.service" ];
    requires = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.jq pkgs.tailscale ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    # Esperar a que tailscale esté autenticado, luego activar serve
    script = ''
      echo "Esperando que tailscale esté autenticado..."
      for i in $(seq 1 60); do
        if tailscale status --json 2>/dev/null | jq -e '.Self.Online' >/dev/null 2>&1; then
          echo "✓ Tailscale online."
          break
        fi
        sleep 2
      done

      if tailscale status --json 2>/dev/null | jq -e '.Self.Online' >/dev/null 2>&1; then
        echo "▶ Activando Tailscale Serve: :443 → localhost:3000"
        tailscale serve --bg --https 443 3000
        echo "✓ OpenClaw expuesto en https://$(hostname).<tu-tailnet>.ts.net"
      else
        echo "⚠ Tailscale no autenticado. Ejecuta: sudo tailscale up --ssh"
        echo "  Luego: sudo systemctl restart tailscale-serve-openclaw"
      fi
    '';

    postStop = ''
      tailscale serve --https 443 3000 off 2>/dev/null || true
    '';
  };
}
