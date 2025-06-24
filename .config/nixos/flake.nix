{
  description = "A very basic flake";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { nixpkgs, ... }@inputs:
    let system = "x86_64-linux";
    in {
      nixosConfigurations.ext-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./configuration.nix ];
      };
    };
}
