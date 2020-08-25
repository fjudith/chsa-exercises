# Connect transaction processor to validator

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes 3 containers `chsa-a7-00`, `chsa-a7-01` and `chsa-a7-02`.
The `validator`, `settings-tp` and `rest-api` services are installed and running localy only on `chsa-a7-00`.

1. Expose the validator.
1. Connect the IntKey transaction processor from `chsa-a7-01`.
2. Connect the XO transaction processor from `chsa-a7-01`.

<details><summary>show</summary>
<p>

## Expose the validator

1. Open a terminal sesion.

```bash
docker exec -it chsa-a7-00 bash
```

2. Edit the Validator in order to expose the component service `/etc/sawtooth/validator.toml`.

```toml
...
bind = [
    "network://tcp://127.0.0.1:8800",
    "component://tcp://eth0:4004"
]
...
```

3. Restart the Validator service.

```bash
sudo systemctl restart sawtooth-validator
```

## Configure IntKey transaction processor

1. Open a terminal sesion.

```bash
docker exec -it chsa-a7-01 bash
```

2. Modify the target host in the Intkey transaction processor environment file.

```bash
SAWTOOTH_INTKEY_TP_PYTHON_ARGS=-v -C tcp://chsa-a7-00:4004
```

3. Enable and state the service.

```bash
sudo systemctl enable sawtooth-intkey-tp-python
sudo systemctl start sawtooth-intkey-tp-python
```

4. Validate the transaction processor registration

```bash
journalctl -lu sawtooth-intkey-tp-python
```

```text
-- Logs begin at Tue 2020-08-25 20:05:43 UTC, end at Tue 2020-08-25 20:33:14 UTC. --
Aug 25 20:20:29 chsa-a7-01 systemd[1]: Started Sawtooth Intkey TP Python.
Aug 25 20:20:29 chsa-a7-01 intkey-tp-python[74]: [2020-08-25 20:20:29.717 INFO     core] register attempt: OK
```



## Configure XO transaction processor

1. Open a terminal sesion.

```bash
docker exec -it chsa-a7-02 bash
```

2. Modify the target host in the Intkey transaction processor environment file.

```bash
SAWTOOTH_XO_TP_PYTHON_ARGS=-v -C tcp://chsa-a7-00:4004
```

3. Enable and state the service.

```bash
sudo systemctl enable sawtooth-xo-tp-python
sudo systemctl start sawtooth-xo-tp-python
```

4. Validate the transaction processor registration

```bash
journalctl -lu sawtooth-xo-tp-python
```

```text
-- Logs begin at Tue 2020-08-25 20:05:43 UTC, end at Tue 2020-08-25 20:34:15 UTC. --
Aug 25 20:20:13 chsa-a7-02 systemd[1]: Started Sawtooth XO TP Python.
Aug 25 20:20:13 chsa-a7-02 xo-tp-python[66]: [2020-08-25 20:20:13.809 INFO     core] register attempt: OK
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
