# homebrew-tap

A personal Homebrew tap.

```bash
brew tap stan-ely/tap
```

| Name | What it is | Install |
| --- | --- | --- |
| `qrdrop` | Send a file straight from one device to another, end-to-end encrypted — the CLI | `brew install stan-ely/tap/qrdrop` |
| `qrdrop-app` | The same thing as a desktop app (cask) | `brew install --cask stan-ely/tap/qrdrop-app` |
| `whisperforge` | GPU-accelerated speech-to-text CLI | `brew install stan-ely/tap/whisperforge` |

**`qrdrop` and `qrdrop-app` are different things.** The first is the command-line
tool, a formula built from the npm registry tarball on top of `brew`'s node. The
second is the desktop application, a cask that installs `qrdrop.app`. They are named
apart on purpose: a formula and a cask sharing one token makes `brew install qrdrop`
warn and quietly resolve to the formula, which is a trap for anyone who meant the
other one. `--cask` is not optional for `qrdrop-app`.

## These files are generated

`Formula/qrdrop.rb` and `Casks/qrdrop-app.rb` are written by release workflows in
[stan-ely/qrdrop](https://github.com/stan-ely/qrdrop) — `.github/workflows/publish.yml`
and `.github/workflows/app-release.yml` respectively. **Hand edits here are overwritten
on the next release.** Change the generator in that repository instead.

## A note on qrdrop-app and code signing

The desktop app is not code-signed — there is no Apple Developer account behind the
project — so macOS will refuse to open it the first time and say it cannot check the
app for malicious software. `brew install --cask` also applies the quarantine
attribute. If you decide to trust it:

```bash
xattr -d com.apple.quarantine /Applications/qrdrop.app
```

That warning is accurate: nobody has vouched for this binary. The cask does print
these caveats on install, so this is not the only place you will meet them. The dmg
carries a build provenance attestation, which is a verifiable claim about where it
was built and is not a signature:

```bash
gh attestation verify <file> --repo stan-ely/qrdrop
```

The cask is **Apple silicon only**. One `.dmg` is built, on an arm64 runner, so it
refuses to install on Intel rather than leaving you a bundle that cannot launch.
