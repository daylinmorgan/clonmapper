{
  description = "clonmapper-protocol";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs.lib) genAttrs;
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
          (texlive.combine {inherit (texlive) 
          scheme-small lualatex-math selnolig siunitx 

          adjustbox babel-german background bidi collectbox csquotes everypage filehook
          footmisc footnotebackref framed fvextra letltxmacro ly1 mdframed mweights
          needspace pagecolor sourcecodepro sourcesanspro titling ucharcat ulem
          unicode-math upquote xecjk xurl zref
          ;})
          (python3.withPackages (packages: with packages; [pip]))
        ];
      };
    });
  };
}
