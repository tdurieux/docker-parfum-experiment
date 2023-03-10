FROM debian:unstable-slim
RUN apt-get update && apt-get install --no-install-recommends -y \
  binfmt-support \
  clang \
  cmake \
  gcc \
  gcc-9-s390x-linux-gnu \
  g++-9-s390x-linux-gnu \
  make \
  qemu-user-static && rm -rf /var/lib/apt/lists/*;
COPY . /simde
WORKDIR /simde
RUN mkdir -p test/build_s390x_clang
WORKDIR /simde/test/build_s390x_clang
RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_FLAGS="-Wall -Wextra -Werror --target=s390x-linux-gnu -march=z196 -I/usr/s390x-linux-gnu/include -O3" -DCMAKE_CXX_FLAGS="-Wall -Wextra -Werror --target=s390x-linux-gnu -march=z196 -I/usr/s390x-linux-gnu/include -O3" ../ && \
  make -j$(nproc)
RUN QEMU_LD_PREFIX=/usr/s390x-linux-gnu/ /usr/bin/qemu-s390x-static ./run-tests
RUN mkdir -p test/build_s390x_gnu
WORKDIR /simde/test/build_s390x_gnu
RUN CC=/usr/bin/s390x-linux-gnu-gcc-9 CXX=/usr/bin/s390x-linux-gnu-g++-9 cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_FLAGS="-Wall -Wextra -Werror" -DCMAKE_CXX_FLAGS="-Wall -Wextra -Werror" ../ && \
  make -j$(nproc)
RUN QEMU_LD_PREFIX=/usr/s390x-linux-gnu/ /usr/bin/qemu-s390x-static ./run-tests
