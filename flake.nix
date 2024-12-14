{
  description = "ACADOS as flake overlay.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }: {
    overlays = {
      default = final: prev: {
        acados = prev.callPackage ./default.nix { };
        acados_template = prev.callPackage ./acados_template.nix { };
      };
    };
  };
}