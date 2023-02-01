FROM rustembedded/cross:aarch64-unknown-linux-musl

RUN apt update && apt install -y --no-install-recommends --assume-yes musl-dev libclang-dev libz-dev && rm -rf /var/lib/apt/lists/*;
ENV BINDGEN_EXTRA_CLANG_ARGS="-I/usr/local/aarch64-linux-musl/include"

COPY install-squashfs-tools.sh /
RUN /install-squashfs-tools.sh && rm /install-squashfs-tools.sh