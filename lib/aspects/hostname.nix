{ ... }:
let
  inherit (builtins) head;
in
{ class, aspect-chain }: {
  name = "hostname";
  nixos = {
    networking.hostName = (head aspect-chain).name;
  };
}
