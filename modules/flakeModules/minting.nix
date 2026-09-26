{ self, lib, ... }:
let
  inherit (self.lib) inject mint;
in
{

  flake.lib = {
    identity = self.lib.extract {
      class = "identity";
      options = {
        description = lib.mkOption {
          type = lib.types.str;
        };
        flake = lib.mkOption {
          type = lib.types.str;
        };
        hash = lib.mkOption {
          type = lib.types.str;
        };
        name = lib.mkOption {
          type = lib.types.str;
        };
        path = lib.mkOption {
          type = lib.types.listOf lib.types.str;
        };
      };
    };

    mint =
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
  };

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
