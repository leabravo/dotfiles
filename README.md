# Dotfiles & openSUSE Tumbleweed Setup Guide

> [!TIP]
> **Goal:** Deploy a lean, stable, and visually unified **Hyprland** desktop on a fresh **openSUSE Tumbleweed** netinstall, styled with **Catppuccin Mocha** across Kitty, Waybar, GTK, and Qt applications.

---

## 📚 Deep Dive Architecture Guides

To make Linux ricing approachable, every design decision, toolkit quirk, and architectural concept is thoroughly documented in dedicated guides:

| Guide | What You Will Learn |
| :--- | :--- |
| ⚡ [**TL;DR: Plain English Summary**](docs/tldr.md) | High-density cheat sheet explaining the core principles and gotchas without fluff or charts. |
| 🎨 [**Theming & Visual Consistency**](docs/theming-and-visual-consistency.md) | How GTK 3/4 (libadwaita), Qt5/6 (Kvantum), and XWayland (`xsettingsd`) synchronize without a desktop daemon, plus how to cure cursor size jumping. |
| 🔤 [**Fonts, Glyphs & Emojis**](docs/fonts-and-glyphs.md) | Why status bar icons show as broken tofu (`▯`), how Fontconfig fallback works, and how to enable full-color emojis. |
| 🪟 [**Wayland, Portals & Polkit**](docs/wayland-and-portals.md) | How to prevent the 30-second file picker freeze, enable graphical root authentication dialogs, and configure native Wayland environment variables. |
| 🔊 [**Modern Audio & Hardware**](docs/modern-audio-and-hardware.md) | Modern PipeWire volume control with WirePlumber (`wpctl`), logarithmic brightness curves, and critical hardware security permissions. |
| 🦎 [**openSUSE System Guide**](docs/opensuse-system-guide.md) | Preventing Zypper recommended bloat, enabling proprietary codecs (`opi codecs`), and Btrfs Snapper rollback recovery. |

---

## Quickstart Setup Checklist

```mermaid
flowchart LR
    A["1. Netinstall & Zypper Hygiene"] --> B["2. Install Packages & Codecs"]
    B --> C["3. Deploy Dotfiles (Stow)"]
    C --> D["4. Configure Services & Greeter"]
    D --> E["5. Reboot into Hyprland!"]
```

---

## 1. openSUSE Netinstall & Zypper Hygiene

During the openSUSE Tumbleweed Netinstall:
* Choose **"Minimal System (Text Mode)"** or **"Generic Desktop"** (avoid full desktop patterns like GNOME or Plasma that pull hundreds of default packages).

### Step 1.1: Lock Zypper to Hard Dependencies Only
By default, Zypper treats "recommended" packages as hard dependencies, pulling in bloat on minimal installations.

Edit `/etc/zypp/zypp.conf` and set:
```ini
solver.onlyRequires = true
```

### Step 1.2: Upgrade the Base System
On Tumbleweed, **always** use `dup` (distribution upgrade), never `up`:
```bash
sudo zypper ref
sudo zypper dup --no-recommends
```

### Step 1.3: Install Git to Clone Repository
On a fresh netinstall, Git is not installed by default. Install it first to clone this repository:
```bash
sudo zypper in --no-recommends git
mkdir -p ~/Projects
git clone https://github.com/bravotux/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
```

> [!NOTE]
> Read the [openSUSE System Guide](docs/opensuse-system-guide.md) for a deep dive into Zypper hygiene, `solver.onlyRequires`, and Snapper rollbacks.

---

## 2. Prerequisites & Package Installation

Install the compositor, audio pipeline, theming engines, fonts, and utilities in one go:

```bash
# 1. Base Utilities, Shell & System Info
sudo zypper in --no-recommends \
  git stow zsh curl tmux fastfetch xdg-user-dirs \
  polkit-gnome wl-clipboard cliphist \
  grub2-snapper-plugin snapper

# 2. Hyprland Desktop Environment & Apps
sudo zypper in --no-recommends \
  hyprland hyprpaper hyprlock hypridle \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  waybar kitty fuzzel mako pcmanfm-qt \
  grim slurp

# 3. Audio, Hardware Control & Power Management
sudo zypper in --no-recommends \
  pipewire pipewire-pulseaudio pipewire-alsa wireplumber playerctl \
  brightnessctl power-profiles-daemon mpd mpc

# 4. Consistent Theming Engines (Qt + GTK)
sudo zypper in --no-recommends \
  qt6ct qt5ct \
  kvantum-manager kvantum-qt6 kvantum-qt5 \
  xsettingsd kora-icon-theme

# 5. Fonts (UI, Monospace, Glyphs & Emojis)
sudo zypper in --no-recommends \
  inter-fonts jetbrains-mono-fonts symbols-only-nerd-fonts \
  fontawesome-fonts google-noto-coloremoji-fonts

# 6. Minimal Greeter
sudo zypper in --no-recommends \
  greetd tuigreet

# 7. Proprietary Multimedia Codecs (Packman)
sudo zypper in --no-recommends opi
opi codecs
```

