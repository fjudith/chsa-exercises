Shield: [![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]

# Certified Hyperledger Sawtooth Administrator (CHSA) exercises

This repository contains a set of exercises to prepare for the 
[Certified Hyperledger Sawtooth](https://training.linuxfoundation.org/certification/certified-hyperledger-sawtooth-administrator-chsa/) exam.

Labs are designed to practice different topology and configuration by leveraging only `systemd` and a `non-root` user to execute tasks.

## Roadmap

* [x] [Install](./a_install) 10%
* [x] [Configuration](./b_configuration) 25%
* [x] [Permissioning, Identity Managmeent, and Security](./c_security) 20%
* [ ] [Lifecycle](./d_lifecycle) 25%
* [ ] [Troubleshooting](./e_troubleshooting) 20%

![Sawtooth Architecture](https://sawtooth.hyperledger.org/docs/core/nightly/master/_images/appdev-environment-multi-node.svg)

## Run

1. Install [Docker](https://docs.docker.com/get-docker/)
2. Install [Docker-Compose](https://docs.docker.com/compose/install/)
3. Clone the repository

```bash
git clone https://github.com/fjudith/chsa-exercices
```

4. Move to the exercice folder

```bash
cd a_install/5_configure_peering/
```

5. Follow the instructions of the README located at the root of each exercice (e.g. [5. Configure Peering](./a_install/5_configure_peering)).

### Known issues

* Works on Windows Subsystem for Linux (WSL) 2 [(ref. doc)](./docs/wsl_genie.md).


## License

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svgg