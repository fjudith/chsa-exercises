# Create genesis block

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-a8-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-a8-00 bash
```

The `validator`, `settings-tp` and `rest-api` services are installed and running.

Keys are already generated for the `sysops` user.

Create the Genesis block with limited use of the `sudo` command.


<details><summary>show</summary>
<p>

1. Create the Genesis Batch file.

```bash
sawset genesis -o ~/config-genesis.batch
```

2. Create the Genesis Block.

```bash
sudo sawadm genesis ~/config-genesis.batch
```

3. Restart the Validator service.

> The service must be restarted for the Genesis block to loaded.
> Either the `sawtooth settings list` will return a 503 HTTP error.

```bash
sudo systemctl restart sawtooth-validator
```

4. Check settings availability

```bash
sawtooth settings list
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5 > Running Sawtooth as a Service > [Create Genesis Block](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html#create-genesis-block)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > CLI Command Reference > sawset > [sawset genesis](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/cli/sawset.html#sawset-genesis)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > CLI Command Reference > sawadm > [sawadm genesis](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/cli/sawset.html#sawadm-genesis)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
