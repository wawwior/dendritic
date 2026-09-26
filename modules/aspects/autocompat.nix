{ self, lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) listOf submodule raw;
  inherit (self.lib.aspects) collect identity extract;
in
{
  flake.aspects.autocompat =
    { class, aspect-chain }:
    let

      aspects = collect (builtins.head aspect-chain);

      identities = builtins.filter (id: id != { }) (map identity aspects);

      extract-compat = extract {
        class = "compat";
        options.provides = mkOption {
          type = listOf (submodule {
            options = {
              target = mkOption {
                type = raw;
              };
              aspect = mkOption {
                type = raw;
              };
            };
          });
          default = [ ];
        };
      };

      compats = lib.concatMap (compat: compat.provides or [ ]) (map extract-compat aspects);

      needed = (builtins.filter (compat: builtins.elem (identity compat.target) identities) compats);

    in
    {
      includes = map (needed: needed.aspect) needed;
    };
}
