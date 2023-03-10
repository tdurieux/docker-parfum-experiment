FROM debian:bullseye-slim
RUN apt-get update && apt-get install --no-install-recommends -y \
  binfmt-support \
  ca-certificates \
  cmake \
  curl \
  binutils \
  gcc-9-powerpc64le-linux-gnu \
  g++-powerpc64le-linux-gnu \
  libxml2-utils \
  make \
  qemu-user-static && rm -rf /var/lib/apt/lists/*;
COPY . /simde
WORKDIR /simde
# RUN mkdir -p test/build_ppc64le
# WORKDIR /simde/test/build_ppc64le
# RUN CC=/usr/bin/powerpc64le-linux-gnu-gcc-9 CXX=/usr/bin/powerpc64le-linux-gnu-g++-9 cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_FLAGS="-Wall -Wextra -Werror -mcpu=power8" -DCMAKE_CXX_FLAGS="-Wall -Wextra -Werror -mcpu=power8" ../ && \
#   make -j$(nproc)
# RUN QEMU_LD_PREFIX=/usr/powerpc64le-linux-gnu/ /usr/bin/qemu-ppc64le-static ./run-tests
WORKDIR /simde
RUN ./test/native-aliases.sh
RUN mkdir -p test/build_ppc64le_native
WORKDIR /simde/test/build_ppc64le_native
RUN CC=/usr/bin/powerpc64le-linux-gnu-gcc-9 CXX=/usr/bin/powerpc64le-linux-gnu-g++-9 cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_FLAGS="-Wall -Wextra -Werror -mcpu=power8 -DSIMDE_ENABLE_NATIVE_ALIASES -DSIMDE_NATIVE_ALIASES_TESTING" -DCMAKE_CXX_FLAGS="-Wall -Wextra -Werror -mcpu=power8 -DSIMDE_ENABLE_NATIVE_ALIASES -DSIMDE_NATIVE_ALIASES_TESTING" ../ && \
  make -j$(nproc)
RUN QEMU_LD_PREFIX=/usr/powerpc64le-linux-gnu/ /usr/bin/qemu-ppc64le-static ./run-tests
