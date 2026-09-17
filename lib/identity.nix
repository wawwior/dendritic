{ inputs, ... }:
{ self, lib, ... }:
let
  flake-ref = self.outPath;

  aspects-lib = inputs.flake-aspects.lib lib;

  inherit (lib) mkOption;

  inherit (aspects-lib.types) aspectsType;
in
{
  options = {
    flake.aspects = mkOption {
      type = (
        aspectsType {
          defaultFunctor =
            self:
            { class, aspect-chain }:
            self
            // {
              identity =
                let
                  flake = flake-ref;
                  name = self.name;
                  description = self.description;
                in
                {
                  inherit flake name description;
                  hash = builtins.hashString "sha512" (builtins.toJSON { inherit flake name description; });
                };
            };
        }
      );
    };
  };
}
