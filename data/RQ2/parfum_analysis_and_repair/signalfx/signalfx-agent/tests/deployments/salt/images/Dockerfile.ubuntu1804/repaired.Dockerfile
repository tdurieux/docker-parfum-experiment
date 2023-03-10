FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates procps systemd wget apt-transport-https libcap2-bin curl python3-apt python3-pip python3-dev gnupg && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir msgpack==0.6.2
RUN pip3 install --no-cache-dir salt==2019.2

ENV container docker
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/systemd-update-utmp*

RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd

COPY deployments/salt/signalfx-agent/ /srv/salt/signalfx-agent/
COPY tests/deployments/salt/images/top.sls /srv/salt/top.sls
COPY tests/deployments/salt/images/top.sls /srv/pillar/top.sls
COPY tests/deployments/salt/images/minion /etc/salt/minion

VOLUME [ "/sys/fs/cgroup" ]
ENTRYPOINT ["/lib/systemd/systemd"]
