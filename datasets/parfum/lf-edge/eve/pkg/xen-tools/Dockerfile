# hadolint ignore=DL3006
FROM lfedge/eve-uefi:2dbd55c5aaa69de821e510ca416ce88ffe60555f as uefi-build

FROM lfedge/eve-alpine:6.7.0 as runx-build
ENV BUILD_PKGS mkinitfs gcc musl-dev e2fsprogs
RUN eve-alpine-deploy.sh

RUN rm -f /sbin/poweroff /etc/mkinitfs/features.d/base.files
COPY initrd/base.files /etc/mkinitfs/features.d/base.files
COPY initrd/init-initrd initrd/mount_disk.sh initrd/udhcpc_script.sh /
COPY initrd/poweroff /sbin/poweroff
COPY initrd/chroot2.c initrd/hacf.c /tmp/
COPY initrd/00000080 /etc/acpi/PWRF/
RUN gcc -s -o /chroot2 /tmp/chroot2.c
RUN gcc -s -o /hacf /tmp/hacf.c
RUN mkinitfs -n -F base -i /init-initrd -o /runx-initrd

FROM lfedge/eve-alpine:6.7.0 as build
ENV BUILD_PKGS \
    gcc make libc-dev dev86 xz-dev perl bash python3-dev \
    gettext iasl util-linux-dev ncurses-dev glib-dev \
    pixman-dev libaio-dev yajl-dev argp-standalone \
    linux-headers git patch texinfo curl tar libcap-ng-dev \
    attr-dev flex bison cmake libusb-dev
ENV BUILD_PKGS_arm64 dtc-dev

ENV PKGS alpine-baselayout musl-utils bash libaio libbz2 glib pixman yajl keyutils libusb xz-libs libuuid sudo
ENV PKGS_arm64 libfdt

RUN eve-alpine-deploy.sh

# Alpine linux defines all 64bit integer types as long. Patch
# /usr/include/bits/alltypes.h to fix compilation with -m32
WORKDIR /
COPY alpine.patch /
RUN patch -p1 < alpine.patch

ENV LIBURING_VERSION 0.7
ENV LIBURING_SOURCE=https://git.kernel.dk/cgit/liburing/snapshot/liburing-${LIBURING_VERSION}.tar.bz2

# Download and verify liburing
RUN \
    [ -f "$(basename ${LIBURING_SOURCE})" ] || curl -fsSLO "${LIBURING_SOURCE}" && \
    tar --absolute-names -xj < "$(basename ${LIBURING_SOURCE})" && mv "/liburing-${LIBURING_VERSION}" /liburing

WORKDIR /liburing
RUN ./configure --prefix=/usr
RUN make src && make install DESTDIR=/out && make install

# Filter out unneeded stuff
RUN rm -rf /out/usr/man
RUN strip /out/usr/lib/* || :

ENV XEN_VERSION 4.15.0
ENV XEN_SOURCE=https://downloads.xenproject.org/release/xen/${XEN_VERSION}/xen-${XEN_VERSION}.tar.gz
ENV EXTRA_QEMUU_CONFIGURE_ARGS="--enable-libusb --enable-linux-aio \
    --enable-vhost-net --enable-vhost-vsock --enable-vhost-scsi --enable-vhost-kernel \
    --enable-vhost-user --enable-linux-io-uring"

WORKDIR /

# Download and verify xen
#TODO: verify Xen
RUN \
    [ -f "$(basename ${XEN_SOURCE})" ] || curl -fsSLO "${XEN_SOURCE}" && \
    tar --absolute-names -xz < "$(basename ${XEN_SOURCE})" && mv "/xen-${XEN_VERSION}" /xen

# Apply local patches
COPY patches-${XEN_VERSION} /patches
WORKDIR /xen
RUN cat /patches/*.patch /patches/"$(uname -m)"/*.patch | patch -p1

RUN mkdir -p /out

# FEATURES="--enable-stubdom --enable-vtpm-stubdom --enable-vtpmmgr-stubdom"
COPY gmp.patch /xen/stubdom
WORKDIR /xen
RUN ./configure --prefix=/usr --disable-xen --disable-qemu-traditional --disable-docs --enable-9pfs \
                --with-system-ovmf=/usr/lib/xen/boot/ovmf.bin --disable-stubdom
RUN make -j "$(getconf _NPROCESSORS_ONLN)" && make dist
RUN dist/install.sh /out

# Filter out a few things that we don't currently need
RUN rm -rf /out/usr/share/qemu-xen/qemu/edk2-* /out/var/run /usr/include /usr/lib/*.a
# FIXME: this is a workaround for Xen on ARM still requiring qemu-system-i386
#   https://wiki.xenproject.org/wiki/Xen_ARM_with_Virtualization_Extensions#Use_of_qemu-system-i386_on_ARM
WORKDIR /out/usr/lib/xen/bin/
RUN strip * || :
RUN if [ "$(uname -m)" = "x86_64" ]; then rm -f qemu-system-i386 && ln -s "qemu-system-$(uname -m)" qemu-system-i386 ;fi

COPY --from=uefi-build / /uefi/
RUN mkdir -p /out/usr/lib/xen/boot && cp /uefi/OVMF.fd /out/usr/lib/xen/boot/ovmf.bin && \
  cp /uefi/OVMF_PVH.fd /out/usr/lib/xen/boot/ovmf-pvh.bin
RUN if [ "$(uname -m)" = "x86_64" ]; then cp /uefi/*.rom /out/usr/lib/xen/boot/;fi

FROM scratch
COPY --from=build /out/ /
COPY --from=runx-build /runx-initrd /usr/lib/xen/boot/runx-initrd
COPY init.sh /
COPY qemu-ifup xen-start /etc/xen/scripts/

# We need to keep a slim profile, which means removing things we don't need
RUN rm -rf /usr/lib/libxen*.a /usr/lib/libxl*.a /usr/lib/debug /usr/lib/python*

# Adjust /var/run, /var/lib and /var/lock to be shared
RUN mv /var /var.template && ln -s /run /var && ln -s /run /var.template/run

# Add a few mountpoints so we can use lowerfs in R/O mode
RUN mkdir /persist /hostfs

ENTRYPOINT []
CMD ["/init.sh"]
