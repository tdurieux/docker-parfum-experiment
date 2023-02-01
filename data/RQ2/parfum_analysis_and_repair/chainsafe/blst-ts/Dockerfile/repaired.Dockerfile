# This is used to build bindings for arm64

ARG NODE_VERSION
FROM node:${NODE_VERSION}

# Install 'add-apt-repository'
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# node-gyp v8.4.0 requires python >= 3.6.0
RUN apt update && apt install --no-install-recommends -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev g++ make && rm -rf /var/lib/apt/lists/*;
RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
RUN tar -xf Python-3.10.0.tgz && rm Python-3.10.0.tgz
RUN cd Python-3.10.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN cd Python-3.10.0 && make install

WORKDIR .
COPY . .

RUN yarn config set ignore-engines true && yarn cache clean;
RUN yarn bootstrap

# Test - spec tests data should already be cached
RUN yarn download-spec-tests
RUN yarn test:unit
RUN yarn test:spec
