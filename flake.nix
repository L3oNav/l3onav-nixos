{
  description = "l3onav-nixos — painless NiXOS configuration flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    nix-rosetta-builder.url = "github:cpick/nix-rosetta-builder";
    nix-rosetta-builder.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    theme-bobthefish.url = "github:oh-my-fish/theme-bobthefish/e3b4d4eafc23516e35f162686f08a42edf844e40";
    theme-bobthefish.flake = false;

    hermes-agent.url = "github:NousResearch/hermes-agent";

    # ── Capa 1: OpenClaw — Orquestación (gateway systemd 24/7) ──
    openclaw-nix = {
      url = "github:Scout-DJ/openclaw-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Capa 3: OpenCode — Ejecución (CLI para programación) ──
    opencode-flake = {
      url = "github:Hy4ri/opencode-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hermes-agent,
      openclaw-nix,
      opencode-flake,
      nixpkgs-stable,
      nix-gaming,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          openldap = prev.openldap.overrideAttrs (_: {
            doCheck = false;
          });
          python3 = prev.python3.override {
            packageOverrides = pyFinal: pyPrev: {
              tpm2-pytss = pyPrev.tpm2-pytss.overridePythonAttrs (_: {
                doCheck = false;
              });
            };
          };
        })
      ];
    in
    {
      nixosConfigurations.comrade = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          openclaw-nix.nixosModules.default
          ./configuration.nix
          {
            nixpkgs.overlays = overlays ++ [
              (final: prev: {
                hermes-agent = hermes-agent.packages.${prev.system}.default;
              })
              openclaw-nix.overlays.default
              opencode-flake.overlays.default
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.comrade = import ./home.nix;
            };
          }
        ];
      };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
