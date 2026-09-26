{ self, ... }:
let
  inherit (self.lib) inject;
  inherit (self.lib.aspects) mint;
in
{
  flake.flakeModules.minting = { inputs, self, ... }: {
    imports = [ inputs.flake-parts.flakeModules.touchup ];
    touchup = {
      attr.aspects.finish =
        aspects:
        builtins.mapAttrs (
          name:
          inject (mint {
            flake = self;
            path = [
              "aspects"
              name
            ];
          })
        ) aspects;
    };
  };
}
