BIN_DIR = $(HOME)/.local/bin
UNIT_DIR = $(HOME)/.config/systemd/user

SOCKETS = $(notdir $(wildcard src/sockets/*.socket))
SERVICES = $(patsubst %.service,%@.service,$(notdir $(wildcard src/services/*.service)))

VERSION = $(shell sed -n '1s/.*(\(.*\)).*/\1/p' debian/changelog)
DEB = dist/wsl-relay-gpg_$(VERSION)_all.deb

.PHONY: install uninstall deb clean

install:
	install -D -m 0755 src/bin/wsl-relay-gpg.sh $(BIN_DIR)/wsl-relay-gpg
	install -D -m 0755 -t $(BIN_DIR) src/bin/npiperelay.exe
	install -D -m 0644 -t $(UNIT_DIR) src/sockets/*.socket
	for unit in src/services/*.service; do \
		install -m 0644 $$unit $(UNIT_DIR)/$$(basename $$unit .service)@.service; \
	done

uninstall:
	rm -f $(BIN_DIR)/wsl-relay-gpg $(BIN_DIR)/npiperelay.exe
	rm -f $(addprefix $(UNIT_DIR)/,$(SOCKETS) $(SERVICES))

deb: $(DEB)

# dpkg writes the packages to the parent directory of the clone, i.e. dist/.
$(DEB): dist/wsl-relay-gpg
	cd $< && dpkg-buildpackage -us -uc

# A clean clone of HEAD, recreated whenever a tracked file changes.
dist/wsl-relay-gpg: $(shell git ls-files)
	rm -rf $@
	git clone . $@

clean:
	rm -rf dist
