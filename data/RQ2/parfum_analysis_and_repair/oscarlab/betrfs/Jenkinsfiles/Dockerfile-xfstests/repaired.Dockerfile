# Needed for ftfs kernel
FROM ubuntu:14.04

# Packages needed to build filesystem and run xfstests
RUN apt-get update && apt-get install --no-install-recommends -y wget vim git g++-4.7 gcc-4.7 valgrind \
                       zlib1g-dev make gcc bc cmake debootstrap \
                       schroot qemu qemu-utils qemu-kvm realpath \
                       bison flex libelf-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

# Build location
RUN mkdir /oscar

CMD ["bash"]
