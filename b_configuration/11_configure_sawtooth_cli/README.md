# Configure sawtooth cli

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-b11-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-b11-00 bash
```

The `validator`, `settings-tp`, `xo-tp-python`, `intkey-tp-python` and `rest-api` services are installed and running.

The Rest API has been exposed to allow third parties to connect.

Configure the CLI in order to avoid passing the `--url` argument every time to the `sawtooth` command.

<details><summary>show</summary>
<p>

1. Copy the CLI configuration file example.

```bash
sudo cp -av /etc/sawtooth/cli.toml.example /etc/sawtooth/cli.toml
```

2. Add the following line to the CLI configuration file `/etc/sawtooth/cli.toml`.

```toml
url = "http://chsa-b11-00:8008"
```

* Fix the CLI configuration file permissions.

```bash
sudo chmod +r /etc/sawtooth/cli.toml
```

2. Test the CLI.

```bash
sawtooth block list
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > [Configuring Sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/path_configuration_file.html)

* Issue (limited scope of use) > (https://jira.hyperledger.org/browse/STL-1308)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
