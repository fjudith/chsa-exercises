# Identify network ID / system / peer ID

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes the following hosts:

host | services
---- | --------
`chsa-c1-00` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c1-01` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c1-02` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c1-loadgen` | Intkey load generator


<details><summary>show</summary>
<p>

1. Open a terminal session in the Intkey load generator

```bash
docker exec -it chsa-c1-loadgen bash
```

## Method 1

Using Sawtooth CLI.

```bash
sawtooth batch list --url http://chsa-c1-00:8008
sawtooth state list --url http://chsa-c1-01:8008
sawtooth peer list --url http://chsa-c1-02:8008
sawtooth transaction list --url http://chsa-c1-00:8008
```

## Method 2

Using CuRL.

```bash
curl http://chsa-c1-00:8008/batches
curl http://chsa-c1-01:8008/state
curl http://chsa-c1-02:8008/peers
curl http://chsa-c1-00:8008/transactions
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Configuring Sawtooth > [Validator Configuration File](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_sawtooth/validator_configuration_file.html)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
