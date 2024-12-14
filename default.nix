{ 
  pkgs ? import <nixpkgs> {}
}:
let 
  version = "0.3.5_stable";
  pname = "ACADOS";
  t_renderer = import ./acados_t_renderer.nix { inherit pkgs; };
in
pkgs.stdenv.mkDerivation {
  inherit version;
  inherit pname;

  src = pkgs.fetchFromGitHub {
    owner = "acados";
    repo = "acados";
    rev = "fd25099ceb0b66a80147b262db162752fdddb6dc"; 
    sha256 = "sha256-tL5wz4J3pL2S9KZbEdcR9mv2EMgSzWXGseyfzYQlGLA=";
    # TODO: There are some modules that could be inputs (e.g. CasADi) which would avoid duplication and having to build them here.
    fetchSubmodules = true;
  };

  CFLAGS = [ "-D_GNU_SOURCE" ];

  nativeBuildInputs = with pkgs; [ 
    gcc
    cmake
  ]; 

  buildInputs = [
    t_renderer
  ];  

  configurePhase = ''
    acados_src_dir=$(pwd)
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$out -DACADOS_WITH_QPOASES=ON -DACADOS_WITH_C_INTERFACE=ON -DACADOS_WITH_OPENMP=ON ..
  '';

  buildPhase = ''
    cd $acados_src_dir/build
    make -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    # Install custom CMake file.
    mkdir -p $out/cmake 
    cp ${./cmake}/* $out/cmake/ -r

    # Link t_renderer.
    # If we don't link t_renderer, ACADOS may later attempt to download it.
    # This won't work because the directory won't be writable and the binary would have to be patched anyway.
    mkdir -p $out/bin
    ln -s ${t_renderer}/bin/acados_t_renderer $out/bin/t_renderer 

    # Install the ACADOS python interface which isn't installed by by make install.
    mkdir $out/interfaces/acados_template -p
    cp $acados_src_dir/interfaces/acados_template/* $out/interfaces/acados_template/ -r

    # Install ACADOS.
    cd $acados_src_dir/build
    make install -j $NIX_BUILD_CORES
  '';


  meta = with pkgs.lib; {
    description = "Fast and embedded solvers for nonlinear optimal control.";
    homepage = "https://github.com/acados/acados"; 
  };
}