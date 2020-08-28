# Identify network ID / system / peer ID

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes the following hosts:

host | services
---- | --------
`chsa-c2-00` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c2-01` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c2-02` | `validator`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c2-loadgen` | Intkey load generator

Retreive the following informations

* Vote permission key
* List of batches
* List of peers
* List of transactions

<details><summary>show</summary>
<p>

1. Open a terminal session in the Intkey load generator

```bash
docker exec -it chsa-c2-loadgen bash
```

## Method 1

Using Sawtooth CLI.

```bash
sawtooth settings list --filter sawtooth.settings.vote.authorized_key --url http://chsa-c2-00:8008
sawtooth batch list --url http://chsa-c2-01:8008
sawtooth state list --url http://chsa-c2-02:8008
sawtooth peer list --url http://chsa-c2-00:8008
sawtooth transaction list --url http://chsa-c2-01:8008
```

## Method 2

Using CuRL.

```bash
curl http://chsa-c2-00:8008/batches
curl http://chsa-c2-01:8008/state
curl http://chsa-c2-02:8008/peers
curl http://chsa-c2-00:8008/transactions
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > CLI Command Reference > [sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/cli/sawtooth.html)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
