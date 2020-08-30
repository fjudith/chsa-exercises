# Permission a transaction processor

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes the following hosts:

host | services
---- | --------
`chsa-c2-00` | `validator`, **`identity-tp`**, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c2-01` | `validator`, **`identity-tp`**, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c2-02` | `validator`, **`identity-tp`**, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c2-influxdb` | InfluxDB time series database
`chsa-c2-grafana` | Grafana monitoring visualization <http://localhost:53000>  (u:admin/p:admin)
`chsa-c2-loadgen` | Intkey load generator

The `loadgen` is repeatedly raising the following error message (ref. `docker logs chsa-c2-loadgen`).

```text
Running command: intkey set QOul667n 22173 --url "http://chsa-c2-00:8008"
Error: Error 400: Bad Request
...
Running command: intkey set csLm9Xdy 17854 --url "http://chsa-c2-01:8008"
Error: Error 400: Bad Request
...
Running command: intkey set xvSsv0DP 16021 --url "http://chsa-c2-02:8008"
Error: Error 400: Bad Request
```

Configure the network to allow the `loadgen` Transaction processor to connect to the API.

<details><summary>show</summary>
<p>

## Retreive the Intey load genrator public key.

1. Open a terminal session in the Intkey load generator.

```bash
docker exec -u sysops -it chsa-c2-loadgen bash
```

2. Copy the public key.

```bash
cat ~/.sawtooth/keys/loadgen.pub
```

```text
020aeb8bfa270f90c01961df6f25f084c61b1854bcc3285d8594380920ab841b44
```

## Update policy on `chsa-c2-00`

1. Open a terminal session in the `chsa-c2-00`.

```bash
docker exec -u sysops -it chsa-c2-00 bash
```

2. Add the following line at the top of the policy file `/etc/sawtooth/policy/policy.example`.

```text
PERMIT_KEY 020aeb8bfa270f90c01961df6f25f084c61b1854bcc3285d8594380920ab841b44
```

3. Restart the Validator service.

```bash
sudo systemctl restart sawtooth-validator
```

## Update policy on `chsa-c2-01`

1. Open a terminal session in the `chsa-c2-01`.

```bash
docker exec -u sysops -it chsa-c2-01 bash
```

2. Add the following line at the top of the policy file `/etc/sawtooth/policy/policy.example`.

```text
PERMIT_KEY 020aeb8bfa270f90c01961df6f25f084c61b1854bcc3285d8594380920ab841b44
```

3. Restart the Validator service.

```bash
sudo systemctl restart sawtooth-validator
```

## Update policy on `chsa-c2-02`

1. Open a terminal session in the `chsa-c2-02`.

```bash
docker exec -u sysops -it chsa-c2-02 bash
```

2. Add the following line at the top of the policy file `/etc/sawtooth/policy/policy.example`.

```text
PERMIT_KEY 020aeb8bfa270f90c01961df6f25f084c61b1854bcc3285d8594380920ab841b44
```

3. Restart the Validator service.

```bash
sudo systemctl restart sawtooth-validator
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administrator's Guide > Configuring Permissions > [Off-Chain Transactor Permissioning](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/configuring_permissions.html#off-chain-transactor-permissioning)
* **Missing in 1.0.5 documentation**: [Install identity TP](https://stackoverflow.com/questions/49302852/how-to-use-sawtooth-identity-tp-processor)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
