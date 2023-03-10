# Copied from:
# https://github.com/solita/docker-systemd/blob/master/Dockerfile
# https://hub.docker.com/r/solita/ubuntu-systemd/
FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y systemd && rm -rf /var/lib/apt/lists/*;

ENV container docker

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;

RUN systemctl set-default multi-user.target

COPY setup /sbin/

STOPSIGNAL SIGRTMIN+3

# Workaround for docker/docker#27202, technique based on comments from docker/docker#9212
CMD ["/bin/bash", "-c", "exec /lib/systemd/systemd --log-target=journal 3>&1"]
