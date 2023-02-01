FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y qemu-system-arm && rm -rf /var/lib/apt/lists/*;

WORKDIR /challenge
COPY qemu-system-arm qemu_run.sh bl1.bin bl2.bin bl32.bin bl32_extra1.bin bl33.bin rootfs.cpio.gz zImage /challenge/

CMD ["/challenge/qemu_run.sh"]

