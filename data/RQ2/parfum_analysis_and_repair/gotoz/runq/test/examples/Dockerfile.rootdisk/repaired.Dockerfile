FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        kmod \
        openssh-server \
        systemd \
        udev \
        docker.io \
     && systemctl enable ssh.service \
     && systemctl enable docker.service && rm -rf /var/lib/apt/lists/*;

RUN echo "rootfs / none defaults,private  0  0" > /etc/fstab
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "root:root" | chpasswd && passwd -u root
RUN /bin/echo -e "[Service]\nExecStart=\nExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock\n" > /etc/systemd/system/docker.service

