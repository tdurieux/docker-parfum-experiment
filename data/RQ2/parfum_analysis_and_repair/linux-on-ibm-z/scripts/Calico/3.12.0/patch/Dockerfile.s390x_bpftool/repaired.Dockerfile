ARG QEMU_IMAGE=calico/go-build:v0.20

FROM ${QEMU_IMAGE} as qemu

FROM s390x/debian:buster-slim as bpftool-build

ARG KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
ARG KERNEL_REF=master

COPY --from=qemu /usr/bin/qemu-s390x-static /usr/bin/

RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y --no-install-recommends \
    gpg gpg-agent libelf-dev libmnl-dev libc-dev iptables libgcc-8-dev \
    bash-completion binutils binutils-dev make git curl \
    ca-certificates xz-utils gcc pkg-config bison flex build-essential && \
apt-get purge --auto-remove && \
apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp

RUN \
git clone --depth 1 -b $KERNEL_REF $KERNEL_REPO && \
cd linux/tools/bpf/bpftool/ && \
sed -i '/CFLAGS += -O2/a CFLAGS += -static' Makefile && \
sed -i 's/LIBS = -lelf $(LIBBPF)/LIBS = -lelf -lz $(LIBBPF)/g' Makefile && \
printf 'feature-libbfd=0\nfeature-libelf=1\nfeature-bpf=1\nfeature-libelf-mmap=1' >> FEATURES_DUMP.bpftool && \
FEATURES_DUMP=`pwd`/FEATURES_DUMP.bpftool make -j `getconf _NPROCESSORS_ONLN` && \
strip bpftool && \
ldd bpftool 2>&1 | grep -q -e "Not a valid dynamic program" \
	-e "not a dynamic executable" || \
	( echo "Error: bpftool is not statically linked"; false ) && \
mv bpftool /usr/bin && rm -rf /tmp/linux

FROM scratch
COPY --from=bpftool-build /usr/bin/bpftool /bpftool
