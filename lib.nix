let
  genforAllSystems = nixpkgs: systems: function:
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

in {
  inherit
    genforAllSystems
    ShellPkgs
  ;
}
