{ self, ... }: {
  flake.aspects.forward-include =
    from:
    { class, aspect-chain }:
    self.lib.aspects.forward {
      each = [ (builtins.head aspect-chain) ];
      fromClass = _: from;
      intoClass = _: "nixos";
      intoPath = _: [ ];
      fromAspect = _: _;
    };
}
