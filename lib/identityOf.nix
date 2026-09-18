{ ... }:
let
  resolveProviderFn =
    aspect:
    if aspect ? __functor then
      (aspect {
        # can be anything
        class = "identity";
        aspect-chain = [ ];
      })
    else
      { };
in
# in case its a parametric aspect, we just do it twice
aspect: (resolveProviderFn (resolveProviderFn aspect)).identity or { }
