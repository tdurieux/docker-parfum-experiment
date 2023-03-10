FROM debian:bullseye-slim
RUN apt-get update && apt-get install --no-install-recommends -y \
  binfmt-support \
  clang \
  cmake \
  gcc \
  gcc-9-aarch64-linux-gnu \
  g++-9-aarch64-linux-gnu \
  make \
  qemu-user-static && rm -rf /var/lib/apt/lists/*;
COPY . /simde

RUN mkdir -p /simde/test/build_gcc_arm64
WORKDIR /simde/test/build_gcc_arm64
RUN CC=/usr/bin/aarch64-linux-gnu-gcc-9 CXX=/usr/bin/aarch64-linux-gnu-g++-9 \
  cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_FLAGS="-march=armv8-a" \
  -DCMAKE_CXX_FLAGS="-march=armv8-a" ../ && make -j$(nproc)
RUN QEMU_LD_PREFIX=/usr/aarch64-linux-gnu/ /usr/bin/qemu-aarch64-static ./run-tests

RUN mkdir -p /simde/test/build_arm64_clang
WORKDIR /simde/test/build_arm64_clang
RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
  -DCMAKE_C_FLAGS="--target=aarch64-linux-gnu -I/usr/aarch64-linux-gnu/include" \
  -DCMAKE_CXX_FLAGS="--target=aarch64-linux-gnu -I/usr/aarch64-linux-gnu/include" \
  ../ && make -j$(nproc)
RUN QEMU_LD_PREFIX=/usr/s390x-linux-gnu/ /usr/bin/qemu-s390x-static ./run-tests
