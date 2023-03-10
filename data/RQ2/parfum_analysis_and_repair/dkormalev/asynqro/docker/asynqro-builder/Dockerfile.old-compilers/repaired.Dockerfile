FROM ubuntu:bionic

COPY image_cleanup.sh /image_cleanup.sh

COPY build_noqt.sh /build_noqt.sh

RUN chmod +x /image_cleanup.sh && chmod +x /build_noqt.sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends wget ca-certificates make git g++ clang \
    && mkdir /extras && cd /extras \
    && wget https://cmake.org/files/v3.15/cmake-3.15.2.tar.gz && tar -xzf cmake-3.15.2.tar.gz && cd cmake-3.15.2 \
    && env CC=/usr/bin/clang CXX=/usr/bin/clang++ ./bootstrap -- -DCMAKE_BUILD_TYPE=Release && make -j4 && make install \
    && cd / && rm -rf extras \
    && cmake --version \
    && /image_cleanup.sh && rm cmake-3.15.2.tar.gz && rm -rf /var/lib/apt/lists/*;

ENV CTEST_OUTPUT_ON_FAILURE=1 \
    CLICOLOR_FORCE=1 \
    CC=clang \
    CXX=clang++

ENTRYPOINT /build.sh
