{ lib, ... }:
let

  inherit (lib) mkOption;
  inherit (lib.types)
    lazyAttrsOf
    listOf
    raw
    submodule
    str
    ;

  hostSubmodule =
    cnf:
    submodule (
      { name, ... }: {
        options = {
          name = mkOption {
            description = "host name";
            default = name;
            type = str;
          };

          aspects = mkOption {
            description = "aspects for this host";
            type = listOf raw;
            default = [ ];
          };

          users = mkOption {
            description = "users for this host";
            type = listOf raw;
            default = [ ];
          };
        };
      }
    );

  hostsType =
    cnf:
    submodule {
      freeformType = lazyAttrsOf (hostSubmodule cnf);
    };

in
{

  flake.lib.types = {
    inherit hostSubmodule hostsType;
  };
}
