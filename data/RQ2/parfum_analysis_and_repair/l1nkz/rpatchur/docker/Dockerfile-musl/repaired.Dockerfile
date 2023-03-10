FROM ekidd/rust-musl-builder

RUN sudo apt update && sudo apt install --no-install-recommends -y \
        libglib2.0-dev \
        libpango1.0-dev \
        libgtk-3-dev \
        libsoup2.4-dev \
        libwebkit2gtk-4.0-dev \
        libsystemd-dev \
        libmount-dev \
        libselinux1-dev \
        libffi-dev \
        autoconf \
        automake \
        autopoint \
        libtool \
        m4 \
        po4a && rm -rf /var/lib/apt/lists/*;

# Compile liblzma
RUN cd /home/rust/libs && \
    git clone https://git.tukaani.org/xz.git && \
    cd xz && \
    git checkout v5.2.5 && \
    CC=musl-gcc ./autogen.sh && \
    CC=musl-gcc ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-shared && \
    cd src/liblzma/ && \
    make && \
    sudo make install && \
    cd ../../../ && \
    rm -rf xz

# Build our application
ENTRYPOINT ["cargo", "build", "--target", "x86_64-unknown-linux-musl"]
