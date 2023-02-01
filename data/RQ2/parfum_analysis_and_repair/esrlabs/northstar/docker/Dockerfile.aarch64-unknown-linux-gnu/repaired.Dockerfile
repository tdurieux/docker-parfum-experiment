FROM rustembedded/cross:aarch64-unknown-linux-gnu

RUN apt update && apt install -y --no-install-recommends --assume-yes libclang-dev libz-dev && rm -rf /var/lib/apt/lists/*;
ENV BINDGEN_EXTRA_CLANG_ARGS="-I/usr/aarch64-linux-gnu/include"

COPY install-squashfs-tools.sh /
RUN /install-squashfs-tools.sh && rm /install-squashfs-tools.sh