FROM buildpack-deps:xenial

RUN groupadd -r node && useradd -r -g node node

RUN echo "deb http://archive.ubuntu.com/ubuntu xenial main universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y libleveldb-dev && rm -rf /var/lib/apt/lists/*;

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 8.10.0

RUN apt-get install -y --no-install-recommends curl libc6 libcurl3 zlib1g libtool autoconf && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
ENV NVM_DIR $HOME/.nvm
RUN . $HOME/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION

RUN git clone https://github.com/jedisct1/libsodium.git
RUN cd /libsodium && git checkout && ./autogen.sh
RUN cd /libsodium && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make check && make install

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN . $HOME/.nvm/nvm.sh && npm i && npm cache clean --force;
COPY . /usr/src/app

EXPOSE 80
EXPOSE 8008
EXPOSE 8007

CMD . $HOME/.nvm/nvm.sh && npm start
