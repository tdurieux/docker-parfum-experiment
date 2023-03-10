FROM docker:dind

RUN apk add --no-cache openssh \
            net-tools \
            iproute2 \
            curl \
            python3 \
            gettext \
            tinc && \
    pip3 install --no-cache-dir tcconfig

ENV TCWRAP_DIR=/etc/tcwrap

RUN mkdir frp && \
    mkdir -p /sockets && \
    mkdir -p /etc/tinc && \
    mkdir -p /etc/tcwrap && \
    mkdir -p /var/run/netns && \
    wget -O - https://github.com/fatedier/frp/releases/download/v0.27.1/frp_0.27.1_linux_amd64.tar.gz | tar -xzf - \
        -C frp --strip-components=1

ADD ./madt_host/frpc.template.ini frpc.template.ini
ADD ./madt_host/madtstartup.sh madtstartup.sh
ADD ./madt_host/tcwrap /usr/bin/tcwrap

ADD ./images /images

# replace line in file
RUN sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/g' /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    passwd -u root && \
    mkdir -p /root/.ssh && \
    mkdir /tmp/madt && \
    chmod +x /usr/bin/tcwrap

ENTRYPOINT ["sh", "madtstartup.sh"]
