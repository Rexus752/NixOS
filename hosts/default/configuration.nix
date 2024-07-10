{ config, lib, pkgs, inputs, ... }:
	
{

	environment.systemPackages = with pkgs; [
		gnomeExtensions.clipboard-history
		gnomeExtensions.dash-to-panel
		kdePackages.kolourpaint
		discord
		firefox
		gnome-tweaks
		libreoffice-qt6-still
		obsidian
		prismlauncher
		spotify
		telegram-desktop
		variety
		whatsapp-for-linux
		yt-dlp
		# Git & GitHub
			gh
			git
			git-credential-manager
		# Wine
			wineWowPackages.stable
			winetricks
		# Compressed Archives
			rar
			zip
			unzip
	];

	nixpkgs.config.allowUnfree = true;	
	environment.gnome.excludePackages = (with pkgs; [
		gnome-tour
		gnome-connections
		totem
		epiphany
		geary
	]);
	
	imports = [
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.default
	];

	boot.loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
		grub = {
			device = "nodev";
			efiSupport = "true";
			useOSProber = "true";
		};
	};

	services = {
		xserver = {
			enable = true;
			displayManager.gdm.enable = true;
			desktopManager.gnome.enable = true;
			xkb.layout = "it";
			excludePackages = [pkgs.xterm];
		};
		printing.enable = true;
		libinput.enable = true;
		openssh.enable = true;
	};

	networking = {
		hostName = "manuel";
		networkmanager.enable = true;
	};

	time.timeZone = "Europe/Rome";
	hardware.pulseaudio.enable = true;

	users.users.manuel = {
		 isNormalUser = true;
		 home = "/home/manuel";
		 initialPassword = "PASSWORD";
		 extraGroups = ["wheel" "networkmanager"];
	};

	nix.settings.experimental-features = ["nix-command" "flakes"];
	home-manager = {
		extraSpecialArgs = {inherit inputs;};
		users = {
			"manuel" = import ./home.nix;
		};
	};

	# This option defines the first version of NixOS you have installed on this particular machine,
	# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
	#
	# Most users should NEVER change this value after the initial install, for any reason,
	# even if you've upgraded your system to a new NixOS release.
	#
	# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
	# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
	# to actually do that.
	#
	# This value being lower than the current NixOS release does NOT mean your system is
	# out of date, out of support, or vulnerable.
	#
	# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
	# and migrated your data accordingly.
	#
	# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "24.05"; # Did you read the comment?
}

