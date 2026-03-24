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
- `config/`: declarative settings such as app repository definitions
- `installers/packages/`: package manager specific setup
- `installers/tools/`: tool and environment configuration
- `installers/apps/`: dotfiles and personal application installers

# files
```
├── README.md
└── src
    ├── config
    │   └── apps.sh
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
