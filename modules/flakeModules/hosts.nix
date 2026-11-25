{
  self,
  lib,
  ...
}:
let

  inherit (lib) mkOption;
  inherit (lib.types) listOf raw;

  inherit (self.aspects) forward-include;

  inherit (self.lib.aspects)
    collect
    extract
    forward
    resolve
    ;
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
      let
        aspects = collect { includes = host.aspects; };
        users = collect { includes = host.users; };
        extract-cross-tree = extract {
          class = "cross-tree";
          options = {
            to-aspects = mkOption {
              type = listOf raw;
              default = [ ];
            };
            to-users = mkOption {
              type = listOf raw;
              default = [ ];
            };
          };
        };
        to-users = lib.flatten (map (aspect: (extract-cross-tree aspect).to-users or [ ]) aspects);
        to-aspects = lib.flatten (map (aspect: (extract-cross-tree aspect).to-aspects or [ ]) users);
      in
      lib.nixosSystem {
        modules = [
          (resolve "nixos" [ ] {
            inherit name;
            includes =
              host.aspects
              ++ [
                (forward-include "__aspects")
              ]
              ++ to-aspects;
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
            ++ to-users;
          }
        ) host.users);
      }
    ) self.hosts;
  };
}
