{ ... }:
aspect:
if aspect ? __functor then
  (aspect {
    class = "identity";
    aspect-chain = [ ];
  }).identity or { }
else
  { }
