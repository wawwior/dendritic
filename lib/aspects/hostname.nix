{ ... }:
let
  inherit (builtins) head;
in
{
  # i dont know why this fails without wrapping it like this
  includes = [
    ({ class, aspect-chain }: {
      nixos = {
        networking.hostName = (head aspect-chain).name;
      };
    })
  ];
}
