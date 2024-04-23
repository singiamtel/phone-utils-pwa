{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  anyio,
  pytest,
}:
buildPythonPackage rec {
  pname = "asyncer";
  version = "0.0.5";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KXnz4Ey+3+XP63kCfc99AE/MRDCgygBmriBJDyGOwG4=";
  };
  dependencies = [
    anyio
  ];
  build-system = [
    poetry-core
  ];
  nativeCheckInputs = [
    pytest
  ];
}
