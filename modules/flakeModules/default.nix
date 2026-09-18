{ inputs, self, ... }: {

  flake.flakeModules.default = {
    imports = [
      self.flakeModules.minting
      self.flakeModules.hosts
      inputs.flake-aspects.flakeModule
    ];
  };

}
