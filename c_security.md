# Permissioning, Identity Management, and Security (20%)

## Identify network ID / system / peer ID

Retreive Sawtooth Network, System, Peer IDs from `host1`.

<details><summary>show</summary>
<p>

### Method 1

Using Sawtooth CLI.

```bash
sawtooth batch list --url http://host1:8008
sawtooth state list --url http://host1:8008
sawtooth peer list --url http://host1:8008
sawtooth transaction list --url http://host1:8008
```

## Method 2

Using CuRL.

```bash
curl http://host1:8008/batches
curl http://host1:8008/state
curl http://host1:8008/peers
curl http://host1:8008/transactions
```

</p>
</details>

## Permission a transaction processor



### Method 1

Using the On-Chain method.

<details><summary>show</summary>
<p>

```bash


</p>
</details>