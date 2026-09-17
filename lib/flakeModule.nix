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

  flake-ref = self.outPath;

  aspects-lib = inputs.flake-aspects.lib lib;

  inherit (builtins) head mapAttrs;

  inherit (lib) mkOption;
  inherit (lib.types) attrsOf listOf submodule;

  inherit (aspects-lib) forward resolve;
  inherit (aspects-lib.types) aspectSubmodule aspectsType;

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

  options = {
    flake.aspects = mkOption {
      type = (
        aspectsType {
          defaultFunctor =
            self:
            { class, aspect-chain }:
            self
            // {
              identity =
                let
                  flake = flake-ref;
                  name = self.name;
                  description = self.description;
                in
                {
                  inherit flake name description;
                  hash = builtins.hashString "sha512" (builtins.toJSON { inherit flake name description; });
                };
            };
        }
      );
    };
    flake.hosts = mkOption {
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
