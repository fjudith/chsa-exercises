# Install Sawtooth packages

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-a1-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-a1-00 bash
```

Simply install Hyperledger Sawtooth v1.0.5.

<details><summary>show</summary>
<p>

```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD
sudo add-apt-repository 'deb http://repo.sawtooth.me/ubuntu/1.0/stable xenial universe'

sudo apt-get update
sudo apt-get install -y sawtooth
```

## Reference

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > [Installing Hyperledger Sawtooth](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/installation.html)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose rm --force --stop -v
```
