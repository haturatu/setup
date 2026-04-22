# setup
My personal setup script for a new computer.

# Usage
Clone this repository and run the `setup.sh` script:

```bash
git clone https://github.com/haturatu/setup.git
cd src
chmod +x setup.sh
./setup.sh
```
## Support
### apt
debian, ubuntu, linuxmint, devuan

### pacman
arch, manjaro, artix

### homebrew
maybe ...

# src layout
`src` is organized by responsibility instead of execution order.

- `lib/`: shared helpers such as environment checks and OS detection
- `config/`: declarative settings such as app repository definitions and package lists
- `installers/packages/`: package manager specific setup
- `installers/tools/`: tool and environment configuration
- `installers/apps/`: dotfiles and personal application installers

# package management
Package lists are managed as line-based text files under `src/config/packages/`.

- `apt.txt`: regular APT packages
- `apt-docker-prerequisites.txt`: prerequisite packages used before adding the Docker APT repository
- `pacman.txt`: regular Pacman packages
- `pacman-ime.txt`: Pacman packages for IME related setup
- `brew.txt`: Homebrew packages

Rules:

- One package per line
- Empty lines are ignored
- Lines starting with `#` are treated as comments

If you want to add or remove packages, edit these files instead of changing the installer scripts directly.

# files
```
├── README.md
└── src
    ├── config
    │   ├── apps.sh
    │   └── packages
    │       ├── apt-docker-prerequisites.txt
    │       ├── apt.txt
    │       ├── brew.txt
    │       ├── pacman-ime.txt
    │       └── pacman.txt
    ├── installers
    │   ├── apps
    │   │   ├── dotfiles.sh
    │   │   └── orig_apps.sh
    │   ├── packages
    │   │   ├── apt.sh
    │   │   ├── brew.sh
    │   │   └── pacman.sh
    │   └── tools
    │       ├── git.sh
    │       ├── pip.sh
    │       ├── timezone.sh
    │       └── vim.sh
    ├── lib
    │   ├── common.sh
    │   └── os.sh
    └── setup.sh
```
