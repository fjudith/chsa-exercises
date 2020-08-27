# Configure metrics

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes 2 containers `chsa-b7-00` et `chsa-b7-01`.
The `validator`, `settings-tp` and `rest-api` services are installed and running on `chsa-b7-00`.

`chsa-b7-01` runs `intkey-tp-python` and `xo-tp-python` services are installed and running on `chsa-b7-01`.

Configure the Validator service to allow connection from Transaction processors.

<details><summary>show</summary>
<p>

## Configure Validator service

1. Open a terminal session on the Validator host.

```bash
docker exec -u sysops -it chsa-b7-00 bash
```

2. Edit the Validator configration file `/etc/sawtooth/validator.toml` to expose the `componet` port.

```toml
...
bind = [
  "network:tcp://127.0.0.1:8800",
  "component:tcp://eth0:4004"
]
...
```

3. Restart the Validator service.

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
