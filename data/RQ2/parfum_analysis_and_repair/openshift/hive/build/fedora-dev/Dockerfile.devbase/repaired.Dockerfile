# Base OS image for Hive development containers FROM on Fedora.

FROM fedora:33

# ssh-agent required for gathering logs in some situations:
RUN if ! rpm -q openssh-clients; then dnf install -y openssh-clients && dnf clean all && rm -rf /var/cache/dnf/*; fi
#
# libvirt libraries required for running bare metal installer.
RUN dnf install -y libvirt-devel && dnf clean all && rm -rf /var/cache/dnf/*

# Hacks to allow writing known_hosts, homedir is / by default in OpenShift.
# Bare metal installs need to write to $HOME/.cache, and $HOME/.ssh for as long as
# we're hitting libvirt over ssh. OpenShift will not let you write these directories
# by default so we must setup some permissions here.
ENV HOME /home/hive
RUN mkdir -p /home/hive && \
    chgrp -R 0 /home/hive && \
    chmod -R g=u /home/hive

# This is so that we can write source certificate anchors during container start up.
RUN mkdir -p /etc/pki/ca-trust/source/anchors && \
    chgrp -R 0 /etc/pki/ca-trust/source/anchors && \
    chmod -R g=u /etc/pki/ca-trust/source/anchors

# This is so that we can run update-ca-trust during container start up.
RUN mkdir -p /etc/pki/ca-trust/extracted/openssl && \
    mkdir -p /etc/pki/ca-trust/extracted/pem && \
    mkdir -p /etc/pki/ca-trust/extracted/java && \
    chgrp -R 0 /etc/pki/ca-trust/extracted && \
    chmod -R g=u /etc/pki/ca-trust/extracted

# TODO: should this be the operator?