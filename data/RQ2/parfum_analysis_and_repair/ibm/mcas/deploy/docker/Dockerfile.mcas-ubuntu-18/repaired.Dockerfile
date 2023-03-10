FROM ubuntu:18.04 AS ofed-ubuntu18
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt-get install --no-install-recommends -y linux-headers-4.15.0-96-generic wget gnupg && rm -rf /var/lib/apt/lists/*;
RUN wget -qO - https://www.mellanox.com/downloads/ofed/RPM-GPG-KEY-Mellanox | apt-key add -
WORKDIR /etc/apt/sources.list.d/
RUN wget https://linux.mellanox.com/public/repo/mlnx_ofed/4.5-1.0.1.0/ubuntu18.04/mellanox_mlnx_ofed.list && apt update
RUN apt install --no-install-recommends -y mlnx-ofed-all && rm -rf /var/lib/apt/lists/*;

FROM ofed-ubuntu18 AS build
COPY . /mcas
WORKDIR /mcas
RUN deps/install-apts-ubuntu-18.sh
RUN git submodule update --init --recursive
RUN rm -rf build && mkdir -p build
WORKDIR /mcas/build
RUN cmake -DBUILD_KERNEL_SUPPORT=1 -DFLATBUFFERS_BUILD_TESTS=0 -DTBB_BUILD_TESTS=0 -DBUILD_PYTHON_SUPPORT=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=`pwd`/dist ..
RUN make bootstrap && make install

FROM ofed-ubuntu18
RUN apt update && apt install --no-install-recommends -y libboost-program-options-dev libboost-system-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
COPY --from=build /mcas/build /mcas/build

#ENTRYPOINT ["/mcas/build/dist/bin/mcas"]
CMD ["/mcas/build/dist/bin/mcas"]
