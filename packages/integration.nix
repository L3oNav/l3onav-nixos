# ─────────────────────────────────────────────────────────────────────────────
# Integración entre las 3 Capas — Scripts y Wrappers
# ─────────────────────────────────────────────────────────────────────────────
# Estos scripts permiten la comunicación entre:
#   OpenClaw (Capa 1) → Hermes (Capa 2) → OpenCode (Capa 3)
#
# Flujo típico:
#   Usuario → OpenClaw → Hermes → OpenCode → resultado → Usuario
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

let
  # ── Script: openclaw-delegate-to-hermes ─────────────────────────
  # Permite que OpenClaw delegue tareas complejas a Hermes.
  # Uso: openclaw-delegate-to-hermes "organiza mi semana"
  delegateToHermes = pkgs.writeShellScriptBin "openclaw-delegate-to-hermes" ''
    set -euo pipefail

    TASK="$*"
    if [ -z "$TASK" ]; then
      echo "Uso: openclaw-delegate-to-hermes <tarea>"
      exit 1
    fi

    echo "🧠 Delegando a Hermes: $TASK"

    # Hermes corre como servicio systemd, usamos su CLI
    if command -v hermes &>/dev/null; then
      hermes --task "$TASK" --output-format json
    else
      echo "❌ Hermes CLI no encontrado. Verifica que services.hermes-agent.addToSystemPackages = true"
      exit 1
    fi
  '';

  # ── Script: hermes-delegate-to-opencode ─────────────────────────
  # Permite que Hermes delegue tareas de programación a OpenCode.
  # Uso: hermes-delegate-to-opencode "refactoriza el módulo de auth"
  delegateToOpenCode = pkgs.writeShellScriptBin "hermes-delegate-to-opencode" ''
    set -euo pipefail

    TASK="$*"
    WORKDIR="''${OPENCODE_WORKDIR:-/home/comrade}"

    if [ -z "$TASK" ]; then
      echo "Uso: hermes-delegate-to-opencode <tarea de programación>"
      exit 1
    fi

    echo "🔧 Delegando a OpenCode: $TASK"

    if command -v opencode &>/dev/null; then
      cd "$WORKDIR"
      opencode --prompt "$TASK" --non-interactive
    else
      echo "❌ OpenCode no encontrado. Verifica que esté instalado."
      exit 1
    fi
  '';

  # ── Script: agent-pipeline ──────────────────────────────────────
  # Pipeline completo: recibe un comando, decide qué capa usar.
  # Uso: agent-pipeline "revisa el PR #123 del repo X"
  agentPipeline = pkgs.writeShellScriptBin "agent-pipeline" ''
    set -euo pipefail

    COMMAND="$*"
    if [ -z "$COMMAND" ]; then
      echo "Uso: agent-pipeline <comando>"
      echo ""
      echo "Ejemplos:"
      echo "  agent-pipeline 'organiza mi semana'           → Hermes"
      echo "  agent-pipeline 'refactoriza auth module'      → Hermes → OpenCode"
      echo "  agent-pipeline 'revisa PR #123 en repo X'     → Hermes → OpenCode"
      exit 1
    fi

    echo "═══════════════════════════════════════════════════"
    echo "  🤖 Agent Pipeline — Sistema 3 Capas"
    echo "═══════════════════════════════════════════════════"
    echo ""
    echo "  Comando: $COMMAND"
    echo ""

    # Paso 1: Hermes analiza y planifica
    echo "  📡 Capa 1 (OpenClaw): Recibido"
    echo "  🧠 Capa 2 (Hermes): Analizando..."
    echo ""

    HERMES_RESULT=$(hermes --task "$COMMAND" --output-format json 2>/dev/null || echo '{"needs_code": true, "plan": "Delegar a OpenCode"}')

    # Paso 2: Si Hermes determina que necesita código, delega a OpenCode
    NEEDS_CODE=$(echo "$HERMES_RESULT" | ${pkgs.jq}/bin/jq -r '.needs_code // true' 2>/dev/null || echo "true")

    if [ "$NEEDS_CODE" = "true" ]; then
      echo "  🔧 Capa 3 (OpenCode): Ejecutando..."
      echo ""
      hermes-delegate-to-opencode "$COMMAND"
    else
      echo "  ✅ Hermes completó la tarea sin necesidad de código."
      echo "$HERMES_RESULT" | ${pkgs.jq}/bin/jq -r '.response // .' 2>/dev/null || echo "$HERMES_RESULT"
    fi
  '';

  # ── Script: check-agents-status ─────────────────────────────────
  # Verifica el estado de los servicios de las 3 capas.
  checkAgentsStatus = pkgs.writeShellScriptBin "check-agents-status" ''
    echo "═══════════════════════════════════════════════════"
    echo "  🤖 Estado del Sistema 3 Capas"
    echo "═══════════════════════════════════════════════════"
    echo ""

    # Capa 1: OpenClaw
    echo "  ── Capa 1: OpenClaw (Orquestación) ──"
    if systemctl is-active --quiet openclaw-gateway; then
      echo "  ✅ openclaw-gateway: ACTIVO"
    else
      echo "  ❌ openclaw-gateway: INACTIVO"
      systemctl status openclaw-gateway --no-pager -l 2>/dev/null | head -5
    fi
    echo ""

    # Capa 2: Hermes
    echo "  ── Capa 2: Hermes (Evolución) ──"
    if systemctl is-active --quiet hermes-agent; then
      echo "  ✅ hermes-agent: ACTIVO"
    else
      echo "  ⚠️  hermes-agent: INACTIVO (puede ser normal si corre bajo demanda)"
    fi
    if command -v hermes &>/dev/null; then
      echo "  ✅ hermes CLI: disponible"
    else
      echo "  ⚠️  hermes CLI: no disponible en PATH"
    fi
    echo ""

    # Capa 3: OpenCode
    echo "  ── Capa 3: OpenCode (Ejecución) ──"
    if command -v opencode &>/dev/null; then
      echo "  ✅ opencode CLI: disponible"
      opencode --version 2>/dev/null && true
    else
      echo "  ❌ opencode CLI: no encontrado"
    fi
    echo ""

    echo "═══════════════════════════════════════════════════"
  '';
in
{
  # ── Instalar scripts de integración ─────────────────────────────
  environment.systemPackages = [
    delegateToHermes
    delegateToOpenCode
    agentPipeline
    checkAgentsStatus
    pkgs.jq  # Necesario para parsear JSON en los scripts
  ];
}
