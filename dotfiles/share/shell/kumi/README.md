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

Requirements: Linux + Wayland (Sway), Rust stable, `pkg-config`, Wayland/font/
audio headers (Arch: `wayland libxkbcommon fontconfig alsa-lib`; Debian:
`libwayland-dev libxkbcommon-dev libfontconfig1-dev libasound2-dev`), `libpam`
(Arch `pam`, Debian `libpam0g-dev`) for the lockscreen, PipeWire/ALSA,
`playerctl` (MPRIS pill), `JetBrainsMono Nerd Font` (icons).

There are no pre-built binaries: the shell is always compiled from this source.

License: MIT or Apache-2.0, see `LICENSE-MIT` and `LICENSE-APACHE`.

## What's inside

| File | Window / feature |
|---|---|
| `bar.rs` | Top bar (time only) + MPRIS media pill + RAM/volume/battery cluster |
| `launcher.rs` | Fullscreen app launcher with glide scrolling |
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
playerctl -p kumizo play     # drive one directly
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
