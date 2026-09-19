{ self, lib, ... }: {
  flake.aspects.autocompat =
    { class, aspect-chain }:
    let

      inherit (self.aspects.autocompat { inherit class aspect-chain; }) identity;

      identities = self.lib.collectAspects "identity" (builtins.head aspect-chain);

      compats = builtins.concatMap (compat: compat.provides) (
        self.lib.collectAspects "compat" (builtins.head (aspect-chain ++ [ { } ]))
      );

      needed = builtins.filter (compat: builtins.elem compat.target.identity identities) compats;

    in
    {
      includes = map (needed: needed.aspect) needed;
    };
}
