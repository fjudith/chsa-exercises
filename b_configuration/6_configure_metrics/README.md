# Configure metrics

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes 2 containers `chsa-b6-00` et `chsa-b6-01`.
The `validator`, `settings-tp` and `rest-api` services are installed and running locally only on `chsa-b6-00`.

`chsa-b6-01` runs an InfluxDB time series database listening on port `8086` with the following credentials:

* **Username**: `influxdb`
* **Password**: `V3ry1ns3cur3P4ssw0rd`

<details><summary>show</summary>
<p>

## Configure Validator service

1. Open a terminal session on the Validator host.

```bash
docker exec -it chsa-b6-00 bash
```

2. Edit the Validator configuration file service `/etc/sawtooth/validator.toml`.

```toml
...
# The host and port for Open TSDB database used for metrics
opentsdb_url = "http://chsa-b4-01:8086"

# The name of the database used for storing metrics
opentsdb_db = "sawtooth"

opentsdb_username = "influxdb"

opentsdb_password = "V3ry1ns3cur3P4ssw0rd"
...
```

3. Restart the Validator service.

```bash
sudo systemctl restart sawtooth-validator
```

## Configure REST API service

1. Edit the REST API configuration file service `/etc/sawtooth/rest_api.toml`

```toml
...
# The host and port for Open TSDB database used for metrics
opentsdb_url = "http://influxdb:8086"

# The name of the database used for storing metrics
opentsdb_db = "sawtooth"

opentsdb_username = "influxdb"

opentsdb_password = "V3ry1ns3cur3P4ssw0rd"
...
```

3. Restart the REST API service.

```bash
sudo systemctl restart sawtooth-rest-api
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > [Running Sawtooth as a Service](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html)
* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Configuring Sawtooth > [Validator Configuration File](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/validator_configuration_file.html)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > Transaction Family Spectifications > Validator Registry Transaction Family > [What TCP ports does Sawtooth use?](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/transaction_family_specifications/validator_registry_transaction_family.html)


</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
