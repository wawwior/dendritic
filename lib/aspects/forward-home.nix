{ inputs, lib, ... }:
let
  aspects-lib = inputs.flake-aspects.lib lib;

  inherit (builtins) head;

  inherit (lib) dropEnd last;

  inherit (aspects-lib) forward resolve;
in
{
  includes = [
    ({ class, aspect-chain }: {
      __aspects = {
        home-manager.sharedModules = [
          (resolve "home" [ ] (head aspect-chain))
        ];
      };
    })
    (
      { class, aspect-chain }:
      forward {
        each = [ (last (dropEnd 1 aspect-chain)) ];
        fromClass = _: "home";
        intoClass = _: "__users";
        intoPath = user: [
          "home-manager"
          "users"
          user.name
        ];
        fromAspect = _: _;
      }
    )
  ];
}
