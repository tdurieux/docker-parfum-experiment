FROM ubuntu:18.04
MAINTAINER Aleksey Karpov <admin@bitaps.com>
RUN apt-get update

RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libtool autotools-dev automake pkg-config libssl-dev libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends -qq install build-essential m4 git cmake nodejs npm default-jre curl && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
RUN git clone https://github.com/emscripten-core/emsdk.git
WORKDIR /root/emsdk

# Install the emscripten dependencies and activate
# RUN cd ./emsdk; git checkout 8a35734a477bd0fd83d9b6336409b0ff0c172f0d
RUN cd ./emsdk; git checkout 2.0.4
RUN ./emsdk install latest
RUN ./emsdk activate latest