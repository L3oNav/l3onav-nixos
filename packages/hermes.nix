# ── Hermes Agent — Migrado a Home Manager ──
#
# La configuración de Hermes se movió de este módulo NixOS (systemd system unit,
# usuario de sistema `hermes`, /var/lib/hermes) a Home Manager.
#
# Ver: packages/hermes-home.nix
# Importado desde: home.nix
#
# Uso actual:
#   hermes chat              → chat interactivo
#   hc                       → alias
#   systemctl --user status hermes-agent  → estado del servicio
#
# El flake input hermes-agent se mantiene como overlay para que pkgs.hermes-agent
# esté disponible en home.packages.
{ ... }:
{
}
