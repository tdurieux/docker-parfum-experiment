FROM ubuntu:20.04

# Needed because tzdata is a transititive dependency and it does not listen to -y :(
# See: https://serverfault.com/a/1016972
ARG DEBIAN_FRONTEND=noninteractive
# ditto
ENV TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get update -qy && apt-get install --no-install-recommends -y \
cargo \
cmake \
coinor-cbc \
coinor-libcbc-dev \
cvc4 \
g++ \
git \
libgmp-dev \
libboost-all-dev \
libssl-dev \
make \
time \
rustc \
zsh \
&& echo "Done" && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/circify/circ.git

WORKDIR /circ
RUN make all
