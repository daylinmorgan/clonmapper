{
  description = "clonmapper-protocol";
  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        with pkgs; {
          devShells.default = mkShell {
            nativeBuildInputs = [
              pandoc
              (texlive.combine { inherit (texlive) scheme-small adjustbox datetime2; })
              (python3.withPackages (packages: with packages; [ pip ]))
            ];
          };
        }
    );
}
