# Install Sawtooth packages

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-a1-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-a1-00 bash
```

Simply install Hyperledger Sawtooth v1.0.5.

<details><summary>show</summary>
<p>

1. Check the number of CPU.

```bash
grep 'cpu cores' /proc/cpuinfo | uniq
```

```text
cpu cores       : 6
```

2. Check the amount of Memory.

```bash
grep 'MemTotal' /proc/meminfo
```

```text
MemTotal:       26237788 kB
```

## Reference

> It is commonly assumed that Hyperledger Sawtooth requires at least 2 CPU (sockets/cores) and 4GB of RAM
> But the documentation does not specifies any hardware recommendations.

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
