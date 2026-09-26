{ lib, ... }:
let

  defaults = {
    class = null;
    aspect-chain = [ { } ];
  };

  bind =
    aspect:
    if (aspect ? __functor && aspect ? __functionArgs) then
      aspect (
        builtins.mapAttrs (name: _: defaults.${name}) (
          lib.filterAttrs (_: optional: !optional) aspect.__functionArgs
        )
      )
    else
      aspect;

  extract =
    { class, options }:
    aspect:
    (lib.evalModules {
      modules = [
        (bind aspect).${class}
        { inherit options; }
      ];
    }).config;

  collect = aspect: lib.flatten ([ aspect ] ++ (map collect ((bind aspect).includes or [ ])));
in
{
  flake.lib = {
    inherit bind extract collect;
  };
}
