# Configuration (25%)

sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Configuring Sawtooth > [Validator Configuration File](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/validator_configuration_file.html)

sawtooth.hyperledger.org > FAQ > Validator > [What TCP ports does Sawtooth use?](https://sawtooth.hyperledger.org/faq/validator/#what-tcp-ports-does-sawtooth-use)

## Configure validator peering and network

Configure 3 validator hosts (i.e. `host1`, `host2` and `host3`).
Each host have two network interfaces:

* `eth0`: for network and component
* `eth1`: for consensus

Dynamic peering must be used and Parallel processing enabled.

<details><summary>show</summary>
<p>

### Method 1

Configuration file.

```bash
sudo cat << EOF > /etc/sawtooth/host1-validator.toml
bind = [
  "network:tcp://eth0:8800",
  "component:tcp://eth0:4004",
  "consensus:tcp://eth1:5050"
]
endpoint = "tcp://host1:8800"
peering = "dynamic"
seeds = [
  "tcp://127.0.0.1:8800", 
  "tcp://host2:8800",
  "tcp://host3:8800"
]
scheduler = "parallel"
EOF
```

```bash
sudo cat << EOF > /etc/sawtooth/host2-validator.toml
bind = [
  "network:tcp://eth0:8800",
  "component:tcp://eth0:4004",
  "consensus:tcp://eth1:5050"
]
endpoint = "tcp://host2:8800"
peering = "dynamic"
seeds = [
  "tcp://127.0.0.1:8800", 
  "tcp://host1:8800",
  "tcp://host3:8800"
]
scheduler = "parallel"
EOF
```

```bash
sudo cat << EOF > /etc/sawtooth/host3-validator.toml
bind = [
  "network:tcp://eth0:8800",
  "component:tcp://eth0:4004",
  "consensus:tcp://eth1:5050"
]
endpoint = "tcp://host3:8800"
peering = "dynamic"
seeds = [
  "tcp://127.0.0.1:8800", 
  "tcp://host1:8800",
  "tcp://host2:8800"
]
scheduler = "parallel"
EOF
```

### Method 2

Command line arguments.

```bash
sawtooth-validator \
--bind network:tcp://eth0:8800 \
--bind component:tcp://eth0:4004 \
--bind consensus:tcp://eth1:5050 \
--endpoint tcp://host1:8800 \
--peering "dynamic" \
--seeds tcp://127.0.0.1:8800 \
--seeds tcp://host2:8800 \
--seeds tcp://host3:8800 \
--scheduler parallel
```

```bash
sawtooth-validator \
--bind network:tcp://eth0:8800 \
--bind component:tcp://eth0:4004 \
--bind consensus:tcp://eth1:5050 \
--endpoint tcp://host2:8800 \
--peering "dynamic" \
--seeds tcp://127.0.0.1:8800 \
--seeds tcp://host1:8800 \
--seeds tcp://host3:8800 \
--scheduler parallel
```

```bash
sawtooth-validator \
--bind network:tcp://eth0:8800 \
--bind component:tcp://eth0:4004 \
--bind consensus:tcp://eth1:5050 \
--endpoint tcp://host3:8800 \
--peering "dynamic" \
--seeds tcp://127.0.0.1:8800 \
--seeds tcp://host1:8800 \
--seeds tcp://host2:8800 \
--scheduler parallel
```

</p>
</details>

## Configure consensus

