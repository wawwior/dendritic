{
  flake.aspects.usergroup =
    { class, aspect-chain }:
    let
      name = (builtins.head aspect-chain).name;
    in
    {
      nixos = {
        users.groups.${name} = { };
      };
      user = {
        group = name;
      };
    };
}
