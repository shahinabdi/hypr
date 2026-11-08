# Shahin's Hyprland Setup

Personal Arch Linux and Hyprland configuration for a Wayland desktop. It includes
Hyprland, Waybar, Rofi, Kitty, Thunar, a Quickshell sidebar, dark GTK settings,
wallpapers, and helper scripts.

## Install

Back up any configurations you want to keep. The installer copies this setup
into `~/.config`; if a destination file already exists with different contents,
it saves a timestamped backup before installing the new file.

On a fresh Arch Linux install, install Git and clone this repository:

```sh
sudo pacman -S --needed git
git clone https://github.com/shahinabdi/hypr.git
cd hypr
./scripts/install.sh
```

The installer installs the packages used by the configuration, deploys the
files into `~/.config`, downloads and installs GoMono Nerd Font into the user's
font directory, refreshes the font cache, and applies the dark GTK appearance.
It is intended for Arch Linux and must be run as a regular user with `sudo`
access.

Log out and back in after installation to start the full Hyprland session.
Open GTK applications may need to be restarted to pick up the dark theme.
The sidebar's Wi-Fi and Bluetooth controls also require the corresponding
NetworkManager and Bluetooth services to be enabled; the installer does not
change service state.

## Fonts

- **GoMono Nerd Font** is downloaded by the installer and used by Kitty.
- **JetBrainsMono Nerd Font** is installed from the Arch repositories for Rofi
  and Waybar.

## Handy scripts

- `~/.config/scripts/apply-dark-theme.sh` reapplies the dark GTK settings.
- `~/.config/scripts/install.sh` installs or updates the setup.
- `~/.config/scripts/install-yay-sugar-candy.sh` optionally installs the Sugar
  Candy SDDM theme; it is separate from the main installer.
