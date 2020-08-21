# Configuration (25%)

sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Configuring Sawtooth > [Validator Configuration File](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/validator_configuration_file.html)

sawtooth.hyperledger.org > FAQ > Validator > [What TCP ports does Sawtooth use?](https://sawtooth.hyperledger.org/faq/validator/#what-tcp-ports-does-sawtooth-use)

sawtooth.hyperledger.org > Docs > Release 1.0.5 > System Administrator's Guide > 


## Configure validator peering and network

Configure three validator hosts (i.e. `host1`, `host2` and `host3`).
Each host have two network interfaces:

* `eth0` (192.168.1.1-3): for network and component
* `eth1` (192.168.2.1-3): for consensus

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

Configure three Devmode consensus engines attached to validators 1,2 and 3.

<details><summary>show</summary>
<p>

```bash
sawset proposal create --key $HOME/.sawtooth/keys/my_key.priv \
-o config-consensus.batch \
sawtooth.consensus.algorithm.name=PoET \
sawtooth.consensus.algorithm.version=0.1 \
sawtooth.poet.report_public_key_pem="$(cat /etc/sawtooth/simulator_rk_pub.pem)" \
sawtooth.poet.valid_enclave_measurements=$(poet enclave measurement) \
sawtooth.poet.valid_enclave_basenames=$(poet enclave basename)

poet registration create --key /etc/sawtooth/keys/validator.priv -o poet.batch

sawset proposal create --key $HOME/.sawtooth/keys/my_key.priv \
-o poet-settings.batch \
sawtooth.poet.target_wait_time=5 \
sawtooth.poet.initial_wait_time=25 \
sawtooth.publisher.max_batches_per_block=100
```



</p>
</details>

## Configure logging

Configure log rotation with 10 backup logs and a maximum size of 10 MB.

### Log configuration reference

```toml
[formatters.simple]
format = "[%(asctime)s.%(msecs)30d [%(threadName)s] %(module)s %(levelname)s] %(message)s"
datefmt = "%H:%M:%S"

[handlers.interconnect]
level = "DEBUG"
formatter = "simple"
class = "logging.handlers.RotatingFileHander"
filename = "interconnect.log"

[loggers."sawtooth_validator.networking.interconnect"]
level = "DEBUG"
propagate = true
handlers = ["interconnect"]
```

<details><summary>show</summary>
<p>

```bash
cat << EOF > /etc/sawtooth/log_config.toml
[formatters.simple]
format = "[%(asctime)s.%(msecs)30d [%(threadName)s] %(module)s %(levelname)s] %(message)s"
datefmt = "%H:%M:%S"

[handlers.interconnect]
level = "DEBUG"
formatter = "simple"
class = "logging.handlers.RotatingFileHander"
filename = "interconnect.log"
maxBytes = 10000000
backupCount = 10

[loggers."sawtooth_validator.networking.interconnect"]
level = "DEBUG"
propagate = true
handlers = ["interconnect"]
```

</p>
</details>

## Configure REST API

Configure REST API in order to connect to the validator running on host1.
the service must me accessible externally.

<details><summary>show</summary>
<p>

```bash
sawtooth-rest-api --connect tcp://validator:8800 --bind eth0:8008
```

</p>
</details>