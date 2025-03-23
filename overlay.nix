final: prev: rec {
  acados = prev.callPackage ./default.nix { };
  acados_0_4_3 = prev.callPackage ./default.nix { version = "0.4.3"; sha256 = "sha256-J0KyKKnkq1f353Aea+D7uNbYRm7/YOTbqBH+NZnwITA="; };
  acados_0_4_4 = prev.callPackage ./default.nix { version = "0.4.4"; sha256 = "sha256-cjyvpr80Dbv/kIkzF9gD6b8WvqOZ4LmMsam69Ip3TgM="; };

  acados_template = prev.callPackage ./acados_template.nix { acados = final.acados; };

  t_renderer = prev.callPackage ./acados_t_renderer.nix { };

  acados-dev = prev.buildEnv {
    name = "acados-dev";
    paths = [
      final.acados
      (final.python312.withPackages (ps: with ps; [
        acados_template
      ]))
    ];
  };
}