# { pkgs, lib, buildPythonPackage, fetchPypi, pythonPackages }:
#
# buildPythonPackage rec {
#   pname = "rembg";
#   version = "2.0.56";  # Use the latest version available on PyPI
#
#   src = fetchPypi {
#     inherit pname version;
#       sha256 = "sha256-LKiqBGBnT9k2It5alfHoMpyHGRlyWZqZuZibjXFobh8=";
#   };
#
#   propagatedBuildInputs = [ 
#   pythonPackages.pillow
#   pythonPackages.numpy
#   pythonPackages.scipy
#   pythonPackages.requests
#   pythonPackages.pip
#   pythonPackages.click
#   pythonPackages.filetype
#   pythonPackages.watchdog
#   pythonPackages.aiohttp
#   pythonPackages.anyio
#   pythonPackages.pytest
#   pythonPackages.gradio
#   pythonPackages.poetry-core
#       (pkgs.callPackage ./asyncer.nix {
#         inherit lib buildPythonPackage fetchPypi;
#  # anyio pytest poetry-core
# anyio = pythonPackages.anyio;
# pytest = pythonPackages.pytest;
# poetry-core = pythonPackages.poetry-core;
#       
#       })
#
#   ];
#
#   meta = {
#     description = "A tool to remove background from images";
#     homepage = "https://github.com/danielgatis/rembg";
#     license = lib.licenses.mit;
#   };
# }
{
  lib,
  pkgs,
  fetchPypi,
  packages,
  ...
}: let
  orp = pkgs.callPackage ./onnxruntime-python.nix {
    onnxruntime = pkgs.callPackage ./onnxruntime.nix {cudaSupport = false;};
    inherit (pkgs.python3Packages) buildPythonPackage numpy packaging;
    inherit (pkgs.python3Packages) pythonRelaxDepsHook;
  };
in
  pkgs.python3Packages.buildPythonApplication rec {
    pname = "rembg";
    version = "2.0.55";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-aR9pHBPi8tdAII6DuBQapfYb5bAhM34k1QKg8UpDo9U=";
    };

    dependencies = with packages; [
      jsonschema
      numpy
      # orp
      opencv4
      pillow
      pooch
      pymatting
      scikit-image
      scipy
      tqdm
      aiohttp
      (callPackage ./asyncer.nix {
        inherit (pkgs.python3Packages) anyio pytest poetry-core;
      })
      click
      fastapi
      filetype
      gradio
      multipart
      uvicorn
      watchdog
      pkgs.onnxruntime
          
    ];

    postPatch = ''
      sed -i 's/opencv-python-headless/opencv/' setup.py
    '';
  }
