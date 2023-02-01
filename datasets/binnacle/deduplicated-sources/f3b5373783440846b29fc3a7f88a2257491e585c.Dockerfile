ARG QEMU_IMAGE=calico/go-build:latest
FROM ${QEMU_IMAGE} as qemu

FROM s390x/debian:buster-slim as bpftool-build

COPY --from=qemu /usr/bin/qemu-s390x-static /usr/bin/

RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y --no-install-recommends \
    gpg gpg-agent libelf-dev libmnl-dev libc-dev iptables libgcc-8-dev \
    bash-completion binutils binutils-dev ca-certificates make git curl \
    xz-utils gcc pkg-config bison flex build-essential && \
apt-get purge --auto-remove && \
apt-get clean

WORKDIR /tmp

RUN \
git clone --depth 1 -b master git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git && \
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

FROM s390x/alpine:3.8 as base
MAINTAINER LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)

# Enable non-native builds of this image on an amd64 hosts.
# This must be the first RUN command in this file!
# we only need this for the intermediate "base" image, so we can run all the apk and other commands
# when running on a kernel >= 4.8, this will become less relevant
COPY --from=qemu /usr/bin/qemu-s390x-static /usr/bin/


# Install our dependencies.
RUN apk --no-cache add ip6tables tini ipset iputils iproute2 conntrack-tools file

ADD felix.cfg /etc/calico/felix.cfg
ADD calico-felix-wrapper /usr/bin

# Put our binary in /code rather than directly in /usr/bin.  This allows the downstream builds
# to more easily extract the Felix build artefacts from the container.
ADD bin/calico-felix-s390x /code/calico-felix
RUN ln -s /code/calico-felix /usr/bin
COPY --from=bpftool-build /usr/bin/bpftool /usr/bin
WORKDIR /code

# Since our binary isn't designed to run as PID 1, run it via the tini init daemon.
ENTRYPOINT ["/sbin/tini", "--"]
# Run felix (via the wrapper script) by default
CMD ["calico-felix-wrapper"]
