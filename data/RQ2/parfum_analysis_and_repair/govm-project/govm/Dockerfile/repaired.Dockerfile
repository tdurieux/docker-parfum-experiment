FROM alpine
MAINTAINER obed.n.munoz@gmail.com, erick.cardona.ruiz@gmail.com
ENV container docker

RUN apk update \
&& apk add --no-cache qemu-system-x86_64 xorriso cdrkit dnsmasq net-tools bridge-utils \
iproute2 curl bash qemu-img \
&& ( apk add --no-cache qemu-hw-display-qxl || true)


COPY startvm /usr/local/bin/startvm
RUN chmod u+x /usr/local/bin/startvm
RUN curl -f -O https://download.clearlinux.org/image/OVMF.fd -o /image/OVMF.fd

VOLUME /image

ENTRYPOINT ["/usr/local/bin/startvm"]
