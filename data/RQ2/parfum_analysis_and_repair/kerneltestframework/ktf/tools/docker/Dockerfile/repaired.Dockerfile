FROM ubuntu:20.04

# build dependencies
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y gcc make xorriso qemu-utils qemu qemu-system-x86 patch && rm -rf /var/lib/apt/lists/*;
# grub is a bit special in containers
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y -o Dpkg::Options::="--force-confdef" -o install grub2 kmod python && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash"]
