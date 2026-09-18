let
  inject =
    f: g:
    if builtins.isFunction f then
      (x: inject (f x) g)
    else if f ? __functor then
      g (
        f
        // {
          __functor = injectFunctor f.__functor g;
        }
      )
    else
      g f;

  injectFunctor =
    f: g:
    if builtins.isFunction f then
      (x: inject (f x) g)
    else if f ? __functor then
      f
      // {
        __functor = injectFunctor f.__functor g;
      }
    else
      f;
in
{
  flake.lib.inject = inject;
}
