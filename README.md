# Certified Hyperledger Sawtooth Administrator (CHSA) exercises

This repository contains a set of exercises to prepare for the [Certified Hyperledger Sawtooth](https://training.linuxfoundation.org/certification/certified-hyperledger-sawtooth-administrator-chsa/) exam.

1. [Install](./a_install) 10%
2. [Configuration](./b_configuration) 25%
3. [Permissioning, Identity Managmeent, and Security](./c_security) 20%
4. [Lifecycle](./d_lifecycle) 25%
5. [Troubleshooting](./e_troubleshooting) 20%

![Sawtooth Architecture](https://sawtooth.hyperledger.org/docs/core/nightly/master/_images/appdev-environment-multi-node.svg)

## Known issues

* Works on Windows Subsystem for Linux (WSL) 2, only if using Ubuntu 20.04 (Focal) and [Genie](https://github.com/arkane-systems/genie) is installed.

```bash
sudo apt install daemonize dbus policykit-1 systemd

# add Microsoft repo with .Net 3.1 runtime
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

curl -s https://packagecloud.io/install/repositories/arkane-systems/wsl-translinux/script.deb.sh | sudo bash
sudo apt install -y systemd-genie
```

Add configuration `/usr/lib/genie/deviated-preverts.conf`:

```json
{
  "daemonize": "/usr/bin/daemonize",
  "mount": "/bin/mount",
  "runuser": "/sbin/runuser",
  "systemd": "/bin/systemd"
}
```

Restart WSL with Genie

```shell
wsl.exe genie -i
```

Shield: [![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg