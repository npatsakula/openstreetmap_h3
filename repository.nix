{ pkgs ? import <nixpkgs> {} }: (pkgs.buildMaven ./project-info.json).repo