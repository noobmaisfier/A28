# Kumi

Kumi is the A28 Wayland shell, built on `kumizo-kit`: bar, launcher,
clipboard manager, notifications, control center, tasks, pomodoro, OSD and
lockscreen — one process, GPU-rendered.

This directory is the shell source installed by A28. Edit it freely; rebuild
with `~/.local/share/shell/build`.

## Build

```bash
cargo build --release
# binaries: target/release/kumi, target/release/kumi-lockscreen
```

Requirements: Linux + Wayland (Sway, Hyprland or Niri), Rust stable, and:

Arch Linux:

```bash
sudo pacman -S --needed base-devel
```

Debian / Ubuntu:

```bash
sudo apt update
sudo apt install -y build-essential pkg-config libwayland-dev \
  libfontconfig1-dev libpam0g-dev
```

Runtime: PipeWire (or PulseAudio), `playerctl`, and a Nerd Font
(`JetBrainsMono Nerd Font`).

A28's installer can use a prebuilt binary; from this source tree, build with
`~/.local/share/shell/build`.

License: MIT or Apache-2.0, see `LICENSE-MIT` and `LICENSE-APACHE`.

## What's inside

| File | Window / feature |
|---|---|
| `bar.rs` | Top bar: clock, MPRIS media pill, RAM/volume/battery cluster, tray |
| `launcher.rs` | Fullscreen app launcher with glide scrolling |
| `theme_picker.rs` | Fullscreen theme picker with live preview |
| `control.rs` | Control center (audio, bluetooth, network, brightness, DnD) |
| `clipboard.rs` | Clipboard history manager |
| `notifs.rs` / `toasts.rs` | Notification history + ephemeral toasts |
| `tasks.rs` | Window switcher |
| `power.rs` | Power menu |
| `pomodoro.rs` | Pomodoro timer |
| `osd.rs` | Volume/brightness OSD |
| `theme.rs` / `theme_ctl.rs` | 11 hardcoded themes, `kumizo service theme …` |
| `lockscreen.rs` | Lockscreen wiring (separate `kumi-lockscreen` binary) |

## Media (MPRIS)

The shell shows and drives media through **MPRIS** only — whatever player
answers on the session bus (browser, external player…). The bar's media pill
shows the title and offers previous / play-pause / next.

There is **no local music player inside the shell**: a local player is its own
program that publishes itself in MPRIS — the shell then displays it like any
other player.

```bash
playerctl -l                 # players on the bus
playerctl play               # drive the active player
kumizo service mpris next    # and through the shell
```

## Drive it without keys

```bash
kumizo ping
kumizo status
kumizo toggle kumi-launcher
kumizo service theme next
kumizo service theme set "Flexoki Light"
```

## Layout

```
src/main.rs       services + windows + run()
src/ui.rs         window ids (BAR = "kumi-bar", …) + shared UI helpers
src/bar.rs        top bar: clock, MPRIS pill, system cluster
src/theme.rs      11 palettes + `pal::` semantic tokens
```
