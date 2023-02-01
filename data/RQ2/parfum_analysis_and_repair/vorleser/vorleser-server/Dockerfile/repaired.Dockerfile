# ------------------------------------
# builder image, contains all dev-deps
# ------------------------------------

FROM debian:unstable as builder

WORKDIR /root

# required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        ca-certificates curl file \
        build-essential \
        clang \
        pkg-config \
        cmake \
        zlib1g \
        zlib1g-dev \
        ffmpeg \
        libsqlite3-0 \
        libsqlite3-dev \
        libavcodec-dev \
        libavformat-dev \
        libavfilter-dev \
        libssl-dev \
        libavdevice-dev \
        libavresample-dev \
        autoconf automake autotools-dev libtool xutils-dev && \
    rm -rf /var/lib/apt/lists/*

# install toolchain using rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly-2019-09-06 -y
ENV PATH=/root/.cargo/bin:$PATH

ADD . vorleser-server

WORKDIR /root/vorleser-server



# ------------------
# build web frontend
# ------------------

FROM codesimple/elm:0.18 as web

ADD vorleser-web /app
RUN cd /app && make release



# --------------
# build vorleser
# --------------

FROM builder as vorleser

COPY --from=web /app/elm.js vorleser-web/elm.js

RUN sed -i -e 's/serverUrl: ""/serverUrl: window.location.href/' -e 's/hideUrlField: false/hideUrlField: true/' vorleser-web/audio.js && \
    cargo build --features webfrontend --release



# ------------------------------------------
# final image with runtime deps and app only
# ------------------------------------------