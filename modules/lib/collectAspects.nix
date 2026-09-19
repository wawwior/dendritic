{ lib, ... }:
let

  bind =
    aspect:
    if builtins.isFunction aspect || (aspect ? __functor && aspect ? __functionArgs) then
      aspect {
        class = null;
        aspect-chain = [ ];
      }
    else
      aspect;

  collectAspects =
    class: aspect:
    lib.flatten (
      [ (bind aspect).${class} or [ ] ] ++ (map (collectAspects class) ((bind aspect).includes or [ ]))
    );
in
{
  flake.lib.collectAspects = collectAspects;
}
