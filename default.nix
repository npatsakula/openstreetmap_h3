{ pkgs ? import <nixpkgs> { }}: let
  repository = pkgs.callPackage ./repository.nix {};
in pkgs.stdenv.mkDerivation rec {
  pname = "osm-to-pgsnapshot-schema-ng";
  version = "1.0-SNAPSHOT";

  src = builtins.fetchTarball "https://github.com/npatsakula/openstreetmap_h3/archive/nix_support.tar.gz";
  buildInputs = with pkgs; [ maven makeWrapper ];

  buildPhase = ''
    mvn package --offline -Dmaven.repo.local=${repository}
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/java

    ln -s ${repository} $out/repository

    install -Dm644 target/${pname}-${version}.jar $out/share/java

    makeWrapper ${pkgs.jdk}/bin/java $out/bin/${pname} \
          --add-flags "-jar $out/share/java/${pname}-${version}.jar"
  '';

}