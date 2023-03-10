ARG LEGATO_TARGET="virt-x86"
ARG FLASH_FILE
ARG KERNEL_IMG=/data/kernel
ARG DTB_FILE=/data/target.dtb
ARG ROOTFS_IMG
ARG LEGATO_IMG
ARG USERFS_IMG
ARG QEMU_CONFIG=/data/qemu-config
ARG QEMU_CONFIG_JSON=/data/qemu.json
ARG QEMU_DIR=/opt/qemu

# Build QEmu
FROM alpine:3.10 AS build
ARG QEMU_DIR

# Dependencies from https://git.alpinelinux.org/aports/tree/main/qemu/APKBUILD
RUN ( \
        apk add --no-cache \
                alpine-sdk \
                alsa-lib-dev \
                bison \
                curl-dev \
                flex \
                glib-dev \
                glib-static \
                gnutls-dev \
                gtk+3.0-dev \
                libaio-dev \
                libcap-dev \
                libcap-ng-dev \
                dtc-dev \
                libjpeg-turbo-dev \
                libnfs-dev \
                libpng-dev \
                libseccomp-dev \
                libssh2-dev \
                libusb-dev \
                libxml2-dev \
                linux-headers \
                lzo-dev \
                ncurses-dev \
                paxmark \
                perl \
                python \
                python3 \
                py-sphinx \
                sdl2-dev \
                snappy-dev \
                spice-dev \
                texinfo \
                usbredir-dev \
                util-linux-dev \
                vde2-dev \
                virglrenderer-dev \
                vte3-dev \
                xfsprogs-dev \
                zlib-dev \
    )

ADD qemu/ /tmp/

RUN ( cd /tmp/qemu/ && \
        ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="$QEMU_DIR" \
                    --target-list=arm-softmmu \
                    --disable-tools \
                    --enable-modules \
                    --disable-glusterfs \
                    --disable-debug-info \
                    --disable-bsd-user \
                    --disable-werror \
                    --disable-sdl \
                    --disable-xen \
                    --cc="${CC:-gcc}" && \
        make ARFLAGS="rc" -j && \
        make install)

# Runtime image
FROM alpine:3.10 AS runtime
ARG LEGATO_TARGET
ARG FLASH_FILE
ARG KERNEL_IMG
ARG DTB_FILE
ARG ROOTFS_IMG
ARG LEGATO_IMG
ARG USERFS_IMG
ARG QEMU_CONFIG
ARG QEMU_CONFIG_JSON
ARG QEMU_DIR

# Runtime Dependencies & tools
RUN ( \
        apk add --no-cache \
                bash \
                jq \
                qemu-system-x86_64 \
                gtk+3.0 \
                libfdt \
                libnfs \
                libssh2 \
    )

COPY --from=build ${QEMU_DIR} ${QEMU_DIR}

ADD data /data/

ENV PID_FILE=/tmp/qemu.pid \
    DATA_DIR=/data \
    LEGATO_TARGET=$LEGATO_TARGET \
    FLASH_FILE=$FLASH_FILE \
    KERNEL_IMG=$KERNEL_IMG \
    DTB_FILE=$DTB_FILE \
    ROOTFS_IMG=$ROOTFS_IMG \
    LEGATO_IMG=$LEGATO_IMG \
    USERFS_IMG=$USERFS_IMG \
    QEMU_CONFIG=$QEMU_CONFIG \
    QEMU_CONFIG_JSON=$QEMU_CONFIG_JSON \
    QEMU_DIR=$QEMU_DIR \
    QEMU_PATH=$QEMU_DIR

# No offset at the port level, so:
# - telnet is available on 21
# - SSH on 22
# - simu control on 5000
ENV OFFSET_PORT 0

VOLUME /data

EXPOSE 21 \
       22 \
       5000 \
       8080 \
       8443

ENTRYPOINT ["/data/legato-qemu"]
