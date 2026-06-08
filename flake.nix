{
  description = "NixOS config with stable + unstable + HM";

  inputs = {

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    
    qylock = {
      url = "github:Darkkal44/qylock";
      flake = false;
    };

  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, home-manager, qylock, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.thinkpad = nixpkgs-stable.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit pkgs-unstable;
        inherit qylock;
      };

      modules = [
        ./nixos/configuration.nix
        ./nixos/hardware-thinkpad.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
        nixosConfigurations.PC = nixpkgs-stable.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit pkgs-unstable;
        inherit qylock;
      };

      modules = [
        ./nixos/configuration.nix
        ./nixos/hardware-PC.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
