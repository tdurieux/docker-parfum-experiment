FROM mhart/alpine-node

# FROM mhart/alpine-node:base
# FROM mhart/alpine-node:base-0.10
# FROM mhart/alpine-node

WORKDIR /src
ADD . .

# If you have native dependencies, you'll need extra tools
RUN apk add --no-cache \
  curl \
  make \
  gcc \
  g++ \
  binutils-gold \
  python \
  linux-headers \
  paxctl \
  libgcc \
  libstdc++ \
  wget \
  cmake \
  python \
  openssl \
  libev \
  libev-dev \
  libevent \
  libevent-dev

RUN wget https://packages.couchbase.com/clients/c/libcouchbase-2.6.0.tar.gz && \
  tar xzf libcouchbase-2.6.0.tar.gz && \
  cd libcouchbase-2.6.0 && \
  mkdir build && \
  cd build && \
  cmake .. && \
  ls -la && \
  make && \
  make install && rm libcouchbase-2.6.0.tar.gz

# If you need npm, don't use a base tag
RUN npm install && npm cache clean --force;

RUN npm install -g babel-cli gulp && npm cache clean --force;

RUN gulp build

RUN ["./bin/microcrawler", "config", "init"]

ENTRYPOINT ["./bin/microcrawler"]