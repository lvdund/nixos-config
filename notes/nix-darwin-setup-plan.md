# Plan: Set up Nix Package Manager on MacBook (Darwin)

> Goal: Install Nix on a MacBook, add `nix-darwin` + Home Manager, and integrate
> the machine as a new host (`macvd`) in the existing `nixos-config` flake.

- **Target machine**: MacBook (Apple Silicon → `aarch64-darwin`, Intel → `x86_64-darwin`)
  — check with `uname -m` (`arm64` → `aarch64-darwin`)
- **Repo**: `nixos-config` (currently `x86_64-linux` only, hosts: `homepc`, `mylaptop`,
  nixpkgs `nixos-26.05`, Home Manager `release-26.05`)
- **Facts below verified against upstream docs** (nix-darwin README + options manual,
  Home Manager manual, Determinate installer README) — see *Sources* at the bottom.

> **Status (2026-09-04)** — repo-side implementation **done** on the NixOS machine
> (no macOS commands run):
> - `flake.nix`: added `nixpkgs-darwin` + `nix-darwin` inputs, `darwinConfigurations.macvd`
> - `darwin/macvd/configuration.nix`: created (optional extras included as comments)
> - `users/lvdund/macvd.nix`: created (reuses the `nvim`/`fish`/`direnv`/`browser`/`git`
>   modules, links the kitty config)
> - Added browser + code: Firefox via shared `browser.nix` (configPath pinned to
>   the XDG path on Linux only — darwin uses HM 26.05 defaults), VS Code via
>   `programs.vscode` (HM, darwin-native), and the
>   dev toolchain mirrored from `nixos/modules/code.nix` (without `vscode.fhs`,
>   which is Linux-only)
> - Git moved to Home Manager: new shared `users/modules/git.nix`
>   (`programs.git` + identity settings), imported by `macvd.nix`,
>   `homepc.nix` and `mylaptop.nix`; removed from darwin system packages
> - Symlinked config paths parameterized: modules take a `repoRoot` argument
>   (default `/etc/nixos/nixos-config`), each host passes its own via
>   `home-manager.extraSpecialArgs.repoRoot` in `flake.nix`
>   (`/Users/lvdund/nixos-config` on the Mac)
>
> Remaining (on the Mac): Phase 0 & 1 (prereqs + installer), clone repo to
> `~/nixos-config`, run `nix flake lock` to add the new inputs to `flake.lock`,
> then Phase 5 bootstrap. Phase 6 optional items live as comments in the config.

---

## Phase 0 — Prerequisites & Preparation

- [ ] Check macOS version is up to date (System Settings → Software Update)
- [ ] Install Xcode Command Line Tools:
  ```sh
  xcode-select --install
  ```
- [ ] Pick installer (all support multi-user/daemon mode + flakes on macOS):
  | Installer | Notes |
  | --- | --- |
  | **Determinate Nix Installer** (default choice below) | Installs *Determinate Nix* by default (flakes pre-enabled), one-line uninstall, survives macOS upgrades, has a GUI macOS `.pkg` |
  | Lix installer | What the nix-darwin docs themselves recommend (Cao Nix fork, uninstaller included) |
  | Official `nixos.org` installer | Works, but **no automated uninstaller on macOS** — manual removal is painful; avoid |
- [ ] Back up existing dotfiles on the Mac (`~/.config`, `~/.zshrc`, `~/.zprofile`, etc.)
- [ ] Pick a hostname now (e.g. `macvd`) — it becomes the flake attr
  (`darwinConfigurations.macvd`, and is set explicitly via `networking.hostName`);
  macOS default hostname has spaces/uppercase, which is why we use an explicit
  `#macvd` attr
- [ ] If the Mac is managed (MDM/corporate), ensure Terminal has Full Disk Access

**Outcome**: Mac is ready to accept the Nix installer.

---

## Phase 1 — Install Nix (Determinate installer)

- [ ] Install (Determinate Nix, flakes enabled out of the box):
  ```sh
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install
  ```
  (or grab the GUI macOS package from Determinate Systems, which uses the same
  installer behind the scenes)
