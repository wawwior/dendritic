{
  self,
  lib,
  ...
}:
let

  inherit (lib) mkOption;
  inherit (lib.types) attrsOf listOf submodule;

  inherit (self.aspects) forward-include;

  inherit (self.lib.aspects) forward resolve;
  inherit (self.lib.aspects.types) providerType;
in
{

  flake.flakeModules.hosts = { self, lib, ... }: {

    options = {
      flake.hosts = mkOption {
        type = attrsOf (submodule {
          options = {
            aspects = mkOption {
              type = listOf (providerType { });
              default = [ ];
            };
            users = mkOption {
              type = listOf (providerType { });
              default = [ ];
            };
          };
        });
        default = { };
      };
    };

    config.flake.nixosConfigurations = builtins.mapAttrs (
      name: host:
      lib.nixosSystem {
        modules = [
          (resolve "nixos" [ ] {
            inherit name;
            includes = host.aspects ++ [ (forward-include "__aspects") ];
          })
          (resolve "nixos" [ ] {
            includes = host.users ++ [
              (forward-include "__users")
              (forward {
                each = host.users;
                fromClass = _: "user";
                intoClass = _: "nixos";
                intoPath = user: [
                  "users"
                  "users"
                  user.name
                ];
                fromAspect = user: user;
              })
            ];
          })
        ];
      }
    ) self.hosts;
  };
}
