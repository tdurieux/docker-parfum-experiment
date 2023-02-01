FROM ubuntu:18.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates procps systemd wget apt-transport-https libcap2-bin curl python3-pip gnupg && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip==20.3.4

ARG ANSIBLE_VERSION='==2.4.0'
RUN pip3 install --no-cache-dir ansible${ANSIBLE_VERSION}

ENV container docker
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/systemd-update-utmp*

RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd

COPY deployments/ansible/* /opt/playbook/
COPY tests/deployments/ansible/images/inventory.ini /opt/playbook/
COPY tests/deployments/ansible/images/playbook.yml /opt/playbook/

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/lib/systemd/systemd"]
