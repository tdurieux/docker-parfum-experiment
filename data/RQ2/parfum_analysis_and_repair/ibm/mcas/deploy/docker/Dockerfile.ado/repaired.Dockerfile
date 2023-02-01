FROM ubuntu:18.04 AS build
COPY . /mcas
WORKDIR /mcas
ENV DEBIAN_FRONTEND=noninteractive
RUN deps/install-apts-ubuntu-18.sh
RUN apt install --no-install-recommends -y linux-headers-`uname -r` && rm -rf /var/lib/apt/lists/*;
RUN git submodule update --init --recursive
RUN rm -rf build && mkdir -p build
WORKDIR /mcas/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/dist ..
RUN make bootstrap && make install

#FROM gcr.io/distroless/cc
FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y libboost-program-options-dev libnuma-dev libkmod-dev libboost-system-dev && rm -rf /var/lib/apt/lists/*;
COPY --from=build /mcas/build /mcas/build
ENTRYPOINT ["/mcas/build/dist/bin/ado"]
