let
  inject =
    g: f:
    if builtins.isFunction f then
      (x: inject g (f x))
    else if f ? __functor && f ? __functionArgs then
      f
      // {
        __functor = inject g f.__functor;
      }
    # else if f ? __functor then
    #   g (
    #     f
    #     // {
    #       __functor = injectFunctor g f.__functor;
    #     }
    #   )
    else
      g f;

in
{
  flake.lib.inject = inject;
}
