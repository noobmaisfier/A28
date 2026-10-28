# Shell source

`kumi/` is the A28 shell source. It is installed to
`~/.local/share/shell/kumi` and built by `build` into `~/.local/bin` as `kumi`
and `kumi-lockscreen`.

- `build` — compile the source and install the binaries.
- `update` — `build` plus build-stamp refresh, with the shell restarted
  too (`--no-restart` to skip).

`kumizo-kit` and the `kumizo` CLI are installed from crates.io, pinned to the
shell version. See the repository README for the customization workflow.

License: MIT or Apache-2.0, see `kumi/LICENSE-MIT` and `kumi/LICENSE-APACHE`.
