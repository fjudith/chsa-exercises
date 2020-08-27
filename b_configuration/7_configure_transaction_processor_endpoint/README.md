# Configure metrics

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes 2 containers `chsa-b7-00` et `chsa-b7-01`.
The `validator`, `settings-tp` and `rest-api` services are installed and running on `chsa-b7-00`.

`chsa-b7-01` runs `intkey-tp-python` and `xo-tp-python` services are installed and running on `chsa-b7-01`.

Check that Transaction processor are successfully registred in the Validator.
Fix the issue if required.

<details><summary>show</summary>
<p>

## Configure Validator service

1. Open a terminal session on the Validator host.

```bash
docker exec -u sysops -it chsa-b7-00 bash
```

2. Check the Validator logs.

```bash
sudo cat /var/log
```

2. Edit the Validator configuration file service `/etc/sawtooth/validator.toml`.

```toml
...
# The host and port for Open TSDB database used for metrics
opentsdb_url = "http://chsa-b7-01:8086"

# The name of the database used for storing metrics
opentsdb_db = "metrics"

opentsdb_username = "lrdata"

opentsdb_password = "{lrdata-pw}"
...
```

3. Restart the Validator service.

```bash
sudo systemctl restart sawtooth-validator
```

## Configure REST API service

1. Edit the REST API configuration file service `/etc/sawtooth/rest_api.toml`.

```toml
...
# The host and port for Open TSDB database used for metrics
opentsdb_url = "http://chsa-b7-01:8086"

# The name of the database used for storing metrics
opentsdb_db = "metrics"

opentsdb_username = "lrdata"
opentsdb_password = "{lrdata-pw}"
...
```

2. Restart the REST API service.

```bash
sudo systemctl restart sawtooth-rest-api
```

## Configure Telegraf (optional)

1. Edit the REST API configuration file service `/etc/telegraf/telegraf.conf`.

```toml
...
[[outputs.influxdb]]
  urls = ["http://chsa-b7-01:8086"]
  database = "metrics"
  username = "lrdata"
  password = "{lrdata-pw}"
  skip_database_creation  = true
...
```

2. Restart the REST API service.

```bash
sudo systemctl restart telegraf
```

## Query the InfluxDB database

```bash
# Show database
curl -u  'lrdata:{lrdata-pw}' -G 'http://chsa-b7-01:8086/query?pretty=true' --data-urlencode "db=metrics" --data-urlencode "q=SHOW DATABASES"

# Show measurements (metrics)
curl -u  'lrdata:{lrdata-pw}' -G 'http://chsa-b7-01:8086/query?pretty=true' --data-urlencode "db=metrics" --data-urlencode "q=SHOW MEASUREMENTS"

# 
curl -u  'lrdata:{lrdata-pw}' -G 'http://chsa-b7-01:8086/query?pretty=true' --data-urlencode "db=metrics" --data-urlencode 'q=SELECT value FROM "sawtooth_validator.block_num"'
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Configuring Sawtooth > [Validator Configuration File](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/validator_configuration_file.html)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > System Administrator’s Guide > Configuring Sawtooth > [REST API Configuration File](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/rest_api_configuration_file.html)
* sawtooth.hyperledger.org > Docs > Release **1.1** > System Administrator’s Guide > [Using Grafana to Display Sawtooth Metrics](https://sawtooth.hyperledger.org/docs/core/releases/1.1/sysadmin_guide/grafana_configuration.html#configure-the-sawtooth-validator-for-grafana)

* docs.influxdata.org > Guides > [Query data with the InfluxDB API](https://docs.influxdata.com/influxdb/v1.8/guides/query_data/)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
