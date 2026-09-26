{ self, lib, ... }: {
  flake.aspects.autocompat =
    { class, aspect-chain }:
    let

      identities = self.lib.collectAspects "identity" (builtins.head aspect-chain);

      aspects = self.lib.collectAspects "compat" (builtins.head aspect-chain);

      compats =
        (lib.evalModules {
          modules = aspects ++ [
            {
              options.provides = lib.mkOption {
                type = lib.types.listOf (
                  lib.types.submodule {
                    options = {
                      target = lib.mkOption {
                        type = lib.types.raw;
                      };
                      aspect = lib.mkOption {
                        type = lib.types.raw;
                      };
                    };
                  }
                );
                default = [ ];
              };
            }
          ];
        }).config.provides;

      needed = builtins.filter (compat: builtins.elem compat.target.identity identities) compats;

    in
    {
      includes = map (needed: needed.aspect) needed;
    };
}