- [ ] Restart the terminal, then verify:
  ```sh
  nix --version
  nix run nixpkgs#hello            # smoke test
  nix flake show github:NixOS/nixpkgs#nixpkgs-unstable --quiet 2>/dev/null | head  # flakes OK
  ```
- [ ] Day-2 commands to remember:
  ```sh
  sudo determinate-nixd upgrade    # upgrade Determinate Nix itself
  /nix/nix-installer uninstall     # clean uninstall of Nix
  ```

> **Note — who owns Nix after `darwin-rebuild`?**
> Modern nix-darwin *manages the Nix installation itself* (option `nix.enable`,
> default package `pkgs.nix` = upstream Nix). After your first
> `darwin-rebuild switch`, nix-darwin takes over the nix-daemon + `/etc/nix/nix.conf`.
> If you prefer to keep installer-managed Determinate Nix (upgraded via
> `determinate-nixd`), set `nix.enable = false;` in your darwin config — but then
> nix-darwin's `nix.*` settings options and self-upgrades are unavailable.

**Outcome**: working multi-user Nix with flakes enabled.

---

## Phase 2 — Add `nix-darwin` to the flake

> ⚠️ Upstream moved: nix-darwin lives at **`github:nix-darwin/nix-darwin`**
> (the old `LnL7/nix-darwin` URL redirects, but don't pin a dead namespace).

- [x] Add inputs in `flake.nix` (done — see `flake.nix`):
  ```nix
  # darwin-flavored nixpkgs (has darwin-specific fixes the nixos-* branch lacks)
  nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

  nix-darwin = {
    url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";  # match your 26.05 era
    inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  home-manager = {  # keep the existing input; release-26.05 matches 26.05 nixpkgs
    url = "github:nix-community/home-manager/release-26.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ```
  - Tradeoff: single `nixpkgs` for everything (simplest, your Linux hosts stay on
    `nixos-26.05`) vs a separate `nixpkgs-darwin` input (what upstream recommends —
    the `-darwin` branch receives darwin fixes). Home Manager release-26.05 works
    with both.
- [x] Add a `darwinConfigurations.macvd` output next to `nixosConfigurations`:
  ```nix
  darwinConfigurations.macvd = nix-darwin.lib.darwinSystem {
    specialArgs = {inherit inputs;};
    modules = [
      ./darwin/macvd/configuration.nix
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.lvdund = import ./users/lvdund/macvd.nix;
        home-manager.backupFileExtension = "backup";
      }
    ];
  };
  ```
  - Note: `darwinSystem`'s `system`/`inputs` arguments are legacy compat shims now —
    set the platform via `nixpkgs.hostPlatform` inside `configuration.nix` (Phase 3)
    and pass `inputs` via `specialArgs`.

**Outcome**: `darwin-rebuild` target exists in the flake.

---

## Phase 3 — Create Darwin configuration

New directory layout (mirrors existing `nixos/`):

```
darwin/macvd/
└── configuration.nix      # system settings
```

- [x] Create `darwin/macvd/configuration.nix` with a minimal start (done, plus optional extras as comments):
  ```nix
  {pkgs, ...}: {
    # REQUIRED on darwin: set platform here (not in darwinSystem)
    nixpkgs.hostPlatform = "aarch64-darwin";  # or "x86_64-darwin"

    # Pin at initial install, never bump afterwards (7 = maxStateVersion
    # of nix-darwin-26.05, the correct value for a fresh install)
    system.stateVersion = 7;

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Make fish a proper login shell (registers it in /etc/shells)
    programs.fish.enable = true;

    users.users.lvdund = {
      name = "lvdund";
      home = "/Users/lvdund";
      shell = pkgs.fish;
    };

    environment.systemPackages = with pkgs; [
      git
      vim
    ];
  }
  ```
- [x] Decide: **Homebrew or not?** (decision: module block ready but disabled in the config)
  - Use nix-darwin's `homebrew` module to manage it declaratively — it only drives
    an existing brew install (you still install Homebrew itself first, at
    `/opt/homebrew` on Apple Silicon):
    ```nix
    homebrew = {
      enable = true;
      casks = ["raycast"];       # GUI apps nixpkgs can't do well
      masApps = { "Xcode" = 497799835; };  # App Store apps via `mas`
    };
    ```
  - Or skip Homebrew entirely if all your apps are in nixpkgs/ Home Manager
- [x] macOS niceties (all verified options, shipped as comments in the config):
  - [x] `system.defaults.*` — Dock autohide, Finder settings, NSGlobalDomain key repeat…
  - [x] `system.keyboard.enableKeyMapping = true;` + remaps (e.g. Caps Lock → Ctrl/Escape)
  - [x] Fonts via `fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ... ]` (kitty/nvim need this)

**Outcome**: a bootable declarative macOS system configuration.

---

## Phase 4 — User environment (Home Manager)

- [x] Create `users/lvdund/macvd.nix` (done, follows the style of `mylaptop.nix`):
  ```nix
  {pkgs, ...}: {
    home.username = "lvdund";
    home.homeDirectory = "/Users/lvdund";
    home.stateVersion = "26.05";  # pin at first install, never bump

    home.packages = with pkgs; [
      kitty
      neovim
      fzf
      ripgrep
    ];
  }
  ```
- [x] Extract shared config from existing Linux user files into reusable modules
  under `users/modules/` (or reuse the `config/` dirs directly):
  - [x] Reuse `config/nvim` for Neovim (imported `../modules/nvim.nix`)
  - [x] Reuse `config/fish` for Fish (imported `../modules/fish.nix`)
  - [x] Reuse `config/kitty` for Kitty terminal (symlink in `macvd.nix`)
  - [x] Parameterize all repo paths: modules take `repoRoot ? "/etc/nixos/nixos-config"`
    and each host passes its own value via `home-manager.extraSpecialArgs.repoRoot`
    in `flake.nix` (`/Users/lvdund/nixos-config` on the Mac)
  - [x] Gate Linux-only bits with `pkgs.stdenv.isLinux` / `isDarwin`
    (systemd units, `systemctl` aliases, waybar/niri are Linux-only — simply not
    imported on darwin; direnv gets fish integration instead of bash-only)
  - [ ] Since Home Manager activation runs as part of `darwin-rebuild`, either let
    HM manage your shell rc, or source the session-vars file it generates:
    `source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"`

**Outcome**: familiar editor/terminal/shell on macOS, sharing dotfiles with Linux hosts.

---

## Phase 5 — First build & verification

- [ ] Bootstrap (nix-darwin has no installer — the first `switch` installs it):
  ```sh
  cd ~/nixos-config
  sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake .#macvd
  ```
  (`nix-darwin/master` instead of `/nix-darwin-26.05` if you track unstable)
- [ ] After the first switch, `darwin-rebuild` is in `PATH`:
  ```sh
  sudo darwin-rebuild switch --flake ~/nixos-config#macvd
  ```
- [ ] Verify:
  - [ ] `darwin-rebuild` works from any shell; `darwin-help` opens local docs
  - [ ] `nix run nixpkgs#hello` works
  - [ ] Default login shell is fish (`echo $SHELL` → nix store fish path)
  - [ ] Fish/kitty/nvim all launch with your configs
  - [ ] No `*.backup` collisions in `~/.config` — if present, resolve conflicts
    and re-run
  - [ ] Reboot once; confirm settings (Dock, keyboard, fonts) persisted
- [ ] Commit `flake.lock` changes to git

**Outcome**: fully switched to the flake-managed Darwin machine.

---

## Phase 6 — Hardening & extras (post-setup)

- [ ] Binary cache / substituter settings via `nix.settings.substituters`
- [ ] Garbage collection on a schedule (launchd-based, verified options):
  ```nix
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
    # interval default: weekly — launchd calendar format:
    # interval = [{ Weekday = 7; Hour = 3; Minute = 15; }];
  };
  nix.optimise.automatic = true;
  ```
- [ ] Touch ID / Apple Watch for sudo — ⚠️ the old
  `security.pam.enableSudoTouchIdAuth` option was **removed**; current form:
  ```nix
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.watchIdAuth = true;  # Apple Watch, optional
  ```
- [ ] Optional quality-of-life:
  - [ ] `programs.direnv.enable = true;` + nix-direnv (see `notes/direnv`)
  - [ ] Window management: yabai / aerospace / skhd
  - [ ] Tiling-aware terminal/browser automation casks via `homebrew.casks`
- [ ] Document day-2 commands in `notes/`:
  ```sh
  sudo darwin-rebuild switch --flake ~/nixos-config#macvd  # apply
  sudo darwin-rebuild --rollback                            # revert
  sudo nix run nix-darwin#darwin-uninstaller                # remove nix-darwin entirely
  ```

**Outcome**: production-ready daily-driver setup.

---

## Common pitfalls

| Problem | Fix |
| --- | --- |
| `nix: command not found` after install | Restart terminal / check `~/.zprofile` sources the nix profile (installer adds it) |
| Pre-existing `~/.zshrc`, `~/.config/fish` | Home Manager renames conflicts to `*.backup`; merge manually then re-run |
| `aarch64-darwin` vs `x86_64-darwin` mismatch | `uname -m`: `arm64` → `aarch64-darwin`, `x86_64` → `x86_64-darwin` |
| nix-darwin "took over" Nix from Determinate install | Expected — nix-darwin manages Nix by default (`nix.package = pkgs.nix`); set `nix.enable = false;` to keep installer-managed Nix |
| Homebrew module errors | Homebrew itself must already be installed at `/opt/homebrew`; the module only drives it |
| `programs.fish` shell not applied | Set both `programs.fish.enable = true;` (registers `/etc/shells`) and `users.users.lvdund.shell = pkgs.fish;` |
| Spaces/uppercase in hostname flake attr | Always switch with explicit `--flake .#macvd`, never rely on LocalHostName |
| macOS upgrade breaks Nix | Determinate-installed Nix is designed to survive upgrades; re-run the installer if `/nix` got wiped |

---

## Command cheat sheet

```sh
# bootstrap (first time only)
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake .#macvd

# switch to new config
sudo darwin-rebuild switch --flake ~/nixos-config#macvd

# preview build without switching
sudo darwin-rebuild build --flake ~/nixos-config#macvd

# rollback
sudo darwin-rebuild --rollback

# update inputs (affects ALL hosts — review carefully)
nix flake update

# ad-hoc shell
nix shell nixpkgs#nodejs

# upgrade / uninstall Nix itself (Determinate install)
sudo determinate-nixd upgrade
/nix/nix-installer uninstall
```

---

## Sources (verified at time of writing)

- nix-darwin README & flake template — `github.com/nix-darwin/nix-darwin` (org moved from LnL7; release branches `nix-darwin-26.05`…; bootstrap via `sudo nix run nix-darwin/...#darwin-rebuild -- switch`; `system.stateVersion = 7` example (= the release's `system.maxStateVersion`); Lix installer recommendation; `darwin-uninstaller`)
- nix-darwin options manual (`nix-darwin.github.io/nix-darwin/manual`) — `nix.enable`/`nix.package` (nix-darwin manages Nix), `nix.gc.automatic` + launchd-style `nix.gc.interval`, `nix.optimise.automatic`, `security.pam.services.sudo_local.touchIdAuth`/`watchIdAuth` (replaces removed `enableSudoTouchIdAuth`), `homebrew.*`, `fonts.packages`, `system.keyboard.*`, `darwin-help`
- Home Manager manual — "nix-darwin module" install path (`home-manager.darwinModules.home-manager`), `useGlobalPkgs`/`useUserPackages`, `hm-session-vars.sh` sourcing for fish
- Determinate Nix Installer README — `install.determinate.systems` one-liner installs Determinate Nix by default, macOS GUI package, `sudo determinate-nixd upgrade`, `/nix/nix-installer uninstall`, survives macOS upgrades
