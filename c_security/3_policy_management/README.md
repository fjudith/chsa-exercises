# Policy management

Build and run the `Ubuntu 16.04 (Xenial)` containers.

```bash
docker-compose up --build -d
```

The stack includes the following hosts:

host | services
---- | --------
`chsa-c3-00` | `validator`, `identity-tp`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c3-01` | `validator`, `identity-tp`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c3-02` | `validator`, `identity-tp`, `settings-tp`, `intkey-tp-python`, `xo-tp-python` and `rest-api`
`chsa-c3-loadgen` | Intkey load generator

1. Configure a policy name `users` denying all transactor connections.
2. Allow the `loadgen` to submit transactions to the network.


<details><summary>show</summary>
<p>

## Retreive the Intey load generator public key.

1. Open a terminal session in the Intkey load generator.

```bash
docker exec -it chsa-c3-loadgen bash
```

2. Copy the public key.

```bash
cat ~/.sawtooth/keys/loadgen.pub
```

```text
020aeb8bfa270f90c01961df6f25f084c61b1854bcc3285d8594380920ab841b44
```

## Create the On-Chain policy

1. Open a terminal session in the `chsa-c3-00`.

```bash
docker exec -u sysops -it chsa-c3-00 bash
```

2. Configure the identity transaction siger public key.

```bash
sawset proposal create \
sawtooth.identity.allowed_keys=$(cat ~/.sawtooth/keys/sysops.pub)
```

3. Configure the policy.

```bash
sawtooth identity policy create \
users "PERMIT_KEY $(cat ~/.sawtooth/keys/sysops.pub)" "DENY_KEY *"
```

```text
Policy committed in 11.4227 sec
```

4. Create the role that includes the policy.

```bash
sawtooth identity role create transactor users
```

```text
Role committed in 7.13635 sec
```

5. Add the `loadgen` user public key to the policy.

```bash
sawtooth identity policy create \
users "PERMIT_KEY 020aeb8bfa270f90c01961df6f25f084c61b1854bcc3285d8594380920ab841b44"
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
