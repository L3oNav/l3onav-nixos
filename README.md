# l3onav-nixos

Configuración NixOS con sistema de 3 capas para agentes AI.

## 🤖 Sistema 3 Capas

Este sistema implementa una arquitectura de agentes AI en 3 capas que trabajan juntas:

```
┌─────────────────────────────────────────────────────────────┐
│  Capa 1: OpenClaw — Orquestación (Sistema Nervioso)         │
│  Servicio systemd 24/7 que recibe comandos y los enruta     │
│  → Telegram, Discord, CLI                                   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│  Capa 2: Hermes — Evolución (Cerebro)                       │
│  Agente con aprendizaje, memoria y planificación            │
│  → Contenedor Podman, OpenRouter, MCP servers               │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│  Capa 3: OpenCode — Ejecución (Las Manos)                   │
│  CLI para tareas de programación precisas                   │
│  → Análisis de código, refactoring, debugging               │
└─────────────────────────────────────────────────────────────┘
```

### Flujo de trabajo

1. **Usuario** envía un comando (Telegram/CLI/Discord)
2. **OpenClaw** recibe y decide qué agente usar
3. **Hermes** analiza, planifica y usa su memoria
4. **OpenCode** ejecuta tareas de código si es necesario
5. **Resultado** regresa al usuario

### Comandos de integración

```bash
# Verificar estado de las 3 capas
check-agents-status

# Delegar tarea a Hermes
openclaw-delegate-to-hermes "organiza mi semana"

# Delegar tarea de código a OpenCode
hermes-delegate-to-opencode "refactoriza el módulo de auth"

# Pipeline completo (OpenClaw → Hermes → OpenCode)
agent-pipeline "revisa el PR #123 del repo X"
```

## 📁 Estructura

```
l3onav-nixos/
├── flake.nix                    # Flake principal con inputs de las 3 capas
├── configuration.nix            # Configuración NixOS (importa capas 1 y 2)
├── home.nix                     # Home Manager (importa capa 3)
├── secrets.nix                  # Secrets (NO en git)
├── secrets.nix.example          # Template de secrets
├── hardware.nix                 # Configuración de hardware
├── hardware-configuration.nix   # Hardware auto-generado
├── declaration.nix              # Declaraciones adicionales
└── packages/
    ├── hermes.nix               # Capa 2: Hermes (Evolución)
    ├── openclaw.nix             # Capa 1: OpenClaw (Orquestación)
    ├── opencode.nix             # Capa 3: OpenCode (Ejecución)
    ├── integration.nix          # Scripts de integración
    └── zsh.nix                  # Configuración Zsh
```

## 🚀 Instalación

### 1. Clonar y configurar secrets

```bash
cd /etc/nixos
git clone <tu-repo> .
cp secrets.nix.example secrets.nix
# Edita secrets.nix con tus valores reales
```

### 2. Configurar secrets de las 3 capas

```bash
# Capa 1: OpenClaw
sudo mkdir -p /var/lib/openclaw
echo "TU_OPENROUTER_API_KEY" | sudo tee /var/lib/openclaw/model-api-key
sudo chmod 600 /var/lib/openclaw/model-api-key
sudo chown openclaw:openclaw /var/lib/openclaw/model-api-key

# Capa 2: Hermes (ya configurado en /var/lib/hermes/env)
# Capa 3: OpenCode (usa variables de entorno o config.json)
```

### 3. Aplicar configuración

```bash
sudo nixos-rebuild switch --flake .#comrade
```

### 4. Verificar instalación

```bash
check-agents-status
```

## 🔧 Configuración

### OpenClaw (Capa 1)

Edita `packages/openclaw.nix`:

- `modelProvider`: Proveedor de AI (openrouter, anthropic, openai, ollama)
- `telegram.enable`: Habilitar bot de Telegram
- `discord.enable`: Habilitar bot de Discord
- `toolAllowlist`: Herramientas permitidas

### Hermes (Capa 2)

Edita `packages/hermes.nix`:

- `settings.model.default`: Modelo por defecto
- `mcpServers`: Servidores MCP (Anki, Obsidian, QMD)
- `container.extraVolumes`: Volúmenes montados

### OpenCode (Capa 3)

Edita `packages/opencode.nix`:

- `provider`: Proveedor de AI
- `model`: Modelo por defecto
- `tools`: Herramientas habilitadas

## 📚 Recursos

- [OpenClaw](https://github.com/openclaw/openclaw) — Gateway de agentes
- [Hermes Agent](https://github.com/NousResearch/hermes-agent) — Agente con aprendizaje
- [OpenCode](https://github.com/opencode-ai/opencode) — CLI de programación
- [NixOS](https://nixos.org/) — Sistema operativo declarativo

## 📝 Licencia

Configuración personal. Úsala como referencia para tu propio setup.
