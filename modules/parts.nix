args@{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.flake-aspects.flakeModule
    (import ./flakeModules/minting.nix args).flake.flakeModules.minting
  ];

  options.flake.lib = lib.mkOption {
    type = lib.types.anything;
    default = { };
  };
}
