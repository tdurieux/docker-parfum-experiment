FROM p4lang/third-party:latest
LABEL maintainer="P4 Developers <p4-dev@lists.p4.org>"
LABEL description="This Docker image does not have any dependency on PI or P4 \
Runtime, it only builds bmv2 simple_switch."

# Select the type of image we're building. Use `build` for a normal build, which
# is optimized for image size. Use `test` if this image will be used for
# testing; in this case, the source code and build-only dependencies will not be
# removed from the image.
ARG IMAGE_TYPE=build

ENV BM_DEPS automake \
            build-essential \
            pkg-config \
            curl \
            git \
            libgmp-dev \
            libpcap-dev \
            libboost-dev \
            libboost-program-options-dev \
            libboost-system-dev \
            libboost-filesystem-dev \
            libboost-thread-dev \
            libtool
ENV BM_RUNTIME_DEPS libboost-program-options1.71.0 \
                    libboost-system1.71.0 \
                    libboost-filesystem1.71.0 \
                    libboost-thread1.71.0 \
                    libgmp10 \
                    libpcap0.8 \
                    python3 \
                    python-is-python3

COPY . /behavioral-model/
WORKDIR /behavioral-model/
RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends $BM_DEPS $BM_RUNTIME_DEPS && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-debugger && \
    make -j$(nproc) && \
    make install-strip && \
    ldconfig && \
    (test "$IMAGE_TYPE" = "build" && \
        apt-get purge -qq $BM_DEPS && \
        apt-get autoremove --purge -qq && \
        rm -rf /behavioral-model /var/cache/apt/* /var/lib/apt/lists/* && \
        echo 'Build image ready') || \
    (test "$IMAGE_TYPE" = "test" && \
      echo 'Test image ready')
