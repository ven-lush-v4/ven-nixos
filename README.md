

welcome to my nixOS repo!

this is where i keep all my nixOS related stuff for my personal laptop

feel free to copy stuff, some of my stuff is copied too

its mostly handwritten, though i did use ai a lil for some of the more niche settings and in the beginning while i was still learning

the config uses home-manager, flakes, and partial modularisation of configuration.nix

````
/etc/nixos/
├── configuration.nix
├── flake.lock
├── flake.nix
├── hardware-configuration.nix
├── home.nix
├── modules
│   ├── locale.nix # misc locale related stuff 
│   ├── boot.nix # for settings related to boot
│   ├── caches.nix # for nix substitutors and caches
│   ├── kernel.nix # for kernel related settings
│   └──packages.nix # system packages
├── README.md
└── sway
    └── config
````
