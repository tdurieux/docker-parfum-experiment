ARG BASE_IMAGE=gcr.io/data-gpdb-public-images/gpdb7-ubuntu18.04-test:latest

FROM ${BASE_IMAGE}

ARG GO_VERSION
ARG GINKGO_VERSION

# install Go utilities
RUN mkdir -p /tmp/pxf_src/ && cd /tmp \
    && wget -O go.tgz -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go.tgz && rm go.tgz \
    && GOPATH=/opt/go /usr/local/go/bin/go install github.com/onsi/ginkgo/ginkgo@v${GINKGO_VERSION}

# install java 11 and dependencies that are missing on the base images
RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y curl sudo openjdk-11-jdk jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create user gpadmin since GPDB cannot run under root
RUN locale-gen en_US.UTF-8 \
    && ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa \
    && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys \
    && chmod 0600 /root/.ssh/authorized_keys \
    && echo "root:password" | chpasswd 2> /dev/null \
    && sed -i -e 's|Defaults    requiretty|#Defaults    requiretty|' /etc/sudoers \
    && sed -ri 's/UsePAM yes/UsePAM no/g;s/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
    && sed -ri 's@^HostKey /etc/ssh/ssh_host_ecdsa_key$@#&@;s@^HostKey /etc/ssh/ssh_host_ed25519_key$@#&@' /etc/ssh/sshd_config \
    && service ssh start \
    && { ssh-keyscan localhost; ssh-keyscan 0.0.0.0; } >> /root/.ssh/known_hosts \
    && groupadd -g 6000 gpadmin && useradd -u 6000 -g 6000 gpadmin -s /bin/bash \
    && echo "gpadmin  ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/gpadmin \
    && groupadd supergroup && usermod -a -G supergroup gpadmin \
    && mkdir -p /home/gpadmin/.ssh \
    && ssh-keygen -t rsa -N "" -f /home/gpadmin/.ssh/id_rsa \
    && cat /home/gpadmin/.ssh/id_rsa.pub >> /home/gpadmin/.ssh/authorized_keys \
    && chmod 0600 /home/gpadmin/.ssh/authorized_keys \
    && echo "gpadmin:password" | chpasswd 2> /dev/null \
    && { ssh-keyscan localhost; ssh-keyscan 0.0.0.0; } >> /home/gpadmin/.ssh/known_hosts \
    && chown -R gpadmin:gpadmin /home/gpadmin \
    # configure gpadmin limits
    && echo >> /etc/security/limits.d/gpadmin-limits.conf 'gpadmin soft core unlimited' \
    && echo >> /etc/security/limits.d/gpadmin-limits.conf 'gpadmin soft nproc 131072' \
    && echo >> /etc/security/limits.d/gpadmin-limits.conf 'gpadmin soft nofile 65536' \
    # add locale for testing
    && localedef -c -i ru_RU -f CP1251 ru_RU.CP1251 \
    # create .pxfrc
    && echo >> ~gpadmin/.pxfrc 'export LANG=en_US.UTF-8' \
    && echo >> ~gpadmin/.pxfrc 'export PGPORT=5432' \
    && echo >> ~gpadmin/.pxfrc 'export GOPATH=/opt/go' \
    && echo >> ~gpadmin/.pxfrc 'export GPHOME=$(find /usr/local/ -name greenplum-db* -type d | head -n1)' \
    && echo >> ~gpadmin/.pxfrc 'export LD_LIBRARY_PATH=${GPHOME}/lib:${LD_LIBRARY_PATH-}' \
    && echo >> ~gpadmin/.pxfrc 'export GPHD_ROOT=/singlecluster' \
    && echo >> ~gpadmin/.pxfrc 'export PXF_HOME=/usr/local/pxf-gp7' \
    && echo >> ~gpadmin/.pxfrc 'export PXF_CONF=/home/gpadmin/pxf' \
    && echo >> ~gpadmin/.pxfrc 'export JAVA_HOME=/usr/lib/jvm/jdk-11' \
    && echo >> ~gpadmin/.pxfrc 'export PATH=${GPHOME}/bin:${PXF_HOME}/bin:${GOPATH}/bin:/usr/local/go/bin:$JAVA_HOME/bin:$PATH' \
    && ln -s ~gpadmin/.pxfrc ~root \
    && echo >> ~gpadmin/.bashrc 'source ~/.pxfrc' \
    && echo >> ~gpadmin/.bash_profile '[[ -f ~/.bashrc ]] && . ~/.bashrc' \
    && chown -R gpadmin:gpadmin ~gpadmin
