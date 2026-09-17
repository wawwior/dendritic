{
  inputs,
  ...
}:
{
  self,
  lib,
  ...
}:
let
  aspects-lib = inputs.flake-aspects.lib lib;

  inherit (builtins) head mapAttrs;

  inherit (lib) mkOption;
  inherit (lib.types) attrsOf listOf submodule;

  inherit (aspects-lib) forward resolve;
  inherit (aspects-lib.types) aspectSubmodule;

  forward-include =
    from:
    { class, aspect-chain }:
    aspects-lib.forward {
      each = [ (head aspect-chain) ];
      fromClass = _: from;
      intoClass = _: "nixos";
      intoPath = _: [ ];
      fromAspect = _: _;
    };
in
{

  imports = [
    inputs.flake-aspects.flakeModule
  ];

  options.flake.hosts = mkOption {
    type = attrsOf (submodule {
      options = {
        aspects = mkOption {
          type = listOf (aspectSubmodule { });
          default = [ ];
        };
        users = mkOption {
          type = listOf (aspectSubmodule { });
          default = [ ];
        };
      };
    });
    default = { };
  };

  config.flake.nixosConfigurations = mapAttrs (
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

}
