FROM debian:buster

COPY run.sh /run.sh
COPY start.sh /start.sh
COPY bzImage /bzImage
COPY rootfs.ssh /rootfs.ssh

RUN apt-get update \
     && apt-get install --no-install-recommends -y qemu-system && rm -rf /var/lib/apt/lists/*;
CMD /start.sh
