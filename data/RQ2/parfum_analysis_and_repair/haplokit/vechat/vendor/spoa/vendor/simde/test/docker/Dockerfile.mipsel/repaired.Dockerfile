FROM debian:buster-slim
RUN apt-get update && apt-get install --no-install-recommends -y gcc-8-mipsel-linux-gnu g++-8-mipsel-linux-gnu qemu-user-static cmake binfmt-support && rm -rf /var/lib/apt/lists/*;
COPY . /simde
WORKDIR /simde
RUN mkdir -p test/build_mipsel
WORKDIR /simde/test/build_mipsel
RUN CC=/usr/bin/mipsel-linux-gnu-gcc-8 CXX=/usr/bin/mipsel-linux-gnu-g++-8 cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_FLAGS="-Wall -Wextra -Werror" -DCMAKE_CXX_FLAGS="-Wall -Wextra -Werror" ../ && \
  make -j$(nproc)
RUN QEMU_LD_PREFIX=/usr/mipsel-linux-gnu/ /usr/bin/qemu-mipsel-static ./run-tests
