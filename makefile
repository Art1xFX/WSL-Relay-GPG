DIRMNGR_SOCKET_SRC=src/sockets/wsl-relay-dirmngr.socket
DIRMNGR_SOCKET_DEST=$(HOME)/.config/systemd/user/wsl-relay-dirmngr.socket
DIRMNGR_SERVICE_SRC=src/services/wsl-relay-dirmngr.service
DIRMNGR_SERVICE_DEST=$(HOME)/.config/systemd/user/wsl-relay-dirmngr@.service
KEYBOXD_SOCKET_SRC=src/sockets/wsl-relay-keyboxd.socket
KEYBOXD_SOCKET_DEST=$(HOME)/.config/systemd/user/wsl-relay-keyboxd.socket
KEYBOXD_SERVICE_SRC=src/services/wsl-relay-keyboxd.service
KEYBOXD_SERVICE_DEST=$(HOME)/.config/systemd/user/wsl-relay-keyboxd@.service
GPG_AGENT_SOCKET_SRC=src/sockets/wsl-relay-gpg-agent.socket
GPG_AGENT_SOCKET_DEST=$(HOME)/.config/systemd/user/wsl-relay-gpg-agent.socket
GPG_AGENT_SERVICE_SRC=src/services/wsl-relay-gpg-agent.service
GPG_AGENT_SERVICE_DEST=$(HOME)/.config/systemd/user/wsl-relay-gpg-agent@.service
GPG_AGENT_SSH_SOCKET_SRC=src/sockets/wsl-relay-gpg-agent-ssh.socket
GPG_AGENT_SSH_SOCKET_DEST=$(HOME)/.config/systemd/user/wsl-relay-gpg-agent-ssh.socket
GPG_AGENT_SSH_SERVICE_SRC=src/services/wsl-relay-gpg-agent-ssh.service
GPG_AGENT_SSH_SERVICE_DEST=$(HOME)/.config/systemd/user/wsl-relay-gpg-agent-ssh@.service
GPG_AGENT_EXTRA_SOCKET_SRC=src/sockets/wsl-relay-gpg-agent-extra.socket
GPG_AGENT_EXTRA_SOCKET_DEST=$(HOME)/.config/systemd/user/wsl-relay-gpg-agent-extra.socket
GPG_AGENT_EXTRA_SERVICE_SRC=src/services/wsl-relay-gpg-agent-extra.service
GPG_AGENT_EXTRA_SERVICE_DEST=$(HOME)/.config/systemd/user/wsl-relay-gpg-agent-extra@.service
GPG_AGENT_BROWSER_SOCKET_SRC=src/sockets/wsl-relay-gpg-agent-browser.socket
GPG_AGENT_BROWSER_SOCKET_DEST=$(HOME)/.config/systemd/user/wsl-relay-gpg-agent-browser.socket
GPG_AGENT_BROWSER_SERVICE_SRC=src/services/wsl-relay-gpg-agent-browser.service
GPG_AGENT_BROWSER_SERVICE_DEST=$(HOME)/.config/systemd/user/wsl-relay-gpg-agent-browser@.service

install: \
	$(DIRMNGR_SOCKET_DEST) \
	$(DIRMNGR_SERVICE_DEST) \
	$(KEYBOXD_SOCKET_DEST) \
	$(KEYBOXD_SERVICE_DEST) \
	$(GPG_AGENT_SOCKET_DEST) \
	$(GPG_AGENT_SERVICE_DEST) \
	$(GPG_AGENT_SSH_SOCKET_DEST) \
	$(GPG_AGENT_SSH_SERVICE_DEST) \
	$(GPG_AGENT_EXTRA_SOCKET_DEST) \
	$(GPG_AGENT_EXTRA_SERVICE_DEST) \
	$(GPG_AGENT_BROWSER_SOCKET_DEST) \
	$(GPG_AGENT_BROWSER_SERVICE_DEST) \
	$(HOME)/.local/bin/wsl-relay-gpg

$(HOME)/.local/bin:
	mkdir -p $(HOME)/.local/bin

$(HOME)/.local/bin/wsl-relay-gpg: $(HOME)/.local/bin
	cp src/bin/wsl-relay-gpg.sh $(HOME)/.local/bin/wsl-relay-gpg
	chmod +x $(HOME)/.local/bin/wsl-relay-gpg

$(DIRMNGR_SOCKET_DEST):
	cp $(DIRMNGR_SOCKET_SRC) $(DIRMNGR_SOCKET_DEST)

$(DIRMNGR_SERVICE_DEST):
	cp $(DIRMNGR_SERVICE_SRC) $(DIRMNGR_SERVICE_DEST)

$(KEYBOXD_SOCKET_DEST):
	cp $(KEYBOXD_SOCKET_SRC) $(KEYBOXD_SOCKET_DEST)

$(KEYBOXD_SERVICE_DEST):
	cp $(KEYBOXD_SERVICE_SRC) $(KEYBOXD_SERVICE_DEST)

$(GPG_AGENT_SOCKET_DEST):
	cp $(GPG_AGENT_SOCKET_SRC) $(GPG_AGENT_SOCKET_DEST)

$(GPG_AGENT_SERVICE_DEST):
	cp $(GPG_AGENT_SERVICE_SRC) $(GPG_AGENT_SERVICE_DEST)

$(GPG_AGENT_SSH_SOCKET_DEST):
	cp $(GPG_AGENT_SSH_SOCKET_SRC) $(GPG_AGENT_SSH_SOCKET_DEST)

$(GPG_AGENT_SSH_SERVICE_DEST):
	cp $(GPG_AGENT_SSH_SERVICE_SRC) $(GPG_AGENT_SSH_SERVICE_DEST)

$(GPG_AGENT_EXTRA_SOCKET_DEST):
	cp $(GPG_AGENT_EXTRA_SOCKET_SRC) $(GPG_AGENT_EXTRA_SOCKET_DEST)

$(GPG_AGENT_EXTRA_SERVICE_DEST):
	cp $(GPG_AGENT_EXTRA_SERVICE_SRC) $(GPG_AGENT_EXTRA_SERVICE_DEST)

$(GPG_AGENT_BROWSER_SOCKET_DEST):
	cp $(GPG_AGENT_BROWSER_SOCKET_SRC) $(GPG_AGENT_BROWSER_SOCKET_DEST)

$(GPG_AGENT_BROWSER_SERVICE_DEST):
	cp $(GPG_AGENT_BROWSER_SERVICE_SRC) $(GPG_AGENT_BROWSER_SERVICE_DEST)

clean:
	rm -f $(DIRMNGR_SOCKET_DEST)
	rm -f $(DIRMNGR_SERVICE_DEST)
	rm -f $(KEYBOXD_SOCKET_DEST)
	rm -f $(KEYBOXD_SERVICE_DEST)
	rm -f $(GPG_AGENT_SOCKET_DEST)
	rm -f $(GPG_AGENT_SERVICE_DEST)
	rm -f $(GPG_AGENT_SSH_SOCKET_DEST)
	rm -f $(GPG_AGENT_SSH_SERVICE_DEST)
	rm -f $(GPG_AGENT_EXTRA_SOCKET_DEST)
	rm -f $(GPG_AGENT_EXTRA_SERVICE_DEST)
	rm -f $(HOME)/.local/bin/wsl-relay-gpg
	rmdir --ignore-fail-on-non-empty $(HOME)/.local/bin
