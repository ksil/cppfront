{ lib
, stdenv
, cmake
, cppfront-src
, nix-gitignore
}:
stdenv.mkDerivation rec {
  pname = "cppfront";
  version = "0.3.0";

  src = nix-gitignore.gitignoreSource [] ../.;

  nativeBuildInputs = [ cmake ];
  buildInputs = [];

  # overwrite the submodule with the source provided as an input to this derivation
#  configurePhase =
#  ''
#    ln -s ${cppfront-src} cppfront
#    ls -al
#    mkdir build && cd build
#    cmake ..
#  '';

  meta = with lib; {
    description = "cppfront";
    homepage = "https://github.com/modern-cmake/cppfront";
    license = licenses.cc-by-nc-nd-40;
    maintainers = with maintainers; [ ];
  };
}