> [!NOTE]
> `opi codecs` configures the Packman repository so web browsers and music players can decode H.264, AAC, and MP4 media.

---

## 3. Bootstrapping Sequence & GNU Stow

Deploy your configurations before enabling the display manager so that Hyprland boots directly into your styled desktop.

### Step 3.1: Clone Dotfiles
```bash
mkdir -p ~/Projects
git clone <repo-url> ~/Projects/dotfiles
cd ~/Projects/dotfiles
```

### Step 3.2: Install Oh My Zsh (and prevent Stow conflicts)
Because [`dot-zshrc`](dot-zshrc) sources `$HOME/.oh-my-zsh`, install it first:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# IMPORTANT: Oh My Zsh generates a default ~/.zshrc which causes GNU Stow to abort.
# Remove it so Stow can symlink your tracked dot-zshrc:
rm -f ~/.zshrc
```

### Step 3.3: Symlink Configurations with Stow
```bash
cd ~/Projects/dotfiles

# Deploy all dotfiles into $HOME
stow --dotfiles --target="$HOME" .
```

> [!TIP]
> The [`.stow-local-ignore`](.stow-local-ignore) file automatically prevents `README.md`, `docs/`, and `.git/` from being linked into `$HOME`.

### Step 3.4: Set Default Login Shell to Zsh
```bash
chsh -s $(which zsh)
```

---

## 4. Developer Utilities (mise & tmux)

Keep the root package manager clean of runtime bloat by using **`mise`** in user-space:

```bash
# 1. Install mise
curl https://mise.run | sh

