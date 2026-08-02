```
make install
systemctl --user daemon-reload
systemctl --user enable --now wsl-relay-dirmngr.socket
systemctl --user enable --now wsl-relay-gpg-agent-browser.socket
systemctl --user enable --now wsl-relay-gpg-agent-extra.socket
systemctl --user enable --now wsl-relay-gpg-agent-ssh.socket
systemctl --user enable --now wsl-relay-gpg-agent.socket
systemctl --user enable --now wsl-relay-keyboxd.socket
```