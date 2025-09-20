.PHONY: install uninstall test clean help

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
SCRIPT_NAME = gh-switch

help:
	@echo "gh-switch - GitHub Account Switcher"
	@echo ""
	@echo "Usage:"
	@echo "  make install    Install gh-switch"
	@echo "  make uninstall  Uninstall gh-switch"
	@echo "  make test       Run tests"
	@echo "  make clean      Clean temporary files"

install:
	@echo "Installing gh-switch to $(BINDIR)..."
	@chmod +x bin/gh-switch-standalone
	@sudo cp bin/gh-switch-standalone $(BINDIR)/$(SCRIPT_NAME)
	@echo "✓ Installed successfully"
	@echo "Run 'gh-switch init' to get started"

uninstall:
	@echo "Uninstalling gh-switch..."
	@sudo rm -f $(BINDIR)/$(SCRIPT_NAME)
	@echo "✓ Uninstalled"
	@echo "Note: Config files in ~/.config/gh-switch/ were preserved"

test:
	@echo "Running tests..."
	@bash tests/test_basic.sh

clean:
	@echo "Cleaning temporary files..."
	@rm -f *.tmp *.bak
	@rm -rf build/ dist/
	@echo "✓ Cleaned"