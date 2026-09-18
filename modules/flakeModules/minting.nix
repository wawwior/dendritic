{ self, ... }:
let
  inherit (self.lib) inject mint;
in
{

  flake.lib.mint =
    {
      flake,
      path ? [ ],
    }:
    set:
    set
    // {
      identity =
        let
          meta = {
            inherit path;
            flake = flake.narHash;
            name = set.name or "<unknown>";
            description = set.description or "<unknown>";
          };
        in
        meta
        // {
          hash = builtins.hashString "sha512" (builtins.toJSON meta);
        };
    };

  flake.flakeModules.minting = { inputs, self, ... }: {
    imports = [ inputs.flake-parts.flakeModules.touchup ];
    touchup = {
      attr.aspects.finish =
        aspects:
        builtins.mapAttrs (
          name: aspect:
          inject aspect (mint {
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
