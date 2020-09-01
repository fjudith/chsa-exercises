# Configure consensus

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-b2-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-b2-00 bash
```

The `validator`, `settings-tp` and `rest-api` services are installed and running.

Add the Poet transaction processor and configure the consensus algorithm.

<details><summary>show</summary>
<p>

1. Check if PoET service is available. 

> If not, run `sudo apt-get install python3-sawtooth-poet-core`.

```bash
sudo ls /lib/systemd/system/sawtooth-poet-validator-registry-tp.service
```

2. Enable and start the service.

```bash
sudo systemctl enable sawtooth-poet-validator-registry-tp
sudo systemctl start sawtooth-poet-validator-registry-tp
```

3. Submit PoET algorithm on-chain configuration.


 ```bash
 cd /tmp
sudo -u sawtooth poet registration create -k /etc/sawtooth/keys/validator.priv

sudo sawset proposal create -k /etc/sawtooth/keys/validator.priv \
sawtooth.consensus.algorithm=poet \
sawtooth.poet.report_public_key_pem="$(cat /etc/sawtooth/simulator_rk_pub.pem)" \
sawtooth.poet.valid_enclave_measurements="$(poet enclave measurement)" \
sawtooth.poet.valid_enclave_basenames="$(poet enclave basename)"

sudo sawset proposal create -k /etc/sawtooth/keys/validator.priv \
sawtooth.publisher.max_batches_per_block=1 \
sawtooth.poet.target_wait_time=10 \
sawtooth.poet.initial_wait_time=20
 ```

4. Validate that new settings are implemented

```bash
sawtooth settings list
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Running Sawtooth as a Service: [Running Sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/systemd.html#running-sawtooth)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > CLI Command Reference > sawset > [sawset proposal create](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/cli/sawset.html#sawset-proposal-create)
* sawtooth.hyperledger.org > Docs > Release 1.0.5 > Transaction Family Spectifications > Validator Registry Transaction Family > [What TCP ports does Sawtooth use?](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/transaction_family_specifications/validator_registry_transaction_family.html)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
