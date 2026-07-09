# Homebrew tap for Stelyph

```sh
brew trust spirallex/tap      # newer Homebrew requires trusting third-party taps first
brew install spirallex/tap/stelyph
```

If `brew` errors with *"Refusing to load formula … from untrusted tap"*, run the
`brew trust spirallex/tap` line above (or set `HOMEBREW_NO_REQUIRE_TAP_TRUST=1`).
It's Homebrew's third-party-tap safety check, not a problem with the formula.

Formulae here are published from https://github.com/Spirallex/rust-pds
