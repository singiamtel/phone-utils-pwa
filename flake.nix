{
  description = "Python Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python312;

        nativeBuildInputs = with pkgs; [
          python
          python312Packages.fastapi
          python312Packages.uvicorn
          python312Packages.jinja2
        ];

        buildInputs = with pkgs; [];
      in {
        devShells.default = pkgs.mkShell {inherit nativeBuildInputs buildInputs;};
        packages.default = pkgs.writeShellApplication {
          name = "utilsapp";
          runtimeInputs = nativeBuildInputs;
          meta = {
            description = "Utils app";
          };
          text = ''
            uvicorn src.main:app --port 3000
          '';
        };
      }
    );
}
