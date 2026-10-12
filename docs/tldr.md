# TL;DR: The Plain English Guide

> [!TIP]
> **What this is:** A quick, plain-English summary of how this setup works, why decisions were made, and how to avoid the most common Linux desktop headaches. No fluff, no complicated charts.

---

## 1. openSUSE Tumbleweed Hygiene

* **Stop Zypper from pulling bloat:** openSUSE installs "recommended" packages by default. A single desktop tool can drag in hundreds of unwanted packages (like games and print daemons).
  * **Fix:** Add `solver.onlyRequires = true` to `/etc/zypp/zypp.conf`.
* **Always use `zypper dup`, never `zypper up`:** Tumbleweed is a rolling release. `zypper up` skips package removals and vendor changes, leading to broken dependencies. `zypper dup` keeps everything in sync.
* **Fix broken web videos:** openSUSE cannot ship patented codecs (H.264, AAC, MP4). Run `opi codecs` once to switch to the community Packman repository so YouTube, Twitch, and Spotify work.
* **The safety net (Snapper):** If an update ever breaks your desktop, reboot, choose an earlier snapshot in the GRUB menu, boot in, and run:
  ```bash
  sudo snapper rollback && sudo reboot
  ```

---

## 2. Visual Consistency (GTK vs. Qt vs. XWayland)

Desktop environments like GNOME or KDE have background programs that force apps to look the same. Hyprland is just a window manager, so applications start with their default styles unless we configure them:

* **GTK 3:** Reads settings from `~/.config/gtk-3.0/settings.ini` (configured via `nwg-look`).
* **GTK 4 (libadwaita):** GNOME specifically designed libadwaita to ignore user themes. To style it, we link our Catppuccin stylesheet directly into `~/.config/gtk-4.0/gtk.css`.
* **Qt 5 & Qt 6:** Qt does not understand GTK CSS. We use `qt6ct` to bridge settings and **Kvantum** to draw vector Catppuccin widgets.
* **XWayland (Steam, Discord, Spotify):** Older X11 apps cannot talk to Wayland. We run `xsettingsd` in the background to broadcast theme names, icons, and smooth font antialiasing.

---

## 3. Why the Mouse Cursor Jumps in Size

In Wayland, the desktop does not draw your cursor over windows; **each app draws its own cursor**.

If Hyprland thinks the cursor is 24px, but your browser thinks it's 16px and Steam thinks it's 48px, the cursor will visibly jump in size or change style as you move the mouse.

* **Fix:** Set cursor size to `24` in all five places:
  1. `hyprland.lua` (`XCURSOR_SIZE` and `HYPRCURSOR_SIZE`)
  2. GTK (`gtk-cursor-theme-size = 24` in `settings.ini`)
  3. `xsettingsd.conf` (`Gtk/CursorThemeSize 24`)
  4. `.Xresources` (`Xcursor.size: 24`)
  5. `qt6ct.conf` (cursor size 24)

---

## 4. Fonts, Broken Icons ("Tofu") & Emojis

* **Why icons break into empty boxes (`▯`):** Icons in Waybar and terminal prompts are not images—they are special Unicode characters. Standard coding fonts have letters and numbers, but zero icons.
* **The four fonts you need:**
  1. `jetbrains-mono-fonts`: For regular text and code.
  2. `symbols-only-nerd-fonts`: For terminal and status bar icons.
  3. `fontawesome-fonts`: For Waybar media, volume, and battery icons.
  4. `google-noto-coloremoji-fonts`: Guarantees color emojis instead of flat black-and-white outlines.
* **Consistent TUI & Desktop Sizing:** All terminal and launcher apps are aligned to JetBrains Mono `10pt` (`kitty.conf` 10.0, `fuzzel.ini` 10, `mako/config` 10) so fonts look cohesive across your terminal, runner, and notifications.
* **Always refresh the cache after installing:** `fc-cache -fv`.

---

## 5. Wayland Portals & The 30-Second Freeze

* **Why apps freeze for 30 seconds:** When an app opens a file picker under Wayland, it asks the system portal service via D-Bus. If no file picker backend is available, the request hangs until D-Bus times out (which takes 25 to 30 seconds).
  * **Fix:** Install both `xdg-desktop-portal-hyprland` (handles screen capture) and `xdg-desktop-portal-gtk` (handles file pickers).
* **Why root prompts silently fail:** Hyprland has no built-in password prompt window. If you try to mount an external hard drive in a file manager without a Polkit agent, the request silently dies.
  * **Fix:** Autostart `/usr/libexec/polkit-gnome-authentication-agent-1` in `hyprland.lua`.

---

## 6. Audio & Hardware Security

* **Use `wpctl`, not `amixer` or `pactl`:** Modern Linux audio runs on PipeWire managed by WirePlumber. The native tool is `wpctl`.
  * Volume up with a safety ceiling: `wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+` (the `-l 1` stops volume at 100% so speakers don't distort).
  * Toggle mute: `wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle`.
* **Smooth brightness:** `brightnessctl -e4 -n2 set 5%+` scales backlight logarithmically (matching how human eyes see light) and keeps a minimum floor so the screen never goes completely pitch black.
* **Security warning:** Grant backlight permissions using `sudo usermod -aG video $USER`. **Never add your user to the `input` group.** Being in `input` gives unprivileged apps raw access to `/dev/input/event*`, allowing any rogue program to log every keystroke and password you type.

---

## 7. GNU Stow & Dotfile Deployment

* **Why Stow aborts on Oh My Zsh:** The Oh My Zsh installer creates a default `~/.zshrc`. Stow refuses to overwrite existing files. Delete `~/.zshrc` right before running `stow --dotfiles --target="$HOME" .`.
* **Keep your root clean with `mise`:** Instead of installing developer tools (Neovim, ripgrep, fzf, lazygit) via root `zypper`, install them in your user home directory with `mise use -g neovim ripgrep fzf lazygit`.
