{
  description = "clonmapper-protocol";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs.lib) genAttrs makeBinPath;
    forAllSystems = f:
      genAttrs ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]
      (system:
        f (import nixpkgs {
          localSystem = system;
        }));
  in {
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          pandoc
          (texlive.combine {inherit (texlive) scheme-small adjustbox datetime2 lualatex-math selnolig siunitx;})
          (python3.withPackages (packages: with packages; [pip]))
        ];
      };
    });
  };
}
