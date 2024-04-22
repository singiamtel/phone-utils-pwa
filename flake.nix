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
          python312Packages.python-jose
          python312Packages.passlib
          python312Packages.python-dotenv
          tailwindcss
        ];

        devInputs = with pkgs; [
          python312Packages.black
        ];
      in {
        devShells.default = pkgs.mkShell {inherit nativeBuildInputs devInputs;};
        packages.default = pkgs.writeShellApplication {
          name = "utilsapp";
          runtimeInputs = nativeBuildInputs;
          meta = {
            description = "Utils app";
          };
          text = ''
            tailwindcss -i static/style/to_all/global.css -o static/style/to_all/tailwind.css
            uvicorn src.main:app --port 3000
          '';
        };
        packages.lint = pkgs.writeShellApplication {
          name = "lint";
          runtimeInputs = devInputs;
          meta = {
            description = "Lint";
          };
          text = ''
            black src
          '';
        };
      }
    );
}
