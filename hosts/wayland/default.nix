{ config, inputs, pkgs, ... }:

{
 imports = 
  (import ../../modules/virtualisation) 
  ++ [ ../../modules/desktop/hyprland ];

  users.users = {
    root.initialPassword = "password";
    wolly = {
      isNormalUser    = true;
      initialPassword = "password";

      extraGroups = [             # Enable ‘sudo’ for the user.
        "wheel" "networkmanager" 
        "docker" "video" 
        "audio" "camera" 
      ]; 

      packages = with pkgs; [
    	  xclip
        pipes
      ];
    };
  };

  # Bootloader
  boot = {
    cleanTmpDir = true;
    initrd.kernelModules = [ "amdgpu" ];

    loader = {
      systemd-boot = {
        enable      = true;
        consoleMode = "auto";
      };

      efi = {
        canTouchEfiVariables  = true;
        efiSysMountPoint      = "/boot";
      };

      timeout = 1;
    };
    consoleLogLevel = 0;
    initrd.verbose  = false;
  };

  # List packages installed in system profile. To search, run $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      grim
      mako
      swaybg
      pamixer

      waybar
      wlogout
      wayland
      wlsunset          # Day/night gamma adjustments for Wayland
      xwayland
      wlr-randr
      eww-wayland
      rofi-wayland
      wl-clipboard
      wayland-utils
      linux-firmware
      wayland-protocols
      inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    adb.enable = true;
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    gvfs.enable = true;
    dbus.packages = [ pkgs.gcr ];
    udev.packages = [ pkgs.android-udev-rules ];
  };

  console.useXkbConfig = true;
  security.sudo.enable = true;
}
