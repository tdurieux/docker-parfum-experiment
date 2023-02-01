##########################
# Last updated at 2017-11-24 15:06:50.175919 -0800 PST
FROM ubuntu:17.10
##########################

##########################
# Set working directory
ENV ROOT_DIR /
WORKDIR ${ROOT_DIR}
ENV HOME /root
##########################

##########################
# Update OS
# Configure 'bash' for 'source' commands
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
  && apt-get -y update \
  && apt-get -y install \
  build-essential \
  gcc \
  apt-utils \
  software-properties-common \
  curl \
  python \
  git \
  && rm /bin/sh \
  && ln -s /bin/bash /bin/sh \
  && ls -l $(which bash) \
  && echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y dist-upgrade \
  && apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y autoremove \
  && apt-get -y autoclean
##########################

##########################
# install Go
ENV GOROOT /usr/local/go
ENV GOPATH /gopath
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}
ENV GO_VERSION 1.9.2
ENV GO_DOWNLOAD_URL https://storage.googleapis.com/golang
RUN rm -rf ${GOROOT} \
  && curl -s ${GO_DOWNLOAD_URL}/go${GO_VERSION}.linux-amd64.tar.gz | tar -v -C /usr/local/ -xz \
  && mkdir -p ${GOPATH}/src ${GOPATH}/bin \
  && go version
##########################

##########################
# Clone source code, static assets
# start at repository root
RUN mkdir -p ${GOPATH}/src/github.com/gyuho/dplearn
WORKDIR ${GOPATH}/src/github.com/gyuho/dplearn

ADD ./cmd ${GOPATH}/src/github.com/gyuho/dplearn/cmd
ADD ./backend ${GOPATH}/src/github.com/gyuho/dplearn/backend
ADD ./pkg ${GOPATH}/src/github.com/gyuho/dplearn/pkg
ADD ./vendor ${GOPATH}/src/github.com/gyuho/dplearn/vendor
ADD ./Gopkg.lock ${GOPATH}/src/github.com/gyuho/dplearn/Gopkg.lock
ADD ./Gopkg.toml ${GOPATH}/src/github.com/gyuho/dplearn/Gopkg.toml

ADD ./frontend ${GOPATH}/src/github.com/gyuho/dplearn/frontend
ADD ./angular-cli.json ${GOPATH}/src/github.com/gyuho/dplearn/angular-cli.json
ADD ./package.json ${GOPATH}/src/github.com/gyuho/dplearn/package.json
ADD ./proxy.config.json ${GOPATH}/src/github.com/gyuho/dplearn/proxy.config.json
ADD ./yarn.lock ${GOPATH}/src/github.com/gyuho/dplearn/yarn.lock

ADD ./scripts/docker/run ${GOPATH}/src/github.com/gyuho/dplearn/scripts/docker/run
ADD ./scripts/tests ${GOPATH}/src/github.com/gyuho/dplearn/scripts/tests

RUN go install -v ./cmd/backend-web-server \
  && go install -v ./cmd/gen-frontend-dep
##########################

##########################
# install Angular, NodeJS for frontend
# 'node' needs to be in $PATH for 'yarn start' command
ENV NVM_DIR /usr/local/nvm
RUN pushd ${GOPATH}/src/github.com/gyuho/dplearn \
  && curl https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | /bin/bash \
  && echo "Running nvm scripts..." \
  && source $NVM_DIR/nvm.sh \
  && nvm ls-remote \
  && nvm install v9.3.0 \
  && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get -y update && apt-get -y install yarn \
  && echo "Updating frontend dependencies..." \
  && rm -rf ./node_modules \
  && yarn install \
  && npm rebuild node-sass --force \
  && npm install \
  && nvm alias default 9.3.0 \
  && nvm alias default node \
  && which node \
  && node -v \
  && cp /usr/local/nvm/versions/node/v9.3.0/bin/node /usr/bin/node \
  && popd
##########################

