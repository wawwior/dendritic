{ inputs, lib, ... }:
{
  flake.lib.aspects = inputs.flake-aspects.lib lib;
}
