# Install (10%)

sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > [Installing Hyperledger Sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/installation.html)

sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > [Running Sawtooth as a Service](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html)

sawtooth.hyperledger.org > FAQ > [Validator](https://sawtooth.hyperledger.org/faq/validator)

sawtooth.hyperledger.org > Docs > Release 1.0.5 > System Administrator's Guide > [Settings Transaction Processor Configuration File](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/settings_tp_configuration.html)

## Verify system meets hardware requirements

Check if you computer hardware meets the Hyperledger Sawtooth requirements of at least 2 CPU and 4GB of RAM.

<details><summary>show</summary>
<p>

```bash
sudo lshw -short
```

Example output using WSL2 Ubuntu distribution.

```text
H/W path    Device    Class      Description
============================================
                      system     Computer
/0                    bus        Motherboard
/0/0                  memory     25GiB System memory
/0/1                  processor  AMD Ryzen 5 3600 6-Core Processor
/0/2        scsi0     storage    
/0/2/0.0.0  /dev/sda  volume     256GiB Virtual Disk
/0/2/0.0.1  /dev/sdb  volume     256GiB Virtual Disk
/0/2/0.0.2  /dev/sdc  volume     256GiB Virtual Disk
/0/2/0.0.3  /dev/sdd  volume     256GiB Virtual Disk
/1          bond0     network    Ethernet interface
/2          eth0      network    Ethernet interface
/3          dummy0    network    Ethernet interface
```

</p>
</details>

## Install Sawtooth packages

<details><summary>show</summary>
<p>

```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD
sudo add-apt-repository 'deb http://repo.sawtooth.me/ubuntu/1.0/stable xenial universe'

sudo apt-get update
sudo apt get install -y sawtooth
```

</p>
</details>

## Generate keys

<details><summary>show</summary>
<p>

```bash
sudo sawadm keygen
```

</p>
</details>

## Create Genesis Block

Create Genesis Block using the key created for user `sawtooth`.

<details><summary>show</summary>
<p>

Generate keys in the default directory (i.e. `~/.sawtooth/keys/`)

```bash
sawtooth keygen sawtooth
```

```text
creating key directory: /home/fjudith/.sawtooth/keys
writing file: /home/fjudith/.sawtooth/keys/sawtooth.priv
writing file: /home/fjudith/.sawtooth/keys/sawtooth.pub
```

Or...

Generate keys in a custom key directory (i.e. `/tmp/keys`)

```bash
mkdir -p /tmp/keys
sawtooth keygen --key-dir /tmp/keys sawtooth
```

```text
writing file: /tmp/keys/sawtooth.priv
writing file: /tmp/keys/sawtooth.pub
```

</p>
</details>

## Start component services

<details><summary>show</summary>
<p>

```bash
sudo systemctl start \
sawtooth-validator \
sawtooth-rest-api \
sawtooth-intkey-tp-python \
sawtooth-settings-tp \
sawtooth-xo-tp-python
```

</p>
</details>

## Register validator

<details><summary>show</summary>
<p>

### Method 1

Use configuration file.

```bash
sudo mv /etc/sawtooth/validator.toml.example /etc/sawtooth/validator.toml

sudo sawtooth-validator --config-dir /etc/sawtooth
```

### Method 2

Use command arguments.

```bash
sudo sawtooth-validator -vv \
--bind component:tcp://eth0:4004 \
--bind network:tcp://eth0:8800 \
--bind concensus:tcp://eth0:5050
```

</p>
</details>

## Configure peering

Add a second Validator named `host2` to the list of peers. 

<details><summary>show</summary>
<p>

### Method 1

Edit configuration file.

```bash
sudo nano /etc/sawtooth/validator.toml
```

Search for the `peers` porperty (i.e. Crtl+W, "peers ="), then add the following line below.

```toml
peers = ["tcp://host1:8800,tcp://host2:8800"]
```

### Method 2

Use command arguments.

```bash
sudo sawtooth-validator -vv \
--bind component:tcp://eth0:4004 \
--bind network:tcp://eth0:8800 \
--bind concensus:tcp://eth0:5050 \
--peers "tcp://host1:8800,tcp://host2:8800"
```

</p>
</details>

## Verify install and fix if necessary (in progress)

<details><summary>show</summary>
<p>

```bash

```

</p>
</details>

## Connect transaction processor to validator

Connect transaction processor to `host1` validator.

<details><summary>show</summary>
<p>

### Method 1

Create configuration file.

```bash
sudo touch /etc/sawtooth/validator.toml

sudo nano /etc/sawtooth/validator.toml
```

Add the following line.

```toml
connect = "tcp://host1:4004"
```

### Method 2

Use command arguments.

```bash
settings-tp -v -C tcp://host1:4004
```

</p>
</details>
