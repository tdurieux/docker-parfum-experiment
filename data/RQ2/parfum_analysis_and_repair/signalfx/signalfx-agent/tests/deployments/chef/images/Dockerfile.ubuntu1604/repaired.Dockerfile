FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates procps systemd apt-transport-https curl gnupg && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/cookbooks
RUN curl -f -Lo windows.tar.gz https://supermarket.chef.io/cookbooks/windows/versions/4.3.4/download && \
    tar -xzf windows.tar.gz && rm windows.tar.gz

ARG CHEF_INSTALLER_ARGS
RUN curl -f -L https://omnitruck.chef.io/install.sh | bash -s -- $CHEF_INSTALLER_ARGS

COPY tests/packaging/images/socat /bin/socat

# Insert our fake certs to the system bundle so they are trusted
COPY tests/packaging/images/certs/*.signalfx.com.* /
RUN cat /*.cert >> /etc/ssl/certs/ca-certificates.crt

ENV container docker
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/systemd-update-utmp*

RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd

COPY deployments/chef /opt/cookbooks/signalfx_agent

WORKDIR /opt

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/lib/systemd/systemd"]
