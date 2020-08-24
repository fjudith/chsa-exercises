# Register validator

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes 3 containers `chsa-a4-00`, `chsa-a4-01` and `chsa-a4-02`.

**Only** `chsa-a4-01` and `chsa-a4-02` are already forming a network.

Add `chsa-a4-00` to the network.

As previous exercices, use `docker exec -u sysops -it <container_name> bash` to open a terminal session in containers.

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
