ARG SOURCE_IMAGE

FROM ${SOURCE_IMAGE}

ENV USER scylla-test
SHELL ["/bin/bash", "-c"]
# Install sudo, collectd and other tools, disable autostart of scylla-server and scylla-housekeeping services,
# remove the login banner and add a new user.
#
# Password for the user is `test' and encrypted using openssl command:
#    $ echo -n test | openssl passwd -crypt -stdin -salt 00
#    00hzYw5m.HyAY
#
# For more details see man page for useradd(8)
RUN apt-get update && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt install -y sudo && \
    adduser --disabled-password --gecos "" $USER || true  && \
    usermod -aG sudo $USER && \
    sudo -Hu $USER sh -c "mkdir -m 700 ~/.ssh" && \
    echo "$USER  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers && \
    apt install -y \
        iproute2 \
        collectd \
        syslog-ng \
        rsync && \
    rm -rf /var/lib/apt/lists/* && \
    echo $'[program:collectd]\n\
command=/usr/sbin/collectd\n\
stdout_logfile=/dev/stdout\n\
stdout_logfile_maxbytes=0\n\
stderr_logfile=/dev/stderr\n\
stderr_logfile_maxbytes=0' > /etc/supervisord.conf.d/collectd.conf && \
    echo $'[program:scylla-manager]\n\
command=/usr/bin/scylla-manager --developer-mode\n\
stdout_logfile=/dev/stdout\n\
stdout_logfile_maxbytes=0\n\
stderr_logfile=/dev/stderr\n\
stderr_logfile_maxbytes=0' > /etc/supervisord.conf.d/scylla-manager.conf && \
    echo "autostart=false" >> /etc/supervisord.conf.d/scylla-server.conf && \
    echo "autostart=false" >> /etc/supervisord.conf.d/scylla-housekeeping.conf
