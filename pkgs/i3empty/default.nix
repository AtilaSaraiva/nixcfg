{ stdenv, lib, python3 }:

stdenv.mkDerivation rec {
  pname = "i3empty";
  version = "0.1";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 -t $out/bin/ i3empty.py
    echo "${python3}/bin/python i3empty.py" > $out/bin/i3empty
  '';
}
