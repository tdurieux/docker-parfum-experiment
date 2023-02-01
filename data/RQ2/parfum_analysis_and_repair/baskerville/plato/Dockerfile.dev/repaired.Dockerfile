FROM rust:1.60.0-buster

RUN apt-get update && apt-get install --no-install-recommends -y libtool \
        pkg-config \
        jq \
        libdjvulibre-dev \
        libharfbuzz-dev \
        libfreetype6-dev \
        libsdl2-dev \
        patch && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://deb.debian.org/debian testing main" > /etc/apt/sources.list \
       && apt-get update \
       && apt-get install --no-install-recommends -y mupdf libmupdf-dev && rm -rf /var/lib/apt/lists/*;

# Referenced in build.rs for mupdf_wrapper.

ENV CARGO_TARGET_OS=linux

# Build Plato.
WORKDIR /plato

ADD . /plato

CMD ["bash", "-c", "cd /plato/src/mupdf_wrapper && ./build.sh && cd /plato/ && cargo test && cargo build --all-features"]
