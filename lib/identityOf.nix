{
  lib,
  ...
}:
let
  inherit (lib) evalModules mkOption;
  inherit (lib.types) str;
in
aspect:
(evalModules {
  modules = [
    (aspect.resolve { class = "identity"; })
    {
      options = {
        flake = mkOption {
          type = str;
        };
        name = mkOption {
          type = str;
        };
        description = mkOption {
          type = str;
        };
        hash = mkOption {
          type = str;
        };
      };
    }
  ];
}).config
