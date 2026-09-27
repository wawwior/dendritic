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

      extract-compats =
        identities: aspect:
        let
          compats = (extract-compat aspect).provides or [ ];
          needed = builtins.filter (compat: builtins.elem (identity compat.target) identities) compats;
          identities' = builtins.filter (id: id != { }) (map (needed: identity needed.aspect) needed);
        in
        lib.flatten (
          (map (needed: needed.aspect) needed)
          ++ map (needed: extract-compats (identities ++ identities') needed.aspect) needed
        );
    in
    {
      includes = lib.flatten (map (extract-compats identities) aspects);
    };
}
