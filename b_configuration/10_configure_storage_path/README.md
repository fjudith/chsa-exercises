# Configure storage path

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-b10-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-b10-00 bash
```

The `validator`, `settings-tp`, `xo-tp-python`, `intkey-tp-python` and `rest-api` services are installed and running.

Migrate all data to the `sawtooth` home directory.

<details><summary>show</summary>
<p>

1. Create target directories with appropriate permissions.

```bash
sudo mkdir -p \
/home/sawtooth/keys \
/home/sawtooth/data \
/home/sawtooth/logs \
/home/sawtooth/policy
```

2. Stop all services.

```bash
sudo systemctl stop \
sawtooth-validator \
sawtooth-settings-tp \
sawtooth-rest-api \
sawtooth-xo-tp-python \
sawtooth-intkey-tp-python
```

3. Migrate data in the appropriate directory.

```bash
sudo cp -va /etc/sawtooth/keys/. /home/sawtooth/keys/
sudo cp -va /var/lib/sawtooth/. /home/sawtooth/data/
sudo cp -va /var/log/sawtooth/. /home/sawtooth/logs/
sudo cp -v /etc/sawtooth/policy/. /home/sawtooth/policy/
```

4. Set appropriate permissions for services.

```bash
sudo chown -R sawtooth:sawtooth \
/home/sawtooth/data \
/home/sawtooth/keys \
/home/sawtooth/logs \
/home/sawtooth/policy
```

5. Copy the Log configuration example.

```bash
sudo cp /etc/sawtooth/path.toml.example /etc/sawtooth/path.toml
```

6. Add the following content to the Log configuration file `/etc/sawtooth/log_config.toml`.

```toml
...
key_dir  = "/home/sawtooth/keys"
data_dir = "/home/sawtooth/data"
log_dir  = "/home/sawtooth/logs"
policy_dir  = "/home/sawtooth/policy"
...
```

7. Fix the Log configuration file permissions.

```bash
sudo chown sawtooth:sawtooth /etc/sawtooth/path.toml
```

8. Restart services.

```bash
sudo systemctl restart \
sawtooth-validator \
sawtooth-settings-tp \
sawtooth-rest-api \
sawtooth-xo-tp-python \
sawtooth-intkey-tp-python
```

9. Validate that authorized key is the same as previous configuration

```bash
sawtooth settings list | grep $(cat /home/sysops/.sawtooth/keys/sysops.pub)
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > [Configuring Sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/path_configuration_file.html)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
