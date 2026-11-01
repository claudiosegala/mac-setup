# macOS setup

Install tools and apps, then configure your development environment:

```bash
git clone https://github.com/claudiosegala/mac-setup.git
cd mac-setup
bash setup-mac.sh
```

Run as your normal macOS user. Expect administrator authentication; some app installers may request it again.
Preview without changing your Mac: `bash setup-mac.sh --dry-run`.

## Customize

- `Brewfile`: apps and command-line tools. Comment out unwanted entries; declare third-party taps explicitly.
- `config/options.sh`: Git identity, Python version, optional Rust/GCC, and installation directories.
- `config/`: VS Code settings/extensions, Ghostty preferences, and the portable C++ starter.

Environment variables override options, for example:

```bash
GIT_NAME="Claudio" GIT_EMAIL="you@example.com" bash setup-mac.sh
```

## Results and reruns

Each item prints `INSTALLED`, `PRESENT`, `CONFIGURED`, `PRESERVED`, `SKIPPED`, `FAILED`, or `BLOCKED`.
Successful results are checked; installed apps still need manual launch and permission checks.
Raw command logs and `results.tsv` go to the printed `~/Library/Logs/mac-setup/run-*` directory.
Use `--verbose` to also print command logs. Clean progress output and maintained files stay within 120 columns.

Reruns preserve personal settings and existing Homebrew package versions. Dependencies may still be installed.
An existing Python or pi installation is verified; Python defaults are configured through uv.
Versions are not pinned. No uninstall or cleanup runs. Failures return a nonzero exit; fix the cause and rerun.
A lock prevents overlapping runs; after interruption, verify no setup is running before removing a stale lock.

## Individual tasks

Run a task directly, for example `bash scripts/python.sh`. It loads its own settings and logs results.
Missing prerequisites are reported; install them or run the full setup first.

## Finish and maintain

Follow the printed [finishing checklist](config/finish.txt) for sign-ins, permissions, and optional steps.
Existing VS Code/Ghostty files are preserved; back them up and copy templates manually to apply later changes.
The old `setup.sh` and `files/` templates have been replaced. Use the command above.
