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
EOF
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

## Configure layer 3 network ports/firewall

Configure `host5` services to listen on the `eth0` network interface, using following modified port configuration.

Service | TCP Port
------- | --------
component | `55001`
network   | `55002`
consensus | `55003`
rest-api  | `55004`

<details><summary>show</summary>
<p>

```bash
sawtooth-validator --bind "component:tcp://eth0:55001" --bind "network:tcp://eth0:55002" --bind "consensus:tcp://eth0:55003" --endpoint "tcp://host1:55001"
settings-tp --connect "tcp://host1:55001"
sawtooth-rest-api --connect "tcp://host1:55001"
intkey-tp-python --connect "tcp://host1:55001"
```

</p>
</details>

## Configure metrics

Configure metrics for both Validator and REST API.
Metrics have be sent to the `tsdb.example.com` on port `4242` in database `sawtooth` using the following credentials.

* **Username**: `sawtooth`
* **Password**: `metrics`

<details><summary>show</summary>
<p>

### Method 1

Using configuration files.

Add the following lines to the Validator configuration file (i.e. `/etc/sawtooth/validator.toml`).

```toml
opentsdb_url = "http://tsdb.example.com:4242"
opentsdb_db = "sawtooth"
opentsdb_username = "sawtooth"
opentsdb_password = "metrics"
```

Add the following lines to the REST API configuration file (i.e. `/etc/sawtooth/rest_api.toml`.

```toml
opentsdb_url = "http://tsdb.example.com:4242"
opentsdb_db = "sawtooth"
opentsdb_username = "sawtooth"
opentsdb_password = "metrics"
```

### Method 2

Using command line arguments.

For Validator.

```bash
sawtooth-validor -vv \
--opentsdb-url "http://sawtooth:metrics@tsdb.example.com:4242" \
--opentsdb-db "sawtooth"
```

For REST API.

```bash
sawtooth-rest-api -vv \
--opentsdb-url "http://sawtooth:metrics@tsdb.example.com:4242" \
--opentsdb-db "sawtooth"
```

</p>
</details>

## Configure transaction processor endpoint

Configure the `intkey` transaction processor to connect to `host1` validator on port `4004`

```bash
intkey-tp-python -vv --connect tcp://host1:4004
```

## Configure systemd services

Enable "Debug" verbosity to systemd service `sawtooth-validator`.

<details><summary>show</summary>
<p>

Edit the Systemd Environment file `/etc/default/sawtooth-validator` and add `-vv` to the `SAWTOOTH_VALIDATOR_ARGS` environment variable.

```bash
SAWTOOTH_VALIDATOR_ARGS="--vv"
```

</p>
</details>

## Choose parallel / sync scheduler

Configure `parallel` transaction processing scheduler.

<details><summary>show</summary>
<p>

The default transaction scheduler is set to `serial` processing.

## Method 1

Edit the `/etc/sawtooth/validator.toml` configuration file, then search for the `scheduler` and replace the `serial` value by `parallel`.

```toml
...
# The type of scheduler to use. The choices are 'serial' or 'parallel'.
scheduler = 'parallel'
...
```

### Method 2

Use command line arguments to enforce the scheduler configuration.

```bash
sudo sawtooth-validator --scheduler "parallel"
```

</p>
</details>

## Configure storage paths

Configure storage path in order to point to the `sawtooth` home directory.
Use the following configuration.

Item | path
---- | ----
Configuration | `/home/sawtooth/conf`
Keys | `/home/sawtooth/conf/keys`
Data | `/home/sawtooth/data`
Log  | `/home/sawtooth/logs`
Policy | `/home/sawtooth/policy`

<details><summary>show</summary>
<p>

```bash
sudo cp /etc/sawtooth/path.toml.example /etc/sawtooth/path.toml

sudo mkdir -p /home/sawtooth/conf/keys /home/sawtooth/data /home/sawtooth/logs /home/sawtooth/policy

sudo cp /etc/sawtooth/*.toml /home/sawtooth/conf/
sudo cp /etc/sawtooth/*.pem /home/sawtooth/conf/
sudo cp /etc/sawtooth/keys/*.* /home/sawtooth/conf/keys/

cat << EOF > /etc/sawtooth/path.toml
conf_dir = "/home/sawtooth/conf"
key_dir = "/home/sawtooth/conf/keys"
data_dir = "/home/sawtooth/data"
log_dir = "/home/sawtooth/logs"
policy_dir = "/home/sawtooth/policy"
EOF
```

</p>
</details>

## Configure Sawtooth CLI

Configure the Sawtooth CLI to connect to `host1` and list blocks.

<details><summary>show</summary>
<p>

### Method 1

Using configuration file.

```bash
cat << EOF > /etc/sawtooth/path.toml
# REST API URL
url = "http://localhost:8008"
EOF

sawtooth block list
```

### Method 2

Using command line arguments.

```bash
sawtooth block list --url http://host1:8008
```

</p>
</details>