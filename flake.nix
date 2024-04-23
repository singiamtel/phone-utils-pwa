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
        python = pkgs.python311;
        packages = pkgs.python311Packages;
      # pass buildpythonpkg to rembg
        
      rembg = pkgs.callPackage ./rembg.nix {
        inherit (pkgs) lib fetchPypi;
        buildPythonPackage = packages.buildPythonPackage;
        packages = packages;
      };
              

        nativeBuildInputs = with pkgs; [
          python
          packages.fastapi
          packages.uvicorn
          packages.jinja2
          packages.python-jose
          packages.passlib
          packages.python-dotenv
          tailwindcss
          rembg
          pkgs.onnxruntime
        ];

        devInputs = with pkgs; [
          packages.black
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
