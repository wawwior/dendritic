{ ... }:
let
  inherit (builtins) head;
in
{
  # FIXME: i do know now why this fails without wrapping it like this, will fix
  includes = [
    ({ class, aspect-chain }: {
      nixos = {
        networking.hostName = (head aspect-chain).name;
      };
    })
  ];
}
