{ lib, self, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (lib) filterAttrs evalModules;
  inherit (self.aspects) bind collect;
in
{
  aspects = {
    bind =
      aspect:
      let
        defaults = {
          class = null;
          aspect-chain = [ { } ];
        };
      in
      if (aspect ? __functor && aspect ? __functionArgs) then
        aspect (
          mapAttrs (name: _: defaults.${name}) (filterAttrs (_: optional: !optional) aspect.__functionArgs)
        )
      else
        aspect;

    extract =
      { class, options }:
      aspect:
      let
        config = (bind aspect).${class} or null;
      in
      if config != null then
        (evalModules {
          modules = [
            config
            { inherit options; }
          ];
        }).config
      else
        { };

    collect = aspect: lib.flatten ([ aspect ] ++ (map collect ((bind aspect).includes or [ ])));
  };
}
