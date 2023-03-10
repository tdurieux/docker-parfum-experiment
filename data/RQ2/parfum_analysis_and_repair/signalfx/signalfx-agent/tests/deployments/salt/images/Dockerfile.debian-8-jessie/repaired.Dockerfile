FROM debian:jessie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates procps wget apt-transport-https init-system-helpers curl python3-apt python3-pip python3-dev python3-zmq gnupg && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir msgpack==0.6.2 Jinja2==2.11.3 MarkupSafe==1.1.1
RUN pip3 install --no-cache-dir salt==2019.2

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \                    
    rm -f /lib/systemd/system/multi-user.target.wants/*;\ 
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Keep it from wiping our scratch dir in /tmp/scratch
RUN rm -f /usr/lib/tmpfiles.d/tmp.conf;

COPY deployments/salt/signalfx-agent/ /srv/salt/signalfx-agent/
COPY tests/deployments/salt/images/top.sls /srv/salt/top.sls
COPY tests/deployments/salt/images/top.sls /srv/pillar/top.sls
COPY tests/deployments/salt/images/minion /etc/salt/minion

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/sbin/init"]
