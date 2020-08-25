# Register validator

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes 3 containers `chsa-a4-00`, `chsa-a4-01` and `chsa-a4-02`.

**Only** `chsa-a4-01` and `chsa-a4-02` are already forming a network, but only `chsa-a4-01` runs the `rest-api`.

Add `chsa-a4-00` to the network.

As previous exercices, use `docker exec -u sysops -it <container_name> bash` to open a terminal session in containers.

<details><summary>show</summary>
<p>

## Generate Validator key pair

```bash
docker exec -u sysops -it chsa-a4-00 bash
```

1. Generate a new Validator key.

```bash
sudo sawadm keygen
```

```text
writing file: /etc/sawtooth/keys/validator.priv
writing file: /etc/sawtooth/keys/validator.pub
```

## Configure the Validator

1. Copy the validator configuration example.

```bash
sudo cp /etc/sawtooth/validator.toml.example /etc/sawtooth/validator.toml
```

2. Edit the `/etc/sawtooth/validator.toml` configuration file in order to:

* Expose the validator
  * Change the `network` listening interface.
  * Change The `endpoint` listening interface.
* Fill the list of peers

```toml
...
# Bind is used to set the network and component endpoints. It should be a list
# of strings in the format "option:endpoint", where the options are currently
# network and component.
bind = [
    "network:tcp://eth0:8800",
    "component:tcp://127.0.0.1:4004"
]
...
# Advertised network endpoint URL.
endpoint = "tcp://127.0.0.1:8800"
...
# A list of peers to attempt to connect to in the format tcp://hostname:port.
# It defaults to None.
peers = ["tcp://chsa-a4-01:8800","tcp://chsa-a4-02:8800"]
...
```

3. Enable the minimal set of services (i.e. `validator` and `settings-tp`)

```bash
sudo systemctl enable sawtooth-validator
sudo systemctl enable sawtooth-settings-tp
```

4. Start services

```bash
sudo systemctl start sawtooth-validator
sudo systemctl start sawtooth-settings-tp
```

6. Exit the `chsa-a4-00` container.
5. Perform sanity checks using the REST API

```bash
docker exec -u sysops -it chsa-a4-01 bash -c 'sudo sawtooth peer list'
```

```text
tcp://chsa-a4-00:8800,tcp://chsa-a4-02:8800,tcp://chsa-a4-02:8800
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Running Sawtooth as a Service: [Running Sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html#running-sawtooth)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > CLI Command Reference > sawadm > [sawadm keygen](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html#running-sawtooth)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > CLI Command Reference > sawtooth > [sawtooth keygen](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/cli/sawtooth.html#sawtooth-keygen)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
