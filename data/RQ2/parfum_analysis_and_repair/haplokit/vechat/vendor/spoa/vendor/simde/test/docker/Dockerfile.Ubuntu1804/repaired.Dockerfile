# bionic with gcc 7.4
FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ cmake make && rm -rf /var/lib/apt/lists/*;
COPY . /simde
WORKDIR /simde/test
RUN mkdir -p build_ubuntu18.04
WORKDIR /simde/test/build_ubuntu18.04
RUN CC=/usr/bin/gcc CXX=/usr/bin/g++ cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
 -DCMAKE_C_FLAGS="-Wall -Wextra -Werror -O3" \
 -DCMAKE_CXX_FLAGS="-Wall -Wextra -Werror -O3"  .. \
 && make -j $(nproc) && ./run-tests
