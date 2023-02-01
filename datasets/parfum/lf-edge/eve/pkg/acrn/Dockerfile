FROM lfedge/eve-alpine:6.7.0 as kernel-build

ENV BUILD_PKGS \
    gcc make libc-dev dev86 xz-dev perl bash python3-dev gettext iasl         \
    util-linux-dev ncurses-dev glib-dev pixman-dev libaio-dev yajl-dev        \
    argp-standalone linux-headers git patch texinfo curl tar bash socat       \
    openssh python3 libc-dev openssl-dev openssl libpciaccess libpciaccess-dev\
    bsd-compat-headers libusb libusb-dev gnu-efi-dev py3-pip
RUN eve-alpine-deploy.sh

RUN pip3 install kconfiglib==12.14.1

ENV ACRN_VERSION 1.3
ENV ACRN_SOURCE=https://github.com/projectacrn/acrn-hypervisor/archive/v${ACRN_VERSION}.tar.gz
RUN \
    [ -f "$(basename ${ACRN_SOURCE})" ] || curl -fsSLO "${ACRN_SOURCE}" && \
    tar --absolute-names -xz < "$(basename ${ACRN_SOURCE})" && mv "/acrn-hypervisor-${ACRN_VERSION}" /acrn-hypervisor
RUN ls -l /acrn-hypervisor
# Apply local patches
COPY patches-${ACRN_VERSION} /patches
WORKDIR /acrn-hypervisor
RUN set -e && for patch in /patches/*.patch; do \
        echo "Applying $patch"; \
        patch -p1 < "$patch"; \
    done

COPY grub-hv.cfg /out/EFI/BOOT/grub-hv.cfg
RUN mkdir -p /out/boot /out/usr/bin /out/usr/lib/systemd/system           \
             /out/usr/share/acrn/bios /out/usr/share/acrn/samples/generic \
             /out/usr/share/acrn/samples/nuc /out/usr/lib/acrn
RUN if [ `uname -m` = "x86_64" ] ; then \
   make SCENARIO=industry PLATFORM=uefi BOARD=generic &&\
   cp /acrn-hypervisor/build/misc/tools/acrntrace /out/usr/bin/ &&\
   cp /acrn-hypervisor/build/misc/tools/acrntrace /out/usr/bin/ &&\
   cp /acrn-hypervisor/build/misc/tools/acrnlog.service /out/usr/lib/systemd/system/acrnlog.service &&\
   cp /acrn-hypervisor/build/misc//tools/acrnlog /out/usr/bin/ &&\
   cp /acrn-hypervisor/build/misc/tools/acrnctl /out/usr/bin/ &&\
   cp /acrn-hypervisor/build/misc/tools/acrnd /out/usr/bin/ &&\
   cp /acrn-hypervisor/build/misc/tools/libacrn-mngr.a /out/usr/bin/ &&\
   cp /acrn-hypervisor/build/misc/tools/acrnd.service /out/usr/lib/systemd/system/acrnd.service &&\
   cp /acrn-hypervisor/build/hypervisor/acrn.bin /out/usr/lib/acrn &&\
   cp /acrn-hypervisor/build/hypervisor/acrn.efi /out/usr/lib/acrn &&\
   cp /acrn-hypervisor/build/hypervisor/acrn.32.out /out/usr/lib/acrn &&\
   cp /acrn-hypervisor/build/hypervisor/acrn.32.out /out/boot &&\
   cp /acrn-hypervisor/build/devicemodel/acrn-dm /out/usr/bin/ &&\
   cp /acrn-hypervisor/devicemodel/bios/* /out/usr/share/acrn/bios/ &&\
   cp /acrn-hypervisor/misc/efi-stub/clearlinux/acrn.conf /out/usr/share/acrn/samples/nuc/acrn.conf ;\
fi


FROM scratch
ENTRYPOINT []
CMD []
COPY --from=kernel-build /out/ /
