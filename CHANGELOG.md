# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-27

### Added
- Initial release of hcloud-ssh-ctl
- Multi-project management with API key storage
- SSH private key management (import from file or paste)
- Server listing and filtering from Hetzner Cloud API
- Multi-server selection interface
- Custom SSH port support (non-standard ports)
- Connection testing feature before executing commands
- Direct SSH execution for reliable command execution
- Verbose logging and debug mode
- Comprehensive error handling and user feedback
- Complete Debian packaging for APT distribution
- GitHub Actions CI/CD pipeline
- Man page documentation
- Complete user guides (README, QUICKSTART, TROUBLESHOOTING, DEBUGGING)

### Features
- **Project Management**: Store and manage multiple Hetzner Cloud projects
- **SSH Key Management**: Import keys from files or paste manually
- **Server Discovery**: Fetch servers from Hetzner Cloud API with filtering
- **Connection Testing**: Test connectivity before running actual commands
- **Custom Ports**: Support for SSH on non-standard ports (2222, 2200, etc.)
- **Debug Mode**: Preserve logs for troubleshooting (DEBUG_MODE=1)
- **Logging**: Comprehensive verbose SSH logs with exit codes
- **Error Detection**: Distinguishes between SSH errors and verbose output
- **Direct SSH**: Uses native SSH command for maximum reliability

### Technical Details
- Written in Bash with dialog TUI framework
- Dependencies: dialog, jq, curl, ssh
- Configuration stored in ~/.config/hcloud-ssh-ctl/
- Secure storage: 700 permissions on config dir, 600 on files
- APT-installable Debian package
- Automated builds via GitHub Actions

### Documentation
- Complete README with installation and usage instructions
- Quick start guide for new users
- Comprehensive troubleshooting guide
- Debugging guide with log analysis
- Man page for command-line reference
- Contributing guidelines for developers
- Project summary with technical architecture

## [Unreleased]

### Changed
- Removed debian/compat file (compat level now only in debian/control)
- Updated GitHub Actions to v4 (removed deprecation warnings)
- Added build-essential to build dependencies

### Fixed
- SSH key dialog exit issue
- Command execution with flags (like `ls -lha`)
- Success detection with SSH verbose output
- Dialog display for large output
- Error handling without set -e

---

## Release Process

To create a new release:

1. Update version in:
   - src/hcloud-ssh-ctl (VERSION variable)
   - debian/changelog (new entry)
   - This CHANGELOG.md

2. Commit changes:
   ```bash
   git add .
   git commit -m "Release vX.Y.Z"
   ```

3. Create and push tag:
   ```bash
   git tag -a vX.Y.Z -m "Release version X.Y.Z"
   git push origin vX.Y.Z
   ```

4. GitHub Actions will automatically:
   - Build the Debian package
   - Test installation
   - Create GitHub Release
   - Upload .deb file

## Version History

- **1.0.0** (2024-11-27): Initial release with full feature set
