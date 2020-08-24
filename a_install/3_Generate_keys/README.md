# Generate keys

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-a3-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-a3-00 bash
```

Generate validator keys, then generate Transactor keys for the `sysops` user its home directory under the `.sawtooth/keys`.

<details><summary>show</summary>
<p>

## Generate validator keys

```bash
# Validator key
sudo sawadm keygen
```

```text
writing file: /etc/sawtooth/keys/validator.priv
writing file: /etc/sawtooth/keys/validator.pub
```

## Generate transaction processor keys

```bash
mkdir -p ~/.sawtooth/keys
sudo sawtooth keygen --key-dir "/home/sysops/.sawtooth/keys/" sysops
```

```text
writing file: /home/sysops/.sawtooth/keys/sysops.priv
writing file: /home/sysops/.sawtooth/keys/sysops.pub
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
