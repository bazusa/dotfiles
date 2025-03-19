{ pkgs, lib, inputs, ... }:
{
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}
