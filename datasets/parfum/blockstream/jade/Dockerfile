FROM debian:bullseye@sha256:6137c67e2009e881526386c42ba99b3657e4f92f546814a33d35b14e60579777 as base
RUN apt-get update -qq && apt-get upgrade --no-install-recommends --no-install-suggests -yqq && apt-get install --no-install-recommends --no-install-suggests -yqq git wget libncurses-dev flex bison gperf libffi-dev libssl-dev dfu-util cmake ninja-build ccache build-essential ca-certificates ccache cmake curl make pkg-config python3 python3-dev python3-pip python3-setuptools python3-serial python3-click python3-cryptography python3-future python3-pyparsing python3-pyelftools python3-pkg-resources python3-wheel unzip bluez-tools bluez libusb-1.0-0 clang-format libglib2.0-dev libpixman-1-dev libgcrypt20-dev virtualenv && apt-get -yqq autoremove && apt-get -yqq clean && rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/*
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN python -m pip install --user pycodestyle

FROM base AS esp-idf

# These ARGs are easily parseable (eg by HWI)
ARG ESP_IDF_BRANCH=v4.4.1
ARG ESP_IDF_COMMIT=1329b19fe494500aeb79d19b27cfd99b40c37aec
RUN mkdir ~/esp && cd ~/esp && git clone --quiet --depth=1 --branch ${ESP_IDF_BRANCH} --single-branch --recursive https://github.com/espressif/esp-idf.git
RUN cd ~/esp/esp-idf && git checkout ${ESP_IDF_COMMIT} && ./install.sh esp32

FROM base AS esp-qemu

# These ARGs are easily parseable (eg by HWI)
ARG ESP_QEMU_BRANCH=esp-develop-20220203
ARG ESP_QEMU_COMMIT=440ff71648f0a6682ad59cf34929c0172c7f27af
RUN git clone --quiet --depth 1 --branch ${ESP_QEMU_BRANCH} --single-branch --recursive https://github.com/espressif/qemu.git \
&& cd qemu && git checkout ${ESP_QEMU_COMMIT} \
    && ./configure --target-list=xtensa-softmmu --static --prefix=/opt \
    --enable-lto \
    --enable-gcrypt \
    --enable-sanitizers \
    --disable-user \
    --disable-opengl \
    --disable-curses \
    --disable-capstone \
    --disable-vnc \
    --disable-parallels \
    --disable-qed \
    --disable-vvfat \
    --disable-vdi \
    --disable-qcow1 \
    --disable-dmg \
    --disable-cloop \
    --disable-bochs \
    --disable-replication \
    --disable-live-block-migration \
    --disable-keyring \
    --disable-containers \
    --disable-docs \
    --disable-libssh \
    --disable-xen \
    --disable-tools \
    --disable-zlib-test \
    --disable-sdl \
    --disable-gtk \
    --disable-vhost-scsi \
    --disable-qom-cast-debug \
    --disable-tpm \
    && ninja -C build install && rm -fr /qemu

FROM esp-idf
COPY --from=esp-qemu /opt /opt
