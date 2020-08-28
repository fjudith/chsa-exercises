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

The load generator is frequently raising the following issue

```text
Error: Error 429: Too Many Requests
Writing to batches.intkey...
[01:28:05 WARNING load] (429): Too Many Requests
```

<details><summary>show</summary>
<p>

## Configure peering on `chsa-b9-00`

1. Open a terminal session.

```bash
docker exec -u sysops -it chsa-b9-00 bash
```

2. Edit the Validator configuration file  `/etc/sawtooth/validator.toml`.

```toml
...
scheduler = 'parallel'
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
scheduler = 'parallel'
...
```

3. Enable and start services.

```bash
sudo systemctl restart sawtooth-validator
```

## Configure peering on `chsa-b9-02`

1. Open a terminal session.

```bash
docker exec -u sysops -it chsa-b9-02 bash
```

2. Edit the Validator configuration file  `/etc/sawtooth/validator.toml`.

```toml
...
scheduler = 'parallel'
...
```

3. Enable and start services.

```bash
sudo systemctl restart sawtooth-validator
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Configuring Sawtooth > [Validator Configuration File](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/validator_configuration_file.html)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
