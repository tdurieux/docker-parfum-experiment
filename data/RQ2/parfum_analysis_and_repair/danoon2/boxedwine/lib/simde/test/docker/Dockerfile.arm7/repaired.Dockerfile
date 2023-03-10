FROM debian:bullseye-slim
RUN apt-get update && apt-get install --no-install-recommends -y \
  binfmt-support \
  clang-9 \
  ninja-build \
  python3-pip \
  gcc \
  gcc-10-arm-linux-gnueabihf \
  g++-10-arm-linux-gnueabihf \
  libstdc++-10-dev-armhf-cross \
  make \
  parallel \
  qemu-user-static && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir meson
ENV QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
COPY . /simde

RUN mkdir -p /simde/build_gcc_arm7
WORKDIR /simde/build_gcc_arm7
RUN CC=/usr/bin/arm-linux-gnueabihf-gcc-10 CXX=/usr/bin/arm-linux-gnueabihf-g++-10 CFLAGS="-march=armv8-a -mfpu=neon" \
  CXXFLAGS="-march=armv7-a -mfpu=neon" \
  meson .. || (cat meson-logs/meson-log.txt; false) && ninja -v && \
  ./test/run-tests --list | grep -oP "^/([^/]+)/([^/]+)" | sort -u | xargs parallel ./test/run-tests --color always {} :::

RUN mkdir -p /simde/build_clang_arm7
WORKDIR /simde/build_clang_arm7
RUN CC=clang-9 CXX=clang++-9 CFLAGS="--target=arm-linux-gnueabihf -march=armv8-a -mfpu=neon -I/usr/arm-linux-gnueabihf/include" \
  CXXFLAGS="--target=arm-linux-gnueabihf -march=armv7a -mfpu=neon -I/usr/arm-linux-gnueabihf/include" \
  meson .. || (cat meson-logs/meson-log.txt; false) && ninja -v && \
  ./test/run-tests --list | grep -oP "^/([^/]+)/([^/]+)" | sort -u | xargs parallel ./test/run-tests --color always {} :::
