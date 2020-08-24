FROM docker.io/amd64/ubuntu:16.04

ENV container=docker LANG=C.UTF-8

# Enable all repositories
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# Install packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    dbus \
    systemd \
    systemd-cron \
    rsyslog \
    iproute2 \
    sudo \
    software-properties-common && \
    apt-get clean && \
    rm -rf /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i 's/^\(module(load="imklog")\)/#\1/' /etc/rsyslog.conf

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*dbus*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN systemctl set-default multi-user.target && \
    systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount

# Create custom user
RUN groupadd --gid 1001 sysops && \
    useradd --uid 1001 --gid sysops --shell /bin/bash --create-home sysops && \
    echo "sysops ALL=(ALL:ALL) NOPASSWD:ALL" | tee -a /etc/sudoers.d/sysops

# Activate custom user
USER sysops

VOLUME ["/sys/fs/cgroup", "/tmp", "/run", "/run/lock"]

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init", "--log-target=journal"]