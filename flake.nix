{
  description = "composable stuff";

  inputs = {
    flake-aspects.url = "github:denful/flake-aspects";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      outputs@{ ... }:
      {
        flake = {
          flakeModule = import ./lib/flakeModule.nix outputs;
          aspects = {
            forward-home = import ./lib/aspects/forward-home.nix outputs;
          };
        };

      }
    );
}
