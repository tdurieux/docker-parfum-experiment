FROM debian:jessie-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates procps wget apt-transport-https init-system-helpers curl python gnupg && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py && \
    python /tmp/get-pip.py pip==20.3.4

ARG ANSIBLE_VERSION='==2.4.0'
RUN pip install --no-cache-dir ansible${ANSIBLE_VERSION}

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

COPY deployments/ansible/* /opt/playbook/
COPY tests/deployments/ansible/images/inventory.ini /opt/playbook/
COPY tests/deployments/ansible/images/playbook.yml /opt/playbook/

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/sbin/init"]
