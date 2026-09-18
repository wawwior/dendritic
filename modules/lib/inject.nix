let
  inject =
    f: g:
    if builtins.isFunction f then
      (x: inject (f x) g)
    else if f ? __functor then
      g (
        f
        // {
          __functor = self: args: g (f.__functor self args);
        }
      )
    else
      (g f);
in
{
  flake.lib.inject = inject;
}
