let
  genForAllSystems = nixpkgs: systems: function:
    nixpkgs.lib.genAttrs
      systems
      (system: function nixpkgs.legacyPackages.${system});

  ShellPkgs = pkgs: with pkgs; {
    base = [
      gnumake
      gcc13
      glibc
      binutils
      python310Packages.compiledb
    ];

    debug = [ valgrind ltrace ];
    testing = [ criterion gcovr ];
  };

  BuildEpitechCBinary = pkgs: info: pkgs.stdenv.mkDerivation ({
    makeFlags = [ "CC=${pkgs.gcc13}/bin/gcc" ];
    hardeningDisable = [ "format" "fortify" ];

    buildPhase = ''
      runHook preBuild

      ${pkgs.gnumake} ${info.name}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp ${info.name} $out/bin/${info.name}

      runHook postInstall
    '';
  } // info);

in
{
  inherit
    genForAllSystems
    ShellPkgs
    BuildEpitechCBinary
    ;
}
