FROM alpine:3.13

ENV LIBISCSI_VERSION 1.19.0
ENV QEMU_VERSION 6.0.0-rc1
ENV QUILT_VERSION 0.66

ENV TERM linux

COPY ./qemu-patches /root/qemu-patches

RUN echo https://mirror.yandex.ru/mirrors/alpine/v3.13/main/       > /etc/apk/repositories \
 && echo https://mirror.yandex.ru/mirrors/alpine/v3.13/community/ >> /etc/apk/repositories \
 && apk --update add \
        # Build essentials
        automake \
        autoconf \
        bison \
        diffutils \
        flex \
        gcc \
        libtool \
        make \
        ninja \
        patch \
        # Deps
        bzip2-dev \
        glib-dev \
        gnutls-dev \
        jpeg-dev \
        libaio-dev \
        libc-dev \
        libcap-dev \
        libcap-ng-dev \
        libnfs-dev \
        libpng-dev \
        libseccomp-dev \
        numactl-dev \
        # https://wiki.qemu.org/ChangeLog/4.1#Build_Dependencies
        libssh-dev \
        libusb-dev \
        ovmf \
        pixman-dev \
        usbredir-dev \
        xen-dev \
        xfsprogs-dev \
        zlib-dev \
        # Helpers
        bash \
        curl \
        ncurses \
        sed \
        tar \
        util-linux \
        xz\
 && cd \
 # Build quilt since the current stable Alpine release doesn't have it so far.
 # TODO: when quilt is in the stable main or community, remove diffutils, sed
 #       and patch from the list above.
 && curl -OL http://download.savannah.gnu.org/releases/quilt/quilt-$QUILT_VERSION.tar.gz \
 && tar xzvf quilt-$QUILT_VERSION.tar.gz \
 && rm quilt-$QUILT_VERSION.tar.gz \
 && cd quilt-$QUILT_VERSION \
 && ./configure && make -j "$(nproc)" && make install \
 && cd && rm -r quilt-$QUILT_VERSION \
 # Build libiscsi
 && curl -OL https://github.com/sahlberg/libiscsi/archive/$LIBISCSI_VERSION.tar.gz \
 && tar xzvf $LIBISCSI_VERSION.tar.gz \
 && rm $LIBISCSI_VERSION.tar.gz \
 && cd libiscsi-$LIBISCSI_VERSION \
 && ./autogen.sh \
 && ./configure && make -j "$(nproc)" && make install \
 && cd && rm -r libiscsi-$LIBISCSI_VERSION \
 # Build QEMU
 && curl -O https://download.qemu.org/qemu-$QEMU_VERSION.tar.xz \
 && tar xJvf qemu-$QEMU_VERSION.tar.xz \
 && rm qemu-$QEMU_VERSION.tar.xz \
 && cd qemu-$QEMU_VERSION \
 && mv /root/qemu-patches patches \
 && env QUILT_PATCHES=patches quilt push -a \
 && ./configure \
        # https://sources.debian.org/src/qemu/stretch/debian/rules/#L57-L61
        # (except or32)
        --target-list=' \
            i386-softmmu \
            x86_64-softmmu \
            alpha-softmmu \
            aarch64-softmmu \
            arm-softmmu \
            cris-softmmu \
            lm32-softmmu \
            m68k-softmmu \
            microblaze-softmmu \
            microblazeel-softmmu \
            mips-softmmu \
            mipsel-softmmu \
            mips64-softmmu \
            mips64el-softmmu \
            moxie-softmmu \
            ppc-softmmu \
            ppc64-softmmu \
            sh4-softmmu \
            sh4eb-softmmu \
            sparc-softmmu \
            sparc64-softmmu \
            s390x-softmmu \
            tricore-softmmu \
            xtensa-softmmu \
            xtensaeb-softmmu \
            unicore32-softmmu \
        ' \
        --disable-docs \
        --disable-gtk --disable-vte \
        --disable-sdl \
        --enable-attr \
        --enable-bzip2 \
        --enable-cap-ng \
        --enable-curl \
        --enable-curses \
        --enable-fdt \
        --enable-gnutls \
        --enable-kvm \
        --enable-libiscsi \
        --enable-libnfs \
        --enable-libssh \
        --enable-libusb \
        --enable-linux-aio \
        --enable-linux-user \
        --enable-modules \
        --enable-numa \
        --enable-seccomp \
        --enable-system \
        --enable-tools \
        --enable-usb-redir \
        --enable-vhost-net \
        --enable-vhost-user \
        --enable-vhost-vsock \
        --enable-virtfs \
        --enable-vnc \
        --enable-vnc-jpeg \
        --enable-vnc-png \
        --enable-xen \
        --enable-xfsctl \
 && make -j "$(nproc)" && make install \
 && cd && rm -r qemu-$QEMU_VERSION \
 && apk del \
    automake \
    autoconf \
    bison \
    diffutils \
    flex \
    gcc \
    libtool \
    make \
    patch \
    sed \
    tar \
    xz\
 && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

