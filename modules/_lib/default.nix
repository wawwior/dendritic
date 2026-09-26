{ inputs, lib, ... }:
let
  aspects = inputs.flake-aspects.lib lib;
in
lib.fix (
  self:
  lib.foldl' lib.recursiveUpdate { } (
    (map (path: import path { inherit lib self; }) [
      ./aspects.nix
      ./inject.nix
      ./minting.nix
      ./types.nix
    ])
    ++ [
      { inherit aspects; }
    ]
  )
)
