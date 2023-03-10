####################################################################
# base image contains all the dependencies we need to build the code
FROM valhalla/valhalla:build-3.1.5 as builder
MAINTAINER Kevin Kreiser <kevinkreiser@gmail.com>

# get the code into the right place and prepare to build it
WORKDIR /usr/local/src/valhalla
ADD . /usr/local/src/valhalla
RUN ls
RUN git submodule sync && git submodule update --init --recursive
RUN mkdir build

# configure the build with symbols turned on so that crashes can be triaged
WORKDIR /usr/local/src/valhalla/build
RUN cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=gcc
RUN make all -j$(nproc)
RUN make install

# we wont leave the source around but we'll drop the commit hash we'll also keep the locales
WORKDIR /usr/local/src
RUN cd valhalla && echo "https://github.com/valhalla/valhalla/tree/$(git rev-parse HEAD)" > ../valhalla_version
RUN for f in valhalla/locales/*.json; do cat ${f} | python3 -c 'import sys; import json; print(json.load(sys.stdin)["posix_locale"])'; done > valhalla_locales
RUN rm -rf valhalla

# the binaries are huge with all the symbols so we strip them but keep the debug there if we need it
WORKDIR /usr/local/bin
RUN for f in valhalla_*; do objcopy --only-keep-debug $f $f.debug; done
RUN tar -cvf valhalla.debug.tar valhalla_*.debug && gzip -9 valhalla.debug.tar && rm valhalla.debug.tar
RUN rm -f valhalla_*.debug
RUN strip --strip-debug --strip-unneeded valhalla_* || true
RUN strip /usr/local/lib/libvalhalla.a
RUN strip /usr/lib/python3/dist-packages/valhalla/python_valhalla.cpython-38-x86_64-linux-gnu.so

####################################################################
# copy the important stuff from the build stage to the runner image
FROM ubuntu:20.04 as runner
MAINTAINER Kevin Kreiser <kevinkreiser@gmail.com>
COPY --from=builder /usr/local /usr/local
COPY --from=builder /usr/bin/prime_* /usr/bin/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libprime* /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/python3/dist-packages/valhalla/* /usr/lib/python3/dist-packages/valhalla/

# we need to add back some runtime dependencies for binaries and scripts
# install all the posix locales that we support
RUN export DEBIAN_FRONTEND=noninteractive && apt update && \
    apt install --no-install-recommends -y \
      libcurl4 libczmq4 libluajit-5.1-2 \
      libprotobuf-lite17 libsqlite3-0 libsqlite3-mod-spatialite libzmq5 zlib1g \
      curl gdb locales parallel python3.8-minimal python3-distutils python-is-python3 \
      spatialite-bin unzip wget && \
    cat /usr/local/src/valhalla_locales | xargs -d '\n' -n1 locale-gen && \
    rm -rf /var/lib/apt/lists/* && \

    # python smoke test
    python3 -c "import valhalla,sys; print (sys.version, valhalla)"