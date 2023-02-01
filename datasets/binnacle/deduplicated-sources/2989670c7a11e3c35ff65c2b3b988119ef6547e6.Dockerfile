# specify the base image for builder
FROM arm64v8/ubuntu:18.04 as builder

COPY qemu-aarch64-static /usr/bin

# install tools and deps for compilation
RUN apt-get update \
  && apt-get install -y libboost-all-dev \
  && apt-get install -y build-essential cmake pkg-config libboost-all-dev libssl-dev libzmq3-dev libunbound-dev libsodium-dev libunwind8-dev liblzma-dev libreadline6-dev libldns-dev libexpat1-dev doxygen graphviz libnorm-dev libpgm-dev git

# Create src directory
WORKDIR /usr/src

# Download and uncompress monero CLI tools
#RUN wget -q https://downloads.getmonero.org/cli/linuxarm8 -O - | tar -jx
#RUN mv monero-*/* .

# compile binaries
RUN git clone --recursive https://github.com/Jasonhcwong/monero-monerobox.git
RUN cd monero-monerobox && git checkout v0.14.0.0-monerobox
RUN mkdir -p /usr/src/monero-monerobox/build && cd /usr/src/monero-monerobox/build && cmake -D BUILD_TESTS=OFF -D ARCH="armv8-a" -D STATIC=ON -D BUILD_64=ON -D CMAKE_BUILD_TYPE=release -D BUILD_TAG="linux-armv8" .. && make -j 4 daemon


# specify the base image for monerod
FROM arm64v8/ubuntu:18.04

COPY qemu-aarch64-static /usr/bin

# install tools
RUN apt-get update \
  && apt-get install -y jq torsocks libnorm1

# Create app directory
WORKDIR /usr/src/app

# Copy entrypoint file
COPY monerod_entrypoint.sh ./

# Copy binaries from builder
COPY --from=builder /usr/src/monero-monerobox/build/bin/* ./

# Expose p2p port and RPC port
EXPOSE 18080 18081

ENTRYPOINT ["/usr/src/app/monerod_entrypoint.sh"]
CMD ["/usr/src/app/monerod", "--config-file=/settings/monerod.conf", "--non-interactive"]


