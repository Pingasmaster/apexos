<p align="center">
  <img src="logo.png" alt="ApeX OS" width="256">
</p>

[![build-apexos](https://github.com/Pingasmaster/apexos/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/Pingasmaster/apexos/actions/workflows/build.yml)

> ## ⚠️ Project status: sunsetting
>
> **This is an old project.** The build still works and everything here is kept up to date, but **support will end** in the near future. Fedora, systemd, and GNOME have all moved to integrate **mandatory age-verification** mechanisms into the stack ApeX OS is built on. I will not maintain an open-source project that is engineered to work *against* its users — software should serve the person running it, never police them. Thank you to everyone who tried ApeX OS along the way.

# ApeX OS (Pre-alpha PoC)

ApeX OS is a modern, user-friendly Linux distribution designed to bring the power and flexibility of Linux to a broader audience by leveraging native wine compatiblity with Windows apps. Built on the foundations of Fedora's immutable containerized approach, it offers unparalleled stability, privacy, and compatibility for a wide range of devices.

## Features

- **Immutable System**: ApeX OS leverages Fedora's containerized architecture for a robust and tamper-proof operating system.
- **Hardware Compatibility**: Works on older hardware, giving new life to devices made obsolete by proprietary systems like Windows 11.
- **Privacy First**: No data collection or intrusive telemetry, ensuring your information stays secure.
- **User-Friendly**: Intuitive interface and streamlined workflows for those transitioning from Windows.
- **Built-In Compatibility**: Includes Wine, Steam, and Flatpak support for a broad range of applications and games.
- **Rollback Functionality**: Snapshots with rollback ensure safe updates and recovery in case of errors.
- **Soon**: A new installer that migrates your windows apps and installs ApeX OS from Windows directly.

## Getting Started

### Minimum Prerequisites

1. A computer with 64-bit architecture.
2. At least 2 GB of RAM and 10 GB of free disk space.

### Recommended configuration

1. A computer with 64-bit architecture.
2. At least 8 GB of RAM and 128 GB of free disk space in an SSD.
3. A semi-decent graphic card, no matter the brand. Note that Nvidia drivers issues on Wayland have largely been resolved.

### Installation

1. Download the latest ISO of ApeX OS from [here](https://apex.p-seed.com:50000/apexos.iso).
2. Use a tool like [Rufus](https://rufus.ie/en/) or [Impression](https://flathub.org/apps/io.gitlab.adhami3310.Impression) or [Etcher](https://www.balena.io/etcher/) to create a bootable USB.
3. Boot from the USB drive and follow the on-screen installation instructions.

### Updating

ApeX OS uses automatic updates. However, if you want to update manually, you can :

```bash
sudo rpm-ostree upgrade
```

Rollback if an update causes issues (rollback are also automatic, but you may do it manually if needed):

```bash
sudo rpm-ostree rollback
```

## Contributing

We welcome contributions to make ApeX OS better! Here's how you can help:

1. Fork this repository and make your changes.
2. Submit a pull request with a detailed description of the changes.
3. Engage with the community for testing and feedback.

## Support

If you encounter any issues or have questions, please use the [Issues](https://github.com/Pingasmaster/apexos/issues) section of this repository. For direct support, feel free to reach out via email or our community channels.

## License

ApeX OS is licensed under the [GPL v3](LICENSE). By contributing, you agree that your contributions will be licensed under the same terms.

## Acknowledgments

ApeX OS is based on the [ublue](https://ublue.it/) containers technologies and leverages a Fedora base to provide an immutable and reliable experience for all users.
