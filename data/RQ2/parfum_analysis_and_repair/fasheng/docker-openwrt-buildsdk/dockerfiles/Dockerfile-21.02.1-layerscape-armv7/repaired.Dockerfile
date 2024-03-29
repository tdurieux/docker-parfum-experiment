FROM alpine:3.16.0

RUN apk update
RUN apk add --no-cache asciidoc bash bc binutils bzip2 cdrkit coreutils diffutils \
            findutils flex g++ gawk gcc gettext git grep intltool libxslt \
            linux-headers make ncurses-dev openssl-dev patch perl python3-dev \
            rsync tar unzip util-linux wget zlib-dev \
            sudo shadow xz
RUN useradd -m -u 1000 -U openwrt &&\
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

ENV OPENWRT_SDK_VERSION 21.02.1
ENV OPENWRT_SDK_ARCH layerscape-armv7
ENV OPENWRT_SDK_URL https://downloads.openwrt.org/releases/21.02.1/targets/layerscape/armv7/openwrt-sdk-21.02.1-layerscape-armv7_gcc-8.4.0_musl_eabi.Linux-x86_64.tar.xz
RUN sudo -iu openwrt wget --tries=3 "${OPENWRT_SDK_URL}" &&\
    sudo -iu openwrt tar xf "$(basename ${OPENWRT_SDK_URL})" &&\
    sudo -iu openwrt rm -f "$(basename ${OPENWRT_SDK_URL})" &&\
    sudo -iu openwrt mv "$(basename ${OPENWRT_SDK_URL%%.tar.*})" openwrtsdk
RUN sudo -iu openwrt mkdir -p openwrtsdk/dl openwrtsdk/bin openwrtsdk/feeds

CMD sudo -iu openwrt bash