# 2. Install developer CLI tools through mise
~/.local/bin/mise use -g neovim ripgrep fzf fd lazygit eza bat
```

When you open Zsh, [`dot-zshrc`](dot-zshrc) automatically activates `mise`:
```bash
eval "$($HOME/.local/bin/mise activate zsh)"
```

---

## 5. Hardware, Audio & Daemons Setup

### Modern Audio (`wpctl` / WirePlumber)
Enable and start the user audio services:
```bash
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
```
- Hyprland multimedia keybindings are pre-wired to `wpctl` in [`hyprland.lua`](dot-config/hypr/hyprland.lua).
- See the [Modern Audio & Hardware Guide](docs/modern-audio-and-hardware.md) for details on volume ceilings and WirePlumber endpoint management.

### Brightness Permissions (`brightnessctl`)
Grant your user permission to control backlight devices without `sudo`:
```bash
sudo usermod -aG video $USER
```
> [!CAUTION]
> **Never add your user to the `input` group.** Membership in `input` allows unprivileged processes to log keystrokes globally. The `video` group alone handles backlight control safely.

### Power Profiles & User Directories
```bash
sudo systemctl enable --now power-profiles-daemon
xdg-user-dirs-update
```

---

## 6. Minimal Greeter (`greetd` + `tuigreet`)

`tuigreet` provides a clean, distraction-free console login that launches your Wayland Hyprland session directly.

### Step 6.1: Set Greeter Permissions & Cache
```bash
sudo mkdir -p /var/cache/tuigreet
sudo chown greeter:greeter /var/cache/tuigreet
sudo chmod 0755 /var/cache/tuigreet
sudo usermod -aG video greeter
```

### Step 6.2: Configure `/etc/greetd/config.toml`
Configure `tuigreet` with Catppuccin Mocha colors and clean padding:

```toml
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --remember-session --asterisks --greeting 'Welcome to openSUSE' --theme 'border=magenta;text=white;prompt=pink;time=blue;action=blue;button=magenta;container=black;input=white' --window-padding 2 --container-padding 2 --prompt-padding 1 --sessions /usr/share/wayland-sessions --cmd Hyprland"
user = "greeter"
```

> [!TIP]
> **Matching the Greeter Font Size (TTY Console):**  
> Because `tuigreet` is a pure TUI running in the Linux Virtual Terminal, its font face and size are governed by `/etc/vconsole.conf`. To give the greeter a crisp, perfectly proportioned bitmap font (avoiding tiny or blurry default console text on HiDPI screens):
> ```bash
> sudo zypper in --no-recommends terminus-bitmap-fonts
> sudo sed -i 's/^FONT=.*/FONT="ter-v18n"/' /etc/vconsole.conf
> ```

### Step 6.3: Enable the Display Manager
```bash
sudo systemctl set-default graphical.target
sudo systemctl enable greetd
```

---

## 7. Visual Consistency & Theme Assets

To achieve full Catppuccin Mocha consistency across GTK, Qt, and XWayland:

### Step 7.1: Download Themes & Icons
```bash
# Catppuccin GTK Theme (Unpack into ~/.themes)
mkdir -p ~/.themes
curl -LO "https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-pink-standard+default.zip"
unzip catppuccin-mocha-pink-standard+default.zip -d ~/.themes/
rm catppuccin-mocha-pink-standard+default.zip
```

> [!NOTE]
> `kora-icon-theme` is installed directly via Zypper in Step 2, so no manual icon extraction is required.

### Step 7.2: Rebuild Font Cache
```bash
fc-cache -fv
```

> [!NOTE]
> Review the [Theming & Visual Consistency Guide](docs/theming-and-visual-consistency.md) and [Fonts, Glyphs & Emojis Guide](docs/fonts-and-glyphs.md) for full explanations of Kvantum, `xsettingsd`, and font fallback hierarchies.

---

## 8. openSUSE Safety Net: Snapper Rollbacks

If a system update ever causes an issue with your display server or GPU driver:
1. Reboot the PC.
2. In the GRUB boot menu, select **"Start read-only snapshot"** and pick the snapshot taken prior to the update.
3. Once booted into the desktop, restore the system state with:
   ```bash
   sudo snapper rollback
   sudo reboot
   ```
Detailed instructions are in the [openSUSE System Guide](docs/opensuse-system-guide.md).

---

## 9. Repository Structure

| Component | Path | Purpose |
| :--- | :--- | :--- |
| **Compositor** | [`dot-config/hypr/hyprland.lua`](dot-config/hypr/hyprland.lua) | Window manager configuration in Lua (monitors, keybinds, rules, autostart) |
| **Status Bar** | [`dot-config/waybar/`](dot-config/waybar) | Status bar with WirePlumber, battery, backlight, power-profiles, and MPD modules |
| **Terminal** | [`dot-config/kitty/kitty.conf`](dot-config/kitty/kitty.conf) | GPU-accelerated Wayland terminal with Catppuccin Mocha Pink theme |
| **System Fetch** | [`dot-config/fastfetch/config.jsonc`](dot-config/fastfetch/config.jsonc) | Fast, modern system information fetcher styled with Catppuccin |
| **App Launcher** | [`dot-config/fuzzel/fuzzel.ini`](dot-config/fuzzel/fuzzel.ini) | Fast Wayland application launcher styled with Catppuccin Mocha Pink |
| **Notifications** | [`dot-config/mako/config`](dot-config/mako/config) | Lightweight Wayland notification daemon with Catppuccin borders |
| **Wallpaper** | [`dot-config/hypr/hyprpaper.conf`](dot-config/hypr/hyprpaper.conf) | Hyprpaper wallpaper daemon configuration |
| **Qt Theming** | [`dot-config/qt6ct/`](dot-config/qt6ct), [`dot-config/Kvantum/`](dot-config/Kvantum) | Qt6ct configuration & Catppuccin Mocha Pink Kvantum theme |
| **GTK Settings** | [`dot-config/xsettingsd/`](dot-config/xsettingsd), [`dot-config/nwg-look/`](dot-config/nwg-look) | XSETTINGS daemon & GTK consistency settings |
| **Music** | [`dot-config/mpd/`](dot-config/mpd), [`dot-config/rmpc/`](dot-config/rmpc) | Music Player Daemon and terminal MPD client |
| **Editor** | [`dot-config/nvim/`](dot-config/nvim) | Neovim configuration with Lua LSP and treesitter |
| **Shell** | [`dot-zshrc`](dot-zshrc) | Zsh configuration with Oh My Zsh and mise activation |
| **Multiplexer** | [`dot-config/tmux/tmux.conf`](dot-config/tmux/tmux.conf) | Modern tmux configuration with Catppuccin Mocha colors and OSC 52 clipboard |
| **Git TUI** | [`dot-config/lazygit/config.yml`](dot-config/lazygit/config.yml) | Terminal Git client styled with Catppuccin Mocha Pink |
| **Documentation** | [`docs/`](docs/) | Deep-dive educational architecture and troubleshooting guides |
