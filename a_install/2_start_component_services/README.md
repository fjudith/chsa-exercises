# Start component services

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-a2-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-a2-00 bash
```

Simply start the `sawtooth-validator` service and check the logs.

<details><summary>show</summary>
<p>

```bash
sudo systemctl start sawtooth-validator

sudo journalctl -lu sawtooth-validator
```

## References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > [Running Sawtooth as a Service](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
