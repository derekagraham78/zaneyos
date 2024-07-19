{
  description = "PapalPenguin's NixOS Flake for Mulder";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-software-center.url = "https://flakehub.com/f/vlinkz/nix-software-center/0.1.2.tar.gz";
    nix-config-modules.url = "https://flakehub.com/f/chadac/nix-config-modules/0.1.0.tar.gz";
    Hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.41.2.tar.gz";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05-small";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    # The nixpkgs entry in the flake registry.
  };
  outputs = {
    nixpkgs,
    fh,
    Hyprland,
    nix-config-modules,
    nix-software-center,
    ...
  }: {
    nixosConfigurations = {
      "Mulder.papalpenguin.com" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            environment.systemPackages = [fh.packages.x86_64-linux.default];
          }
        ];
      };
    };
  };
}
