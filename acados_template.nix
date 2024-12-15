{ pkgs ? import <nixpkgs> {}, acados ? import ./default.nix { inherit pkgs; } }:

pkgs.python3Packages.buildPythonPackage {
  pname = "acados_template";
  version = acados.version;

  src = "${acados}/interfaces/acados_template";

  buildInputs = with pkgs; with pkgs.python3Packages; [
    pip
    setuptools_scm
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [ 
    numpy
    scipy
    casadi
    matplotlib
    cython
  ];

  meta = with pkgs.lib; {
    description = "acados_template python interface";
    homepage = "https://github.com/acados/acados";
  };
}