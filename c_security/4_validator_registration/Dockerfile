FROM docker.io/amd64/ubuntu:16.04

ENV container=docker LANG=C.UTF-8 \
    USER="sysops" \
    USERID="1001" \
    GROUP="sysops" \
    GROUPID="1001"

# Enable all repositories
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# Install packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    software-properties-common \
    apt-transport-https \
    nano \
    emacs \
    vim \
    curl \
    netcat \
    dbus \
    systemd \
    systemd-cron \
    rsyslog \
    iproute2 \
    sudo && \
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
RUN groupadd --gid ${GROUPID} ${GROUP} && \
    useradd --uid ${USERID} --gid ${GROUPID} --shell /bin/bash --create-home ${USER} && \
    echo "sysops ALL=(ALL:ALL) NOPASSWD:ALL" | tee -a /etc/sudoers.d/${USER}

# Install Sawtooth
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD && \
    sudo add-apt-repository 'deb http://repo.sawtooth.me/ubuntu/1.0/stable xenial universe' && \
    sudo apt-get update -y && \
    sudo apt-get install -y sawtooth  python3-sawtooth-identity && \
    apt-get clean && \
    rm -rf /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install network key generator
RUN sudo apt-get update -y && \
    sudo apt-get install g++ libzmq3-dev -y && \
    sudo curl -O https://raw.githubusercontent.com/zeromq/libzmq/master/tools/curve_keygen.cpp && \
    sudo g++ curve_keygen.cpp -o /usr/local/bin/curve_keygen -lzmq && \
    sudo apt-get remove g++ libzmq3-dev -y && \
    sudo rm -f curve_keygen.cpp && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Telegraph
RUN curl -sL https://repos.influxdata.com/influxdb.key |  sudo apt-key add - && \
    sudo apt-add-repository "deb https://repos.influxdata.com/ubuntu xenial stable" && \
    sudo apt-get update -y && \
    sudo apt-get install -y telegraf && \
    apt-get clean && \
    rm -rf /usr/share/doc/* /usr/share/man/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG ASSET_PATH

# Add configuration file
COPY ${ASSET_PATH}/*.toml /etc/sawtooth/

# Add Entrypoint
COPY ${ASSET_PATH}/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh && \
    chown ${USERID}:${GROUPID} /docker-entrypoint.sh  

# VOLUME ["/sys/fs/cgroup", "/tmp", "/run", "/run/lock"]

STOPSIGNAL SIGRTMIN+3

# Activate custom user
USER ${USER}

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["/sbin/init", "--log-target=journal"]