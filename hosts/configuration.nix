{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./system
  ];
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };
  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };
  time.timeZone = "Europe/Oslo";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
  ];
  users.users = {
    intervbs = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["wheel" "networkmanager" "docker" "libvirtd" "video" "audio"];
    };
  };
  # Add dconf settings
  programs.dconf.enable = true;
  services = {
    printing.enable = true; # Enable CUPS to print documents.
    # Enable the X11 windowing system.
    xserver = {
      videoDrivers = ["amdgpu"];
    };
    blueman.enable = true;
    dbus.enable = true;
    dbus.packages = [pkgs.gnome.gnome-keyring pkgs.gcr];
    gnome.gnome-keyring = {
      enable = true;
    };
    openssh = {
      enable = true;
      # Forbid root login through SSH.
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
  sound.enable = true;
  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    keyboard.zsa.enable = true;
    bluetooth.enable = true;
    # Enable braodcom chip for bluetooth
    enableAllFirmware = true;
    pulseaudio.enable = false;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        sync.enable = true;
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
  # Enable virtualisation and docker support
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/opt/docker";
      };
    };
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
  ];
  system.stateVersion = "23.11";
}
