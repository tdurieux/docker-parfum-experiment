FROM qemu:latest

WORKDIR /clearlinux

RUN apt-get install --no-install-recommends -yq wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.clearlinux.org/image/start_qemu.sh
RUN wget https://download.clearlinux.org/image/OVMF.fd
RUN wget https://download.clearlinux.org/image/clear-3060-kvm.img.xz

RUN apt-get install --no-install-recommends -yq xz-utils && rm -rf /var/lib/apt/lists/*;
RUN unxz clear-3060-kvm.img.xz

RUN chmod 755 start_qemu.sh

CMD ./start_qemu.sh clear-3060-kvm.img
