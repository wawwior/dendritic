{
  self,
  lib,
  ...
}:
let

  inherit (lib) mkOption;

  inherit (self.aspects) forward-include;

  inherit (self.lib.aspects) forward resolve;
  inherit (self.lib.types) hostsType;
in
{

  flake.flakeModules.hosts = { self, lib, ... }: {

    options = {
      flake.hosts = mkOption {
        type = hostsType { };
        default = { };
      };
    };

    config.flake.nixosConfigurations = builtins.mapAttrs (
      name: host:
      lib.nixosSystem {
        modules = [
          (resolve "nixos" [ ] {
            inherit name;
            includes = host.aspects ++ [
              (forward-include "__aspects")
            ];
          })
        ]
        ++ (map (
          user:
          resolve "nixos" [ ] {
            name = user.name;
            includes = [
              user
              (forward-include "__users")
              (forward {
                each = [ { } ];
                fromClass = _: "user";
                intoClass = _: "nixos";
                intoPath = _: [
                  "users"
                  "users"
                  user.name
                ];
                fromAspect = _: user;
              })
            ]
            ++ [ ];
          }
        ) host.users);
      }
    ) self.hosts;
  };
}
