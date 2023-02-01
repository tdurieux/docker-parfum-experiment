FROM ubuntu:focal

USER root

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y git curl libfuse2 gcc g++ make libxtst-dev libpng++-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g node-gyp && npm cache clean --force;

ADD ./build.sh /build.sh
RUN chmod +x /build.sh

WORKDIR /wl

CMD /build.sh