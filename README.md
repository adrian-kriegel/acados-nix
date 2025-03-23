# acados-nix

Nix flake containing packages 

- [acados](https://github.com/acados/acados)
- [acados_template](https://github.com/acados/acados/tree/01452a6c902298da39947ccb6f44fb550cf51d07/interfaces/acados_template)
- [t_renderer](https://github.com/acados/tera_renderer/)

All packages are patched to work out of the box without setting ``ACADOS_SOURCE_DIR`` or ``LD_LIBRARY_PATH`` as in the original installation instructions.

## Usage

Quickly get a shell with all packages and a python environment: 

```bash
nix shell github:adrian-kriegel/acados-nix#acados-dev
```

Example usage in a flake: 

```nix
{
  inputs.acados-overlay.url = "github:adrian-kriegel/acados-nix";

  outputs = { self, nixpkgs, acados-overlay }:
    let
      pkgs = import nixpkgs { 
        system = "x86_64-linux";
        overlays = [ acados-overlay.overlays.default ];
      };
    in {
      
      devShells.x86_64-linux.default = pkgs.mkShell {

        buildInputs = with pkgs; [
          acados
          (pkgs.python312.withPackages (ps: with ps; [
            acados_template
          ]))
        ];
      };
    };
}
```

# ACADOS versions 

See [overlay.nix](./overlay.nix) for pre-configured versions of ACADOS. You can use any version by overriding either `version` or `rev`. Be sure to change the SHA256 hash to the correct value (just let nix complain and copy it from the error message).

```nix 
my_acados = acados.override { 
  version="0.4.5";
  sha256="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
}
```

```nix
my_acados = acados.override { 
  version="my-special-revision";
  rev="01452a6c902298da39947ccb6f44fb550cf51d07";
  sha256="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
}
```
