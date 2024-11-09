{ 
  pkgs ? import <nixpkgs> {},
  patchelf ? pkgs.patchelf,
  version ? "0.0.34",
  sha256 ? "sha256-OQBj80qOE2IFZLShNgEicBaOFCHdeSCnRwSHSeHZlxg=",
}:
let
  binary_name = "acados_t_renderer";
in pkgs.stdenv.mkDerivation {
  pname = "acados_t_renderer";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/acados/tera_renderer/releases/download/v${version}/t_renderer-v${version}-linux";
    inherit sha256;
  };

  unpackPhase = ":";

  nativeBuildInputs = [ patchelf ];

  patchPhase = ''
    cp $src ./patched-binary
    chmod +w ./patched-binary
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) ./patched-binary
    patchelf --set-rpath $out/lib:$NIX_LD_LIBRARY_PATH ./patched-binary
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./patched-binary $out/bin/${binary_name}
    chmod +x $out/bin/${binary_name}
  '';
}