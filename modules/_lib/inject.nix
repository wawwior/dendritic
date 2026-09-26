{ self, ... }:
{
  inject =
    g: f:
    if builtins.isFunction f then
      (x: self.inject g (f x))
    else if f ? __functor && f ? __functionArgs then
      f
      // {
        __functor = self.inject g f.__functor;
      }
    else
      g f;
}
