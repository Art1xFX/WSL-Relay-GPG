# WSL Relay for GnuPG

Use the GnuPG agent running on Windows from inside WSL.

`wsl-relay-gpg` provides the standard GnuPG sockets (`S.gpg-agent`, `S.gpg-agent.ssh`, `S.dirmngr`, …) inside WSL. It
forwards every connection to the matching socket of the Windows GnuPG installation, such as
[Gpg4win](https://www.gpg4win.org/). `gpg`, `git` and `ssh` in WSL then work with the keys, smartcards and pinentry of
Windows, as if the agent were running locally.

## Why

- **One keyring.** Keys live on Windows only. You do not need to copy secret keys into each WSL distribution.
- **Smartcards and YubiKeys.** WSL has no direct access to USB devices, but the Windows agent does.
- **One passphrase cache.** The Windows pinentry asks for the passphrase, and the cache is shared by Windows and WSL.
- **SSH through gpg-agent.** `ssh` in WSL can use the authentication keys held by the Windows agent.

## How it works

The package installs systemd user socket units that listen on the GnuPG socket paths in `/run/user/<uid>/gnupg/`. For
each connection, systemd starts a short-lived service. That service asks the Windows `gpgconf.exe` where the
corresponding Windows socket is, and hands the connection to
[npiperelay](https://github.com/albertony/npiperelay), which relays the traffic to it.

The native Linux `gpg-agent`, `dirmngr` and `keyboxd` sockets are masked so that they do not compete for the same
paths.

## Requirements

- WSL 2 with systemd enabled. Add the following to `/etc/wsl.conf` and run `wsl --shutdown` from Windows:

  ```ini
  [boot]
  systemd=true
  ```

- GnuPG for Windows (for example Gpg4win), with `gpgconf.exe` in the Windows `PATH`.
- For SSH: `enable-ssh-support` in `%APPDATA%\gnupg\gpg-agent.conf` on Windows.

## Installation

Install the package:

```sh
sudo apt install ./wsl-relay-gpg_*.deb
```

The package enables its sockets for all users and masks the native GnuPG sockets. The change takes effect at the next
login, so restart WSL from Windows:

```sh
wsl --shutdown
```

For SSH, point `SSH_AUTH_SOCK` to the relayed socket in `~/.bashrc` (or the profile of your shell):

```sh
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
```

Check that it works:

```sh
gpg --list-secret-keys
gpg --card-status
ssh-add -L
```

Removing the package (`sudo apt remove wsl-relay-gpg`) unmasks the native GnuPG sockets again.

### Without the package

Install the relay into `~/.local/bin` and `~/.config/systemd/user`, mask the native sockets and enable the relayed
ones. `npiperelay.exe` is built from the `src/npiperelay` submodule, which requires Go 1.26 or newer:

```sh
git submodule update --init
make install
systemctl --user daemon-reload
systemctl --user mask dirmngr.socket gpg-agent.socket gpg-agent-browser.socket \
  gpg-agent-extra.socket gpg-agent-ssh.socket keyboxd.socket
systemctl --user enable --now wsl-relay-dirmngr.socket wsl-relay-gpg-agent.socket \
  wsl-relay-gpg-agent-browser.socket wsl-relay-gpg-agent-extra.socket \
  wsl-relay-gpg-agent-ssh.socket wsl-relay-keyboxd.socket
```

`make uninstall` removes the files again.

## Building the package

Requires `dpkg-dev`, `debhelper` and `golang-go` 1.26 or newer (from `trixie-backports` on Debian 13):

```sh
make deb
```

This builds the binary package (`.deb`) and the source package for OBS (`.dsc` and `.tar.xz`) into `dist/`. The
build uses a clean clone of the committed `HEAD`, so uncommitted changes are not included.

## License

[MIT](LICENSE). The bundled `npiperelay.exe` is MIT-licensed, Copyright (c) 2017 John Starks.
