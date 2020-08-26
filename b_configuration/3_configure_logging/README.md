# Configure logging

Build and run the `Ubuntu 16.04 (Xenial)` container, then open an interactive shell inside the `chsa-b3-00` container.

```bash
docker-compose up --build -d

docker exec -u sysops -it chsa-b3-00 bash
```

The `validator`, `settings-tp` and `rest-api` services are installed and running.

`rsyslog` service is also running.

Configure sawtooth logs if order to send logs to `rsyslog`

<details><summary>show</summary>
<p>

1. Create a YAML Log configuration file `/etc/sawtooth/log_config.yaml`.

```bash
sudo touch /etc/sawtooth/log_config.yaml
```

2. Edit the file with the following content
   
```yaml
version: 1
formatters:
  simple:
    format: "[%(asctime)s.%(msecs)03d [%(threadName)s] %(module)s %(levelname)s] %(message)s"
    datefmt: "%H:%M:%S"
  
handlers:
  syslog:
    level: "DEBUG"
    formatter: "simple"
    class: "logging.handlers.SysLogHandler"
    address: ["localhost", "514"]
    facility: "LOG_USER"
    socktype: "ext://socket.SOCK_DGRAM"


loggers:
  sawtooth_validator.networking.interconnect:
    level: "DEBUG"
    propagate: false
    handlers: [ "syslog"]
```

### References

* sawtooth.hyperledger.org > Docs > Release 1.0.5  > System Administator's Guide > Configuring Sawtooth [Log Configuration](https://sawtooth.hyperledger.org/docs/core/releases/1.0.5/sysadmin_guide/log_configuration.html)
* External documentation [SysLogHandler](https://docs.python.org/3/library/logging.handlers.html#sysloghandler)
* Resolve [NameError: name 'socket' is not defined](https://stackoverflow.com/questions/36770053/how-to-refer-to-a-standard-library-in-a-logging-configuration-file)

</p>
</details>

Once finished, run the following command to stop and cleanup the docker lab environment.

```bash
docker-compose down --remove-orphans -v
```
