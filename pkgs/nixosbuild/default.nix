{ pkgs, ... }:

let
  luajitPackages = luapackages: with luapackages; [
    luafilesystem
  ];
  luajitWithPackages = pkgs.luajit.withPackages luajitPackages;
in
pkgs.stdenv.mkDerivation {
  name = "build-config";
  src = ./.;

  nativeBuildInputs = [
    pkgs.luajit
  ] ++ (with pkgs.luajitPackages; [
    luafilesystem
  ]);

  buildPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp build.lua $out/lib/
    cat > $out/bin/nixosbuild << EOF
exec ${luajitWithPackages}/bin/luajit $out/lib/build.lua "\$@"
EOF
    chmod +x $out/bin/nixosbuild
  '';
}
