FROM node

WORKDIR /tmp

# update package lists and install dependencies
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y autoconf automake build-essential python-dev && rm -rf /var/lib/apt/lists/*;

# install watchman
ENV WATCHMAN_VERSION=4.9.0
RUN \
  curl -f -LO https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.tar.gz && \
  tar xzf v${WATCHMAN_VERSION}.tar.gz && rm v${WATCHMAN_VERSION}.tar.gz && \
  cd watchman-${WATCHMAN_VERSION} && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

# cleanup
RUN \
  apt-get purge -y autoconf automake build-essential python-dev && \
  apt-get autoremove -y && \
  apt-get clean all && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/relay-modern-boilerplate/app

COPY package.json package-lock.json ./
RUN npm i && npm cache clean --force;

COPY . .

# TODO: production build steps
