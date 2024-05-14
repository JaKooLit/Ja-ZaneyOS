{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.amdgpu;
in
{
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD Drivers";
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module 
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];
    # OpenGL
    hardware.opengl = {
      ## amdvlk: an open-source Vulkan driver from AMD
      extraPackages = [ pkgs.amdvlk ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };
  };
}
