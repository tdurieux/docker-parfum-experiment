# xenial with gcc 5.4
FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y \
  clang-3.8 \
  cmake \
  gcc \
  g++ \
  libomp-dev \
  libxml2-utils \
  libc++-dev \
  make \
  ninja-build \
  python3-pip \
  python3-setuptools \
  python3-wheel && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir meson==0.50.0
COPY . /simde
WORKDIR /simde/test
RUN mkdir -p /simde/test/build_ubuntu16.04_clang
WORKDIR /simde/test/build_ubuntu16.04_clang
RUN CC=/usr/bin/clang-3.8 CXX=/usr/bin/clang++-3.8 cmake -DCMAKE_C_FLAGS="-mavx2 -Weverything -Werror -Wno-c++98-compat-pedantic -Wno-newline-eof" -DCMAKE_CXX_FLAGS="-mavx2 -Weverything -Werror -Wno-c++98-compat-pedantic -Wno-newline-eof"  .. \
 && make -j $(nproc) && ./run-tests
RUN mkdir -p /simde/test/build_ubuntu16.04_gcc
WORKDIR /simde/test/build_ubuntu16.04_gcc
RUN CC=/usr/bin/gcc CXX=/usr/bin/g++ cmake -DCMAKE_C_FLAGS="-Wall -Wextra -Werror -Werror=unused-but-set-variable" -DCMAKE_CXX_FLAGS="-Wall -Wextra -Werror -Werror=unused-but-set-variable"  .. \
 && make -j $(nproc) && ./run-tests

WORKDIR /simde/
RUN bash ./test/native-aliases.sh
RUN mkdir -p /simde/build_ubuntu16.04_clang_native
WORKDIR /simde/build_ubuntu16.04_clang_native
RUN CC=/usr/bin/clang CXX=/usr/bin/clang++ CFLAGS="-Wall -Wextra -DSIMDE_ENABLE_NATIVE_ALIASES -DSIMDE_NATIVE_ALIASES_TESTING" CXXFLAGS="-Wall -Wextra -DSIMDE_ENABLE_NATIVE_ALIASES -DSIMDE_NATIVE_ALIASES_TESTING"  meson .. \
 && ninja && ./test/run-tests

