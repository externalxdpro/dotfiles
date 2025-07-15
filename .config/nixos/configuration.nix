# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "ext-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver libvdpau-va-gl ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.steam-hardware.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.ly.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs;
      [
        #  thunderbird
      ];
  };

  programs.direnv.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.hyprland.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (inputs.zen-browser.packages."${system}".default.override {
      nativeMessagingHosts = [ pkgs.passff-host ];
    })
    vim
    (emacs.pkgs.withPackages (epkgs: with epkgs; [ mu4e libvterm ]))
    mu
    ispell
    libtool
    libnotify
    neovim
    git
    stow
    fish
    starship
    wget
    grimblast
    dwt1-shell-color-scripts
    lolcat
    waybar
    alacritty
    eza
    rofi
    ripgrep
    meson
    mu
    isync
    syncthing
    zip
    unzip
    nwg-look
    equibop
    btop
    lxde.lxsession
    dunst
    dex
    udiskie
    networkmanagerapplet
    wlogout
    swaylock-effects
    swayidle
    sway-audio-idle-inhibit
    swww
    pass
    tessen
    pcmanfm-qt
    pavucontrol
    pamixer
    playerctl
    brightnessctl
    youtube-music
    moonlight-qt
    jellyfin-media-player

    kdePackages.breeze
    kdePackages.breeze-gtk
    layan-kde
    layan-gtk-theme
    tela-icon-theme

    nil
    nixfmt

    clang-tools
    gcc
    gnumake
    cmake

    cargo
    rust-analyzer
    rustfmt
    rustc
  ];

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  fonts.packages = with pkgs; [ nerd-fonts.caskaydia-cove font-awesome ];

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

  services.udisks2.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
