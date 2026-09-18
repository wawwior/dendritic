{ self, lib, ... }:
{
  flake.aspects.forward-home = {
    includes = [
      ({ class, aspect-chain }: {
        __aspects = {
          home-manager.sharedModules = [
            (self.lib.aspects.resolve "home" [ ] (builtins.head aspect-chain))
          ];
        };
      })
      (
        { class, aspect-chain }:
        self.lib.aspects.forward {
          each = [ (lib.last (lib.dropEnd 1 aspect-chain)) ];
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
  };
}
