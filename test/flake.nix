{
  description = "Development environment for Odysseus.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    acados-overlay.url = "github:adrian-kriegel/acados-nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    acados-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { 
          inherit system; 

          overlays = [
            acados-overlay.overlays.default
          ];
        };
        
        python = pkgs.python312.withPackages (ps: with ps; [ 
          
          pkgs.acados_template
        ]);
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ 
            python
            acados
          ];
          shellHook = ''
            echo ""
            echo "##########################################"
            echo "Checking package ..."
            echo "##########################################"
            echo ""
            echo "ACADOS: ${pkgs.acados}"
            echo "acados_template: ${pkgs.acados_template}"

            if [ ! -f ${pkgs.acados}/bin/t_renderer ]; then
              echo "File acados/bin/t_renderer not found!"
              exit -1
            fi

            echo ""
            echo "##########################################"
            echo "Checking python interface installation..."
            echo "##########################################"
            echo ""

            python_acados_path=$(python -c "\
from acados_template.utils import get_acados_path
print(get_acados_path())")

            echo "get_acados_path() returned \"$python_acados_path\""

            if [ ! "$(realpath $python_acados_path)" = "$(realpath ${pkgs.acados})" ]; then
              echo "get_acados_path() did not return acados store path!"
              exit -1
            fi

            echo ""
            echo "##########################################"
            echo "OK!"
            echo "##########################################"
            echo ""
          '';
        };
      }
    );
}