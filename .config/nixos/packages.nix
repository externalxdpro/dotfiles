{ pkgs, lib, ... }:

let
  # Core / CLI

  shell = with pkgs; [
    fish
    starship
    fzf
    eza
    ripgrep
    lolcat
    dwt1-shell-color-scripts
  ];

  cliTools = with pkgs; [
    git
    stow
    wget
    btop
    caligula
    jq
  ];

  archives = with pkgs; [
    zip
    unzip
    p7zip
    rar
  ];

  # Editors & writing

  editors = with pkgs; [
    vim
    neovim
    (emacs.pkgs.withPackages (
      epkgs: with epkgs; [
        mu4e
        libvterm
      ]
    ))
    emacs-lsp-booster
    libtool # needed to build vterm
  ];

  writing = with pkgs; [
    ispell
    (aspellWithDicts (d: with d; [ en ]))
    languagetool
    texliveFull
    libreoffice
  ];

  mail = with pkgs; [
    mu
    isync
  ];

  # Desktop: shared (any WM / session)

  desktopCommon = with pkgs; [
    alacritty
    rofi
    rofi-power-menu
    dunst
    libnotify
    nwg-look
    lxsession
    dex
    udiskie
    networkmanagerapplet
    syncthingtray
    kdePackages.breeze
    kdePackages.breeze-gtk
  ];

  fileManagement = with pkgs; [
    pcmanfm
    xarchiver
    cifs-utils
  ];

  secrets = with pkgs; [
    rbw
    rofi-rbw
    pinentry-rofi
  ];

  # Desktop: Wayland

  wayland = with pkgs; [
    waybar
    wlogout
    wlr-randr
    kanshi
    swaylock-effects
    hypridle
    awww
    wtype
    wl-clipboard-rs
    # screenshots
    grimblast
    grim
    slurp
  ];

  # Desktop: X11

  x11 = with pkgs; [
    xmobar
    arandr
    feh
    picom
    numlockx
    pasystray
    xdotool
    xclip
    maim
    # trayer
  ];

  # Media & audio

  audio = with pkgs; [
    pavucontrol
    pamixer
    playerctl
  ];

  media = with pkgs; [
    mpv
    pear-desktop
    lrcget
    moonlight-qt
    # jellyfin-media-player
  ];

  # mpd = with pkgs; [
  #   mpd
  #   mpdris2
  #   mpd-discord-rpc
  #   mpc
  #   rmpc
  #   cava
  # ];

  # Apps

  browsers = with pkgs; [
    brave
    qutebrowser
  ];

  apps = with pkgs; [
    vesktop
    gimp3
    gearlever
    # winboat
  ];

  # Hardware & system services

  hardware = with pkgs; [
    brightnessctl
    polychromatic
    system-config-printer
  ];

  networking = with pkgs; [
    dnsmasq
  ];

  # Development

  devNix = with pkgs; [
    nil
    nixfmt
  ];

  devCCpp = with pkgs; [
    clang-tools
    gcc
    gnumake
    cmake
    meson
    (writeShellScriptBin "codelldb" "exec ${vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb \"$@\"\n")
  ];

  devRust = with pkgs; [
    cargo
    rustc
    rust-analyzer
    rustfmt
  ];

  devPython = with pkgs; [
    (python3.withPackages (
      ps: with ps; [
        beautifulsoup4
        requests
      ]
    ))
    pyright
    black
  ];

  devWeb = with pkgs; [
    nodejs
    prettier
    typescript-language-server
    vscode-langservers-extracted
  ];

  devJava = with pkgs; [
    jdk25
    jetbrains.idea
    maven
  ];
in
{
  environment.systemPackages = lib.concatLists [
    shell
    cliTools
    archives

    editors
    writing
    mail

    desktopCommon
    fileManagement
    secrets
    wayland
    x11

    audio
    media
    browsers
    apps

    hardware
    networking

    devNix
    devCCpp
    devRust
    devPython
    devWeb
    devJava
  ];
}
