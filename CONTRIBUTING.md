# Contributing to hcloud-ssh-ctl

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Development Setup

1. **Fork and clone the repository**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/hcloud-ssh-ctl.git
   cd hcloud-ssh-ctl
   ```

2. **Install dependencies**:
   ```bash
   sudo apt-get update
   sudo apt-get install dialog jq curl pssh devscripts debhelper
   ```

3. **Test locally**:
   ```bash
   # Run directly without installation
   bash src/hcloud-ssh-ctl

   # Or install locally
   sudo make install
   hcloud-ssh-ctl
   ```

## Making Changes

1. **Create a branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Edit files in `src/` for the main script
   - Update `docs/` for documentation changes
   - Update `debian/` for packaging changes

3. **Test your changes**:
   ```bash
   # Test the script
   bash src/hcloud-ssh-ctl

   # Build and test the package
   make build-deb
   sudo dpkg -i ../hcloud-ssh-ctl_*.deb
   ```

4. **Update documentation**:
   - Update README.md if adding features
   - Update man page in `docs/hcloud-ssh-ctl.1`
   - Update QUICKSTART.md for user-facing changes

5. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

## Code Style

- Use 4 spaces for indentation
- Follow existing code structure
- Add comments for complex logic
- Use meaningful variable names
- Keep functions focused and small

## Bash Script Guidelines

- Always use `set -e` for error handling
- Quote variables: `"$variable"` not `$variable`
- Use `local` for function variables
- Check command existence before use
- Clean up temporary files

Example:
```bash
do_something() {
    local input="$1"

    if [ -z "$input" ]; then
        echo "Error: input required" >&2
        return 1
    fi

    # Do work here
}
```

## Testing

Before submitting:

1. **Test basic functionality**:
   - Add/remove projects
   - Add/remove SSH keys
   - List servers (if you have a test API key)
   - Navigate all menus

2. **Test package building**:
   ```bash
   make clean
   make build-deb
   ```

3. **Test installation**:
   ```bash
   sudo dpkg -i ../hcloud-ssh-ctl_*.deb
   hcloud-ssh-ctl
   sudo apt-get remove hcloud-ssh-ctl
   ```

## Submitting Changes

1. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create a Pull Request**:
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Describe your changes clearly

3. **Pull Request checklist**:
   - [ ] Code follows project style
   - [ ] All tests pass
   - [ ] Documentation updated
   - [ ] Commit messages are clear
   - [ ] No unnecessary files included

## Reporting Bugs

When reporting bugs, please include:

1. **System information**:
   - OS and version
   - Shell version (`bash --version`)
   - Tool version (`hcloud-ssh-ctl` → About)

2. **Steps to reproduce**:
   - What you did
   - What you expected
   - What actually happened

3. **Logs/errors**:
   - Error messages
   - Screenshots if relevant

## Feature Requests

When requesting features:

1. **Describe the problem**: What are you trying to solve?
2. **Propose a solution**: How would you like it to work?
3. **Consider alternatives**: Are there other ways to solve it?
4. **Additional context**: Why is this important?

## Project Structure

```
hcloud-ssh-ctl/
├── src/
│   └── hcloud-ssh-ctl          # Main script
├── debian/                      # Debian packaging
│   ├── control
│   ├── changelog
│   ├── rules
│   ├── install
│   ├── copyright
│   ├── postinst
│   └── compat
├── docs/
│   └── hcloud-ssh-ctl.1        # Man page
├── scripts/
│   ├── build-package.sh        # Build helper
│   └── setup-apt-repo.sh       # APT repo helper
├── .github/
│   └── workflows/
│       └── build.yml           # CI/CD
├── Makefile                     # Build rules
├── README.md                    # Main documentation
├── QUICKSTART.md               # Quick start guide
├── CONTRIBUTING.md             # This file
└── LICENSE                      # MIT License
```

## Release Process

For maintainers:

1. **Update version**:
   - `src/hcloud-ssh-ctl` → VERSION variable
   - `debian/changelog` → new entry

2. **Update documentation**:
   - README.md
   - CHANGELOG.md (if exists)

3. **Create tag**:
   ```bash
   git tag -a v1.0.1 -m "Release version 1.0.1"
   git push origin v1.0.1
   ```

4. **Build and release**:
   - GitHub Actions will build automatically
   - Upload to package repository

## Questions?

Feel free to:
- Open an issue for questions
- Start a discussion
- Contact the maintainer

Thank you for contributing! 🎉
