PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1

.PHONY: all install uninstall build-deb clean

all:
	@echo "Nothing to build. Run 'make install' to install."

install:
	install -D -m 0755 src/hcloud-ssh-ctl $(DESTDIR)$(BINDIR)/hcloud-ssh-ctl
	install -D -m 0644 docs/hcloud-ssh-ctl.1 $(DESTDIR)$(MANDIR)/hcloud-ssh-ctl.1
	@echo "Installation complete!"
	@echo "Run 'hcloud-ssh-ctl' to start."

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/hcloud-ssh-ctl
	rm -f $(DESTDIR)$(MANDIR)/hcloud-ssh-ctl.1
	@echo "Uninstallation complete."

build-deb:
	@echo "Building Debian package..."
	dpkg-buildpackage -us -uc -b
	@echo "Debian package built successfully!"
	@echo "Package file: ../hcloud-ssh-ctl_*.deb"

clean:
	rm -f ../hcloud-ssh-ctl_*.deb
	rm -f ../hcloud-ssh-ctl_*.changes
	rm -f ../hcloud-ssh-ctl_*.buildinfo
	rm -rf debian/hcloud-ssh-ctl
	rm -rf debian/.debhelper
	rm -f debian/debhelper-build-stamp
	rm -f debian/files
	@echo "Clean complete."

help:
	@echo "Available targets:"
	@echo "  make install      - Install hcloud-ssh-ctl locally"
	@echo "  make uninstall    - Uninstall hcloud-ssh-ctl"
	@echo "  make build-deb    - Build Debian package"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make help         - Show this help message"
