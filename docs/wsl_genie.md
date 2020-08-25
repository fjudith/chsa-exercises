# Run Systemd services / Containers on WSL 2

Thanks to [Genie](https://github.com/arkane-systems/genie)

Successfuly tested Ubuntu 20.04 Focal Fossa form @cerebrate

```bash
sudo apt install daemonize dbus policykit-1 systemd

# add Microsoft repo with .Net 3.1 runtime
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

curl -s https://packagecloud.io/install/repositories/arkane-systems/wsl-translinux/script.deb.sh | sudo bash
sudo apt install -y systemd-genie
```

Add configuration `/usr/lib/genie/deviated-preverts.conf`:

```json
{
  "daemonize": "/usr/bin/daemonize",
  "mount": "/bin/mount",
  "runuser": "/sbin/runuser",
  "systemd": "/bin/systemd"
}
```

Restart WSL with Genie

```shell
wsl.exe genie -i
```