# Configure validator peering and network

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes the following hosts:

host | services
---- | --------
`chsa-b9-00` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-b9-01` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-b9-02` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-b9-influxdb` | InfluxDB time series database
`chsa-b9-grafana` | Grafana monitoring visualization <http://localhost:53000>
`chsa-b9-loadgen` | Intkey load generator

The load generator is randomly raising the following issue

```text
Error: Error 429: Too Many Requests
Writing to batches.intkey...
[01:28:05 WARNING load] (429): Too Many Requests
```

<details><summary>show</summary>
<p>

## Configure peering on `chsa-b7-00`

1. Open a terminal session.

```bash
docker exec -u sysops -it chsa-b7-00 bash
```

2. Edit the Validator configuration file  `/etc/sawtooth/validator.toml`.

```toml
...
bind = [
  "network:tcp://eth0:8800",
  "component:tcp://127.0.0.1:4004"
]
...
endpoint = "tcp://chsa-b9-00:8800"
...
peering = "dynamic"
...
```

3. Restart the `sawtooth-validator` service.

```bash
sudo systemctl restart sawtooth-validator
```

## Configure peering on `chsa-b9-01`

1. Open a terminal session.

```bash
docker exec -u sysops -it chsa-b9-01 bash
```

2. Edit the Validator configuration file  `/etc/sawtooth/validator.toml`.

```toml
...
bind = [
  "network:tcp://eth0:8800",
  "component:tcp://127.0.0.1:4004"
]
...
endpoint = "tcp://chsa-b9-01:8800"
...
peering = "dynamic"
...
seeds = ["tcp://chsa-b9-00:8800"]
...
```

3. Enable and start services.

```bash
sudo sawadm keygen
sudo systemctl enable sawtooth-validator sawtooth-settings-tp sawtooth-rest-api
sudo systemctl start sawtooth-validator sawtooth-settings-tp sawtooth-rest-api
```

## Configure peering on `chsa-b9-02`

1. Open a terminal session.

```bash
docker exec -u sysops -it chsa-b9-02 bash
```

2. Edit the Validator configuration file  `/etc/sawtooth/validator.toml`.

```toml
...
bind = [
  "network:tcp://eth0:8800",
  "component:tcp://127.0.0.1:4004"
]
...
endpoint = "tcp://chsa-b9-02:8800"
...
peering = "dynamic"
...
seeds = ["tcp://chsa-b9-00:8800"]
...
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
