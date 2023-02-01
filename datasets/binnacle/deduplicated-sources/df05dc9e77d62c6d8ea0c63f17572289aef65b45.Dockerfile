##########################
# Last updated at 2017-11-24 15:06:50.175919 -0800 PST
# https://hub.docker.com/_/nginx/
FROM nginx:alpine
##########################

##########################
# Set working directory
ENV ROOT_DIR /
WORKDIR ${ROOT_DIR}
ENV HOME /root
##########################

##########################
RUN set -ex \
  && apk update \
  && apk add --no-cache \
  bash \
  ca-certificates \
  gcc \
  musl-dev \
  openssl \
  curl \
  wget \
  tar \
  git
##########################

##########################
# install Go
ENV GOROOT /usr/local/go
ENV GOPATH /gopath
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}
ENV GO_VERSION 1.9.2
ENV GO_DOWNLOAD_URL https://storage.googleapis.com/golang
RUN rm -rf ${GOROOT} \
  && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
  && curl -s ${GO_DOWNLOAD_URL}/go${GO_VERSION}.linux-amd64.tar.gz | tar -v -C /usr/local/ -xz \
  && mkdir -p ${GOPATH}/src ${GOPATH}/bin \
  && go version
##########################

##########################
# Clone source code, static assets
RUN mkdir -p ${GOPATH}/src/github.com/gyuho/dplearn
WORKDIR ${GOPATH}/src/github.com/gyuho/dplearn

ADD ./cmd ${GOPATH}/src/github.com/gyuho/dplearn/cmd
ADD ./backend ${GOPATH}/src/github.com/gyuho/dplearn/backend
ADD ./pkg ${GOPATH}/src/github.com/gyuho/dplearn/pkg
ADD ./vendor ${GOPATH}/src/github.com/gyuho/dplearn/vendor
ADD ./scripts/docker/run ${GOPATH}/src/github.com/gyuho/dplearn/scripts/docker/run

RUN go install -v ./cmd/gen-nginx-conf
##########################

##########################
# Configure reverse proxy
RUN mkdir -p /etc/nginx/sites-available/
ADD nginx.conf /etc/nginx/sites-available/default
##########################

