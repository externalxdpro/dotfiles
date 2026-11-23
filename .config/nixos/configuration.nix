# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    ./packages.nix
    inputs.mangowm.nixosModules.mango
  ];

  swapDevices = [
    {
      device = "/var/lib/swap";
      size = 16 * 1024;
    }
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "resume_offset=27424768" ];

  boot.resumeDevice = "/dev/disk/by-uuid/4e1a9acb-ddd5-4187-a27f-01a3fa73dbb9";

  networking.hostName = "ext-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [ networkmanager-openvpn ];
  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.openrazer.enable = true;

  hardware.steam-hardware.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable power management
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # Fix waking immediately after suspend
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    extraConfig = ''
      Section "InputClass"
          Identifier "Keyboard"
          Option "AutoRepeat" "250 13"
      EndSection

      Section "InputClass"
          Identifier "Mouse"
          Option "AccelProfile" "flat"
      EndSection
    '';
    exportConfiguration = true;
    videoDrivers = [
      "modesetting"
      "nvidia"
    ];
    windowManager = {
      qtile = {
        enable = true;
        # backend = "wayland";
        extraPackages =
          py3Pkgs: with py3Pkgs; [
            qtile-extras
          ];
      };
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.ly.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:escape_shifted_capslock";
  };

  # Enable CUPS to print documents and avahi for autodiscovery of printers
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      canon-cups-ufr2
      gutenprintBin
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sakib = {
    isNormalUser = true;
    description = "sakib";
    extraGroups = [
      "libvirtd"
      "networkmanager"
      "openrazer"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          mpv
          libepoxy
        ];
    };
  };

  programs.direnv.enable = true;

  programs.dms-shell = {
    enable = true;
    systemd.enable = false;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.hyprland.enable = true;
  programs.mango.enable = true;
  programs.river-classic.enable = true;

  programs.kdeconnect.enable = true;

  programs.virt-manager.enable = true;

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "qutebrowser-3.7.0"
  ];

  # Overrides
  nixpkgs.overlays = [
    (self: super: {
      mpv = super.mpv.override {
        scripts = [ self.mpvScripts.mpris ];
      };
    })
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    font-awesome
    mononoki
    ubuntu-classic
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing
    user = "sakib";
    group = "users";
    configDir = "/home/sakib/.config/syncthing";
  };

  # Mount, trash, and other functionalities
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation = {
    containers.enable = true;
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "dmenu";
        chooser_cmd = "${pkgs.rofi}/bin/rofi -dmenu";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
