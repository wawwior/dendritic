{
  flake.aspects.hostname = { class, aspect-chain }: {
    name = "hostname";
    nixos = {
      networking.hostName = (builtins.head aspect-chain).name;
    };
  };
}
