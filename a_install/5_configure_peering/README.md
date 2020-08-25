# Configure Peering

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes 3 containers `chsa-a5-00`, `chsa-a5-01` and `chsa-a5-02`.
The `validator`, `settings-tp` and `rest-api` services are already installed.

Only `chsa-a5-00` is currently configured and running locally.

Configure dynamic peering and start the services in the remaining hosts.

> **Warning**: Modification of TOML configuration files is not permitted.

<details><summary>show</summary>
<p>

## Configure peering on `chsa-a5-00`

1. Open a terminal session.

```bash
docker exec -u sysops -it chsa-a5-00 bash
```

2. Add the following line to the environment file `/etc/default/sawtooth-validator`.

```bash
SAWTOOTH_VALIDATOR_ARGS="--peering dynamic --bind network:tcp://eth0:8800 --endpoint tcp://chsa-a5-00:8800"
```

3. Restart the `sawtooth-validator` service.

```bash
sudo systemctl restart sawtooth-validator
```

## Configure peering on `chsa-a5-01`

1. Open a terminal session.

```bash
docker exec -u sysops -it chsa-a5-01 bash
```

2. Add the following line to the environment file `/etc/default/sawtooth-validator`.

```bash
SAWTOOTH_VALIDATOR_ARGS="--peering dynamic --bind network:tcp://eth0:8800 --endpoint tcp://chsa-a5-01:8800 --seed tcp://chsa-a5-00:8800"
```

3. Enable and start services.

```bash
sudo sawadm keygen
sudo systemctl enable sawtooth-validator sawtooth-settings-tp sawtooth-rest-api
sudo systemctl start sawtooth-validator sawtooth-settings-tp sawtooth-rest-api
```

## Configure peering on `chsa-a5-02`

1. Open a terminal session.

```bash
docker exec -u sysops -it chsa-a5-02 bash
```

2. Add the following line to the environment file `/etc/default/sawtooth-validator`.

```bash
SAWTOOTH_VALIDATOR_ARGS="--peering dynamic --bind network:tcp://eth0:8800 --endpoint tcp://chsa-a5-02:8800 --seed tcp://chsa-a5-00:8800"
```

3. Enable and start services.

```bash
sudo sawadm keygen
sudo systemctl enable sawtooth-validator sawtooth-settings-tp sawtooth-rest-api
sudo systemctl start sawtooth-validator sawtooth-settings-tp sawtooth-rest-api
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Running Sawtooth as a Service: [Running Sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html#running-sawtooth)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > CLI Command Reference > sawtooth > [sawtooth peer list](https://sawtooth.hyperledger.org/docs/core/releases/1.0/cli/sawtooth.html#sawtooth-peer-list)
* sawtooth.hyperledger.org > FAQ > Validator > [What TCP ports does Sawtooth use?](https://sawtooth.hyperledger.org/faq/validator/#what-tcp-ports-does-sawtooth-use)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
