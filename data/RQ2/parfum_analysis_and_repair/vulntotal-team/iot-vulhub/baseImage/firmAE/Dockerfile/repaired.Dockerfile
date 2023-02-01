FROM firmianay/binwalk:noentry

WORKDIR /root

COPY ./firmAE /root/firmAE

RUN apt-get update && \
    apt-get install --no-install-recommends -y busybox-static bash-static dmsetup kpartx netcat snmp uml-utilities util-linux vlan bc && \
    apt-get install --no-install-recommends -y qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils && \
    apt-get install -y --no-install-recommends curl openssh-server tcpdump && \
    sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config && echo "root:root" | chpasswd && echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    pip3 install --no-cache-dir python-magic && rm -rf /var/lib/apt/lists/*
