{
  description = "l3onav-nixos — painless NiXOS configuration flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hermes-agent,
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
          # hy3: override to latest master for Hyprland 0.54.3 compat
          hyprlandPlugins = prev.hyprlandPlugins // {
            hy3 = prev.hyprlandPlugins.hy3.overrideAttrs (old: {
              version = "0.54.2.1-unstable-2026-05";
              src = final.fetchFromGitHub {
                owner = "outfoxxed";
                repo = "hy3";
                rev = "a7282db2d7ca336d3c9faa5d10d75fc43eed37aa";
                hash = "sha256-P3wwiIfqo89evW7xzI+wOI/qM1WPZBiiSmGNtBmYeVk=";
              };
            });
          };
        })
      ];
    in
    {
      nixosConfigurations.comrade = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          hermes-agent.nixosModules.default
          ./configuration.nix
          {
            nixpkgs.overlays = overlays;
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
