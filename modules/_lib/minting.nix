{ lib, self, ... }:
let
  inherit (builtins) hashString toJSON;
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;
  inherit (self.aspects) extract;
in
{
  aspects = {
    mint =
      {
        flake,
        path ? [ ],
      }:
      aspect:
      aspect
      // {
        identity =
          let
            meta = {
              inherit path;
              flake = flake.narHash;
              name = aspect.name or "<unknown>";
              description = aspect.description or "<unknown>";
            };
          in
          meta
          // {
            hash = hashString "sha512" (toJSON meta);
          };
      };

    identity = extract {
      class = "identity";
      options = {
        description = mkOption {
          type = str;
        };
        flake = mkOption {
          type = str;
        };
        hash = mkOption {
          type = str;
        };
        name = mkOption {
          type = str;
        };
        path = mkOption {
          type = listOf str;
        };
      };
    };
  };
}
