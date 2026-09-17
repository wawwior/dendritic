{
  description = "composable stuff";

  inputs = {
    flake-aspects.url = "github:denful/flake-aspects";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      args@{ ... }:
      {
        flake = {
          flakeModule = import ./lib/flakeModule.nix args;
          aspects = {
            forward-home = import ./lib/aspects/forward-home.nix args;
            hostname = import ./lib/aspects/hostname.nix args;
          };
          lib = {
            identityOf = import ./lib/identityOf.nix args;
          };
        };

      }
    );
}
