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

  collectAspects =
    class: aspect:
    lib.flatten (
      [ (bind aspect).${class} or [ ] ] ++ (map (collectAspects class) ((bind aspect).includes or [ ]))
    );
in
{
  flake.lib.collectAspects = collectAspects;
}
