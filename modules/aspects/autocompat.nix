{ self, lib, ... }: {
  flake.aspects.autocompat =
    { class, aspect-chain }:
    let

      aspects = self.lib.collect (builtins.head aspect-chain);

      identities = map self.lib.identity aspects;

      extract-compat = self.lib.extract {
        class = "compat";
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
      };

      compats = lib.concatMap (compat: compat.provides) (map extract-compat aspects);

      needed = builtins.filter (compat: builtins.elem compat.target.identity identities) compats;

    in
    {
      includes = map (needed: needed.aspect) needed;
    };
}
