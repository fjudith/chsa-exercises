# Verify install and fix if necessary

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes 3 containers `chsa-a6-00`, `chsa-a6-01` and `chsa-a6-02`.
The `validator`, `settings-tp` and `rest-api` services are installed.
`chsa-a6-01` has been rebooted earlier, but it did'nt reconnects to the Validator network.

<details><summary>show</summary>
<p>

## Check visible peers from all hosts

```bash
docker exec -u sysops -it chsa-a6-00 bash -c 'sudo sawtooth peer list'
docker exec -u sysops -it chsa-a6-01 bash -c 'sudo sawtooth peer list'
docker exec -u sysops -it chsa-a6-02 bash -c 'sudo sawtooth peer list'
```
## Check if all services are listening

```bash
docker exec -u sysops -it chsa-a6-00 bash -c 'sudo ss -anlp | grep sawtooth'
docker exec -u sysops -it chsa-a6-01 bash -c 'sudo ss -anlp | grep sawtooth'
docker exec -u sysops -it chsa-a6-02 bash -c 'sudo ss -anlp | grep sawtooth'
```

## Check services logs

```bash
docker exec -u sysops -it chsa-a6-00 bash -c 'sudo journalctl -l -u sawtooth-validator -u sawtooth-settings-tp -u sawtooth-rest-api'
docker exec -u sysops -it chsa-a6-01 bash -c 'sudo journalctl -l -u sawtooth-validator -u sawtooth-settings-tp -u sawtooth-rest-api'
docker exec -u sysops -it chsa-a6-02 bash -c 'sudo journalctl -l -u sawtooth-validator -u sawtooth-settings-tp -u sawtooth-rest-api'
```

> Settings transaction processor is not started on `chsa-a6-01`.

## Troubleshoot and Fix

1. Open a terminal session in `chsa-a6-01`, then check the status of the `sawtooth-settings-tp` service.

```bash
docker exec -u sysops -it chsa-a6-01 bash

sudo systemctl status sawtooth-settings-tp
```

```text
● sawtooth-settings-tp.service - Sawtooth TP Settings
   Loaded: loaded (/lib/systemd/system/sawtooth-settings-tp.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
```

> Automatic startup is `disabled`. Meaning the service will not start at boot time.

2. Enable the service, and restart the service.

```bash
sudo systemctl enable sawtooth-settings-tp

sudo systemctl start sawtooth-settings-tp
```

3. Check and validate

```bash
sudo systemctl status sawtooth-settings-tp
```

```text
● sawtooth-settings-tp.service - Sawtooth TP Settings
   Loaded: loaded (/lib/systemd/system/sawtooth-settings-tp.service; enabled; vendor preset: enabled)
...
Aug 25 12:47:55 chsa-a6-01 systemd[1]: Started Sawtooth TP Settings.
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Running Sawtooth as a Service: [Running Sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html#running-sawtooth)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > CLI Command Reference > sawtooth > [sawtooth peer list](https://sawtooth.hyperledger.org/docs/core/releases/1.0/cli/sawtooth.html#sawtooth-peer-list)
* sawtooth.hyperledger.org > FAQ > Validator > [What TCP ports does Sawtooth use?](https://sawtooth.hyperledger.org/faq/validator/#what-tcp-ports-does-sawtooth-use)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
