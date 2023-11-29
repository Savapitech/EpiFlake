{
  outputs = { self, nixpkgs }:
    let
      lib = import ./lib.nix;
      forAllSystems = (self.lib.genForAllSystems nixpkgs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]);
    in
    {
      inherit lib;
      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
    };
}
