FROM p4lang/third-party:latest
LABEL maintainer="P4 Developers <p4-dev@lists.p4.org>"
LABEL description="This Docker image includes only the most widely-used PI \
artifacts: PI core and P4Runtime. It does not include the Thrift-based PI \
implementation for the bmv2 backend."

# Default to using 2 make jobs, which is a good default for CI. If you're
# building locally or you know there are more cores available, you may want to
# override this.
ARG MAKEFLAGS=-j2

# Select the type of image we're building. Use `build` for a normal build, which
# is optimized for image size. Use `test` if this image will be used for
# testing; in this case, the source code and build-only dependencies will not be
# removed from the image.
ARG IMAGE_TYPE=build

ENV PI_DEPS automake \
            build-essential \
            g++ \
            libboost-dev \
            libboost-system-dev \
            libboost-thread-dev \
            libtool \
            pkg-config
ENV PI_RUNTIME_DEPS libboost-system1.71.0 \
                    libboost-thread1.71.0 \
                    python3 \
                    python-is-python3

COPY . /PI/
WORKDIR /PI/
RUN apt-get update && \
    apt-get install -y --no-install-recommends $PI_DEPS $PI_RUNTIME_DEPS && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-Werror --without-bmv2 --without-internal-rpc --without-cli --with-proto --with-sysrepo && \
    make && \
    make install-strip && \
    (test "$IMAGE_TYPE" = "build" && \
      apt-get purge -y $PI_DEPS && \
      apt-get autoremove --purge -y && \
      rm -rf /PI /var/cache/apt/* /var/lib/apt/lists/* && \
      echo 'Build image ready') || \
    (test "$IMAGE_TYPE" = "test" && \
      echo 'Test image ready')
