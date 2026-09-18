{ ... }:
let
  inherit (builtins) head;
in
{ class, aspect-chain }: {
  nixos = {
    networking.hostName = (head aspect-chain).name;
  };
}
