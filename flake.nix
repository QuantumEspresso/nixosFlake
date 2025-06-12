{
  description = "NixOS configuration with two or more channels";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager?ref=release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
    ags.url = "github:aylur/ags";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nvf,
    ags,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations."masyaf" = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        # Overlays-module makes "pkgs.unstable" available in configuration.nix
        ({
          config,
          pkgs,
          ...
        }: {nixpkgs.overlays = [overlay-unstable];})
        nvf.nixosModules.default
        ./nixos/configuration.nix
      ];
    };
  };
}
