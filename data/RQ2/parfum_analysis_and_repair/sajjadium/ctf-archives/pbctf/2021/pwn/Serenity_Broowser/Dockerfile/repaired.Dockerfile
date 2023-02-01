FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install --no-install-recommends -y qemu-system-i386 xinetd socat && rm -rf /var/lib/apt/lists/*;

COPY files/disk.qcow2 /serenity/disk.qcow2
COPY files/Kernel /serenity/Kernel
COPY files/Prekernel /serenity/Prekernel

WORKDIR /serenity/
COPY ctf.xinetd /etc/xinetd.d/ctf
COPY start.sh /start.sh
RUN useradd -ms /bin/bash ctf

EXPOSE 2323

CMD ["/bin/sh", "-c", "chmod +666 /dev/kvm && /usr/sbin/xinetd -dontfork"]
