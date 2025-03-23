{
  description = "ACADOS as flake overlay.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems }:
  let
    overlay = import ./overlay.nix;
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in
  {
    overlays.default = overlay;
    packages = eachSystem (system: 
      let 
        pkgs = import nixpkgs { 
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in with pkgs; {
        inherit acados-dev;
        inherit acados;
        inherit acados_0_4_3;
        inherit acados_0_4_4;
        inherit acados_template;
        inherit t_renderer;
      }
    );
  };
}