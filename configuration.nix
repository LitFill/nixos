# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  # config,
  pkgs,
  options,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nix packman setting
  nix.settings = {
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "litfill"
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Graphics & Hardware Acceleration
  hardware.graphics = {
    enable = true;
  };

  # Display Manager & Desktop
  services.displayManager.sddm = {
    wayland.enable = true;
  };

  networking.hostName = "perihelion"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "id_ID.UTF-8";

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "id";
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
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."litfill" = {
    isNormalUser = true;
    description = "LitFill";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [
      #pkgs.kdePackages.kate
    ];

    # Install firefox.
    programs.firefox.enable = true;
    programs.kdeconnect.enable = true;

    # nix-ld
    programs.nix-ld = {
      enable = true;
      libraries =
        options.programs.nix-ld.libraries.default
        ++ (with pkgs; [
          fontconfig
          freetype
          glib
          libGL
          libX11
          libXcursor
          libXi
          libXrandr
          libglvnd
          libsecret
          libtinfo
          libxcb
          libxkbcommon
          stdenv.cc.cc.lib
          vulkan-loader
          wayland

          webkitgtk_4_1
        ]);
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      bat
      btop
      delta
      eza
      fd
      fzf
      git
      glib
      gnupg
      helix
      imv
      mpv
      pass
      ripgrep
      tailscale
      tmux
      vim
      wasmtime
      wezterm
      wget
      yazi
    ];

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Keyd config
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              # lettermod(<layer>, <key>, <idle timeout>, <hold timeout>)
              a = "lettermod(alt, a, 150, 200)";
              s = "lettermod(meta, s, 150, 200)";
              d = "lettermod(shift, d, 150, 200)";
              f = "lettermod(control, f, 150, 200)";

              j = "lettermod(control, j, 150, 200)";
              k = "lettermod(shift, k, 150, 200)";
              l = "lettermod(meta, l, 150, 200)";
              semicolon = "lettermod(alt, ;, 150, 200)";

              # Aktivasi Layer Prog
              # Menahan Caps Lock akan mengaktifkan layer [prog]
              capslock = "layer(prog)";
            };

            prog = {

              # Navigasi ala Vim
              h = "left";
              j = "down";
              k = "up";
              l = "right";

              # Simbol-simbol utama Prog
              n = "macro(->)";
              p = "macro(<-)";
              c = "macro(::)";
              g = "macro(=>)";
              ";" = "macro(:=)";
              t = "macro(|>)";
              f = "macro(<|)";

              # Simbol umum lainnya
              space = "_";
              d = "$";
              b = "\\";
              e = "=";
              v = "|";
              a = "&";
              q = "+";
              w = "*";

              # Pasangan kurung
              u = "(";
              i = ")";

              # Easy control
              "," = "backspace";
              "." = "delete";
            };
          };
        };
      };
    };

    # This value determines the NixOS release from which the default settings for
    # stateful data, like file locations and database versions on your system
    # were taken. It‘s perfectly fine and recommended to leave this value at the
    # release version of the first install of this system.  Before changing this
    # value read the documentation for this option (e.g. man configuration.nix or
    # on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?

  };
}
